<script setup>
import { ref } from 'vue'
import { adminApi } from '../api/admin.js'

const emit = defineEmits(['success', 'back'])

const username = ref('')
const password = ref('')
const loading = ref(false)
const error = ref('')

async function onSubmit () {
  if (loading.value) return
  error.value = ''

  if (!username.value.trim()) {
    error.value = '请输入管理员账号'
    return
  }
  if (!password.value) {
    error.value = '请输入管理密钥'
    return
  }

  loading.value = true
  try {
    await adminApi.login({ username: username.value.trim(), password: password.value })
    emit('success')
  } catch (e) {
    error.value = e.message || '登录失败，请重试'
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <div class="admin-login">
    <SeaScene />

    <div class="admin-login-card card">
      <div class="admin-login-head">
        <span class="admin-login-badge">⚙</span>
        <h1>后台管理系统</h1>
        <p>伟大航道 · 数据管理入口</p>
      </div>

      <form novalidate @submit.prevent="onSubmit">
        <div class="field">
          <label for="aUser">管理员账号</label>
          <input id="aUser" v-model="username" type="text" autocomplete="username" placeholder="请输入账号">
        </div>

        <div class="field">
          <label for="aPwd">管理密钥</label>
          <input id="aPwd" v-model="password" type="password" autocomplete="current-password" placeholder="请输入密钥">
        </div>

        <p v-if="error" class="alert">{{ error }}</p>

        <button id="aBtn" class="btn" :class="{ loading }" type="submit" :disabled="loading">
          {{ loading ? '正在进入…' : '进入后台' }}
        </button>
      </form>

      <p class="admin-login-tip">本入口仅对管理员开放，不提供注册功能。</p>

      <button class="admin-back" type="button" @click="emit('back')">← 返回前台首页</button>
    </div>
  </div>
</template>

<script>
import SeaScene from './SeaScene.vue'
export default { components: { SeaScene } }
</script>
