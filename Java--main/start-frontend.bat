@echo off
rem ============================================================
rem  仅启动前端 luffy-vue（Vite 开发服务器，端口 5173）
rem  node_modules 缺失时自动用 npmmirror 镜像安装依赖
rem ============================================================
chcp 936 >nul
title luffy-vue 前端 5173
cd /d "%~dp0frontend-5173"

if exist "node_modules\" (
    echo [1/2] 依赖已就绪，跳过安装。
) else (
    echo [1/2] node_modules 缺失，正在安装依赖（首次约 1-3 分钟）...
    call npm ci --no-audit --no-fund
    if errorlevel 1 call npm install --no-audit --no-fund
)

echo [2/2] 启动 Vite 开发服务器 ...
echo 8 秒后自动打开浏览器，关闭本窗口即停止前端。
start "" cmd /c "timeout /t 8 /nobreak >nul && start "" http://localhost:5173"
call npm run dev
pause
