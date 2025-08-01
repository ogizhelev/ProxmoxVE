#!/usr/bin/env bash

# Copyright (c) 2021-2025 tteck
# Author: tteck (tteckster)
# License: MIT | https://github.com/ogizhelev/ProxmoxVE/raw/main/LICENSE
# Source: https://www.nocodb.com/

source /dev/stdin <<<"$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing NocoDB"
mkdir -p /opt/nocodb
cd /opt/nocodb
curl -fsSL http://get.nocodb.com/linux-x64 -o nocodb -L
chmod +x nocodb
msg_ok "Installed NocoDB"

msg_info "Creating Service"
service_path="/etc/systemd/system/nocodb.service"
echo "[Unit]
Description=nocodb

[Service]
Type=simple
Restart=always
User=root
WorkingDirectory=/opt/nocodb
ExecStart=/opt/nocodb/./nocodb

[Install]
WantedBy=multi-user.target" >$service_path
systemctl enable -q --now nocodb
msg_ok "Created Service"

motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get -y autoremove
$STD apt-get -y autoclean
msg_ok "Cleaned"
