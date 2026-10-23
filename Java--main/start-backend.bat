@echo off
rem ============================================================
rem  仅启动后端 springBootTest（端口 8081）
rem  target 缺失时自动用 Maven Wrapper 编译
rem ============================================================
chcp 936 >nul
title springBootTest 后端 8081
cd /d "%~dp0backend-8081"

if exist "target\springBootTest-0.0.1-SNAPSHOT.jar" (
    echo [1/2] 已有编译产物，跳过编译。
) else (
    echo [1/2] 未发现编译产物，开始编译（首次约 1-2 分钟）...
    call mvnw.cmd -s maven-settings.xml -DskipTests package
    if errorlevel 1 (
        echo 编译失败！请检查网络或 maven-settings.xml 配置。
        pause
        exit /b 1
    )
)

echo [2/2] 启动后端：http://localhost:8081/Luffy.html
echo 关闭本窗口即停止后端。
java -jar target\springBootTest-0.0.1-SNAPSHOT.jar --server.port=8081
pause
