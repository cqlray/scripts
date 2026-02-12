@echo off
REM ========================================
REM Chrome 不安全源配置脚本
REM 在 Windows 7 上启用 Chrome 本地 HTTP 支持
REM ========================================

setlocal enabledelayedexpansion

REM 颜色输出
color 0A

echo.
echo ========================================
echo Chrome 不安全源配置工具
echo ========================================
echo.

REM 检查管理员权限
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo 错误：此脚本需要管理员权限运行
    echo 请右键选择"以管理员身份运行"
pause
    exit /b 1
)

REM 获取 Chrome 用户数据目录
set "CHROME_USER_DATA=%USERPROFILE%\AppData\Local\Google\Chrome\User Data"

if not exist "%CHROME_USER_DATA%" (
    echo 错误：未找到 Chrome 用户数据目录
    echo 请确保已安装 Google Chrome
    pause
    exit /b 1
)

echo 检测到 Chrome 路径: %CHROME_USER_DATA%
echo.

REM 关闭所有 Chrome 进程
echo 关闭 Chrome 进程...
taskkill /F /IM chrome.exe >nul 2>&1
timeout /t 2 /nobreak

REM 创建或修改 Local State 文件
set "LOCAL_STATE=%CHROME_USER_DATA%\Local State"

REM 备份原始文件
if exist "%LOCAL_STATE%" (
    copy "%LOCAL_STATE%" "%LOCAL_STATE%.bak" >nul
    echo 已备份原配置文件
)

REM 检测 Chrome 安装路径
set "CHROME_PATH=C:\Program Files\Google\Chrome\Application\chrome.exe"
set "CHROME_PATH_X86=C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"

if exist "%CHROME_PATH%" (
    echo 检测到 64 位 Chrome...
    set "CHROME_EXECUTABLE=%CHROME_PATH%"
) else if exist "%CHROME_PATH_X86%" (
    echo 检测到 32 位 Chrome...
    set "CHROME_EXECUTABLE=%CHROME_PATH_X86%"
) else (
    echo 错误：未找到 Chrome 安装路径
    pause
    exit /b 1
)

REM 获取桌面路径
set "DESKTOP=%USERPROFILE%\Desktop"

REM 创建 VBScript 来生成快捷方式
set "VBS_FILE=%temp%\create_shortcut.vbs"
(
echo Set oWS = WScript.CreateObject("WScript.Shell"^)
echo sLinkFile = "%DESKTOP%\Chrome - Insecure Origins.lnk"
echo Set oLink = oWS.CreateShortcut(sLinkFile^)
echo oLink.TargetPath = "%CHROME_EXECUTABLE%"
echo oLink.Arguments = "--unsafely-treat-insecure-origin-as-secure=http://localhost,http://localhost:8080,http://127.0.0.1,http://127.0.0.1:8080 --user-data-dir=\"%CHROME_USER_DATA%\""
echo oLink.WorkingDirectory = "%CHROME_EXECUTABLE:~0,-37%"
echo oLink.Description = "Chrome (Insecure Origins Enabled)"
echo oLink.Save
) > "%VBS_FILE%"

cscript.exe "%VBS_FILE%"

echo.
echo ========================================
echo 配置完成！
echo ========================================
echo.
echo 建议方法：
echo 1. 使用桌面上新创建的 "Chrome - Insecure Origins.lnk" 快捷方式启动
echo    或手动使用以下命令启动 Chrome：
echo.
echo    chrome.exe --unsafely-treat-insecure-origin-as-secure=http://localhost,http://localhost:8080,http://127.0.0.1,http://127.0.0.1:8080
echo.
echo 2. 可访问的不安全源：
echo    - http://localhost
echo    - http://localhost:8080
echo    - http://127.0.0.1
echo    - http://127.0.0.1:8080
echo.
echo 3. 如需添加其他域名，修改脚本中的域名列表或编辑快捷方式属性
echo.
echo 清理临时文件...
del /F /Q "%VBS_FILE%" >nul 2>&1

echo 完成！按任意键退出...
pause >nul
exit /b 0