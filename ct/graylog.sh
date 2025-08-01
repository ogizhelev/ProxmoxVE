#!/usr/bin/env bash
source <(curl -fsSL https://raw.githubusercontent.com/ogizhelev/ProxmoxVE/main/misc/build.func)
# Copyright (c) 2021-2025 community-scripts ORG
# Author: Slaviša Arežina (tremor021)
# License: MIT | https://github.com/ogizhelev/ProxmoxVE/raw/main/LICENSE
# Source: https://graylog.org/

APP="Graylog"
TAGS="logging"
var_cpu="${var_cpu:-2}"
var_ram="${var_ram:-8192}"
var_disk="${var_disk:-30}"
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

    if [[ ! -d /etc/graylog ]]; then
        msg_error "No ${APP} Installation Found!"
        exit
    fi
    msg_info "Stopping $APP"
    systemctl stop graylog-datanode
    systemctl stop graylog-server
    msg_ok "Stopped $APP"

    msg_info "Updating $APP"
    $STD apt-get update
    $STD apt-get upgrade -y
    msg_ok "Updated $APP"

    msg_info "Starting $APP"
    systemctl start graylog-datanode
    systemctl start graylog-server
    msg_ok "Started $APP"

    msg_ok "Update Successful"
    exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${CREATING}${GN}${APP} setup has been successfully initialized!${CL}"
echo -e "${INFO}${YW} Access it using the following URL:${CL}"
echo -e "${TAB}${GATEWAY}${BGN}http://${IP}:9000${CL}"