<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { getProfile, clearAuth, userApi } from '../api/user.js'
import { homeApi, formatBounty, formatNumber } from '../api/home.js'
import SeaScene from './SeaScene.vue'
import CrewPanel from './CrewPanel.vue'
import RoutePanel from './RoutePanel.vue'
import WantedPanel from './WantedPanel.vue'
import ShopPanel from './ShopPanel.vue'
import StoryPanel from './StoryPanel.vue'

const emit = defineEmits(['logout', 'open-admin'])

const profile = getProfile()
const username = computed(() => (profile && profile.username) || '船长')

/* ---------- 导航 ---------- */
const menus = [
  { name: '首页', comp: null },
  { name: '船员名册', comp: 'CrewPanel' },
  { name: '航线图鉴', comp: 'RoutePanel' },
  { name: '悬赏令', comp: 'WantedPanel' },
  { name: '杂货小镇', comp: 'ShopPanel' },
  { name: '章节故事', comp: 'StoryPanel' }
]
const activeMenu = ref('首页')
const panelMap = { CrewPanel, RoutePanel, WantedPanel, ShopPanel, StoryPanel }

const activePanel = computed(() => {
  const m = menus.find(x => x.name === activeMenu.value)
  return m && m.comp ? panelMap[m.comp] : null
})

function switchMenu (name) {
  activeMenu.value = name
  // 切换页面后平滑滚回顶部，配合吸顶导航保证随时可跳转
  window.scrollTo({ top: 0, behavior: 'smooth' })
}

/* ---------- 首页展示数据（后端 /api/home/summary） ---------- */
const summaryLoading = ref(true)
const summary = ref({
  crewCount: 0,
  roleCount: 0,
  routeCount: 0,
  wantedCount: 0,
  shopCount: 0,
  storyCount: 0,
  topRoutes: [],
  topWanteds: [],
  topCrews: [],
  topStories: []
})

async function loadSummary () {
  summaryLoading.value = true
  try {
    summary.value = await homeApi.summary()
  } catch (e) {
    toast(e.message || '首页数据加载失败')
  } finally {
    summaryLoading.value = false
  }
}

/* ---------- 搜索（后端 /api/home/search，五路） ---------- */
const keyword = ref('')
const searching = ref(false)
const searchResult = ref(null) // null = 未搜索
const searchedKeyword = ref('')

async function doSearch () {
  const kw = keyword.value.trim()
  if (!kw) {
    toast('先输入想找的东西吧，比如「和之国」或「橡胶果实」')
    return
  }
  searching.value = true
  try {
    const data = await homeApi.search(kw)
    searchedKeyword.value = kw
    searchResult.value = data
    if (!data.total) toast(`大海上没找到「${kw}」的踪迹 🌊`)
  } catch (e) {
    toast(e.message || '搜索服务出错了')
  } finally {
    searching.value = false
  }
}

function closeSearch () {
  searchResult.value = null
  searchedKeyword.value = ''
}

/** 搜索结果与榜单卡片点击 → 直接跳到对应页面并打开详情前的提示 */
function goPanel (name) {
  activeMenu.value = name
}

/* ---------- 详情弹窗（首页榜单卡片复用） ---------- */
const detail = ref(null)

function openDetail (type, item) {
  detail.value = { type, data: item }
}

function closeDetail () {
  detail.value = null
}

function dangerStars (level) {
  const n = Math.max(0, Math.min(5, Number(level) || 0))
  return '★'.repeat(n) + '☆'.repeat(5 - n)
}

/* ---------- 退出登船 ---------- */
const exiting = ref(false)

async function logout () {
  if (exiting.value) return
  exiting.value = true
  try { await userApi.logout() } catch { /* 令牌本就失效也不影响退出 */ }
  clearAuth()
  emit('logout')
}

/* ---------- 轻提示 ---------- */
const toastText = ref('')
let toastTimer = null

function toast (msg) {
  toastText.value = msg
  clearTimeout(toastTimer)
  toastTimer = setTimeout(() => { toastText.value = '' }, 2200)
}

onMounted(() => {
  loadSummary()
  window.addEventListener('keydown', onKeydown)
  window.addEventListener('scroll', onScroll, { passive: true })
})

