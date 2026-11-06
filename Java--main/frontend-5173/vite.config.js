import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

// 本机局域网 IP（前后端统一绑定此地址，供局域网内其它设备访问）
const LOCAL_IP = '192.168.68.40'

// 后端 Spring Boot 服务地址（application-dev.properties 中 server.port=8081）
const BACKEND = `http://${LOCAL_IP}:8081`

export default defineConfig({
  plugins: [vue()],
  server: {
    port: 5173,
    strictPort: true,
    // 绑定局域网 IP：手机/其它电脑通过 http://192.168.68.40:5173 访问前端
    host: LOCAL_IP,
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
