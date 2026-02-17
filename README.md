# BYU-IEEE-ServerProject

Scripts to run after installing Proxmox Virtual Environment

Copy and run this script in Node->Shell:

bash -c "$(curl -fsSL https://raw.githubusercontent.com/FlexyRexy/BYU-IEEE-ServerProject/main/proxmox-post-install.sh)"

Copy and run this script in LXC->Console:

bash -c "$(curl -fsSL https://raw.githubusercontent.com/FlexyRexy/BYU-IEEE-ServerProject/main/tailscale-subnet.sh)"

Copy and run this script in the Ubuntu Terminal:

sudo bash -c "$(wget -qO- https://raw.githubusercontent.com/FlexyRexy/BYU-IEEE-ServerProject/main.autostart-cli.sh)"
