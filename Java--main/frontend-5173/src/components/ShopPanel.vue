<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { homeApi, formatNumber } from '../api/home.js'

const list = ref([])
const loading = ref(true)
const filter = ref('全部')
const detail = ref(null)

const categories = computed(() => {
  const set = ['全部']
  list.value.forEach(s => {
    if (s.category && !set.includes(s.category)) set.push(s.category)
  })
  return set
})

const shown = computed(() =>
  filter.value === '全部' ? list.value : list.value.filter(s => s.category === filter.value))

async function load () {
  loading.value = true
  try {
    list.value = await homeApi.shops()
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
      <h2>🏪 杂货小镇</h2>
      <p>从东海的酒馆到蛋头岛的贩卖机，伟大航路沿线的铺子在等着你。</p>
    </header>

    <div class="chips">
      <button
        v-for="c in categories"
        :key="c"
        type="button"
        class="chip"
        :class="{ active: filter === c }"
        @click="filter = c"
      >{{ c }}</button>
    </div>

    <div v-if="loading" class="panel-loading">正在打点货架……</div>
    <div v-else class="card-grid">
      <article
        v-for="s in shown"
        :key="s.id"
        class="data-card clickable"
        @click="detail = s"
      >
        <div class="data-card-top">
          <span class="data-icon">{{ s.icon }}</span>
          <div class="data-head">
            <b>{{ s.name }}</b>
            <small>{{ s.category }} · {{ s.location }}</small>
          </div>
        </div>
        <p class="data-line">🎁 招牌：{{ s.item }}</p>
        <p class="data-bounty">฿ {{ formatNumber(s.price) }}</p>
      </article>
    </div>

    <p v-if="!loading && !shown.length" class="panel-empty">这类店铺还没开张。</p>

    <transition name="pop">
      <div v-if="detail" class="detail-mask" @click.self="detail = null">
        <div class="detail-modal">
          <button class="detail-close" type="button" @click="detail = null">✕</button>
          <span class="detail-route-icon">{{ detail.icon }}</span>
          <h3 class="detail-title">{{ detail.name }}</h3>
          <p class="detail-route-region">{{ detail.category }} · {{ detail.location }}</p>
          <div class="detail-rows">
            <p><span>招牌商品</span>{{ detail.item }}</p>
            <p><span>售价</span>฿ {{ formatNumber(detail.price) }}</p>
          </div>
          <p class="detail-desc">{{ detail.description }}</p>
        </div>
      </div>
    </transition>
  </section>
</template>
