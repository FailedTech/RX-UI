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

# Function to retrieve the latest release version from GitHub API
get_latest_version() {
    latest_release=$(curl -s "https://api.github.com/repos/MetaCubeX/Clash.Meta/releases/latest" | grep -o '"tag_name": "v.*"' | cut -d '"' -f4)
    echo "$latest_release"
}

# Function to retrieve the installed version of Clash Meta Core
get_installed_version() {
    if [ -f "$CM_Core_PATH" ]; then
    # clash-meta -v | awk 'NR==1 {gsub(/^v/, "", $3); print $3}'
        installed_version=$("$CM_Core_PATH" -v | awk 'NR==1 {print $3}')
        echo "$installed_version"
    else
        echo "clash-meta not found"
    fi
}

# Function to update or install Clash Meta Core
update_or_install_CM_Core() {
    # Get the latest version from GitHub
    latest_version=$(get_latest_version)
    # Get the installed version
    installed_version=$(get_installed_version)

    # Echo the installed version
    echo -e "${yellow}Installed version: ${plain}${installed_version}"

    # Compare the installed version with the latest version
    if [ "$installed_version" = "$latest_version" ]; then
        echo -e "${green}You already have the latest version: ${plain}${installed_version}"
    else
        echo -e "${red}Updating clash-meta core from ${plain}${installed_version} ${red}to ${plain}${latest_version}"
        # Here you can add the code to download and update the latest version
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
