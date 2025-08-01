#!/usr/bin/env bash

# Copyright (c) 2021-2025 tteck
# Author: tteck (tteckster)
# License: MIT | https://github.com/ogizhelev/ProxmoxVE/raw/main/LICENSE
# Source: https://www.influxdata.com/

source /dev/stdin <<<"$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing Dependencies"
$STD apt-get install -y lsb-base
$STD apt-get install -y lsb-release
msg_ok "Installed Dependencies"

msg_info "Setting up InfluxDB Repository"
curl -fsSL "https://repos.influxdata.com/influxdata-archive_compat.key" | gpg --dearmor >/etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg
echo "deb [signed-by=/etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg] https://repos.influxdata.com/debian stable main" >/etc/apt/sources.list.d/influxdata.list
msg_ok "Set up InfluxDB Repository"

read -r -p "${TAB3}Which version of InfluxDB to install? (1 or 2) " prompt
if [[ $prompt == "2" ]]; then
  INFLUX="2"
else
  INFLUX="1"
fi

msg_info "Installing InfluxDB"
$STD apt-get update
if [[ $INFLUX == "2" ]]; then
  $STD apt-get install -y influxdb2
else
  $STD apt-get install -y influxdb
  curl -fsSL "https://dl.influxdata.com/chronograf/releases/chronograf_1.10.7_amd64.deb" -o "/chronograf_1.10.7_amd64.deb"
  $STD dpkg -i chronograf_1.10.7_amd64.deb
fi
$STD systemctl enable --now influxdb
msg_ok "Installed InfluxDB"

read -r -p "${TAB3}Would you like to add Telegraf? <y/N> " prompt
if [[ "${prompt,,}" =~ ^(y|yes)$ ]]; then
  msg_info "Installing Telegraf"
  $STD apt-get install -y telegraf
  msg_ok "Installed Telegraf"
fi

motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get -y autoremove
$STD apt-get -y autoclean
msg_ok "Cleaned"
