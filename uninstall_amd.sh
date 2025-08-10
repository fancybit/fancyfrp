#!/bin/bash

# 检查是否以root权限运行
if [ "$EUID" -ne 0 ]
  then echo "请以root权限运行此脚本"
  exit 1
fi

# 定义变量
INSTALL_DIR="/usr/local/bin"
CONFIG_DIR="/etc/frps"
SERVICE_FILE="frpsrv.service"
SERVICE_NAME="frpsrv"

# 停止FRP服务
echo "停止FRP服务..."
systemctl stop $SERVICE_NAME
if [ $? -ne 0 ]
  then echo "警告: 停止服务失败，可能服务未运行"
fi

# 禁用自启动
echo "禁用服务自启动..."
systemctl disable $SERVICE_NAME
if [ $? -ne 0 ]
  then echo "警告: 禁用服务自启动失败"
fi

# 删除可执行文件
echo "删除可执行文件..."
rm -f "$INSTALL_DIR/frps"
if [ $? -ne 0 ]
  then echo "警告: 删除frps失败"
else
  echo "已删除 $INSTALL_DIR/frps"
fi

# 删除服务脚本
rm -f "$INSTALL_DIR/frpsrv.sh"
if [ $? -ne 0 ]
  then echo "警告: 删除frpsrv.sh失败"
else
  echo "已删除 $INSTALL_DIR/frpsrv.sh"
fi

# 删除服务单元文件
echo "删除服务单元文件..."
rm -f /etc/systemd/system/$SERVICE_FILE
if [ $? -ne 0 ]
  then echo "警告: 删除服务单元文件失败"
else
  echo "已删除 /etc/systemd/system/$SERVICE_FILE"
fi

# 删除配置文件和目录
echo "删除配置文件和目录..."
rm -rf "$CONFIG_DIR"
if [ $? -ne 0 ]
  then echo "警告: 删除配置目录失败"
else
  echo "已删除 $CONFIG_DIR"
fi

# 重新加载systemd
echo "重新加载systemd..."
systemctl daemon-reload
if [ $? -ne 0 ]
  then echo "警告: 重新加载systemd失败"
else
  echo "systemd已重新加载"
fi

# 检查服务状态（应该已不存在）
echo "检查服务状态..."
systemctl status $SERVICE_NAME --no-pager || echo "服务 $SERVICE_NAME 已不存在"

# 输出卸载完成信息
echo "FRP服务卸载完成!"