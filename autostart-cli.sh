#!/bin/bash

# Ensure the user is running script as sudo
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root. Try using sudo."
   exit 1
fi

# Set the PVE virtual machine to autostart with the computer
virsh autostart pve

# Verify autostart status
virsh dominfo pve | grep Autostart

# Autostart the virtual network interface
virsh net-autostart default

# Disable the GUI and switch to CLI only
systemctl set-default multi-user.target
