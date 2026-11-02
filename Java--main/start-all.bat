@echo off
rem ============================================================
rem  航海王项目 一键启动入口（调用 PowerShell 脚本）
rem  双击本文件即可：数据库自检 + 后端 8081 + 前端 5173 + 打开浏览器
rem  停止：双击 stop-all.bat
rem ============================================================
chcp 936 >nul
title 航海王项目 一键启动
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0start-all.ps1"
pause
