@echo off
chcp 65001 >nul
title 丁卓 · 个人主页 - 本地预览
cd /d "%~dp0"

echo ============================================
echo   丁卓 · 个人主页  本地预览
echo ============================================
echo.

where python >nul 2>nul
if %errorlevel%==0 (
  set "SRV=python"
  set "ARGS=-m http.server 8080 --bind 127.0.0.1"
  goto :run
)

where py >nul 2>nul
if %errorlevel%==0 (
  set "SRV=py"
  set "ARGS=-m http.server 8080 --bind 127.0.0.1"
  goto :run
)

where npx >nul 2>nul
if %errorlevel%==0 (
  set "SRV=npx"
  set "ARGS=--yes serve -l 8080 ."
  goto :run
)

echo [!] 没找到 python 或 npx，改为直接用浏览器打开本地文件。
echo     注意：直接打开时数字分身、主题切换等功能依然可用。
start "" "index.html"
goto :eof

:run
echo 服务地址: http://127.0.0.1:8080/
echo 按 Ctrl+C 停止服务。
echo.
start "" "http://127.0.0.1:8080/"
%SRV% %ARGS%
