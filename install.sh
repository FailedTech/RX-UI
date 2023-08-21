#!/bin/bash

#####################################################
#This shell script is used for backend RetaliX panel
# Control
#Author: FailedTech
#Date:08/03/2023
#Version:0.0.1
#####################################################
#color definitions
plain='\033[0m'
red='\033[0;31m'
blue='\033[0;34m' 
pink='\033[0;35m'
green='\033[0;32m'
yellow='\033[0;33m'

#################### Clash Meta Session #############
RX_UI_VERSION='0.0.1'
SCRIPT_PATH='/usr/local/sbin/RX-UI'
CM_Core_PATH='/usr/local/bin/clash-meta'
CM_SERVICE_PATH='/etc/systemd/system/clash-meta.service'
CM_DOWNLOAD_PATH='/usr/local/Clash-Meta/Download/'
CM_CONFIG_PATH='/usr/local/Clash-Meta/Config/'

Script_install() {
    if [[ ! -f "${SCRIPT_PATH}" ]]; then
        wget --no-check-certificate -O ${SCRIPT_PATH} "https://raw.githubusercontent.com/FailedTech/RX-UI/main/install.sh"
        chmod +x ${SCRIPT_PATH}
    fi
}

CM_Directory_setup(){
    if [[ -d "/usr/local/Clash-Meta" ]]; then
        (
            mkdir -p ${CM_CONFIG_PATH} ${CM_DOWNLOAD_PATH}
        )
    else
        (
        mkdir -p "/usr/local/Clash-Meta" ${CM_CONFIG_PATH} ${CM_DOWNLOAD_PATH}
        )
    fi
}

CM_Core_latest_version() {
    latest_release=$(curl -s "https://api.github.com/repos/MetaCubeX/Clash.Meta/releases/latest" | grep -o '"tag_name": "v.*"' | cut -d '"' -f4 | sed 's/v//')
    echo "$latest_release"
}

CM_Core_installed_version() {
    if [ -f "$CM_Core_PATH" ]; then
        installed_version=$("$CM_Core_PATH" -v | awk 'NR==1 {print $3}' | sed 's/v//')
        echo "$installed_version"
    else
        echo "0"
    fi
}

CM_Core_download(){
    curl -Lo ${CM_DOWNLOAD_PATH}clash-meta.gz "https://github.com/MetaCubeX/Clash.Meta/releases/download/v$(CM_Core_latest_version)/clash.meta-linux-amd64-compatible-v$(CM_Core_latest_version).gz"
    gunzip ${CM_DOWNLOAD_PATH}clash-meta.gz &&
    mv ${CM_DOWNLOAD_PATH}clash-meta $CM_Core_PATH && chmod +x $CM_Core_PATH
    echo -e "${green}clash-meta core successfully installed ${plain}"
}

CM_Core_install() {
    latest_version=$(CM_Core_latest_version)
    installed_version=$(CM_Core_installed_version)
    if [ "$installed_version" = "0" ]; then
        echo -e "${red}Clash-Meta Core not found ${plain}" &&
        echo -e "${green}Installing Clash-Meta Core ${plain}${blue}v$latest_version ${plain}" &&
        CM_Core_download
    elif [ "$installed_version" = "$latest_version" ]; then
        echo -e "${green}You already have the latest version: ${plain}${blue}v${installed_version}${plain}"
    elif [ "$installed_version" \< "$latest_version" ]; then
        echo -e "${green}Updating Clash-Meta Core from ${plain}${blue}v${installed_version}${plain}${green} to ${plain}${blue}v${latest_version}${plain}" &&
        rm -rf $CM_Core_PATH &&
        CM_Core_download
    fi
}

CM_Core_uninstall(){
    rm -rf $CM_Core_PATH 
}

CM_Core_status(){
   $CM_Core_PATH status
}

