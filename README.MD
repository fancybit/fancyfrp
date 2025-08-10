# FRP服务安装配置指南

## 项目介绍

本项目提供了在CentOS系统上快速部署FRP（Fast Reverse Proxy）服务器的脚本和配置文件。FRP是一个高性能的反向代理应用，可用于将本地服务暴露到公网，支持TCP、UDP、HTTP、HTTPS等多种协议。

## 许可证

本项目采用MIT许可证授权。详细信息请查看项目中的LICENSE文件。

## 环境要求

- CentOS 7/8系统
- 具有root权限的用户
- 已解压的FRP文件（本项目包含frp_0.63.0_linux_arm64版本）

## 文件结构

```
FRP/
├── README.MD                   # 本说明文件
├── frp_0.63.0_linux_arm64/     # Linux ARM64架构版本
│   ├── LICENSE                 # 许可证文件
│   ├── frpc                    # FRP客户端可执行文件
│   ├── frpc.toml               # FRP客户端配置文件
│   ├── frps                    # FRP服务器可执行文件
│   ├── frps.toml               # FRP服务器配置文件
│   ├── frpsrv.service          # systemd服务单元文件
│   ├── frpsrv.sh               # FRP服务器启动脚本
│   └── installsrv.sh           # 安装脚本
└── frp_0.63.0_windows_amd64/   # Windows AMD64架构版本
    ├── LICENSE
    ├── frpc.exe
    ├── frpc.toml
    ├── frps.exe
    └── frps.toml
```

## 安装步骤

1. 将项目复制到CentOS服务器上
2. 进入Linux版本目录
   ```bash
   cd frp_0.63.0_linux_arm64
   ```
3. 运行安装脚本（需要root权限）
   ```bash
   sudo sh installsrv.sh
   ```

   该脚本会执行以下操作：- 将 `frpsrv.sh`复制到 `/usr/local/bin/`目录
   - 为脚本添加执行权限
   - 将 `frpsrv.service`复制到 `/etc/systemd/system/`目录
   - 重新加载systemd配置
   - 设置服务开机自启动
   - 启动FRP服务

## 配置说明

### 服务器配置（frps.toml）

默认配置仅包含基础设置：

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
# logFile = "./frps.log"
# logLevel = "info"
# logMaxDays = 3
```

### 客户端配置（frpc.toml）

客户端配置示例：

```toml
# 服务器地址
serverAddr = "x.x.x.x"
# 服务器端口
serverPort = 7000

# 认证方式
# authenticationMethod = "token"
# token = "your_token"

# 代理配置示例
[[proxies]]
name = "ssh"
type = "tcp"
localIp = "127.0.0.1"
localPort = 22
remotePort = 6000
```

## 使用方法

### 服务管理

- 启动服务：
  ```bash
  sudo systemctl start frpsrv
  ```
- 停止服务：
  ```bash
  sudo systemctl stop frpsrv
  ```
- 重启服务：
  ```bash
  sudo systemctl restart frpsrv
  ```
- 查看服务状态：
  ```bash
  sudo systemctl status frpsrv
  ```
- 设置开机自启动：
  ```bash
  sudo systemctl enable frpsrv
  ```
- 禁用开机自启动：
  ```bash
  sudo systemctl disable frpsrv
  ```

## 注意事项

1. 确保服务器防火墙已开放FRP服务所需的端口（默认7000）
2. 如果修改了 `frps.toml`配置文件，需要重启服务使配置生效
3. 对于生产环境，建议设置更复杂的认证方式和密码
4. 本项目提供的FRP版本为0.63.0，您可以根据需要替换为其他版本
5. Windows版本仅供参考，本项目主要针对Linux系统的服务安装

## 常见问题

1. **服务启动失败怎么办？**
   查看服务状态获取详细错误信息：

   ```bash
   sudo systemctl status frpsrv -l
   ```
2. **如何修改服务监听端口？**
   编辑 `frps.toml`文件，修改 `bindPort`的值，然后重启服务。
3. **如何配置多个代理？**
   在 `frpc.toml`文件中添加多个 `[[proxies]]`块，每个块对应一个代理配置。