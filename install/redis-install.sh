#!/usr/bin/env bash

# Copyright (c) 2021-2025 tteck
# Author: tteck (tteckster)
# License: MIT | https://github.com/ogizhelev/ProxmoxVE/raw/main/LICENSE
# Source: https://redis.io/

source /dev/stdin <<<"$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing Dependencies"
$STD apt-get install -y apt-transport-https
$STD apt-get install -y lsb-release
msg_ok "Installed Dependencies"

msg_info "Installing Redis"
curl -fsSL "https://packages.redis.io/gpg" | gpg --dearmor >/usr/share/keyrings/redis-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" >/etc/apt/sources.list.d/redis.list
$STD apt-get update
$STD apt-get install -y redis
sed -i 's/^bind .*/bind 0.0.0.0/' /etc/redis/redis.conf
systemctl enable -q --now redis-server
msg_ok "Installed Redis"

motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get -y autoremove
$STD apt-get -y autoclean
msg_ok "Cleaned"
