#!/usr/bin/env bash
source <(curl -fsSL https://raw.githubusercontent.com/ogizhelev/ProxmoxVE/main/misc/build.func)
# Copyright (c) 2021-2025 tteck
# Author: tteck (tteckster)
# License: MIT | https://github.com/ogizhelev/ProxmoxVE/raw/main/LICENSE
# Source: https://github.com/AlexxIT/go2rtc

APP="go2rtc"
var_tags="${var_tags:-streaming;video}"
var_cpu="${var_cpu:-2}"
var_ram="${var_ram:-2048}"
var_disk="${var_disk:-4}"
var_os="${var_os:-debian}"
var_version="${var_version:-12}"
var_unprivileged="${var_unprivileged:-1}"

header_info "$APP"
variables
color
catch_errors

function update_script() {
  header_info
  check_container_storage
  check_container_resources
  if [[ ! -d /opt/go2rtc ]]; then
    msg_error "No ${APP} Installation Found!"
    exit
  fi
  msg_info "Updating $APP"
  systemctl stop go2rtc
  cd /opt/go2rtc
  rm go2rtc_linux_amd64
  curl -fsSL "https://github.com/AlexxIT/go2rtc/releases/latest/download/go2rtc_linux_amd64" -o $(basename "https://github.com/AlexxIT/go2rtc/releases/latest/download/go2rtc_linux_amd64")
  chmod +x go2rtc_linux_amd64
  systemctl start go2rtc
  msg_ok "Updated $APP"
  exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${CREATING}${GN}${APP} setup has been successfully initialized!${CL}"
echo -e "${INFO}${YW} Access it using the following URL:${CL}"
echo -e "${TAB}${GATEWAY}${BGN}http://${IP}:1984${CL}"
