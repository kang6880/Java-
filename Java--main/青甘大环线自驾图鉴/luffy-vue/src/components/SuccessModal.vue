<script setup>
defineProps({
  show: { type: Boolean, default: false },
  who: { type: String, default: '船长' }
})
const emit = defineEmits(['close'])
</script>

<template>
  <div class="mask" :class="{ show }">
    <div class="flag">
      <div class="post"></div>
      <h3>🎉 登船成功！</h3>
      <p>欢迎加入，<span class="who">{{ who }}</span>！<br>你的旗帜已升起，伟大航道在前方等你。</p>
      <button @click="emit('close')">继 续 航 行</button>
    </div>
  </div>
</template>
