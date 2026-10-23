<script setup>
import { ref } from 'vue'
import { userApi } from '../api/user.js'

const emit = defineEmits(['success', 'switch-tab'])

const account = ref('')
const pwd = ref('')
const showPwd = ref(false)
const loading = ref(false)
const tipWarning = ref('')
const shakeCard = ref(false)

function clearErr () {
  tipWarning.value = ''
}

async function onSubmit () {
  if (loading.value) return
  if (!account.value.trim() || !pwd.value) {
    tipWarning.value = '请输入航海士代号与船舱密钥'
    shakeCard.value = true
    setTimeout(() => { shakeCard.value = false }, 520)
    return
  }

  loading.value = true
  tipWarning.value = ''
  try {
    // 调用后端 POST /api/user/login，成功后 token/档案由 userApi 统一存入 localStorage
    const data = await userApi.login({
      account: account.value.trim(),
      password: pwd.value
    })
    emit('success', (data && data.username) || account.value.trim())
  } catch (e) {
    tipWarning.value = e.message
    shakeCard.value = true
    setTimeout(() => { shakeCard.value = false }, 520)
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <section class="card" :class="{ shake: shakeCard }">
    <h2>欢迎回来，航海士</h2>
    <p class="sub">用航海士代号或贝利邮箱验证身份，继续你的航程</p>

    <div v-if="tipWarning" class="alert">{{ tipWarning }}</div>

    <form novalidate @submit.prevent="onSubmit">
      <div class="field">
        <input type="text" id="lAccount" v-model="account" placeholder=" " autocomplete="username" @input="clearErr">
        <label for="lAccount">航海士代号 / 贝利邮箱</label>
        <span class="icon">🧭</span>
      </div>

      <div class="field">
        <input :type="showPwd ? 'text' : 'password'" id="lPwd" v-model="pwd" placeholder=" " autocomplete="current-password" @input="clearErr">
        <label for="lPwd">船舱密钥</label>
        <span class="icon" @click="showPwd = !showPwd">{{ showPwd ? '🙈' : '👁️' }}</span>
      </div>

      <button id="lBtn" class="btn" :class="{ loading }" type="submit">
        <span class="txt">
          <svg class="spinner" viewBox="0 0 100 100">
            <g stroke="#fff" stroke-width="8" fill="none" stroke-linecap="round">
              <circle cx="50" cy="50" r="40" opacity=".3" />
              <path d="M50 10 A40 40 0 0 1 90 50" />
            </g>
          </svg>
          <span>{{ loading ? '正在验证身份…' : '登 船 启 航' }}</span>
        </span>
      </button>
    </form>

    <p class="foot">还没有名册？ <a href="#" @click.prevent="emit('switch-tab', 'register')">去登记</a></p>
  </section>
</template>
