#!/usr/bin/env bash

# Copyright (c) 2021-2025 tteck
# Author: tteck (tteckster)
# License: MIT | https://github.com/ogizhelev/ProxmoxVE/raw/main/LICENSE
# Source: https://github.com/AlexxIT/go2rtc

source /dev/stdin <<<"$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing go2rtc"
mkdir -p /opt/go2rtc
cd /opt/go2rtc
curl -fsSL "https://github.com/AlexxIT/go2rtc/releases/latest/download/go2rtc_linux_amd64" -o "go2rtc_linux_amd64"
chmod +x go2rtc_linux_amd64
msg_ok "Installed go2rtc"

msg_info "Creating Service"
service_path="/etc/systemd/system/go2rtc.service"
echo "[Unit]
Description=go2rtc service
After=network.target

[Service]
Type=simple
User=root
ExecStart=/opt/go2rtc/go2rtc_linux_amd64

[Install]
WantedBy=multi-user.target" >$service_path
systemctl enable -q --now go2rtc
msg_ok "Created Service"

motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get -y autoremove
$STD apt-get -y autoclean
msg_ok "Cleaned"
