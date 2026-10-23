<script setup>
import { ref, computed } from 'vue'
import { getProfile, clearAuth, userApi } from '../api/user.js'
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

/* ---------- 搜索（纯前端占位） ---------- */
const keyword = ref('')
const searching = ref(false)

function doSearch () {
  const kw = keyword.value.trim()
  if (!kw) {
    toast('先输入想找的东西吧，比如「伟大航路的地图」')
    return
  }
  searching.value = true
  // 预留：后端搜索接口就绪后，在这里调用 API 并渲染结果
  setTimeout(() => {
    searching.value = false
    toast(`已收到搜索「${kw}」，搜索服务开发中 ⚓`)
  }, 600)
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
        <button class="search-btn" :disabled="searching" @click="doSearch">
          {{ searching ? '搜索中…' : '启航搜索' }}
        </button>
      </div>

      <!-- 占位卡片：提示后续页面入口（均未开发） -->
      <div class="home-cards">
        <div class="home-card">
          <div class="home-card-head">🗺️ 今日航线</div>
          <p>记录你与伙伴们的下一段航程。</p>
          <span class="home-badge">页面开发中</span>
        </div>
        <div class="home-card">
          <div class="home-card-head">🏴‍☠️ 热门悬赏</div>
          <p>伟大航道最新悬赏令，看看谁的赏金又涨了。</p>
          <span class="home-badge">页面开发中</span>
        </div>
        <div class="home-card">
          <div class="home-card-head">📜 船员名册</div>
          <p>已登记的航海士一览，找到你的同行伙伴。</p>
          <span class="home-badge">页面开发中</span>
        </div>
      </div>
    </main>

    <!-- 轻提示 -->
    <transition name="toast">
      <div v-if="toastText" class="toast">{{ toastText }}</div>
    </transition>
  </div>
</template>
