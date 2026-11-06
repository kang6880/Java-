@echo off
rem ============================================================
rem  航海王项目 一键停止（自包含版，不依赖 ps1）
rem  通过端口 8081 / 5173 找到并结束对应进程
rem ============================================================
chcp 65001 >nul
title 航海王项目 一键停止
setlocal enabledelayedexpansion

echo.
echo ============ 正在停止航海王项目 ============

rem 结束占用 8081（后端）的进程
set FOUND=0
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":8081" ^| findstr "LISTENING"') do (
    echo   停止后端进程 PID=%%a（端口 8081）
    taskkill /F /PID %%a >nul 2>&1
    set FOUND=1
)
if "!FOUND!"=="0" echo   后端（8081）未在运行。

rem 结束占用 5173（前端）的进程
set FOUND=0
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":5173" ^| findstr "LISTENING"') do (
    echo   停止前端进程 PID=%%a（端口 5173）
    taskkill /F /PID %%a >nul 2>&1
    set FOUND=1
)
if "!FOUND!"=="0" echo   前端（5173）未在运行。

echo.
echo   [完成] 所有服务已停止。
echo.

endlocal
pause
