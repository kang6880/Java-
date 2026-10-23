<script setup>
import { ref, reactive, computed } from 'vue'
import { userApi } from '../api/user.js'

const emit = defineEmits(['success', 'switch-tab'])

/* ---------- 表单状态 ---------- */
const username = ref('')
const email = ref('')
const pwd = ref('')
const pwd2 = ref('')
const agree = ref(false)
const showPwd = ref(false)
const errors = reactive({ user: false, mail: false, pwd: false, pwd2: false })
const btnState = ref('idle') // idle | loading | success
const cardShake = ref(false)
const tipWarning = ref('')
const ripples = ref([])
let rippleId = 0

/* ---------- 密码强度 ---------- */
const strength = computed(() => {
  const v = pwd.value
  let s = 0
  if (v.length >= 6) s++
  if (v.length >= 10) s++
  if (/[A-Z]/.test(v) && /[a-z]/.test(v)) s++
  if (/\d|\W/.test(v)) s++
  return s
})
const strengthColors = ['#e2cfa8', '#e2683c', '#e8a020', '#d8c22a', '#2e9e5b']
const strengthLabels = ['未设置', '太弱了，风一吹就散', '勉强够用', '不错，能挡住小喽啰', '固若金汤，大将也破不开']

const tipText = computed(() =>
  tipWarning.value ? tipWarning.value : '密钥强度：' + strengthLabels[strength.value]
)
const tipColor = computed(() => (tipWarning.value ? '#c0392b' : '#8a6d4b'))

function barStyle(i){
  return {
    background: i < strength.value ? strengthColors[strength.value] : '#e2cfa8'
  }
}

/* ---------- 交互 ---------- */
function shakeCard(){
  cardShake.value = true
  setTimeout(() => { cardShake.value = false }, 520)
}

function clearErr(key){
  errors[key] = false
  if (key === 'pwd') tipWarning.value = ''
}

function addRipple(e){
  const el = e.currentTarget
  const r = el.getBoundingClientRect()
  const d = Math.max(r.width, r.height)
  const id = ++rippleId
  ripples.value.push({
    id,
    style: {
      width: d + 'px',
      height: d + 'px',
      left: (e.clientX - r.left - d / 2) + 'px',
      top: (e.clientY - r.top - d / 2) + 'px'
    }
  })
  setTimeout(() => {
    ripples.value = ripples.value.filter(x => x.id !== id)
  }, 700)
}

function toggleEye(){
  showPwd.value = !showPwd.value
}

/* ---------- 校验与提交 ---------- */
function validate(){
  let ok = true
  errors.user = username.value.trim().length < 3
  errors.mail = !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email.value)
  errors.pwd = pwd.value.length < 6
  errors.pwd2 = pwd2.value !== pwd.value || !pwd2.value
  ok = !errors.user && !errors.mail && !errors.pwd && !errors.pwd2
  return ok
}

async function onSubmit(){
  if (btnState.value !== 'idle') return

  if (!validate()){
    shakeCard()
    return
  }
  if (!agree.value){
    tipWarning.value = '请先勾选并同意《伟大航道航行守则》'
    shakeCard()
    return
  }

  // 调用后端 POST /api/user/register
  btnState.value = 'loading'
  tipWarning.value = ''
  try {
    const user = await userApi.register({
      username: username.value.trim(),
      email: email.value.trim(),
      password: pwd.value
    })
    btnState.value = 'success'
    emit('success', (user && user.username) || username.value.trim())
  } catch (e) {
    btnState.value = 'idle'
    // 统一展示后端返回的中文提示（如「代号已被占用」「邮箱已登记」）
    tipWarning.value = e.message
    shakeCard()
  }
}

/* 弹层关闭后重置整个表单 */
function resetForm(){
  username.value = ''
  email.value = ''
  pwd.value = ''
  pwd2.value = ''
  agree.value = false
  showPwd.value = false
  errors.user = false
  errors.mail = false
  errors.pwd = false
  errors.pwd2 = false
  btnState.value = 'idle'
  tipWarning.value = ''
}

defineExpose({ resetForm })
</script>

<template>
  <section class="card" :class="{ shake: cardShake }">
    <h2>加入船员名册</h2>
    <p class="sub">填写以下信息，即刻启航前往伟大航道</p>

    <form novalidate @submit.prevent="onSubmit">
      <div class="field" :class="{ invalid: errors.user }">
        <input type="text" id="user" v-model="username" placeholder=" " autocomplete="off" @input="clearErr('user')">
        <label for="user">航海士代号</label>
        <span class="icon">🏴‍☠️</span>
        <div class="err">代号至少 3 个字符</div>
      </div>

      <div class="field" :class="{ invalid: errors.mail }">
        <input type="email" id="mail" v-model="email" placeholder=" " autocomplete="off" @input="clearErr('mail')">
        <label for="mail">贝利邮箱</label>
        <span class="icon">📮</span>
        <div class="err">邮箱格式不正确</div>
      </div>

      <div class="field" :class="{ invalid: errors.pwd }">
        <input :type="showPwd ? 'text' : 'password'" id="pwd" v-model="pwd" placeholder=" " @input="clearErr('pwd')">
        <label for="pwd">船舱密钥</label>
        <span class="icon" @click="toggleEye">{{ showPwd ? '🙈' : '👁️' }}</span>
        <div class="err">密钥至少 6 位</div>
      </div>

      <div class="strength">
        <i v-for="i in 4" :key="i" :class="{ on: i - 1 < strength }" :style="barStyle(i - 1)"></i>
      </div>
      <div class="tip" :style="{ color: tipColor }">{{ tipText }}</div>

      <div class="field" :class="{ invalid: errors.pwd2 }">
        <input type="password" id="pwd2" v-model="pwd2" placeholder=" " @input="clearErr('pwd2')">
        <label for="pwd2">再次确认密钥</label>
        <span class="icon">🔒</span>
        <div class="err">两次输入的密钥不一致</div>
      </div>

      <label class="agree">
        <input type="checkbox" v-model="agree">
        <span>我已阅读并同意《伟大航道航行守则》与《船员保密协议》，愿意为梦想承担一切风浪。</span>
      </label>

      <button
        class="btn"
        :class="{ loading: btnState === 'loading', success: btnState === 'success' }"
        type="submit"
        @pointerdown="addRipple"
      >
        <span v-for="r in ripples" :key="r.id" class="ripple" :style="r.style"></span>
        <span class="txt">
          <svg class="spinner" viewBox="0 0 100 100">
            <g stroke="#fff" stroke-width="8" fill="none" stroke-linecap="round">
              <circle cx="50" cy="50" r="40" opacity=".3" />
              <path d="M50 10 A40 40 0 0 1 90 50" />
            </g>
          </svg>
          <svg class="check" viewBox="0 0 32 32"><path d="M6 17 L13 24 L26 9" fill="none" stroke="#fff" stroke-width="4" stroke-linecap="round" stroke-linejoin="round" /></svg>
          <span>{{ btnState === 'loading' ? '正在登记名册…' : btnState === 'success' ? '登船成功' : '登 船 注 册' }}</span>
        </span>
      </button>
    </form>

    <p class="foot">已在名册之中？ <a href="#" @click.prevent="emit('switch-tab', 'login')">返回登录</a></p>
  </section>
</template>
