import { createApp } from 'vue'
import App from './App.vue'
import './style.css'

const app = createApp(App)
app.mount('#app')

/* 全局点击涟漪特效：在点击位置生成一圈金色波纹
 *
 * 性能优化（原实现每次点击都 appendChild 一个新节点，快速/连续点击时会堆积大量 DOM，
 * 是卡顿主因之一）：
 *  1. 复用单个 <span> 节点，动画结束后归位复用，不再反复增删 DOM；
 *  2. 节流：距上次波纹 < 90ms 的点击直接忽略，避免连点风暴；
 *  3. 跳过文本选中、拖拽等非点击操作（只响应鼠标主键）。
 */
const rippleEl = document.createElement('span')
rippleEl.className = 'click-ripple'
rippleEl.style.display = 'none'
document.body.appendChild(rippleEl)

let lastRippleAt = 0

document.addEventListener('pointerdown', (e) => {
  if (e.button !== 0 && e.pointerType === 'mouse') return // 只响应鼠标左键

  const now = performance.now()
  if (now - lastRippleAt < 90) return // 节流：连点只画一次
  lastRippleAt = now

  rippleEl.style.left = e.clientX + 'px'
  rippleEl.style.top = e.clientY + 'px'
  // 移除再强制回流以重启动画，然后用 RAF 挂上（避免同帧 style 合并导致动画不重启）
  rippleEl.style.animation = 'none'
  rippleEl.style.display = 'block'
  // 强制重排，确保 animation 重新开始
  void rippleEl.offsetWidth
  rippleEl.style.animation = ''
})

/* 动画结束即隐藏并复用节点（不删除） */
rippleEl.addEventListener('animationend', () => {
  rippleEl.style.display = 'none'
})

/* 性能优化：标签页切到后台时暂停所有装饰动画（配合 style.css 的 .page-hidden 规则），
   切回前台再恢复，显著降低后台 CPU/GPU 占用 */
document.addEventListener('visibilitychange', () => {
  document.documentElement.classList.toggle('page-hidden', document.hidden)
})
