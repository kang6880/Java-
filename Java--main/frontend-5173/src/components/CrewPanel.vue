<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { homeApi, formatBounty, formatNumber } from '../api/home.js'

const list = ref([])
const loading = ref(true)
const filter = ref('全部')
const detail = ref(null)

const affiliations = computed(() => {
  const set = ['全部']
  list.value.forEach(c => {
    if (c.affiliation && !set.includes(c.affiliation)) set.push(c.affiliation)
  })
  return set
})

const shown = computed(() =>
  filter.value === '全部' ? list.value : list.value.filter(c => c.affiliation === filter.value))

async function load () {
  loading.value = true
  try {
    list.value = await homeApi.crews()
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

function openDetail (item) {
  detail.value = item
}
</script>

<template>
  <section class="panel">
    <header class="panel-head">
      <h2>⚓ 船员名册</h2>
      <p>伟大航路上有名有姓的航海士，从草帽一伙到四皇与海军本部。</p>
    </header>

    <div class="chips">
      <button
        v-for="a in affiliations"
        :key="a"
        type="button"
        class="chip"
        :class="{ active: filter === a }"
        @click="filter = a"
      >{{ a }}</button>
    </div>

    <div v-if="loading" class="panel-loading">正在展开名册……</div>
    <div v-else class="card-grid">
      <article
        v-for="c in shown"
        :key="c.id"
        class="data-card clickable"
        @click="openDetail(c)"
      >
        <div class="data-card-top">
          <span class="data-icon">{{ c.icon }}</span>
          <div class="data-head">
            <b>{{ c.name }}</b>
            <small>「{{ c.alias }}」· {{ c.position }}</small>
          </div>
        </div>
        <p class="data-line">🏴 {{ c.affiliation }}</p>
        <p class="data-line">{{ c.devilFruit ? '🍈 ' + c.devilFruit : '🥾 无果实能力' }}</p>
        <p class="data-bounty">{{ formatBounty(c.bounty) }}</p>
      </article>
    </div>

    <p v-if="!loading && !shown.length" class="panel-empty">这一势力暂时没有记录在册的船员。</p>

    <transition name="pop">
      <div v-if="detail" class="detail-mask" @click.self="detail = null">
        <div class="detail-modal detail-crew">
          <button class="detail-close" type="button" @click="detail = null">✕</button>
          <span class="detail-crew-avatar">{{ detail.icon }}</span>
          <h3 class="detail-title">{{ detail.name }}</h3>
          <p class="detail-crew-mail">「{{ detail.alias }}」 · {{ detail.position }}</p>
          <div class="detail-rows">
            <p><span>所属势力</span>{{ detail.affiliation }}</p>
            <p><span>出身地</span>{{ detail.origin }}</p>
            <p><span>恶魔果实</span>{{ detail.devilFruit || '无' }}</p>
            <p><span>悬赏金</span>฿ {{ formatNumber(detail.bounty) }}</p>
          </div>
          <p class="detail-desc">{{ detail.description }}</p>
        </div>
      </div>
    </transition>
  </section>
</template>
