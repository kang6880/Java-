<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { homeApi } from '../api/home.js'

const list = ref([])
const loading = ref(true)
const filter = ref('全部')
const detail = ref(null)      // 展开的完整情节
const video = ref(null)       // 弹出的视频 { title, video }

const seas = computed(() => {
  const set = ['全部']
  list.value.forEach(s => {
    if (s.sea && !set.includes(s.sea)) set.push(s.sea)
  })
  return set
})

const shown = computed(() =>
  filter.value === '全部' ? list.value : list.value.filter(s => s.sea === filter.value))

/* 记录每个篇章的动态封面图 URL（由 bvid 实时拉取） */
const covers = ref({})

async function fetchCover (s) {
  // 有显式 cover 就用；否则若 video 是 bvid，尝试拉 B站真实封面
  if (s.cover) { covers.value[s.id] = s.cover; return }
  if (!isBvid(s.video)) return
  try {
    const res = await fetch(`https://api.bilibili.com/x/web-interface/view?bvid=${s.video}`)
    const j = await res.json()
    const pic = j?.data?.pic
    if (pic) covers.value[s.id] = pic.replace(/^http:/, 'https:')
  } catch { /* 拉取失败则用渐变兜底 */ }
}

async function load () {
  loading.value = true
  try {
    list.value = await homeApi.stories()
    list.value.forEach(s => fetchCover(s))
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  load()
  window.addEventListener('keydown', onKeydown)
})
onUnmounted(() => window.removeEventListener('keydown', onKeydown))

function onKeydown (e) {
  if (e.key === 'Escape') {
    detail.value = null
    video.value = null
  }
}

function openDetail (s) {
  detail.value = s
}

/* 判断 video 是否为 bvid（可直接内嵌播放） */
function isBvid (v) {
  return /^BV[0-9A-Za-z]+$/.test(v || '')
}

/* 构造 B站播放器嵌入地址 */
function bilibiliEmbed (bvid) {
  return `//player.bilibili.com/player.html?bvid=${bvid}&high_quality=1&autoplay=0`
}

function openVideo (s) {
  if (!s.video) return
  video.value = { title: s.title, video: s.video }
}

/* 为每个篇章生成不同的海洋渐变色封面（避免裂图，同时保证视觉统一） */
const coverPalette = [
  'linear-gradient(135deg,#0a3d6b,#12629b)',
  'linear-gradient(135deg,#8a5a2b,#c98a3b)',
  'linear-gradient(135deg,#2b6b8a,#4aa3c9)',
  'linear-gradient(135deg,#4a2b6b,#7a4aa3)',
  'linear-gradient(135deg,#2b3d4a,#4a6b7a)',
  'linear-gradient(135deg,#6b1f1f,#a33b3b)',
  'linear-gradient(135deg,#1f5b6b,#3b9aa3)',
  'linear-gradient(135deg,#5b1f4a,#9a3b7a)',
  'linear-gradient(135deg,#2b5b1f,#4a9a3b)',
  'linear-gradient(135deg,#5b2b1f,#9a4a3b)',
  'linear-gradient(135deg,#1f1f5b,#3b3b9a)',
  'linear-gradient(135deg,#0b4f6f,#1283b3)'
]
function coverBg (i) {
  return coverPalette[i % coverPalette.length]
}
</script>

