cp frps /usr/local/bin/frps
# 创建目录（如果不存在）
mkdir -p /etc/frps/
cp frps.toml /etc/frps/frps.toml
cp frpsrv.sh /usr/local/bin/frpsrv.sh
cp frpsrv.service /etc/systemd/system/frpsrv.service

chmod +x /usr/local/bin/frps
chmod +x /usr/local/bin/frpsrv.sh

systemctl daemon-reload
systemctl enable frpsrv
systemctl start frpsrv
