#!/bin/bash 
cd frp_0.54.0_linux_amd64

chmod +x frps
chmod +x frpsrv.sh

mkdir -p /etc/frps/
cp ../config/frps.toml /etc/frps/frps.toml
cp frps /usr/local/bin/frps
cp ../install/frpsrv.sh /usr/local/bin/frpsrv.sh
cp ../install/frpsrv.service /etc/systemd/system/frpsrv.service

systemctl daemon-reload
systemctl enable frpsrv
systemctl start frpsrv
