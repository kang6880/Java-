import { createApp } from 'vue'
import App from './App.vue'
import './style.css'

const app = createApp(App)
app.mount('#app')

/* 全局点击涟漪特效：在点击位置生成一圈金色波纹 */
document.addEventListener('pointerdown', (e) => {
  // 忽略按钮内的自带涟漪（RegisterForm 的 addRipple 已处理），避免双重特效
  const el = document.createElement('span')
  el.className = 'click-ripple'
  const x = e.clientX
  const y = e.clientY
  el.style.left = x + 'px'
  el.style.top = y + 'px'
  document.body.appendChild(el)
  el.addEventListener('animationend', () => el.remove())
  setTimeout(() => el.remove(), 800)
})