<template>
  <section class="panel">
    <header class="panel-head">
      <h2>📖 篇章故事</h2>
      <p>从东海出发到蛋头岛，热血与羁绊贯穿每一个篇章 —— 点击卡片看完整情节，点「看解说」直达视频。</p>
    </header>

    <div class="chips">
      <button
        v-for="s in seas"
        :key="s"
        type="button"
        class="chip"
        :class="{ active: filter === s }"
        @click="filter = s"
      >{{ s }}</button>
    </div>

    <div v-if="loading" class="panel-loading">正在翻阅航海日志……</div>

    <div v-else class="story-grid">
      <article
        v-for="(s, i) in shown"
        :key="s.id"
        class="story-card"
      >
        <div class="story-cover" :style="covers[s.id] ? { backgroundImage: `url(${covers[s.id]})`, backgroundSize: 'cover', backgroundPosition: 'center' } : { background: coverBg(i) }">
          <span v-if="!covers[s.id]" class="story-cover-emoji">{{ s.icon }}</span>
          <span class="story-cover-no">第 {{ i + 1 }} 章</span>
        </div>

        <div class="story-main">
          <h3 class="story-title">{{ s.title }}</h3>
          <p class="story-meta">{{ s.sea }} · {{ s.chapters }} · {{ s.episodes }}</p>
          <p class="story-roles">登场：{{ s.mainRoles }}</p>
          <p class="story-summary">{{ s.summary }}</p>

          <div class="story-actions">
            <button class="story-btn story-btn-more" type="button" @click="openDetail(s)">
              阅读完整情节
            </button>
            <button
              class="story-btn story-btn-video"
              type="button"
              :disabled="!s.video"
              @click="openVideo(s)"
            >
              <svg viewBox="0 0 24 24" width="14" height="14" fill="currentColor"><path d="M8 5v14l11-7z"/></svg>
              看解说视频
            </button>
          </div>
        </div>
      </article>
    </div>

    <p v-if="!loading && !shown.length" class="panel-empty">这段海域的故事还没被记录下来。</p>

    <!-- 完整情节弹窗 -->
    <transition name="pop">
      <div v-if="detail" class="detail-mask" @click.self="detail = null">
        <div class="detail-modal detail-story">
          <button class="detail-close" type="button" @click="detail = null">✕</button>
          <span class="detail-route-icon">{{ detail.icon }}</span>
          <h3 class="detail-title">{{ detail.title }}</h3>
          <p class="detail-route-region">{{ detail.sea }} · {{ detail.chapters }} · {{ detail.episodes }}</p>
          <div class="detail-rows">
            <p><span>登场</span>{{ detail.mainRoles }}</p>
          </div>
          <p class="detail-desc story-full">{{ detail.fullText || detail.summary }}</p>
          <button
            v-if="detail.video"
            class="story-btn story-btn-video story-btn-block"
            type="button"
            @click="video = { title: detail.title, video: detail.video }"
          >
            <svg viewBox="0 0 24 24" width="14" height="14" fill="currentColor"><path d="M8 5v14l11-7z"/></svg>
            观看本篇解说视频
          </button>
        </div>
      </div>
    </transition>

    <!-- 视频弹窗 -->
    <transition name="pop">
      <div v-if="video" class="detail-mask video-mask" @click.self="video = null">
        <div class="video-modal">
          <button class="detail-close" type="button" @click="video = null">✕</button>
          <h3 class="video-title">{{ video.title }} · 解说视频</h3>
          <div class="video-body">
            <div v-if="isBvid(video.video)" class="video-frame-wrap">
              <span class="video-loading">▶ 正在加载 B 站播放器…</span>
              <iframe
                class="video-frame"
                :src="bilibiliEmbed(video.video)"
                scrolling="no"
                border="0"
                frameborder="no"
                framespacing="0"
                allowfullscreen="true"
                referrerpolicy="no-referrer"
              ></iframe>
            </div>
            <div v-else class="video-fallback">
              <span class="video-fallback-icon">🎬</span>
              <p>本篇解说视频已为你准备好，点击下方按钮前往 B 站观看。</p>
              <a class="story-btn story-btn-video" :href="video.video" target="_blank" rel="noopener">
                <svg viewBox="0 0 24 24" width="14" height="14" fill="currentColor"><path d="M8 5v14l11-7z"/></svg>
                前往 B 站观看
              </a>
            </div>
          </div>
          <p v-if="isBvid(video.video)" class="video-tip">若上方播放器无法加载，可<a :href="`https://www.bilibili.com/video/${video.video}`" target="_blank" rel="noopener">点此前往 B 站直接观看</a>。</p>
        </div>
      </div>
    </transition>
  </section>
</template>
