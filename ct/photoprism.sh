#!/usr/bin/env bash
source <(curl -fsSL https://raw.githubusercontent.com/ogizhelev/ProxmoxVE/main/misc/build.func)
# Copyright (c) 2021-2025 tteck
# Author: tteck (tteckster)
# License: MIT | https://github.com/ogizhelev/ProxmoxVE/raw/main/LICENSE
# Source: https://www.photoprism.app/

APP="PhotoPrism"
var_tags="${var_tags:-media;photo}"
var_cpu="${var_cpu:-2}"
var_ram="${var_ram:-3072}"
var_disk="${var_disk:-8}"
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
  if [[ ! -d /opt/photoprism ]]; then
    msg_error "No ${APP} Installation Found!"
    exit
  fi
  msg_info "Stopping PhotoPrism"
  sudo systemctl stop photoprism
  msg_ok "Stopped PhotoPrism"

  msg_info "Updating PhotoPrism"
  $STD apt-get install -y libvips42
  curl -fsSL https://dl.photoprism.app/pkg/linux/amd64.tar.gz | tar -xzf - -C /opt/photoprism --strip-components=1
  msg_ok "Updated PhotoPrism"

  msg_info "Starting PhotoPrism"
  sudo systemctl start photoprism
  msg_ok "Started PhotoPrism"
  msg_ok "Update Successful"
  exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${CREATING}${GN}${APP} setup has been successfully initialized!${CL}"
echo -e "${INFO}${YW} Access it using the following URL:${CL}"
echo -e "${TAB}${GATEWAY}${BGN}http://${IP}:2342${CL}"
