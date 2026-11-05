@echo off
rem ============================================================
rem  航海王项目 一键启动（自包含版，不依赖 ps1）
rem  双击本文件即可：数据库自检 -> 后端 8081 -> 前端 5173 -> 打开浏览器
rem  停止：双击 stop-all.bat
rem ============================================================
chcp 936 >nul
title 航海王项目 一键启动
setlocal enabledelayedexpansion

set ROOT=%~dp0
set BACKEND=%ROOT%backend-8081
set FRONTEND=%ROOT%frontend-5173
set MYSQL="C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe"
set JAR=%BACKEND%\target\springBootTest-0.0.1-SNAPSHOT.jar

echo.
echo ============ [1/4] 数据库自检 ============
%MYSQL% -uroot -p123456 -e "USE springboottest; SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo   [警告] 无法连接数据库 springboottest，请确认 MySQL 已启动且账号密码正确。
    echo          脚本将继续启动后端，但接口可能报数据库错误。
) else (
    echo   [OK] 数据库 springboottest 连接正常。
)

echo.
echo ============ [2/4] 后端编译检查 ============
if exist "%JAR%" (
    echo   [OK] 已有编译产物，跳过编译。
) else (
    echo   [编译] 未发现编译产物，开始编译（首次约 1-2 分钟）...
    pushd "%BACKEND%"
    call mvnw.cmd -s maven-settings.xml -DskipTests package
    if errorlevel 1 (
        echo   [错误] 后端编译失败！请检查网络或 maven-settings.xml 配置。
        popd
        pause
        exit /b 1
    )
    popd
)

echo.
echo ============ [3/4] 启动前后端 ============
rem 先停掉可能残留的同名进程，避免端口占用
call "%ROOT%stop-all.bat" >nul 2>&1

echo   启动后端（端口 8081）...
start "springBootTest-8081" /min cmd /c "cd /d "%BACKEND%" && java -jar target\springBootTest-0.0.1-SNAPSHOT.jar --server.port=8081"

echo   启动前端（端口 5173）...
start "luffy-vue-5173" /min cmd /c "cd /d "%FRONTEND%" && npm run dev -- --strictPort"

echo.
echo ============ [4/4] 健康检查 ============
echo   等待后端就绪（最多 60 秒）...
set READY=0
for /l %%i in (1,1,30) do (
    timeout /t 2 /nobreak >nul
    curl -s -o nul http://127.0.0.1:8081/api/home/summary
    if not errorlevel 1 (
        set READY=1
        goto :backend_ok
    )
)
:backend_ok
if "!READY!"=="1" (
    echo   [OK] 后端 8081 已就绪。
) else (
    echo   [提示] 后端仍在启动中，稍后会自动就绪。
)

echo   等待前端就绪...
set FREADY=0
for /l %%i in (1,1,20) do (
    timeout /t 1 /nobreak >nul
    curl -s -o nul http://localhost:5173/
    if not errorlevel 1 (
        set FREADY=1
        goto :front_ok
    )
)
:front_ok
if "!FREADY!"=="1" (
    echo   [OK] 前端 5173 已就绪。
) else (
    echo   [提示] 前端仍在启动中。
)

echo.
echo ============ 启动完成 ============
echo   前端访问地址：http://localhost:5173
echo   后端 API 地址：http://127.0.0.1:8081
echo   演示账号：路飞 / 123456
echo.
echo   关闭两个最小化窗口即可停止前后端；或双击 stop-all.bat 一键停止。
echo.
start "" http://localhost:5173

endlocal
pause
