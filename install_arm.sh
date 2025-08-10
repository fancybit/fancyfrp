#!/bin/bash

# 检查是否以root权限运行
if [ "$EUID" -ne 0 ]
  then echo "请以root权限运行此脚本"
  exit 1
fi

# 定义变量
FRP_VERSION="0.63.0"
FRP_ARCH="arm64"
FRP_DIR="frp_${FRP_VERSION}_linux_${FRP_ARCH}"
INSTALL_DIR="/usr/local/bin"
CONFIG_DIR="/etc/frps"
SERVICE_FILE="frpsrv.service"

# 检查FRP目录是否存在
if [ ! -d "$FRP_DIR" ]; then
  echo "错误: 未找到目录 $FRP_DIR"
  exit 1
fi

# 进入FRP目录
cd "$FRP_DIR"

# 添加执行权限
chmod +x frps

# 创建配置目录
mkdir -p "$CONFIG_DIR"

# 复制配置文件
cp ../config/frps.toml "$CONFIG_DIR/frps.toml"
if [ $? -ne 0 ]; then
  echo "错误: 复制配置文件失败"
  exit 1
fi

# 复制可执行文件
cp frps "$INSTALL_DIR/frps"
if [ $? -ne 0 ]; then
  echo "错误: 复制frps失败"
  exit 1
fi

# 复制服务脚本和单元文件
cp ../frpsrv.sh "$INSTALL_DIR/frpsrv.sh"
if [ $? -ne 0 ]; then
  echo "错误: 复制frpsrv.sh失败"
  exit 1
fi

cp ../$SERVICE_FILE /etc/systemd/system/$SERVICE_FILE
if [ $? -ne 0 ]; then
  echo "错误: 复制服务单元文件失败"
  exit 1
fi

# 重新加载systemd并启动服务
systemctl daemon-reload
if [ $? -ne 0 ]; then
  echo "错误: 重新加载systemd失败"
  exit 1
fi

systemctl enable frpsrv
if [ $? -ne 0 ]; then
  echo "错误: 设置服务开机自启失败"
  exit 1
fi

systemctl start frpsrv
if [ $? -ne 0 ]; then
  echo "错误: 启动服务失败"
  exit 1
fi

# 检查服务状态
systemctl status frpsrv --no-pager

echo "FRP服务安装完成!"
