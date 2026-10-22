<script setup>
import { ref } from 'vue'
import SeaScene from './components/SeaScene.vue'
import BrandPanel from './components/BrandPanel.vue'
import RegisterForm from './components/RegisterForm.vue'
import SuccessModal from './components/SuccessModal.vue'
import ConfettiLayer from './components/ConfettiLayer.vue'

const registerFormRef = ref(null)
const confettiRef = ref(null)
const maskShow = ref(false)
const who = ref('船长')

function onSuccess(name){
  who.value = name || '船长'
  confettiRef.value?.celebrate()
  setTimeout(() => { maskShow.value = true }, 420)
}

function closeMask(){
  maskShow.value = false
  setTimeout(() => {
    registerFormRef.value?.resetForm()
  }, 300)
}
</script>

<template>
  <!-- 背景场景 -->
  <SeaScene />

  <main class="stage">
    <!-- 左侧招募令 -->
    <BrandPanel />
    <!-- 右侧表单 -->
    <RegisterForm ref="registerFormRef" @success="onSuccess" />
  </main>

  <!-- 成功弹层 -->
  <SuccessModal :show="maskShow" :who="who" @close="closeMask" />
  <!-- 庆祝粒子 -->
  <ConfettiLayer ref="confettiRef" />
</template>
