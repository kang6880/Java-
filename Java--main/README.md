# 航海王 · 船员招募登记系统

一个以《航海王》为主题的 Spring Boot + Vue3 全栈学习项目。

## 技术栈

- **后端**：Spring Boot 3.4.5 + MyBatis-Plus 3.5.9 + MySQL 8.0（端口 8081）
- **前端**：Vue3 + Vite5（端口 5173）
- **数据库**：MySQL，库名 `springboottest`（root / 123456）

## 快速启动

双击 `start-all.bat` 一键启动（数据库自检 → 后端 → 前端 → 打开浏览器）。

| 脚本 | 作用 |
|------|------|
| `start-all.bat` | 一键启动全部服务 |
| `stop-all.bat` | 一键停止全部服务 |
| `start-backend.bat` | 仅启动后端 |
| `start-frontend.bat` | 仅启动前端 |

## 功能模块

- **用户体系**：注册 / 登录 / 密码重置 / 个人中心（BCrypt 加密 + Token 鉴权）
- **前台首页**：船员名册、航线图鉴、悬赏令、杂货小镇、篇章故事、全站搜索
- **航海王全史**：时间线展示（/onepiece，无需登录）
- **后台管理**：五大数据模块增删改查（/admin）

## 演示账号

- 用户名：`路飞`　密码：`123456`

## 数据库

结构 + 数据快照见 `springboottest.sql`，重建命令：

```bash
mysql -uroot -p123456 --default-character-set=utf8mb4 < springboottest.sql
```
