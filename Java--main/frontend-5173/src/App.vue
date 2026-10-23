<script setup>
import { ref } from 'vue'
import { getToken } from './api/user.js'
import SeaScene from './components/SeaScene.vue'
import BrandPanel from './components/BrandPanel.vue'
import LoginForm from './components/LoginForm.vue'
import RegisterForm from './components/RegisterForm.vue'
import HomePage from './components/HomePage.vue'
import SuccessModal from './components/SuccessModal.vue'
import ConfettiLayer from './components/ConfettiLayer.vue'

/* ---------- 视图状态：auth（登录/注册） | home（首页） ---------- */
/* 已有令牌则直接进首页（与单文件版行为一致） */
const view = ref(getToken() ? 'home' : 'auth')
const authTab = ref('login') // login | register

/* 注册成功：弹庆祝层，回到登录页并提示去登录 */
const registerFormRef = ref(null)
const confettiRef = ref(null)
const maskShow = ref(false)
const who = ref('船长')

function onSuccess (name) {
  who.value = name || '船长'
  confettiRef.value?.celebrate()
  setTimeout(() => { maskShow.value = true }, 420)
}

function closeMask () {
  maskShow.value = false
  setTimeout(() => {
    registerFormRef.value?.resetForm()
    authTab.value = 'login'
  }, 300)
}

/* 登录成功 → 首页 */
function onLoginSuccess () {
  view.value = 'home'
}

/* 首页退出 → 回登录页 */
function onLogout () {
  authTab.value = 'login'
  view.value = 'auth'
}
</script>

<template>
  <!-- ==================== 登录 / 注册 ==================== -->
  <template v-if="view === 'auth'">
    <SeaScene />

    <main class="stage">
      <!-- 左侧招募令 -->
      <BrandPanel />
      <!-- 右侧：登录 / 注册双页签 -->
      <div class="auth-panel card">
        <div class="tabs">
          <button type="button" :class="{ active: authTab === 'login' }" @click="authTab = 'login'">登船验证</button>
          <button type="button" :class="{ active: authTab === 'register' }" @click="authTab = 'register'">招募登记</button>
        </div>

        <LoginForm v-show="authTab === 'login'" @success="onLoginSuccess" @switch-tab="authTab = $event" />
        <RegisterForm v-show="authTab === 'register'" ref="registerFormRef" @success="onSuccess" @switch-tab="authTab = $event" />
      </div>
    </main>

    <!-- 成功弹层 -->
    <SuccessModal :show="maskShow" :who="who" @close="closeMask" />
    <!-- 庆祝粒子 -->
    <ConfettiLayer ref="confettiRef" />
  </template>

  <!-- ==================== 首页 ==================== -->
  <HomePage v-else @logout="onLogout" />
</template>
