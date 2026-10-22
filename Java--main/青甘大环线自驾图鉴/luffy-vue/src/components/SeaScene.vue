<script setup>
import { ref } from 'vue'

/* 装饰：云与海鸥（与原版位置一致，延迟随机） */
const clouds = [
  { top: 120, width: 60,  height: 26, duration: 120 },
  { top: 300, width: 140, height: 34, duration: 90 },
  { top: 520, width: 80,  height: 22, duration: 150 }
].map(c => ({
  ...c,
  delay: -(Math.random() * c.duration)
}))

const gulls = [
  { top: 70,  size: 11, duration: 26 },
  { top: 110, size: 9,  duration: 34 },
  { top: 150, size: 13, duration: 30 }
].map(g => ({
  ...g,
  delay: -(Math.random() * g.duration),
  text: '🕊️'
}))

const sceneRef = ref(null)
</script>

<template>
  <div class="scene" ref="sceneRef">
    <div class="sun"></div>

    <div
      v-for="(c, i) in clouds"
      :key="'cloud-' + i"
      class="cloud"
      :style="{
        top: c.top + 'px',
        width: c.width + 'px',
        height: c.height + 'px',
        animationDuration: c.duration + 's',
        animationDelay: c.delay + 's'
      }"
    ></div>

    <div
      v-for="(g, i) in gulls"
      :key="'gull-' + i"
      class="gull"
      :style="{
        top: g.top + 'px',
        fontSize: g.size + 'px',
        animationDuration: g.duration + 's',
        animationDelay: g.delay + 's'
      }"
    >{{ g.text }}</div>

    <div class="wave w3"><svg viewBox="0 0 1440 200" preserveAspectRatio="none"><path fill="#0d4c7d" d="M0,120 C240,60 360,180 720,120 C1080,60 1200,180 1440,120 L1440,200 L0,200 Z"/></svg></div>
    <div class="wave w2"><svg viewBox="0 0 1440 200" preserveAspectRatio="none"><path fill="#12629b" d="M0,140 C200,90 340,190 720,140 C1100,90 1240,190 1440,140 L1440,200 L0,200 Z"/></svg></div>
    <div class="wave w1"><svg viewBox="0 0 1440 200" preserveAspectRatio="none"><path fill="#1a78b8" d="M0,160 C260,110 420,200 720,160 C1020,120 1180,200 1440,160 L1440,200 L0,200 Z"/></svg></div>
  </div>
</template>
