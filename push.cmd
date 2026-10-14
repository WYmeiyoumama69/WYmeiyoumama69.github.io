@echo off
chcp 65001 >nul
title 推送到 GitHub - WYmeiyoumama69
cd /d "%~dp0"

echo ============================================
echo   推送个人主页到 GitHub
echo ============================================
echo.
echo 当前目录: %CD%
echo.

if not exist ".git" (
  echo [X] 当前目录下没有 .git，无法推送。
  echo     请确认这个脚本放在 D:\个人网站 文件夹里。
  echo.
  pause
  exit /b 1
)

echo [1/4] 检查仓库状态...
git rev-parse --abbrev-ref HEAD
git log --oneline -1
echo.

echo [2/4] 检查代理设置（本机代理 127.0.0.1:7897）...
git config --global --get http.https://github.com/.proxy >nul 2>nul
if not %errorlevel%==0 (
  echo     未设置，正在配置...
  git config --global http.https://github.com/.proxy http://127.0.0.1:7897
)
git config --global --get http.https://github.com/.proxy
echo.

echo [3/4] 确保远程地址正确...
git remote remove origin >nul 2>nul
git remote add origin https://github.com/WYmeiyoumama69/WYmeiyoumama69.github.io.git
git remote -v
echo.

echo [4/4] 开始推送...
echo.
echo   >>> 如果弹出 GitHub 登录窗口，请选择 "Sign in with your browser"
echo   >>> 然后在浏览器里完成授权，回来即可自动推送完成
echo.
git push -u origin main

if %errorlevel%==0 (
  echo.
  echo ============================================
  echo   推送成功！
  echo.
  echo   最后一步：开启 GitHub Pages
  echo     1. 打开 https://github.com/WYmeiyoumama69/WYmeiyoumama69.github.io/settings/pages
  echo     2. Source 选 "Deploy from a branch"
  echo     3. Branch 选 main，目录选 / (root)
  echo     4. 点 Save
  echo.
  echo   1-2 分钟后访问网址：
  echo     https://WYmeiyoumama69.github.io/
  echo ============================================
) else (
  echo.
  echo ============================================
  echo   [!] 推送失败，对照下面的情况处理：
  echo.
  echo   Repository not found
  echo     -^> 仓库还没创建。打开 https://github.com/new
  echo        名字填 WYmeiyoumama69.github.io，选 Public，
  echo        不要勾选任何 README/gitignore，然后重新运行本脚本。
  echo.
  echo   Authentication failed / 一直卡住
  echo     -^> 在 Windows 开始菜单搜索 "凭据管理器" ^> Windows 凭据，
  echo        删掉里面 github 相关条目，再重新运行本脚本登录。
  echo.
  echo   Failed to connect / Connection reset
  echo     -^> 确认代理软件（Clash）正在运行。
  echo        本脚本默认使用端口 7897。
  echo        如果你的代理端口不是 7897，请把下面这条命令里的
  echo        端口号换成你自己的，然后执行：
  echo.
  echo           git config --global http.https://github.com/.proxy http://127.0.0.1:代理端口
  echo.
  echo        注意：上面这行必须替换成真实数字端口再执行，
  echo              直接照抄中文占位符会导致 Unsupported proxy syntax 错误。
  echo ============================================
)

echo.
pause
