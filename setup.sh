#!/bin/bash
cwd=$(pwd)

## Create service file
echo '[Unit]' > /etc/systemd/system/lid-brightness-handler.service
echo "Description=lid-brightness-handler" >> /etc/systemd/system/lid-brightness-handler.service
echo "After=network.target" >> /etc/systemd/system/lid-brightness-handler.service
echo "[Service]" >> /etc/systemd/system/lid-brightness-handler.service
echo "ExecStart=${cwd}/lid-brightness-watcher.sh" >> /etc/systemd/system/lid-brightness-handler.service
echo "Restart=always" >> /etc/systemd/system/lid-brightness-handler.service
echo "RestartSec=3" >> /etc/systemd/system/lid-brightness-handler.service
echo "TimeoutStopSec=0" >> /etc/systemd/system/lid-brightness-handler.service
echo "User=root" >> /etc/systemd/system/lid-brightness-handler.service
echo "Group=root" >> /etc/systemd/system/lid-brightness-handler.service
echo "RuntimeDirectory=${cwd}" >> /etc/systemd/system/lid-brightness-handler.service
echo "RuntimeDirectoryMode=2755" >> /etc/systemd/system/lid-brightness-handler.service
echo "LimitNOFILE=65535" >> /etc/systemd/system/lid-brightness-handler.service
echo "[Install]" >> /etc/systemd/system/lid-brightness-handler.service
echo "WantedBy=multi-user.target" >> /etc/systemd/system/lid-brightness-handler.service

apt install brightnessctl -y
systemctl daemon-reload
systemctl enable --now lid-brightness-handler.service
systemctl restart lid-brightness-handler.service

