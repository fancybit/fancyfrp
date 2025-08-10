#!/bin/bash
systemctl start frpsrv
systemctl enable frpsrv
systemctl status frpsrv
echo "frpsrv服务已启动并设置为开机自启"
echo "frpsrv服务状态:"
systemctl status frpsrv
echo "frpsrv服务日志:"
journalctl -u frpsrv -f
echo "按任意键结束"
read -n 1 -s
