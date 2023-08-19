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
CM_Core_PATH='/usr/local/bin/clash-meta'
Download_Latest_Version= curl -Lo clash-meta "https://github.com/MetaCubeX/Clash.Meta/releases/download/v$(get_latest_version)/clash.meta-linux-amd64-compatible-v$(get_latest_version).gz"

# Function to retrieve the latest release version from GitHub API
get_latest_version() {
    latest_release=$(curl -s "https://api.github.com/repos/MetaCubeX/Clash.Meta/releases/latest" | grep -o '"tag_name": "v.*"' | cut -d '"' -f4 | sed 's/v//')
    echo "$latest_release"
}

# Function to retrieve the installed version of Clash Meta Core
get_installed_version() {
    if [ -f "$CM_Core_PATH" ]; then
        # clash-meta -v | awk 'NR==1 {gsub(/^v/, "", $3); print $3}'
        installed_version=$("$CM_Core_PATH" -v | awk 'NR==1 {print $3}')
        echo "$installed_version"
    else
        echo "0"
    fi
}

# Function to update or install Clash Meta Core
update_or_install_CM_Core() {
    latest_version=$(get_latest_version)
    installed_version=$(get_installed_version)
    echo -e "$installed_version   $latest_version"

    if [ "$installed_version" -eq 0 ]; then
        echo -e "${red}Clash-Meta Core not found ${plain}" &&
        echo -e "${green}Installing Clash-Meta Core ${plain}${blue}v$latest_version ${plain}" &&
        gunzip clash-meta &&
        mv clash-meta $CM_Core_PATH && chmod +x $CM_Core_PATH
    elif [ "$installed_version" = "$latest_version" ]; then
        echo -e "${green}You already have the latest version: ${plain}${installed_version}"
    elif [ "$installed_version" -lt "$latest_version" ]; then
        echo -e "${green}Updating Clash-Meta Core from ${plain}${blue}${installed_version}${plain}${green} to ${plain}${blue}${latest_version}${plain}" &&
        rm -rf $CM_Core_PATH &&

    fi
}

# Call the function to update or install CM core
update_or_install_CM_Core


test(){
# Set the appropriate package name based on the architecture
architecture=$(uname -m)
if [ "$architecture" = "x86_64" ]; then
    package="clash.meta-linux-amd64-compatible-$latest_release.gz"
else
    echo "Unsupported architecture: $architecture"
    exit 1
fi

# Download the latest release binary
curl -LO "https://github.com/MetaCubeX/Clash.Meta/releases/download/$latest_release/$package"

# Extract the downloaded .gz file
gunzip "$package"

# Make the binary executable (if needed)
chmod +x "${package%.gz}"

# Check the version of the binary
./"${package%.gz}" -v
}
