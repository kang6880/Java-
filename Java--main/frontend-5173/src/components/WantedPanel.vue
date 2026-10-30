<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { homeApi, formatBounty, formatNumber } from '../api/home.js'

const list = ref([])
const loading = ref(true)
const filter = ref('全部')
const detail = ref(null)

const crews = computed(() => {
  const set = ['全部']
  list.value.forEach(w => {
    if (w.crew && !set.includes(w.crew)) set.push(w.crew)
  })
  return set
})

const shown = computed(() =>
  filter.value === '全部' ? list.value : list.value.filter(w => w.crew === filter.value))

async function load () {
  loading.value = true
  try {
    list.value = await homeApi.wanteds()
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
      <h2>🏴‍☠️ 悬赏令</h2>
      <p>世界政府张贴的通缉名单，悬赏金越高，说明他们越让海军头痛。</p>
    </header>

    <div class="chips">
      <button
        v-for="c in crews"
        :key="c"
        type="button"
        class="chip"
        :class="{ active: filter === c }"
        @click="filter = c"
      >{{ c }}</button>
    </div>

    <div v-if="loading" class="panel-loading">正在张贴悬赏令……</div>
    <div v-else class="card-grid">
      <article
        v-for="w in shown"
        :key="w.id"
        class="data-card wanted-card clickable"
        @click="detail = w"
      >
        <p class="wanted-tag">WANTED</p>
        <div class="data-card-top">
          <span class="data-icon">{{ w.icon }}</span>
          <div class="data-head">
            <b>{{ w.name }}</b>
            <small>「{{ w.epithet }}」</small>
          </div>
        </div>
        <p class="data-line">🏴 {{ w.crew }}</p>
        <p class="data-bounty">฿ {{ formatNumber(w.bounty) }}</p>
      </article>
    </div>

    <p v-if="!loading && !shown.length" class="panel-empty">这张榜单上还没有人上榜。</p>

    <transition name="pop">
      <div v-if="detail" class="detail-mask" @click.self="detail = null">
        <div class="detail-modal detail-wanted">
          <button class="detail-close" type="button" @click="detail = null">✕</button>
          <p class="poster-head">MARINE · 世界政府公告</p>
          <p class="poster-epithet">「{{ detail.epithet }}」</p>
          <span class="poster-icon">{{ detail.icon }}</span>
          <h3 class="poster-name">{{ detail.name }}</h3>
          <p class="poster-crew">所属海贼团：{{ detail.crew || '不明' }}</p>
          <div class="poster-bounty">
            <span class="poster-berry">฿</span>
            <b>{{ formatNumber(detail.bounty) }}</b>
          </div>
          <p class="poster-bounty-fmt">悬赏金额：{{ formatBounty(detail.bounty) }}</p>
          <p v-if="detail.description" class="poster-desc">{{ detail.description }}</p>
          <p class="poster-dead">DEAD OR ALIVE</p>
        </div>
      </div>
    </transition>
  </section>
</template>
