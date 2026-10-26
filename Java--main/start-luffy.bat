@echo off
title Luffy One-Click Launcher
set "BASE=%~dp0backend-8081"

echo ============================================
echo  Luffy Crew Registration - One Click Start
echo ============================================

rem Check if backend already listening on 8081
netstat -ano | findstr ":8081" | findstr "LISTENING" >nul
if errorlevel 1 (
    echo [1/2] Backend not running. Starting backend, please wait ...
    start "springBootTest Backend" /min cmd /c "cd /d "%BASE%" && java -jar target\springBootTest-0.0.1-SNAPSHOT.jar --server.port=8081"
    timeout /t 10 /nobreak >nul
) else (
    echo [1/2] Backend already running on port 8081.
)

echo [2/2] Opening Luffy.html in your browser ...
start "" "%~dp0frontend-5173\Luffy.html"

echo.
echo Done! This window can be closed.
timeout /t 3 /nobreak >nul
