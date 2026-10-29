<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { homeApi } from '../api/home.js'

const list = ref([])
const loading = ref(true)
const filter = ref('全部')
const detail = ref(null)

const seas = computed(() => {
  const set = ['全部']
  list.value.forEach(s => {
    if (s.sea && !set.includes(s.sea)) set.push(s.sea)
  })
  return set
})

const shown = computed(() =>
  filter.value === '全部' ? list.value : list.value.filter(s => s.sea === filter.value))

async function load () {
  loading.value = true
  try {
    list.value = await homeApi.stories()
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
  if (e.key === 'Escape') detail.value = null
}
</script>

<template>
  <section class="panel">
    <header class="panel-head">
      <h2>📖 篇章故事</h2>
      <p>从东海出发到蛋头岛，每一个篇章都留下了无法磨灭的传说。</p>
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
    <ol v-else class="story-timeline">
      <li
        v-for="(s, i) in shown"
        :key="s.id"
        class="story-item clickable"
        @click="detail = s"
      >
        <span class="story-index">{{ i + 1 }}</span>
        <div class="story-body">
          <h3>{{ s.icon }} {{ s.title }}</h3>
          <p class="story-meta">{{ s.sea }} · {{ s.chapters }} · {{ s.episodes }}</p>
          <p class="story-roles">登场：{{ s.mainRoles }}</p>
          <p class="story-summary">{{ s.summary }}</p>
        </div>
      </li>
    </ol>

    <p v-if="!loading && !shown.length" class="panel-empty">这段海域的故事还没被记录下来。</p>

    <transition name="pop">
      <div v-if="detail" class="detail-mask" @click.self="detail = null">
        <div class="detail-modal">
          <button class="detail-close" type="button" @click="detail = null">✕</button>
          <span class="detail-route-icon">{{ detail.icon }}</span>
          <h3 class="detail-title">{{ detail.title }}</h3>
          <p class="detail-route-region">{{ detail.sea }}</p>
          <div class="detail-rows">
            <p><span>漫画</span>{{ detail.chapters }}</p>
            <p><span>动画</span>{{ detail.episodes }}</p>
            <p><span>登场</span>{{ detail.mainRoles }}</p>
          </div>
          <p class="detail-desc">{{ detail.summary }}</p>
        </div>
      </div>
    </transition>
  </section>
</template>
