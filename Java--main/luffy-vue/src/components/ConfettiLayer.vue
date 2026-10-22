<script setup>
import { ref } from 'vue'

const on = ref(false)
const pieces = ref([])
let timer = null

/* 撒花庆祝：矩形彩纸 + 贝利金币 */
function celebrate(){
  clearTimeout(timer)
  const colors = ['#f2c14e', '#e2683c', '#2e9e5b', '#3fa9dd', '#c0392b', '#f7e9cd']
  pieces.value = Array.from({ length: 90 }, (_, i) => {
    const coin = Math.random() < 0.35
    return {
      id: i,
      cls: coin ? 'p coin' : 'p rect',
      style: {
        background: coin ? '' : colors[i % colors.length],
        left: Math.random() * 100 + 'vw',
        animation: `fall ${2 + Math.random() * 1.6}s linear ${Math.random() * 0.6}s forwards`
      }
    }
  })
  on.value = true
  timer = setTimeout(() => {
    on.value = false
    pieces.value = []
  }, 4200)
}

defineExpose({ celebrate })
</script>

<template>
  <div class="confetti" :class="{ on }">
    <div v-for="p in pieces" :key="p.id" :class="p.cls" :style="p.style"></div>
  </div>
</template>
