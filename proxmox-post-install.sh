#!/bin/bash
# Helper script to be run on Proxmox to update sources and install tailscale

# Remove the enterprise sources from proxmox
rm /etc/apt/sources.list.d/pve-enterprise.sources
rm /etc/apt/sources.list.d/ceph.sources

# Add the non-subscription proxmox source to APT
echo "Types: deb
URIs: http://download.proxmox.com/debian/pve
Suites: trixie
Components: pve-no-subscription
Signed-By: /usr/share/keyrings/proxmox-archive-keyring.gpg" | tee /etc/apt/sources.list.d/proxmox.sources

# Add the non-subscription ceph source to APT
echo "Types: deb
URIs: http://download.proxmox.com/debian/ceph-squid
Suites: trixie
Components: no-subscription
Signed-By: /usr/share/keyrings/proxmox-archive-keyring.gpg" | tee /etc/apt/sources.list.d/ceph.sources

# Update the sources lists and upgrade proxmox
apt update && apt upgrade -y

# Create a Debian linux container.
bash -c "$(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/ct/debian.sh)"

# Create a tailscale node on the Debian container
bash -c "$(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/tools/addon/add-tailscale-lxc.sh)"



