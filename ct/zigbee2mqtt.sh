#!/usr/bin/env bash
source <(curl -fsSL https://raw.githubusercontent.com/ogizhelev/ProxmoxVE/main/misc/build.func)
# Copyright (c) 2021-2025 tteck
# Author: tteck (tteckster)
# License: MIT | https://github.com/ogizhelev/ProxmoxVE/raw/main/LICENSE
# Source: https://www.zigbee2mqtt.io/

APP="Zigbee2MQTT"
var_tags="${var_tags:-smarthome;zigbee;mqtt}"
var_cpu="${var_cpu:-2}"
var_ram="${var_ram:-1024}"
var_disk="${var_disk:-5}"
var_os="${var_os:-debian}"
var_version="${var_version:-12}"
var_unprivileged="${var_unprivileged:-0}"

header_info "$APP"
variables
color
catch_errors

function update_script() {
  header_info
  check_container_storage
  check_container_resources
  if [[ ! -d /opt/zigbee2mqtt ]]; then
    msg_error "No ${APP} Installation Found!"
    exit
  fi

  if [[ -f ~/.zigbee2mqtt ]]; then
    CURRENT="$(cat ~/.zigbee2mqtt)"
  elif [[ -f /opt/${APP}_version.txt ]]; then
    CURRENT="$(cat /opt/${APP}_version.txt)"
    rm -f /opt/${APP}_version.txt
  else
    CURRENT=""
  fi

  RELEASE=$(curl -fsSL https://api.github.com/repos/Koenkk/zigbee2mqtt/releases/latest | grep "tag_name" | awk '{print substr($2, 2, length($2)-3) }')
  if [[ "$RELEASE" != "$CURRENT" ]]; then
    if ! command -v jq &>/dev/null; then
      $STD apt-get update
      $STD apt-get install -y jq
    fi
    NODE_VERSION=24 NODE_MODULE="pnpm@$(curl -fsSL https://raw.githubusercontent.com/Koenkk/zigbee2mqtt/master/package.json | jq -r '.packageManager | split("@")[1]')" setup_nodejs

    msg_info "Stopping Service"
    systemctl stop zigbee2mqtt
    msg_ok "Stopped Service"

    msg_info "Creating Backup"
    rm -rf /opt/${APP}_backup*.tar.gz
    mkdir -p /opt/z2m_backup
    $STD tar -czf /opt/z2m_backup/${APP}_backup_$(date +%Y%m%d%H%M%S).tar.gz -C /opt zigbee2mqtt
    mv /opt/zigbee2mqtt/data /opt/z2m_backup
    msg_ok "Backup Created"

    fetch_and_deploy_gh_release "Zigbee2MQTT" "Koenkk/zigbee2mqtt" "tarball" "latest" "/opt/zigbee2mqtt"

    msg_info "Updating ${APP} to v${RELEASE}"
    rm -rf /opt/zigbee2mqtt/data
    mv /opt/z2m_backup/data /opt/zigbee2mqtt
    cd /opt/zigbee2mqtt
    $STD pnpm install --frozen-lockfile
    $STD pnpm build
    msg_ok "Updated Zigbee2MQTT"

    msg_info "Starting Service"
    systemctl start zigbee2mqtt
    msg_ok "Started Service"

    msg_info "Cleaning up"
    rm -rf /opt/z2m_backup
    msg_ok "Cleaned up"
  else
    msg_ok "No update required. ${APP} is already at v${RELEASE}."
  fi
  exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${CREATING}${GN}${APP} setup has been successfully initialized!${CL}"
echo -e "${INFO}${YW} Access it using the following URL:${CL}"
echo -e "${TAB}${GATEWAY}${BGN}http://${IP}:9442${CL}"
