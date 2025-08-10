chmod +x frps
chmod +x frpsrv.sh

# 创建目录（如果不存在）
mkdir -p /etc/frps/
cp frps.toml /etc/frps/frps.toml
cp frps /usr/local/bin/frps
cp frpsrv.sh /usr/local/bin/frpsrv.sh
cp frpsrv.service /etc/systemd/system/frpsrv.service

systemctl daemon-reload
systemctl enable frpsrv
systemctl start frpsrv
