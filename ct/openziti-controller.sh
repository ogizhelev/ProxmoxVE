#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/ogizhelev/ProxmoxVE/main/misc/build.func)
# Copyright (c) 2021-2025 community-scripts ORG
# Author: emoscardini
# License: MIT | https://github.com/ogizhelev/ProxmoxVE/raw/main/LICENSE
# Source: https://github.com/openziti/ziti

APP="openziti-controller"
var_tags="network;openziti-controller"
var_cpu="2"
var_ram="1024"
var_disk="8"
var_os="debian"
var_version="12"
var_unprivileged="1"

header_info "$APP"
variables
color
catch_errors

function update_script() {
   header_info
   check_container_storage
   check_container_resources
   if [[ ! -d /opt/openziti ]]; then
      msg_error "No ${APP} Installation Found!"
      exit
   fi
   msg_info "Updating $APP LXC"
   $STD apt-get update
   $STD apt-get -y upgrade
   msg_ok "Updated $APP LXC"
   exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${CREATING}${GN}${APP} setup has been successfully initialized!${CL}"
echo -e "${INFO}${YW} Access it using the following URL:${CL}"
echo -e "${TAB}${GATEWAY}${BGN}https://${IP}:<port>/zac${CL}"