onUnmounted(() => {
  window.removeEventListener('keydown', onKeydown)
  window.removeEventListener('scroll', onScroll)
})

function onKeydown (e) {
  if (e.key === 'Escape') closeDetail()
}

/* 今日日期（欢迎语用） */
const today = new Date().toLocaleDateString('zh-CN', { month: 'long', day: 'numeric', weekday: 'long' })

/* 回到顶部按钮：滚动超过一屏才显示 */
const showTop = ref(false)
function onScroll () {
  showTop.value = window.scrollY > window.innerHeight * 0.8
}
function toTop () {
  window.scrollTo({ top: 0, behavior: 'smooth' })
}
</script>

<template>
  <SeaScene />

  <div class="home">
    <!-- 顶部导航栏 -->
    <nav class="nav">
      <div class="nav-brand">
        <svg class="nav-wheel" viewBox="0 0 100 100">
          <g stroke="#f2c14e" stroke-width="6" fill="none" stroke-linecap="round">
            <circle cx="50" cy="50" r="38" />
            <circle cx="50" cy="50" r="13" fill="#0b3f6f" />
          </g>
          <g stroke="#f2c14e" stroke-width="6" stroke-linecap="round">
            <path d="M50 12 L50 37" /><path d="M50 63 L50 88" />
            <path d="M12 50 L37 50" /><path d="M63 50 L88 50" />
            <path d="M23 23 L41 41" /><path d="M59 59 L77 77" />
            <path d="M77 23 L59 41" /><path d="M41 59 L23 77" />
          </g>
        </svg>
        <span class="nav-title">伟大航道</span>
      </div>

      <ul class="nav-menus">
        <li v-for="m in menus" :key="m.name">
          <a href="#" :class="{ active: activeMenu === m.name }" @click.prevent="switchMenu(m.name)">{{ m.name }}</a>
        </li>
      </ul>

      <div class="nav-user">
        <button class="nav-admin" type="button" @click="emit('open-admin')">⚙ 后台管理系统</button>
        <span class="nav-avatar">{{ username.slice(0, 1) }}</span>
        <span class="nav-name">{{ username }}</span>
        <button class="nav-exit" :disabled="exiting" @click="logout">退出登船</button>
      </div>
    </nav>

    <!-- 各功能页：切换导航时渲染 -->
    <main v-if="activePanel" class="home-main panel-wrap">
      <div class="panel-toolbar">
        <button class="back-home" type="button" @click="switchMenu('首页')">
          <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><path d="M19 12H5" /><path d="M12 19l-7-7 7-7" /></svg>
          返回首页
        </button>
      </div>
      <transition name="panel-swap" mode="out-in">
        <component :is="activePanel" :key="activeMenu" />
      </transition>
    </main>

    <!-- 首页：欢迎语 + 搜索栏 + 展示区 -->
    <main v-else class="home-main">
      <p class="home-date">{{ today }} · 晴，适合出航</p>
      <h1 class="home-title">欢迎登船，<em>{{ username }}</em>！</h1>
      <p class="home-sub">世代传承的意志、时代的浪潮、人的梦想 —— 这些都是无法阻挡的。</p>

      <div class="search">
        <svg class="search-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round">
          <circle cx="11" cy="11" r="7" />
          <path d="M21 21 L16.5 16.5" />
        </svg>
        <input
          v-model="keyword"
          type="text"
          placeholder="搜索航线、船员、悬赏令、店铺、篇章……"
          @keyup.enter="doSearch"
        >
        <button v-if="searchResult" class="search-clear" type="button" @click="closeSearch">✕</button>
        <button class="search-btn" :disabled="searching" @click="doSearch">
          {{ searching ? '搜索中…' : '启航搜索' }}
        </button>
      </div>

      <!-- 搜索结果（五路） -->
      <transition name="fade">
        <section v-if="searchResult" class="search-result">
          <p class="search-result-title">
            「{{ searchedKeyword }}」共命中 <b>{{ searchResult.total }}</b> 条
          </p>

          <div v-if="searchResult.routes.length" class="result-group">
            <h3 class="result-group-head">
              🗺️ 航线 · {{ searchResult.routes.length }}
              <a href="#" class="result-more" @click.prevent="goPanel('航线图鉴')">进入图鉴 ›</a>
            </h3>
            <ul class="result-list">
              <li v-for="r in searchResult.routes" :key="'r' + r.id" class="result-item clickable" @click="openDetail('route', r)">
                <span class="result-icon">{{ r.icon }}</span>
                <span class="result-main">
                  <b>{{ r.name }}</b>
                  <small>{{ r.region }} · {{ dangerStars(r.dangerLevel) }}</small>
                </span>
                <span class="result-desc">{{ r.description }}</span>
              </li>
            </ul>
          </div>

          <div v-if="searchResult.wanteds.length" class="result-group">
            <h3 class="result-group-head">
              🏴‍☠️ 悬赏令 · {{ searchResult.wanteds.length }}
              <a href="#" class="result-more" @click.prevent="goPanel('悬赏令')">进入榜单 ›</a>
            </h3>
            <ul class="result-list">
              <li v-for="w in searchResult.wanteds" :key="'w' + w.id" class="result-item clickable" @click="openDetail('wanted', w)">
                <span class="result-icon">{{ w.icon }}</span>
                <span class="result-main">
                  <b>{{ w.name }}</b>
                  <small>{{ w.epithet }} · {{ w.crew }}</small>
                </span>
                <span class="result-bounty">{{ formatBounty(w.bounty) }}</span>
              </li>
            </ul>
          </div>

          <div v-if="searchResult.crews.length" class="result-group">
            <h3 class="result-group-head">
              ⚓ 船员名册 · {{ searchResult.crews.length }}
              <a href="#" class="result-more" @click.prevent="goPanel('船员名册')">进入名册 ›</a>
            </h3>
            <ul class="result-list">
              <li v-for="c in searchResult.crews" :key="'c' + c.id" class="result-item clickable" @click="openDetail('crew', c)">
                <span class="result-icon">{{ c.icon }}</span>
                <span class="result-main">
                  <b>{{ c.name }}</b>
                  <small>「{{ c.alias }}」 · {{ c.affiliation }}</small>
                </span>
                <span class="result-desc">{{ c.devilFruit || '无果实能力' }}</span>
              </li>
            </ul>
          </div>

          <div v-if="searchResult.shops.length" class="result-group">
            <h3 class="result-group-head">
              🏪 杂货小镇 · {{ searchResult.shops.length }}
              <a href="#" class="result-more" @click.prevent="goPanel('杂货小镇')">进入小镇 ›</a>
            </h3>
            <ul class="result-list">
              <li v-for="s in searchResult.shops" :key="'s' + s.id" class="result-item clickable" @click="openDetail('shop', s)">
                <span class="result-icon">{{ s.icon }}</span>
                <span class="result-main">
                  <b>{{ s.name }}</b>
                  <small>{{ s.category }} · {{ s.location }}</small>
                </span>
                <span class="result-bounty">฿ {{ formatNumber(s.price) }}</span>
              </li>
            </ul>
          </div>

          <div v-if="searchResult.stories.length" class="result-group">
            <h3 class="result-group-head">
              📖 篇章故事 · {{ searchResult.stories.length }}
              <a href="#" class="result-more" @click.prevent="goPanel('章节故事')">进入故事 ›</a>
            </h3>
            <ul class="result-list">
              <li v-for="s in searchResult.stories" :key="'st' + s.id" class="result-item clickable" @click="openDetail('story', s)">
                <span class="result-icon">{{ s.icon }}</span>
                <span class="result-main">
                  <b>{{ s.title }}</b>
                  <small>{{ s.sea }} · {{ s.episodes }}</small>
                </span>
                <span class="result-desc">{{ s.summary }}</span>
              </li>
            </ul>
          </div>
        </section>
      </transition>

      <!-- 首页展示区 -->
      <template v-if="!searchResult">
        <div class="home-stats">
          <div class="stat" @click="goPanel('船员名册')">
            <b>{{ summary.roleCount }}</b><span>名册人物</span>
          </div>
          <div class="stat" @click="goPanel('航线图鉴')">
            <b>{{ summary.routeCount }}</b><span>收录航线</span>
          </div>
          <div class="stat" @click="goPanel('悬赏令')">
            <b>{{ summary.wantedCount }}</b><span>悬赏令</span>
          </div>
          <div class="stat" @click="goPanel('杂货小镇')">
            <b>{{ summary.shopCount }}</b><span>杂货店铺</span>
          </div>
          <div class="stat" @click="goPanel('章节故事')">
            <b>{{ summary.storyCount }}</b><span>篇章故事</span>
          </div>
        </div>

        <div class="home-cards" :class="{ loading: summaryLoading }">
          <!-- 今日航线 -->
          <div class="home-card">
            <div class="home-card-head">
              🗺️ 今日航线
              <a href="#" class="card-more" @click.prevent="goPanel('航线图鉴')">更多 ›</a>
            </div>
            <ul v-if="summary.topRoutes.length" class="card-list">
              <li v-for="r in summary.topRoutes" :key="r.id" class="clickable" @click="openDetail('route', r)">
                <span class="card-emoji">{{ r.icon }}</span>
                <span class="card-text">
                  <b>{{ r.name }}</b>
                  <small>{{ r.region }} · {{ dangerStars(r.dangerLevel) }}</small>
                </span>
              </li>
            </ul>
            <p v-else class="card-empty">{{ summaryLoading ? '正在展开海图……' : '海图暂无航线记录' }}</p>
          </div>

          <!-- 热门悬赏 -->
          <div class="home-card">
            <div class="home-card-head">
              🏴‍☠️ 热门悬赏
              <a href="#" class="card-more" @click.prevent="goPanel('悬赏令')">更多 ›</a>
            </div>
            <ul v-if="summary.topWanteds.length" class="card-list">
              <li v-for="w in summary.topWanteds" :key="w.id" class="clickable" @click="openDetail('wanted', w)">
                <span class="card-emoji">{{ w.icon }}</span>
                <span class="card-text">
                  <b>{{ w.name }}</b>
                  <small>{{ formatBounty(w.bounty) }}</small>
                </span>
              </li>
            </ul>
            <p v-else class="card-empty">{{ summaryLoading ? '正在张贴悬赏令……' : '暂无悬赏记录' }}</p>
          </div>

          <!-- 船员名册概览 -->
          <div class="home-card">
            <div class="home-card-head">
              ⚓ 名册人物
              <a href="#" class="card-more" @click.prevent="goPanel('船员名册')">更多 ›</a>
            </div>
            <ul v-if="summary.topCrews.length" class="card-list">
              <li v-for="c in summary.topCrews" :key="c.id" class="clickable" @click="openDetail('crew', c)">
                <span class="card-emoji">{{ c.icon }}</span>
                <span class="card-text">
                  <b>{{ c.name }}</b>
                  <small>{{ c.position }} · {{ formatBounty(c.bounty) }}</small>
                </span>
              </li>
            </ul>
            <p v-else class="card-empty">{{ summaryLoading ? '正在翻开名册……' : '暂无名册记录' }}</p>
          </div>

          <!-- 最新篇章 -->
          <div class="home-card">
            <div class="home-card-head">
              📖 最新篇章
              <a href="#" class="card-more" @click.prevent="goPanel('章节故事')">更多 ›</a>
            </div>
            <ul v-if="summary.topStories.length" class="card-list">
              <li v-for="s in summary.topStories" :key="s.id" class="clickable" @click="openDetail('story', s)">
                <span class="card-emoji">{{ s.icon }}</span>
                <span class="card-text">
                  <b>{{ s.title }}</b>
                  <small>{{ s.episodes }}</small>
                </span>
              </li>
            </ul>
            <p v-else class="card-empty">{{ summaryLoading ? '正在翻阅航海日志……' : '暂无篇章记录' }}</p>
          </div>
        </div>
      </template>
    </main>

    <!-- 详情弹窗 -->
    <transition name="pop">
      <div v-if="detail" class="detail-mask" @click.self="closeDetail">
        <!-- 航线 -->
        <div v-if="detail.type === 'route'" class="detail-modal detail-route">
          <button class="detail-close" type="button" @click="closeDetail">✕</button>
          <span class="detail-route-icon">{{ detail.data.icon }}</span>
          <h3 class="detail-title">{{ detail.data.name }}</h3>
          <p class="detail-route-region">{{ detail.data.region }}</p>
          <p class="detail-stars">危险等级 <b>{{ dangerStars(detail.data.dangerLevel) }}</b></p>
          <p class="detail-desc">{{ detail.data.description }}</p>
        </div>

        <!-- 悬赏令 -->
        <div v-else-if="detail.type === 'wanted'" class="detail-modal detail-wanted">
          <button class="detail-close" type="button" @click="closeDetail">✕</button>
          <p class="poster-head">MARINE · 世界政府公告</p>
          <p class="poster-epithet">「{{ detail.data.epithet }}」</p>
          <span class="poster-icon">{{ detail.data.icon }}</span>
          <h3 class="poster-name">{{ detail.data.name }}</h3>
          <p class="poster-crew">所属海贼团：{{ detail.data.crew || '不明' }}</p>
          <div class="poster-bounty">
            <span class="poster-berry">฿</span>
            <b>{{ formatNumber(detail.data.bounty) }}</b>
          </div>
          <p class="poster-bounty-fmt">悬赏金额：{{ formatBounty(detail.data.bounty) }}</p>
          <p class="poster-dead">DEAD OR ALIVE</p>
        </div>

        <!-- 船员 -->
        <div v-else-if="detail.type === 'crew'" class="detail-modal detail-crew">
          <button class="detail-close" type="button" @click="closeDetail">✕</button>
          <span class="detail-crew-avatar">{{ detail.data.icon }}</span>
          <h3 class="detail-title">{{ detail.data.name }}</h3>
          <p class="detail-crew-mail">「{{ detail.data.alias }}」 · {{ detail.data.position }}</p>
          <div class="detail-rows">
            <p><span>所属势力</span>{{ detail.data.affiliation }}</p>
            <p><span>出身地</span>{{ detail.data.origin }}</p>
            <p><span>恶魔果实</span>{{ detail.data.devilFruit || '无' }}</p>
            <p><span>悬赏金</span>฿ {{ formatNumber(detail.data.bounty) }}</p>
          </div>
          <p class="detail-desc">{{ detail.data.description }}</p>
        </div>

        <!-- 杂货 -->
        <div v-else-if="detail.type === 'shop'" class="detail-modal">
          <button class="detail-close" type="button" @click="closeDetail">✕</button>
          <span class="detail-route-icon">{{ detail.data.icon }}</span>
          <h3 class="detail-title">{{ detail.data.name }}</h3>
          <p class="detail-route-region">{{ detail.data.category }} · {{ detail.data.location }}</p>
          <div class="detail-rows">
            <p><span>招牌商品</span>{{ detail.data.item }}</p>
            <p><span>售价</span>฿ {{ formatNumber(detail.data.price) }}</p>
          </div>
          <p class="detail-desc">{{ detail.data.description }}</p>
        </div>

        <!-- 篇章 -->
        <div v-else class="detail-modal">
          <button class="detail-close" type="button" @click="closeDetail">✕</button>
          <span class="detail-route-icon">{{ detail.data.icon }}</span>
          <h3 class="detail-title">{{ detail.data.title }}</h3>
          <p class="detail-route-region">{{ detail.data.sea }}</p>
          <div class="detail-rows">
            <p><span>漫画</span>{{ detail.data.chapters }}</p>
            <p><span>动画</span>{{ detail.data.episodes }}</p>
            <p><span>登场</span>{{ detail.data.mainRoles }}</p>
          </div>
          <p class="detail-desc">{{ detail.data.summary }}</p>
        </div>
      </div>
    </transition>

    <!-- 轻提示 -->
    <transition name="toast">
      <div v-if="toastText" class="toast">{{ toastText }}</div>
    </transition>

    <!-- 回到顶部 -->
    <transition name="fade">
      <button v-if="showTop" class="to-top" type="button" title="回到顶部" @click="toTop">
        <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><path d="M12 19V5" /><path d="M5 12l7-7 7 7" /></svg>
      </button>
    </transition>
  </div>
</template>
