@echo off
rem ============================================================
rem  一键停止：后端（8081）+ 前端（5173）
rem ============================================================
chcp 936 >nul
title Luffy 一键停止

echo 正在停止后端（端口 8081）...
for /f "tokens=5" %%p in ('netstat -ano ^| findstr ":8081" ^| findstr "LISTENING"') do taskkill /F /PID %%p >nul 2>&1

echo 正在停止前端（端口 5173）...
for /f "tokens=5" %%p in ('netstat -ano ^| findstr ":5173" ^| findstr "LISTENING"') do taskkill /F /PID %%p >nul 2>&1

echo.
echo 已全部停止。窗口可关闭。
pause
