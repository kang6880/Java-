@echo off
rem ============================================================
rem  Luffy 一键启动（后端 8081 + 前端 5173 + 数据库自检）
rem  特点：电脑重置后 node_modules / target 被删也能直接跑
rem  停止：双击 stop-all.bat，或关掉对应的黑窗口
rem ============================================================
chcp 936 >nul
title Luffy 一键启动

rem ---------- 1. 数据库自检：springboottest 库不存在则自动初始化 ----------
set "MYSQL=mysql"
mysql --version >nul 2>&1 || set "MYSQL=C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe"
"%MYSQL%" -uroot -p123456 -e "USE springboottest;" >nul 2>&1
if errorlevel 1 (
    echo [1/3] 检测到 springboottest 库不存在，正在执行 SQL 初始化 ...
    "%MYSQL%" -uroot -p123456 --default-character-set=utf8mb4 < "%~dp0luffy_register.sql"
    if errorlevel 1 (
        echo 数据库初始化失败！请确认 MySQL 已启动且账号密码为 root/123456。
        pause
        exit /b 1
    )
) else (
    echo [1/3] 数据库 springboottest 正常。
)

rem ---------- 2. 后端：8081 未监听则编译（如缺 target）并启动 ----------
netstat -ano | findstr ":8081" | findstr "LISTENING" >nul
if errorlevel 1 (
    echo [2/3] 后端未启动，正在后台编译并启动（首次约 1-2 分钟）...
    start "springBootTest Backend" /min cmd /c "cd /d %~dp0backend-8081 && if not exist target\springBootTest-0.0.1-SNAPSHOT.jar call mvnw.cmd -s maven-settings.xml -DskipTests package && java -jar target\springBootTest-0.0.1-SNAPSHOT.jar --server.port=8081"
    echo     等待后端就绪 ...
    timeout /t 15 /nobreak >nul
) else (
    echo [2/3] 后端已在 8081 运行。
)

rem ---------- 3. 前端：5173 未监听则装依赖（如缺 node_modules）并启动 ----------
netstat -ano | findstr ":5173" | findstr "LISTENING" >nul
if errorlevel 1 (
    echo [3/3] 前端未启动，正在后台安装依赖并启动（首次约 1-3 分钟）...
    start "luffy-vue Dev" /min cmd /c "cd /d %~dp0frontend-5173 && if not exist node_modules call npm ci --no-audit --no-fund || call npm install --no-audit --no-fund && npm run dev"
    echo     等待前端就绪 ...
    timeout /t 8 /nobreak >nul
) else (
    echo [3/3] 前端已在 5173 运行。
)

echo.
echo ============================================
echo  全部就绪！即将打开浏览器 ...
echo  单文件版页面：也可双击 Luffy.html
echo  停止服务：双击 stop-all.bat
echo ============================================
start "" http://localhost:5173
pause
