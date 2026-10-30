<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { homeApi, formatBounty, formatNumber } from '../api/home.js'

const list = ref([])
const loading = ref(true)
const filter = ref('全部')
const detail = ref(null)
const keyword = ref('')

const affiliations = computed(() => {
  const set = ['全部']
  list.value.forEach(c => {
    if (c.affiliation && !set.includes(c.affiliation)) set.push(c.affiliation)
  })
  return set
})

const shown = computed(() => {
  let arr = filter.value === '全部' ? list.value : list.value.filter(c => c.affiliation === filter.value)
  if (keyword.value.trim()) {
    const kw = keyword.value.trim()
    arr = arr.filter(c =>
      (c.name || '').includes(kw) ||
      (c.alias || '').includes(kw) ||
      (c.position || '').includes(kw) ||
      (c.devilFruit || '').includes(kw)
    )
  }
  return arr
})

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
      <p>伟大航路上有名有姓的航海士，从草帽一伙到四皇、海军本部与传奇海贼 —— 点击任意角色，展开完整档案。</p>
    </header>

    <div class="crew-tools">
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
      <input
        v-model="keyword"
        class="crew-search"
        type="text"
        placeholder="搜索名字 / 称号 / 果实…"
      >
    </div>

    <div v-if="loading" class="panel-loading">正在展开名册……</div>
    <div v-else class="card-grid">
      <article
        v-for="c in shown"
        :key="c.id"
        class="data-card crew-card clickable"
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
        <p class="data-line">🗺️ {{ c.origin }}</p>
        <p class="data-line">{{ c.devilFruit ? '🍈 ' + c.devilFruit : '🥾 无果实能力' }}</p>
        <p class="data-bounty">{{ formatBounty(c.bounty) }}</p>
        <p class="crew-card-desc">{{ c.description }}</p>
      </article>
    </div>

    <p v-if="!loading && !shown.length" class="panel-empty">没有找到符合条件的船员。</p>

    <transition name="pop">
      <div v-if="detail" class="detail-mask" @click.self="detail = null">
        <div class="detail-modal detail-crew">
          <button class="detail-close" type="button" @click="detail = null">✕</button>
          <!-- 动漫形象：有 image 用真图，否则用大 emoji 形象 -->
          <div class="crew-portrait">
            <img v-if="detail.image" :src="detail.image" :alt="detail.name" class="crew-portrait-img">
            <span v-else class="crew-portrait-emoji">{{ detail.icon }}</span>
          </div>
          <h3 class="detail-title">{{ detail.name }}</h3>
          <p class="detail-crew-mail">「{{ detail.alias }}」 · {{ detail.position }}</p>

          <div class="crew-sections">
            <div class="crew-section">
              <h4>📋 基本档案</h4>
              <div class="detail-rows">
                <p><span>所属势力</span>{{ detail.affiliation }}</p>
                <p><span>出身地</span>{{ detail.origin }}</p>
                <p><span>恶魔果实</span>{{ detail.devilFruit || '无' }}</p>
                <p><span>悬赏金</span>฿ {{ formatNumber(detail.bounty) }}（{{ formatBounty(detail.bounty) }}）</p>
              </div>
            </div>

            <div class="crew-section">
              <h4>📜 人物介绍</h4>
              <p class="detail-desc">{{ detail.description }}</p>
            </div>

            <div v-if="detail.deeds" class="crew-section">
              <h4>🔥 主要事迹</h4>
              <p class="crew-deeds">{{ detail.deeds }}</p>
            </div>
          </div>
        </div>
      </div>
    </transition>
  </section>
</template>
