<script setup>
import { ref, reactive } from 'vue'
import { userApi } from '../api/user.js'

/**
 * 重置密钥（罗宾重置）—— 移植自单文件版 Luffy.html 的 view-reset 视图
 * 代号 + 绑定邮箱双重验证，通过后设置新密钥
 */
const emit = defineEmits(['success', 'switch-tab'])

/* ---------- 表单状态 ---------- */
const username = ref('')
const email = ref('')
const pwd = ref('')
const showPwd = ref(false)
const errors = reactive({ user: false, mail: false, pwd: false })
const btnState = ref('idle') // idle | loading | success
const cardShake = ref(false)
const tipWarning = ref('')

/* ---------- 交互 ---------- */
function shakeCard () {
  cardShake.value = true
  setTimeout(() => { cardShake.value = false }, 520)
}

function clearErr (key) {
  errors[key] = false
  tipWarning.value = ''
}

/* ---------- 校验与提交 ---------- */
function validate () {
  errors.user = !username.value.trim()
  errors.mail = !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email.value)
  errors.pwd = pwd.value.length < 6
  return !errors.user && !errors.mail && !errors.pwd
}

async function onSubmit () {
  if (btnState.value !== 'idle') return

  if (!validate()) {
    shakeCard()
    return
  }

  // 调用后端 POST /api/user/reset
  btnState.value = 'loading'
  tipWarning.value = ''
  try {
    await userApi.resetPassword({
      username: username.value.trim(),
      email: email.value.trim(),
      password: pwd.value
    })
    btnState.value = 'success'
    // 稍作停留让「重置成功」状态可见，再回登录页并预填代号
    const name = username.value.trim()
    setTimeout(() => emit('success', name), 600)
  } catch (e) {
    btnState.value = 'idle'
    tipWarning.value = e.message
    shakeCard()
  }
}

/* 回到登录页前清空表单，避免残留 */
function resetForm () {
  username.value = ''
  email.value = ''
  pwd.value = ''
  showPwd.value = false
  errors.user = false
  errors.mail = false
  errors.pwd = false
  btnState.value = 'idle'
  tipWarning.value = ''
}
</script>

<template>
  <section class="card" :class="{ shake: cardShake }">
    <h2>罗宾帮你重置密钥</h2>
    <p class="sub">代号 + 绑定邮箱双重验证，通过后即可设置新密钥</p>

    <div v-if="tipWarning" class="alert">{{ tipWarning }}</div>

    <form novalidate @submit.prevent="onSubmit">
      <div class="field" :class="{ invalid: errors.user }">
        <input type="text" id="rUser" v-model="username" placeholder=" " autocomplete="off" @input="clearErr('user')">
        <label for="rUser">航海士代号</label>
        <span class="icon">🏴‍☠️</span>
        <div class="err">请输入代号</div>
      </div>

      <div class="field" :class="{ invalid: errors.mail }">
        <input type="email" id="rMail" v-model="email" placeholder=" " autocomplete="off" @input="clearErr('mail')">
        <label for="rMail">绑定的贝利邮箱</label>
        <span class="icon">📮</span>
        <div class="err">邮箱格式不正确</div>
      </div>

      <div class="field" :class="{ invalid: errors.pwd }">
        <input :type="showPwd ? 'text' : 'password'" id="rPwd" v-model="pwd" placeholder=" " @input="clearErr('pwd')">
        <label for="rPwd">新的船舱密钥</label>
        <span class="icon" @click="showPwd = !showPwd">{{ showPwd ? '🙈' : '👁️' }}</span>
        <div class="err">新密钥至少 6 位</div>
      </div>

      <button
        class="btn"
        :class="{ loading: btnState === 'loading', success: btnState === 'success' }"
        type="submit"
      >
        <span class="txt">
          <svg class="spinner" viewBox="0 0 100 100">
            <g stroke="#fff" stroke-width="8" fill="none" stroke-linecap="round">
              <circle cx="50" cy="50" r="40" opacity=".3" />
              <path d="M50 10 A40 40 0 0 1 90 50" />
            </g>
          </svg>
          <svg class="check" viewBox="0 0 32 32"><path d="M6 17 L13 24 L26 9" fill="none" stroke="#fff" stroke-width="4" stroke-linecap="round" stroke-linejoin="round" /></svg>
          <span>{{ btnState === 'loading' ? '正在重置…' : btnState === 'success' ? '重置成功' : '重 置 密 钥' }}</span>
        </span>
      </button>
    </form>

    <p class="foot"><a href="#" @click.prevent="emit('switch-tab', 'login')">← 返回登录</a></p>
  </section>
</template>
