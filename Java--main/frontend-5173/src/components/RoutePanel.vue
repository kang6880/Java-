<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { homeApi } from '../api/home.js'

const list = ref([])
const loading = ref(true)
const filter = ref('全部')
const detail = ref(null)

const regions = computed(() => {
  const set = ['全部']
  list.value.forEach(r => {
    if (r.region && !set.includes(r.region)) set.push(r.region)
  })
  return set
})

const shown = computed(() =>
  filter.value === '全部' ? list.value : list.value.filter(r => r.region === filter.value))

function stars (level) {
  const n = Math.max(0, Math.min(5, Number(level) || 0))
  return '★'.repeat(n) + '☆'.repeat(5 - n)
}

async function load () {
  loading.value = true
  try {
    list.value = await homeApi.routes()
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
      <h2>🗺️ 航线图鉴</h2>
      <p>从东海的风车村一路到伟大航路的尽头拉夫坦路，每条航线都有它的故事。</p>
    </header>

    <div class="chips">
      <button
        v-for="r in regions"
        :key="r"
        type="button"
        class="chip"
        :class="{ active: filter === r }"
        @click="filter = r"
      >{{ r }}</button>
    </div>

    <div v-if="loading" class="panel-loading">正在展开海图……</div>
    <div v-else class="card-grid">
      <article
        v-for="r in shown"
        :key="r.id"
        class="data-card clickable"
        @click="detail = r"
      >
        <div class="data-card-top">
          <span class="data-icon">{{ r.icon }}</span>
          <div class="data-head">
            <b>{{ r.name }}</b>
            <small>{{ r.region }}</small>
          </div>
        </div>
        <p class="data-stars">危险等级 <b>{{ stars(r.dangerLevel) }}</b></p>
        <p class="data-desc">{{ r.description }}</p>
      </article>
    </div>

    <p v-if="!loading && !shown.length" class="panel-empty">这片海域暂无航线记录。</p>

    <transition name="pop">
      <div v-if="detail" class="detail-mask" @click.self="detail = null">
        <div class="detail-modal detail-route">
          <button class="detail-close" type="button" @click="detail = null">✕</button>
          <span class="detail-route-icon">{{ detail.icon }}</span>
          <h3 class="detail-title">{{ detail.name }}</h3>
          <p class="detail-route-region">{{ detail.region }}</p>
          <p class="detail-stars">危险等级 <b>{{ stars(detail.dangerLevel) }}</b></p>
          <p class="detail-desc">{{ detail.description }}</p>
        </div>
      </div>
    </transition>
  </section>
</template>
