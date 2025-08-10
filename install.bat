@echo on
:: 将当前工作目录设置为批处理所在目录
cd /d %~dp0
:: 设置字符集为UTF-8
chcp 65001 >nul

:: 配置变量
set "FRP_VERSION=0.63.0"
set "FRP_ARCH=windows_amd64"
set "INSTALL_DIR=%ProgramFiles%\frp"

:: 检查是否以管理员权限运行
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo 正在请求管理员权限...
    :: 创建VBScript以管理员权限重新启动批处理
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /b
)

:: 创建安装目录和配置目录
mkdir "%INSTALL_DIR%" 2>nul

:: 复制文件
echo 复制文件...
copy /Y ".\frp_%FRP_VERSION%_%FRP_ARCH%\*" "%INSTALL_DIR%\" >nul
copy /Y ".\config\*" "%INSTALL_DIR%\" >nul
copy /Y ".\frpsrv.bat" "%INSTALL_DIR%\" >nul

:: 添加到PATH环境变量
echo 添加到系统PATH环境变量...
setx PATH "%PATH%;%INSTALL_DIR%" /M >nul

:: 创建快捷方式到桌面（可选）
echo 创建桌面快捷方式...
set "DESKTOP=%USERPROFILE%\Desktop"
set "SHORTCUT_NAME=FRP 服务器.lnk"
set "EXE_PATH=%INSTALL_DIR%\frpsrv.bat"
set "ICON_PATH=%INSTALL_DIR%\frps.exe"

powershell -Command "$WshShell = New-Object -ComObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%DESKTOP%\%SHORTCUT_NAME%'); $Shortcut.TargetPath = '%EXE_PATH%'; $Shortcut.IconLocation = '%ICON_PATH%'; $Shortcut.Save()" >nul

:: 创建Windows服务
 echo 创建Windows服务...
 set "SERVICE_NAME=FRPServer"
 set "SERVICE_DISPLAY_NAME=FRP Server"
 set "SERVICE_DESCRIPTION=Fast Reverse Proxy Server"

 :: 检查服务是否已存在
 sc query %SERVICE_NAME% >nul 2>&1
 if %errorLevel% EQU 0 (
     echo 服务 %SERVICE_NAME% 已存在，正在删除...
     sc delete %SERVICE_NAME% >nul
     timeout /t 2 /nobreak >nul
 )

 :: 创建服务，正确指定启动参数
 :: 在sc create命令中，binPath参数的格式为："可执行文件路径 参数1 参数2 ..."
 :: 所有参数必须包含在同一个引号内
 sc create %SERVICE_NAME% binPath="%INSTALL_DIR%\frps.exe -c %INSTALL_DIR%\frps.toml" start= auto DisplayName= "%SERVICE_DISPLAY_NAME%" obj= "LocalSystem" description= "%SERVICE_DESCRIPTION%"


:: 启动服务
sc start %SERVICE_NAME% >nul
if %errorLevel% NEQ 0 (
    echo 创建服务失败！请以管理员权限运行此脚本。
) else (
    echo 服务 %SERVICE_NAME% 已成功创建并启动！
)

:: 完成安装
echo 安装完成！
echo FRP %FRP_VERSION% 已成功安装到 %INSTALL_DIR%
echo 可执行文件已添加到系统PATH
echo Windows服务已创建：%SERVICE_DISPLAY_NAME%

echo 按任意键退出...
pause >nul

