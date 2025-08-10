#!/bin/bash

# 检查是否以root权限运行
if [ "$EUID" -ne 0 ]
  then echo "请以root权限运行此脚本"
  exit 1
fi

# 定义变量
INSTALL_DIR="/usr/local/bin"
CONFIG_DIR="/etc/frps"
SERVICE_NAME="frpsrv"
SERVICE_FILE="$SERVICE_NAME.service"

# 停止服务
echo "正在停止$SERVICE_NAME服务..."
systemctl stop $SERVICE_NAME
if [ $? -ne 0 ]; then
  echo "警告: 停止服务失败，可能服务未运行"
fi

# 禁用开机自启
echo "正在禁用$SERVICE_NAME服务开机自启..."
systemctl disable $SERVICE_NAME
if [ $? -ne 0 ]; then
  echo "警告: 禁用服务开机自启失败"
fi

# 删除可执行文件和服务脚本
echo "正在删除可执行文件和服务脚本..."
rm -f "$INSTALL_DIR/frps"
rm -f "$INSTALL_DIR/frpsrv.sh"

# 删除服务单元文件
echo "正在删除服务单元文件..."
rm -f /etc/systemd/system/$SERVICE_FILE

# 删除配置目录
echo "正在删除配置目录..."
rm -rf "$CONFIG_DIR"

# 重新加载systemd
echo "正在重新加载systemd..."
systemctl daemon-reload
if [ $? -ne 0 ]; then
  echo "警告: 重新加载systemd失败"
fi

# 检查服务状态
echo "检查服务状态..."
systemctl status $SERVICE_NAME --no-pager || echo "$SERVICE_NAME服务已不存在或未运行"

# 输出卸载完成信息
if [ $? -eq 0 ]; then
  echo "FRP服务卸载完成!"
else
  echo "FRP服务卸载过程中出现警告，但已尽力完成所有可能的卸载步骤。"
fi