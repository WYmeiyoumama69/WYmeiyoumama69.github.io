@echo off
chcp 65001 >nul
title 丁卓 · 个人主页 - 部署到 GitHub Pages
cd /d "%~dp0"

echo ============================================
echo   部署到 GitHub Pages
echo ============================================
echo.

if "%1"=="" (
  echo 用法: deploy.cmd 你的GitHub用户名
  echo 例如: deploy.cmd zhuoding
  echo.
  echo 部署后网址将是:
  echo     https://你的用户名.github.io/
  echo.
  echo 提示: 仓库必须命名为  你的用户名.github.io  才能得到上面的根网址。
  exit /b 1
)

set "USERNAME=%1"
set "REPO=%USERNAME%.github.io"
set "REMOTE=https://github.com/%USERNAME%/%REPO%.git"

echo GitHub 用户: %USERNAME%
echo 仓库名     : %REPO%
echo 远程地址   : %REMOTE%
echo.

if not exist ".git" (
  echo [1/4] 初始化本地仓库...
  git init -b main
) else (
  echo [1/4] 本地仓库已存在，跳过初始化。
)

if not exist ".nojekyll" type nul > .nojekyll

echo [2/4] 暂存文件...
git add -A

echo [3/4] 提交...
git commit -m "feat: Persona 3 Reload 风格个人主页 + 数字分身模块" 2>nul
if not %errorlevel%==0 echo     没有新改动需要提交。

echo [4/4] 推送...
git remote remove origin 2>nul
git remote add origin "%REMOTE%"
git push -u origin main

if %errorlevel%==0 (
  echo.
  echo ============================================
  echo   推送成功！
  echo.
  echo   接下来在浏览器打开:
  echo     %REMOTE:.git=%
  echo   进入 Settings - Pages
  echo     Source 选择: Deploy from a branch
  echo     Branch 选择: main  /  (root)
  echo     点击 Save
  echo.
  echo   等 1-2 分钟后访问:
  echo     https://%REPO%/
  echo ============================================
) else (
  echo.
  echo [!] 推送失败。常见原因:
  echo     1. GitHub 上还没有创建仓库 %REPO%
  echo     2. 未登录或凭据过期（会弹出登录窗口，建议用 Token）
  echo     3. 用户名拼写有误
)

echo.
pause
