import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

// 后端 Spring Boot 服务地址（application-dev.properties 中 server.port=8081）
// 用 127.0.0.1 而非 localhost：避免 Windows 上 localhost 偶发解析到 IPv6(::1) 导致代理连接被拒
const BACKEND = 'http://127.0.0.1:8081'

export default defineConfig({
  plugins: [vue()],
  server: {
    port: 5173,
    host: true,
    // 开发环境代理：前端请求 /api/** 一律转发到后端，浏览器视角是同源，天然没有跨域问题
    proxy: {
      '/api': {
        target: BACKEND,
        changeOrigin: true,
        // 后端冷启动/瞬时抖动时避免前端一直挂起，超时后快速报错便于重试
        timeout: 10000
      }
    }
  }
})