CM_Service_default(){
    echo -e "[Unit]
Description=Clash-Meta Daemon, Another Clash Kernel.
After=network.target NetworkManager.service systemd-networkd.service iwd.service

[Service]
Type=simple
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_RAW CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_RAW CAP_NET_BIND_SERVICE
Restart=always
ExecStartPre=/usr/bin/sleep 1s
ExecStart=/usr/local/bin/clash-meta -d /usr/local/Clash-Meta/Config

[Install]
WantedBy=multi-user.target" | sudo tee ${CM_SERVICE_PATH}
}

CM_Service_install(){
    if [[ -f "$CM_SERVICE_PATH" ]]; then
        CM_Service_default
    else
        sudo touch ${CM_SERVICE_PATH}
        CM_Service_default
    fi
}

CM_Service_start(){
    sudo systemctl enable clash-meta
    sudo systemctl start clash-meta
}

CM_Service_stop(){
    sudo systemctl stop clash-meta
}

CM_Service_restart(){
    sudo systemctl daemon-reload
    sudo systemctl restart clash-meta
}

CM_Service_status(){
    sudo systemctl status clash-meta
}

CM_Config_default(){
    echo -e "
mixed-port: 7890
allow-lan: true
mode: rule
log-level: debug
ipv6: true
external-controller: 0.0.0.0:9090
dns:
  enable: true
  ipv6: true
  nameserver:
    - '8.8.8.8'
    - '1.1.1.1'
proxies:
  [{'name':'proxyname','type':'vless','server':'yourserver','port':yourport,'uuid':'youruuid','network':'tcp'}]
proxy-groups:
  [{'name':'AUTO','type':'load-balance','proxies':['proxyname'],
  'url':'https://instagram.com','interval':100,'strategy':'consistent-hashing'}]
rules:
  - MATCH,AUTO
  - Match,Mannual
  - IP-CIDR,127.0.0.0/8,DIRECT
  - IP-CIDR,172.16.0.0/12,DIRECT
  - IP-CIDR,192.168.0.0/16,DIRECT
  - IP-CIDR,10.0.0.0/8,DIRECT
" | sudo tee ${CM_CONFIG_PATH}config.yaml
}

CM_Config_install(){
    if [[ -f "${CM_CONFIG_PATH}config.yaml" ]]; then
        CM_Config_default
    else
        sudo touch "${CM_CONFIG_PATH}config.yaml"
        CM_Config_default
    fi
}

CM_Config_edit(){
    sudo nano ${CM_CONFIG_PATH}config.yaml
}

CM_Config_check(){
    sudo ${CM_Core_PATH} ${CM_CONFIG_PATH}config.yaml
}

menu() {
    clear &&
    echo -e "
${green}RX-UI-v${RX_UI_VERSION} Management Script${plain}
${pink}>>>>>>>>>>   Exit  <<<<<<<<<<${plain}
${green}0.${plain} Exit
${pink}>>>>>>>>>>   Core  <<<<<<<<<<${plain}
${green}1.${plain} Install/Update
${green}2.${plain} Uninstall     ${green}3.${plain} Status
${pink}>>>>>>>>>> Service <<<<<<<<<<${plain}
${green}4.${plain} Start         ${green}5.${plain} Stop
${green}6.${plain} Restart       ${green}7.${plain} Status
${pink}>>>>>>>>>>  Config  <<<<<<<<<<${plain}
${green}8.${plain} Edit Config   ${green}9.${plain} Check Config
      "

    read -p "Please enter your choice [0-21]: " num
    clear

    case "$num" in
        0)
            exit 0
            ;;
        1)
            CM_Directory_setup
            CM_Core_install
            read
            menu
            ;;
        2)
            CM_Core_uninstall
            menu
            ;;
        3)
            CM_Core_status
            read
            menu
            ;;
        4)
            CM_Service_start
            read && menu
            ;;
        5)
            CM_Service_stop
            menu
            ;;
        6)
            CM_Service_restart && menu
            ;;
        7)
            CM_Service_status && menu
            ;;
        8)
            CM_Config_edit && menu
            ;;
        9)
            CM_Config_check && menu
            ;;
        10)
            menu
            ;;
        11)
            menu
            ;;
        *)
            echo "Please enter a valid option [0-21]"
            menu
            ;;
    esac
}

Script_install
menu
