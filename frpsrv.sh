#!/bin/bash

# 定义变量
FRPS_PATH="/usr/local/bin/frps"
CONFIG_PATH="/etc/frps/frps.toml"

# 检查frps可执行文件是否存在
if [ ! -f "$FRPS_PATH" ]; then
  echo "错误: 未找到frps可执行文件: $FRPS_PATH"
  exit 1
fi

# 检查配置文件是否存在
if [ ! -f "$CONFIG_PATH" ]; then
  echo "错误: 未找到配置文件: $CONFIG_PATH"
  exit 1
fi

# 启动frps服务
"$FRPS_PATH" -c "$CONFIG_PATH"

# 检查启动是否成功
if [ $? -ne 0 ]; then
  echo "错误: 启动frps服务失败"
  exit 1
fi

# 输出启动成功信息
echo "frps服务已成功启动"
