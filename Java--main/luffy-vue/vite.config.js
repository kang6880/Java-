import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

// 后端 Spring Boot 服务地址（application-dev.properties 中 server.port=8081）
const BACKEND = 'http://localhost:8081'

export default defineConfig({
  plugins: [vue()],
  server: {
    port: 5173,
    host: true,
    // 开发环境代理：前端请求 /api/** 一律转发到后端，浏览器视角是同源，天然没有跨域问题
    proxy: {
      '/api': {
        target: BACKEND,
        changeOrigin: true
      }
    }
  }
})
