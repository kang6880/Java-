<script setup>
import { ref, computed, onMounted } from 'vue'
import { getProfile, clearAuth, userApi } from '../api/user.js'
import { homeApi, formatBounty } from '../api/home.js'
import SeaScene from './SeaScene.vue'

const emit = defineEmits(['logout'])

const profile = getProfile()
const username = computed(() => (profile && profile.username) || '船长')

/* ---------- 导航 ---------- */
const menus = ['首页', '船员名册', '航线图鉴', '悬赏令', '杂货小镇']
const activeMenu = ref('首页')

function switchMenu (name) {
  if (name === activeMenu.value) return
  activeMenu.value = name
  // 其余页面暂未开发：点亮选中态并提示
  toast(`「${name}」页面开发中，敬请期待 ⚓`)
}

/* ---------- 首页展示数据（后端 /api/home/summary） ---------- */
const summaryLoading = ref(true)
const summary = ref({
  crewCount: 0,
  routeCount: 0,
  wantedCount: 0,
  topRoutes: [],
  topWanteds: []
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

onMounted(loadSummary)

/* ---------- 搜索（后端 /api/home/search） ---------- */
const keyword = ref('')
const searching = ref(false)
const searchResult = ref(null) // null = 未搜索；{ routes, wanteds, crews, total }
const searchedKeyword = ref('')

async function doSearch () {
  const kw = keyword.value.trim()
  if (!kw) {
    toast('先输入想找的东西吧，比如「伟大航路的地图」')
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

/* 今日日期（欢迎语用） */
const today = new Date().toLocaleDateString('zh-CN', { month: 'long', day: 'numeric', weekday: 'long' })
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
        <li v-for="m in menus" :key="m">
          <a href="#" :class="{ active: activeMenu === m }" @click.prevent="switchMenu(m)">{{ m }}</a>
        </li>
      </ul>

      <div class="nav-user">
        <span class="nav-avatar">{{ username.slice(0, 1) }}</span>
        <span class="nav-name">{{ username }}</span>
        <button class="nav-exit" :disabled="exiting" @click="logout">退出登船</button>
      </div>
    </nav>

    <!-- 主体：欢迎语 + 搜索栏 -->
    <main class="home-main">
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
          placeholder="搜索航线、船员、悬赏令……"
          @keyup.enter="doSearch"
        >
        <button v-if="searchResult" class="search-clear" type="button" @click="closeSearch">✕</button>
        <button class="search-btn" :disabled="searching" @click="doSearch">
          {{ searching ? '搜索中…' : '启航搜索' }}
        </button>
      </div>

      <!-- 搜索结果（有结果时替换下方三卡片展示区） -->
      <transition name="fade">
        <section v-if="searchResult" class="search-result">
          <p class="search-result-title">
            「{{ searchedKeyword }}」共命中 <b>{{ searchResult.total }}</b> 条
          </p>

          <div v-if="searchResult.routes.length" class="result-group">
            <h3 class="result-group-head">🗺️ 航线 · {{ searchResult.routes.length }}</h3>
            <ul class="result-list">
              <li v-for="r in searchResult.routes" :key="'r' + r.id" class="result-item">
                <span class="result-icon">{{ r.icon }}</span>
                <span class="result-main">
                  <b>{{ r.name }}</b>
                  <small>{{ r.region }} · 危险等级 {{ r.dangerLevel }}</small>
                </span>
                <span class="result-desc">{{ r.description }}</span>
              </li>
            </ul>
          </div>

          <div v-if="searchResult.wanteds.length" class="result-group">
            <h3 class="result-group-head">🏴‍☠️ 悬赏令 · {{ searchResult.wanteds.length }}</h3>
            <ul class="result-list">
              <li v-for="w in searchResult.wanteds" :key="'w' + w.id" class="result-item">
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
            <h3 class="result-group-head">📜 船员名册 · {{ searchResult.crews.length }}</h3>
            <ul class="result-list">
              <li v-for="c in searchResult.crews" :key="'c' + c.id" class="result-item">
                <span class="result-icon result-avatar">{{ c.username.slice(0, 1) }}</span>
                <span class="result-main">
                  <b>{{ c.username }}</b>
                  <small>{{ c.email }}</small>
                </span>
                <span class="result-desc">于 {{ (c.createTime || '').slice(0, 10) }} 登记入册</span>
              </li>
            </ul>
          </div>
        </section>
      </transition>

      <!-- 首页展示区：真实数据（后端 /api/home/summary） -->
      <template v-if="!searchResult">
        <div class="home-stats">
          <div class="stat">
            <b>{{ summary.crewCount }}</b><span>在册船员</span>
          </div>
          <div class="stat">
            <b>{{ summary.routeCount }}</b><span>收录航线</span>
          </div>
          <div class="stat">
            <b>{{ summary.wantedCount }}</b><span>悬赏令</span>
          </div>
        </div>

        <div class="home-cards" :class="{ loading: summaryLoading }">
          <!-- 今日航线：按 sortNo 取前 3 -->
          <div class="home-card">
            <div class="home-card-head">🗺️ 今日航线</div>
            <ul v-if="summary.topRoutes.length" class="card-list">
              <li v-for="r in summary.topRoutes" :key="r.id">
                <span class="card-emoji">{{ r.icon }}</span>
                <span class="card-text">
                  <b>{{ r.name }}</b>
                  <small>{{ r.region }} · {{ r.dangerLevel }}危</small>
                </span>
              </li>
            </ul>
            <p v-else class="card-empty">{{ summaryLoading ? '正在展开海图……' : '海图暂无航线记录' }}</p>
          </div>

          <!-- 热门悬赏：按赏金降序取前 3 -->
          <div class="home-card">
            <div class="home-card-head">🏴‍☠️ 热门悬赏</div>
            <ul v-if="summary.topWanteds.length" class="card-list">
              <li v-for="w in summary.topWanteds" :key="w.id">
                <span class="card-emoji">{{ w.icon }}</span>
                <span class="card-text">
                  <b>{{ w.name }}</b>
                  <small>{{ formatBounty(w.bounty) }}</small>
                </span>
              </li>
            </ul>
            <p v-else class="card-empty">{{ summaryLoading ? '正在张贴悬赏令……' : '暂无悬赏记录' }}</p>
          </div>

          <!-- 船员名册：在册人数统计 -->
          <div class="home-card">
            <div class="home-card-head">📜 船员名册</div>
            <p class="card-crew-line">
              已有 <b class="card-crew-num">{{ summary.crewCount }}</b> 名航海士登记入册，
              找到你的同行伙伴，一起出发吧！
            </p>
            <p class="card-empty card-crew-tip">名册详情页开发中，可先用上方搜索查找船员 🔍</p>
          </div>
        </div>
      </template>
    </main>

    <!-- 轻提示 -->
    <transition name="toast">
      <div v-if="toastText" class="toast">{{ toastText }}</div>
    </transition>
  </div>
</template>
