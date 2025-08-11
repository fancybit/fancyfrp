# FancyFRP服务安装配置指南

## 项目介绍

本项目提供了跨平台的FRP（Fast Reverse Proxy）服务器部署解决方案，支持自动检测系统架构并完成安装。FRP是一个高性能的反向代理应用，可用于将本地服务暴露到公网，支持TCP、UDP、HTTP、HTTPS等多种协议。

## 许可证

本项目采用MIT许可证授权。详细信息请查看项目中的LICENSE文件。

## 支持平台

- **Linux**：支持AMD64(x86_64)和ARM64(aarch64)架构
- **Windows**：支持AMD64架构

## 环境要求

### Linux环境

- 具有root权限的用户
- 支持systemd的Linux发行版（如CentOS 7/8、Ubuntu 16.04+等）
- 已安装curl（可选，用于下载FRP）

### Windows环境

- Windows 7或更高版本
- 具有管理员权限的用户

## 文件结构

```
fancyfrp/
├── README.MD                   # 本说明文件
├── LICENSE                     # 许可证文件
├── config/
│   ├── frpc.toml               # 客户端配置文件模板
│   └── frps.toml               # 服务器配置文件模板
├── frp_0.63.0_linux_amd64/     # Linux AMD64架构版本
│   ├── frpc                    # FRP客户端可执行文件
│   └── frps                    # FRP服务器可执行文件
├── frp_0.63.0_linux_arm64/     # Linux ARM64架构版本
│   ├── frpc                    # FRP客户端可执行文件
│   └── frps                    # FRP服务器可执行文件
├── frp_0.63.0_windows_amd64/   # Windows AMD64架构版本
│   ├── frpc.exe                # FRP客户端可执行文件
│   └── frps.exe                # FRP服务器可执行文件
├── frpsrv.bat                  # Windows启动脚本
├── frpsrv.service              # Linux systemd服务单元文件
├── frpsrv.sh                   # Linux启动脚本
├── install.bat                 # Windows安装脚本
├── install.sh                  # Linux自动架构检测安装脚本
└── uninstall.sh                # Linux卸载脚本
```

## 安装步骤

### Linux系统

1. 将项目复制到Linux服务器上
2. 进入项目目录

   ```bash
   cd fancyfrp
   ```
3. 为安装脚本添加执行权限

   ```bash
   chmod +x install.sh
   ```
4. 运行安装脚本（需要root权限）

   ```bash
   sudo ./install.sh
   ```

   该脚本会自动检测系统架构，并执行以下操作：

   - 检查FRP目录是否存在
   - 创建配置目录 `/etc/frps`
   - 复制配置文件和可执行文件
   - 复制服务脚本和单元文件
   - 重新加载systemd配置
   - 设置服务开机自启动
   - 启动FRP服务

### Windows系统

1. 将项目复制到Windows计算机上
2. 双击运行 `install.bat` 文件（需要管理员权限）

   该脚本会执行以下操作：

   - 创建安装目录 `%ProgramFiles%\frp`
   - 复制配置文件和可执行文件
   - 创建Windows服务
   - 启动FRP服务

## 卸载步骤

### Linux系统

1. 进入项目目录

   ```bash
   cd fancyfrp
   ```
2. 为卸载脚本添加执行权限

   ```bash
   chmod +x uninstall.sh
   ```
3. 运行卸载脚本（需要root权限）

   ```bash
   sudo ./uninstall.sh
   ```

   该脚本会执行以下操作：

   - 停止FRP服务
   - 禁用开机自启
   - 删除可执行文件和服务脚本
   - 删除服务单元文件
   - 删除配置目录
   - 重新加载systemd配置

### Windows系统

1. 双击运行 `uninstall.bat` 文件（需要管理员权限）

   该脚本会执行以下操作：

   - 停止FRP服务
   - 删除Windows服务
   - 删除安装目录和文件

## 配置说明

### 服务器配置（frps.toml）

默认配置文件位于 `config/frps.toml`，基础设置如下：

```toml
# 服务器监听端口
bindPort = 7000
```

您可以根据需求添加更多配置，例如：

```toml
# 绑定地址，默认监听所有地址
# bindAddr = "0.0.0.0"

# 服务器监听端口
bindPort = 7000

# 仪表盘配置（可选）
# dashboardAddr = "0.0.0.0"
# dashboardPort = 7500
# dashboardUser = "admin"
# dashboardPwd = "admin"

# 日志配置
# logFile = "/var/log/frps.log"
# logLevel = "info"
# logMaxDays = 3

# 认证配置
# authenticationMethod = "token"
# token = "your_token_here"
```

### 客户端配置（frpc.toml）

客户端配置文件位于 `config/frpc.toml`，配置示例：

```toml
# 服务器地址
serverAddr = "x.x.x.x"
# 服务器端口
serverPort = 7000

# 认证配置（如果服务器开启了认证）
# authenticationMethod = "token"
# token = "your_token_here"

# 代理配置示例
[[proxies]]
name = "ssh"
type = "tcp"
localIP = "127.0.0.1"
localPort = 22
remotePort = 6000

# HTTP代理示例
# [[proxies]]
# name = "web"
# type = "http"
# localIP = "127.0.0.1"
# localPort = 80
# customDomains = ["your_domain.com"]
```

## 使用方法

### Linux系统

- 启动服务：`sudo systemctl start frpsrv`
- 停止服务：`sudo systemctl stop frpsrv`
- 重启服务：`sudo systemctl restart frpsrv`
- 查看服务状态：`sudo systemctl status frpsrv`
- 设置开机自启：`sudo systemctl enable frpsrv`
- 禁用开机自启：`sudo systemctl disable frpsrv`

### Windows系统

- 启动服务：`sc start FRPServer` 或使用 `frpsrv.bat`
- 停止服务：`sc stop FRPServer`
- 查看服务状态：`sc query FRPServer`

## 故障排除

1. **服务启动失败**

   - 检查配置文件是否正确
   - 检查端口是否被占用
   - 查看日志文件了解详细错误信息
2. **连接问题**

   - 确保服务器防火墙已开放相关端口
   - 验证服务器地址和端口是否正确
   - 检查网络连接是否正常
3. **权限问题**

   - 确保以管理员/root权限运行安装脚本
   - 检查文件和目录权限是否正确

如需更多帮助，请参考FRP官方文档：https://gofrp.org/docs/
