<script setup>
import { ref, onMounted } from 'vue'
import { homeApi } from '../api/home.js'

/* 草帽一伙头像展示：数据源为数据库 home_crew 表（通过 /api/home/crews/preview 拉取），
 * 保证与船员名册、后台管理单一数据源一致。
 * 仅保留一份静态兜底：当后端未启动/接口异常时，头像墙仍能显示，不至于空白。 */
const crew = ref([])

const FALLBACK = [
  { icon: '🎩', name: '蒙奇·D·路飞', position: '船长' },
  { icon: '🗡️', name: '罗罗诺亚·索隆', position: '剑士' },
  { icon: '🍊', name: '娜美', position: '航海士' },
  { icon: '🎯', name: '乌索普', position: '狙击手' },
  { icon: '🚬', name: '文斯莫克·山治', position: '厨师' },
  { icon: '🦌', name: '托尼托尼·乔巴', position: '船医' },
  { icon: '📚', name: '妮可·罗宾', position: '考古学家' },
  { icon: '🔧', name: '弗兰奇', position: '船匠' },
  { icon: '🎻', name: '布鲁克', position: '音乐家' },
  { icon: '👊', name: '甚平', position: '舵手' }
]

onMounted(async () => {
  try {
    const list = await homeApi.previewCrews()
    if (Array.isArray(list) && list.length) {
      crew.value = list.slice(0, 10)
    } else {
      crew.value = FALLBACK
    }
  } catch {
    crew.value = FALLBACK
  }
})
</script>

<template>
  <section class="brand">
    <!-- 舵轮 -->
    <svg class="wheel" viewBox="0 0 100 100">
      <g stroke="#f2c14e" stroke-width="5" fill="none" stroke-linecap="round">
        <circle cx="50" cy="50" r="40" />
        <circle cx="50" cy="50" r="14" fill="#0b3f6f" />
      </g>
      <g stroke="#f2c14e" stroke-width="5" stroke-linecap="round">
        <path d="M50 10 L50 36" /><path d="M50 64 L50 90" />
        <path d="M10 50 L36 50" /><path d="M64 50 L90 50" />
        <path d="M22 22 L41 41" /><path d="M59 59 L78 78" />
        <path d="M78 22 L59 41" /><path d="M41 59 L22 78" />
      </g>
      <circle cx="50" cy="50" r="5" fill="#f7e9cd" />
    </svg>

    <h1><small>O N E &nbsp; P I E C E</small>船员招募登记处</h1>

    <!-- 草帽一伙头像墙：贴合动漫的角色展示 -->
    <div class="crew-wall">
      <p class="crew-wall-title">☠ 草帽一伙 · 期待你的加入</p>
      <ul class="crew-orbit">
        <li
          v-for="(c, i) in crew"
          :key="c.name"
          class="crew-avatar"
          :style="{ animationDelay: (i * 0.35) + 's' }"
          :title="c.name + ' · ' + (c.position || c.alias || '')"
        >
          <span class="crew-emoji">{{ c.icon }}</span>
          <span class="crew-name">{{ c.name }}</span>
        </li>
      </ul>
    </div>

    <div class="wanted">
      登记须知 ——<br>
      ① 悬赏金：<b>面议</b>，按战力结算<br>
      ② 抵达集合地：<b>香波迪群岛 · 1 号码头</b><br>
      ③ 携带物品：梦想 ≥ <b>1 个</b><br>
      ④ 禁止事项：背叛同伴（唯一不可饶恕之罪）
    </div>

    <p class="quote">"世代传承的意志、时代的浪潮、人的梦想 —— 这些都是无法阻挡的。"</p>
  </section>
</template>
