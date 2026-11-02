@echo off
rem ============================================================
rem  一键停止入口（调用 PowerShell 脚本）
rem ============================================================
chcp 936 >nul
title 航海王项目 一键停止
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0stop-all.ps1"
pause
