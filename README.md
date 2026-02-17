# BYU-IEEE-ServerProject

Steps for setting up your server within BYU networking contraints:
1. Install Ubuntu
    - Follow these selections during install:
          - Interactive Installation --> Default selection --> Install third-party software for graphics and Wi-Fi hardware --> Erase disk and install Ubuntu
    - Your name should be "IEEE-NETID"
    - Leave the computer name and username as they should be filled in as you fill out the name field
    - Password: please see a member of the presidency for a password to enter. DO NOT ENTER YOUR OWN. Unapproved passwords may subject you to loss of computer privileges.
    - Timezone: America/Denver (you can click on the map to select the timezone)
    - Select Install
  
2. After restarting and logging in, wait for a "Welcome" window to open
    - Select Next --> Skip for now --> No, don't share system data --> Finish
      
3. Connect to eduroam after installation
    - Go here and select the "Connecting to eduroam for Linux" option: https://support.byu.edu/it?id=kb_article&sys_id=5dd1ceca1be5f25021d0edb8b04bcb8a#mcetoc_1i5eh98cm26

4. Install virt-manager
    - Open "Terminal"
    - Run "sudo apt update" to get a list of packages for the computer
    - Run "sudo apt install virt-manager"
    - Restart the computer

5. Copy the Proxmox ISO and start the virtual manager
    - Copy the proxmox-ve_9.1-1.iso from the Ubuntu installer USB drive to your Downloads folder
    - Start the Virtual Machine Manager program
    - Select "New Virtual Machine"
        - Choose Local install media --> Browse for ISO --> Browse Local (select ISO from your Downloads folder) --> Uncheck the autodetect option and search for Debian 13
        - If a window appears asking to correct the emulator's search path permissions, select "yes"
        - Set the Memory, CPU, and Storage to the maximum available value
        - Name the virtual machine "pve" and select Finish

6. Install Proxmox
    - After creating the VM, it will boot. Select "Install Proxmox VE (graphical)"
    - Select "I agree" during setup
    - Target Harddisk should be the virtual storage set up in step 5. Select next
    - Set the Country to United States and the timezone to America/Denver
    - The password should be the same as the password you set above in step 1
    - Set the email to your netid@byu.edu email
    - The hostname (FQDN) should be "netid.ieee.local"
    - Leave the IP address, gateway, and DNS server as is
    - Select install. The system will automatically reboot
  
7. Set up Proxmox and install tailscale
    - Once the VM reboots, it will show an IPv4 address. Enter that address (including the port number) into a browser in Ubuntu. A security warning will appear, click "Advanced" then "Accept the Risk and Continue"
      - Make sure to record the IP address and port number so you can access the web interface!
    - The username is "root" and the password will be the one set during installation
    - Select the node with your netid and open the shell from the menu pane
    - Copy and paste the first command listed below (proxmox-post-install.sh) into the shell window. This may take some time
      - As part of this script, you will see some options appear:
      - Opt out of telemetry/data sharing
      - Select "Default Install"
      - Type "y" and press enter when asked to add Tailscale to existing LXC Container
      - Select container "100 debian" with the spacebar and press enter
  
8. Set up Tailscale
    - From the left menu pane, select the "100 (debian)" container
    - Under "Shutdown" select "Reboot" and wait for the container to restart
    - Open the container "Console"
    - Run the second script below (tailscale-subnet.sh) in the console
    - A https link will be provided to connect to your tailscale account. Go to the provided link in a web browser and log in/create a tailscale account to connect
    - Once you have authenticated and connected the device to your tailscale account, the console should update
    - In your tailscale admin control panel (https://login.tailscale.com/admin/machines), you should see the debian container listed as connected
      - Click the three dots at the far right of the machine in the control panel
      - Select "Edit Route Settings"
      - Under "Subnet Routes" check the IPv4 address listed and click save.
    - From your laptop or another device, install and connect to Tailscale
    - Attempt to navigate to the IP address of your Proxmox control panel (this is the IP address and port listed in the virtual machine)
    - If successful, continue to step 9

9. Clean up ubuntu and enable VM autostart
   - You can now close your virtual machine and the Virtual Machine Manager windows (this will not shutdown your VM)
   - Open "Terminal" in Ubuntu
   - Copy and paste the third command listed below (autostart-cli.sh) to your terminal window
   - Restart the computer
   - The computer should start to a CLI login screen
   - Wait a few moments and attempt to access your Proxmox interface from the IP address you recorded earlier
   - If you were able to connect, congratulations! You have a working server
  

Scripts to run after installing Proxmox Virtual Environment

Copy and run this script in Node->Shell:

bash -c "$(curl -fsSL https://raw.githubusercontent.com/FlexyRexy/BYU-IEEE-ServerProject/main/proxmox-post-install.sh)"

Copy and run this script in LXC->Console:

bash -c "$(curl -fsSL https://raw.githubusercontent.com/FlexyRexy/BYU-IEEE-ServerProject/main/tailscale-subnet.sh)"

Copy and run this script in the Ubuntu Terminal:

sudo bash -c "$(wget -qO- https://raw.githubusercontent.com/FlexyRexy/BYU-IEEE-ServerProject/main/autostart-cli.sh)"
