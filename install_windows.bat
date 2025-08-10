@echo off
setlocal enabledelayedexpansion

:: 配置变量
set "FRP_VERSION=0.63.0"
set "FRP_ARCH=windows_amd64"
set "INSTALL_DIR=%ProgramFiles%\frp"
set "CONFIG_DIR=%ProgramData%\frp"

:: 检查是否以管理员权限运行
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo 请以管理员权限运行此脚本！
    pause
    exit /b 1
)

:: 创建安装目录和配置目录
echo 创建安装目录: %INSTALL_DIR%
mkdir "%INSTALL_DIR%" 2>nul
mkdir "%INSTALL_DIR%\bin" 2>nul

echo 创建配置目录: %CONFIG_DIR%
mkdir "%CONFIG_DIR%" 2>nul

:: 复制可执行文件
echo 复制可执行文件...
copy /Y ".\frp_%FRP_VERSION%_%FRP_ARCH%\frpc.exe" "%INSTALL_DIR%\bin\" >nul
copy /Y ".\frp_%FRP_VERSION%_%FRP_ARCH%\frps.exe" "%INSTALL_DIR%\bin\" >nul
copy /Y ".\frpsrv.bat" "%INSTALL_DIR%\bin\" >nul

:: 复制配置文件
echo 复制配置文件...
copy /Y ".\config\frpc.toml" "%CONFIG_DIR%\" >nul
copy /Y ".\config\frps.toml" "%CONFIG_DIR%\" >nul

:: 添加到PATH环境变量
echo 添加到系统PATH环境变量...
setx PATH "%PATH%;%INSTALL_DIR%\bin" /M >nul

:: 创建快捷方式到桌面（可选）
echo 创建桌面快捷方式...
set "DESKTOP=%USERPROFILE%\Desktop"
set "SHORTCUT_NAME=FRP 服务器.lnk"
set "EXE_PATH=%INSTALL_DIR%\bin\frpsrv.bat"
set "ICON_PATH=%INSTALL_DIR%\bin\frps.exe"

powershell -Command "$WshShell = New-Object -ComObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%DESKTOP%\%SHORTCUT_NAME%'); $Shortcut.TargetPath = '%EXE_PATH%'; $Shortcut.IconLocation = '%ICON_PATH%'; $Shortcut.Save()" >nul

:: 完成安装
echo 安装完成！
echo FRP %FRP_VERSION% 已成功安装到 %INSTALL_DIR%
echo 配置文件位于 %CONFIG_DIR%
echo 可执行文件已添加到系统PATH

echo 按任意键退出...
pause >nul
endlocal
