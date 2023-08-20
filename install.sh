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
CM_Core_PATH='/usr/local/bin/clash-meta'

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
    curl -Lo 'clash-meta.gz' "https://github.com/MetaCubeX/Clash.Meta/releases/download/v$(CM_Core_latest_version)/clash.meta-linux-amd64-compatible-v$(CM_Core_latest_version).gz"
    gunzip clash-meta.gz &&
    mv clash-meta $CM_Core_PATH && chmod +x $CM_Core_PATH
}

CM_Core_setup() {
    latest_version=$(CM_Core_latest_version)
    installed_version=$(CM_Core_installed_version)
    echo -e "$installed_version $latest_version"
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

menu() {
    echo -e "
      ${green}RX-UI-v${RX_UI_VERSION} Management Script${plain}
      ${pink}>>>>>>>>>> Exit <<<<<<<<<<${plain}"

    read -p "Please enter your choice [0-21]: " num

    case "$num" in
        0)
            exit 0
            ;;
        1)
            CM_Core_setup && menu
            ;;
        *)
            echo "Please enter a valid option [0-21]"
            menu
            ;;
    esac
//  Edit Config
//Check Config
-------core------
Install
Update 
Uninstall
-------
  ${pink}>>>>>>>>>> Service <<<<<<<<<<${plain}
  ${green}4.${plain} Start sing-box service
  ${green}5.${plain} Stop sing-box service
  ${green}6.${plain} Restart sing-box service
  ${green}7.${plain} View sing-box status
}
menu
