@echo off
set CONFIG_DIR=%ProgramData%\frp
set LOG_DIR=%CONFIG_DIR%\log
set LOG_FILE=%LOG_DIR%\frps.log

:: 创建日志目录
mkdir "%LOG_DIR%" 2>nul

:: 启动FRP服务器
echo 启动FRP服务器...
start /b "" "frps.exe" -c "%CONFIG_DIR%\frps.toml" > "%LOG_FILE%" 2>&1

:: 等待服务器启动
timeout /t 5 /nobreak

:: 检查日志文件是否存在
if not exist "%LOG_FILE%" (
    echo 启动失败！请检查配置文件和日志文件。
    pause
    exit /b 1
)

:: 检查日志文件是否包含启动成功的信息
find "Server is running" "%LOG_FILE%" >nul
if %errorLevel% NEQ 0 (
    echo 启动失败！请检查配置文件和日志文件。
    pause
    exit /b 1
)

:: 启动成功
echo FRP服务器已成功启动！
pause   
exit /b 0
