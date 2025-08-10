cp frpsrv.sh /usr/local/bin/frpsrv.sh
chmod +x /usr/local/bin/frpsrv.sh
cp frpsrv.service /etc/systemd/system/frpsrv.service
systemctl daemon-reload
systemctl enable frpsrv
systemctl start frpsrv