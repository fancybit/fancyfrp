@echo off
:: 设置字符集为UTF-8
chcp 65001 >nul

:: 获取安装目录
set "INSTALL_DIR=%ProgramFiles%\frp"

:: 检查frps.exe是否存在
if not exist "%INSTALL_DIR%\frps.exe" (
    echo 未找到FRP服务器可执行文件: %INSTALL_DIR%\frps.exe
    echo 请先运行install_windows.bat完成安装
    pause
    exit /b 1
)

:: 检查配置文件是否存在
if not exist "%INSTALL_DIR%\frps.toml" (
    echo 未找到配置文件: %INSTALL_DIR%\frps.toml
    echo 请确保配置文件已正确安装
    pause
    exit /b 1
)

:: 启动FRP服务器
 echo 正在启动FRP服务器...
 start "FRP Server" "%INSTALL_DIR%\frps.exe" -c "%INSTALL_DIR%\frps.toml"

:: 检查是否启动成功
if %errorLevel% EQU 0 (
    echo FRP服务器已成功启动
    echo 日志将显示在FRP服务器窗口中
) else (
    echo FRP服务器启动失败
    pause
    exit /b 1
)

exit /b 0