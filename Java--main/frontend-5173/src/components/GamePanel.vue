<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { homeApi } from '../api/home.js'

/* 恶魔果实记忆配对：翻两张牌，配对草帽团成员。
 * 牌面数据源为数据库 home_crew 表（登录态下经 /api/home/crews 拉取），
 * 每局随机抽取 8 名成员组成 16 张牌；数据不足或接口异常时回退到内置牌池。
 * 评级：<=14 步 传说级 / <=20 大海贼 / <=28 超新星 / 其余 见习海贼 */

/* 静态兜底牌池：仅在接口不可用时使用 */
const FALLBACK_POOL = [
  { icon: '🎩', name: '路飞' },
  { icon: '🗡️', name: '索隆' },
  { icon: '🍊', name: '娜美' },
  { icon: '🎯', name: '乌索普' },
  { icon: '🚬', name: '山治' },
  { icon: '🦌', name: '乔巴' },
  { icon: '📚', name: '罗宾' },
  { icon: '🔧', name: '弗兰奇' },
  { icon: '🎻', name: '布鲁克' },
  { icon: '👊', name: '甚平' },
  { icon: '☠️', name: '罗杰' },
  { icon: '🍖', name: '肉肉' }
]

/* 从数据库拉取的牌面池（icon + name） */
const CREW_POOL = ref(FALLBACK_POOL)

onMounted(async () => {
  try {
    const list = await homeApi.crews()
    if (Array.isArray(list) && list.length >= 8) {
      CREW_POOL.value = list.map(c => ({ icon: c.icon, name: c.name }))
    }
  } catch {
    /* 保留兜底牌池 */
  }
  // 数据就绪（或回退）后开第一局
  newGame()
})

const flipped = ref([])      // 当前翻开的牌下标
const matched = ref(new Set()) // 已配对的 emoji
const steps = ref(0)
const seconds = ref(0)
const playing = ref(false)
const finished = ref(false)
let timer = null
let lockBoard = false

function shuffle (arr) {
  const a = [...arr]
  for (let i = a.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1))
    ;[a[i], a[j]] = [a[j], a[i]]
  }
  return a
}

/* 生成 16 张牌（8 种 × 2） */
const cards = ref([])

function newGame () {
  const pool = CREW_POOL.value
  const picked = shuffle(pool).slice(0, 8)
  cards.value = shuffle([...picked, ...picked.map(c => ({ ...c }))])
    .map((c, idx) => ({ ...c, key: idx }))
  flipped.value = []
  matched.value = new Set()
  steps.value = 0
  seconds.value = 0
  playing.value = true
  finished.value = false
  lockBoard = false
  clearInterval(timer)
  timer = setInterval(() => { if (playing.value) seconds.value++ }, 1000)
}

const matchedCount = computed(() => matched.value.size)

function flip (idx) {
  if (!playing.value || lockBoard) return
  if (flipped.value.includes(idx)) return
  if (matched.value.has(cards.value[idx].icon)) return

  flipped.value.push(idx)

  if (flipped.value.length === 2) {
    steps.value++
    lockBoard = true
    const [a, b] = flipped.value
    if (cards.value[a].icon === cards.value[b].icon) {
      setTimeout(() => {
        matched.value.add(cards.value[a].icon)
        flipped.value = []
        lockBoard = false
        if (matched.value.size === 8) win()
      }, 420)
    } else {
      setTimeout(() => {
        flipped.value = []
        lockBoard = false
      }, 760)
    }
  }
}

function win () {
  playing.value = false
  finished.value = true
  clearInterval(timer)
}

const rank = computed(() => {
  if (steps.value <= 14) return { title: '传说级', icon: '👑', desc: '海贼王就是你！' }
  if (steps.value <= 20) return { title: '大海贼', icon: '🏴‍☠️', desc: '悬赏令即将更新！' }
  if (steps.value <= 28) return { title: '超新星', icon: '⚡', desc: '新世界向你招手' }
  return { title: '见习海贼', icon: '🥴', desc: '再练练，伟大航路还远' }
})

onUnmounted(() => clearInterval(timer))
</script>

<template>
  <div class="game-panel">
    <h2 class="panel-title">🍈 恶魔果实记忆配对</h2>
    <p class="game-desc">翻开两张牌，找出所有草帽团成员的配对。步数越少评级越高！</p>

    <div class="game-hud">
      <span>👟 步数 <b>{{ steps }}</b></span>
      <span>⏱ 时长 <b>{{ seconds }}</b>s</span>
      <span>🎯 配对 <b>{{ matchedCount }}/8</b></span>
      <button class="game-restart" type="button" @click="newGame">🔄 重新开始</button>
    </div>

    <div class="game-board">
      <button
        v-for="(c, idx) in cards"
        :key="c.key"
        type="button"
        class="game-card"
        :class="{
          open: flipped.includes(idx),
          done: matched.has(c.icon)
        }"
        @click="flip(idx)"
      >
        <span class="card-back">🏴‍☠️</span>
        <span class="card-face">
          <b>{{ c.icon }}</b>
          <small>{{ matched.has(c.icon) ? c.name : '' }}</small>
        </span>
      </button>
    </div>

    <transition name="pop">
      <div v-if="finished" class="game-win">
        <div class="game-win-card">
          <span class="win-icon">{{ rank.icon }}</span>
          <h3>{{ rank.title }}</h3>
          <p>{{ rank.desc }}</p>
          <p class="win-stat">用 {{ steps }} 步 · {{ seconds }} 秒完成全部配对</p>
          <button class="game-restart big" type="button" @click="newGame">再来一局</button>
        </div>
      </div>
    </transition>
  </div>
</template>
