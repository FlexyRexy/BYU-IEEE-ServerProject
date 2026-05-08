# BYU-IEEE-ServerProject

Steps for setting up your server in a home network environment

1. Create a USB installer with Proxmox
    - You will need an 8 GB flash drive (the drive will be erased when creating the boot disk)
    - Download the latest version of Proxmox VE ISO (https://www.proxmox.com/en/downloads/proxmox-virtual-environment/iso)
    - Download Rufus or Raspberry Pi Imager
        - Rufus: https://rufus.ie/en/
        - Raspberry Pi Imager: https://www.raspberrypi.com/software/
    - Rufus:
        - Select the flash drive you inserted into your computer
        - Under "Boot selection", pick Disk or ISO image and click "SELECT".
        - Browse for the Proxmox ISO file downloaded earlier
        - If a warning appears about ISOHybrid image, select "OK"
        - Click "START"
        - Click "OK" when asked to erase the drive
    - Raspberry Pi Imager:
        - Install the tool from the file downloaded above
        - In the imaging tool, skip the "Device" option and select "OS" menu option
        - Scroll to the bottom and select "Use custom" then browse to the Proxmox ISO file
        - Select "NEXT" and select the flash drive you inserted into your computer, then click "NEXT" again
        - Verify that the summary of options is correct, then select "WRITE"
        - Follow the remaining prompts
    - Eject the flash drive and plug it into your designated server equipment to begin installing Proxmox

2. Adjust BIOS settings (this step will apply to Dell Optiplex systems)
    - If you have already completed this step, you can skip to step 3.
    - Boot into the BIOS after powering on the computer by pressing F2 on the keyboard
    - Open "System Configuration" in the left hand menu
    - Look for "SATA Operation"
    - Make sure this setting is set to "AHCI" so that the operating system can find the internal storage drives
    - Save and exit the BIOS. The computer will restart, press F12 when the computer restarts to open the boot menu

3. Install Proxmox from USB
    - REQUIRED: Make sure that the computer has an Ethernet connection to your home router PRIOR to installing Proxmox. Proxmox does not have built in support for WiFi
        - If you would like to use Proxmox with WiFi (not recommended), please use the original instructions from club meetings or Google how to set up Proxmox with WiFi
    - Immediately after restarting, press F12 to open the boot menu
    - Select the flash drive from the list of options. This should launch the Proxmox installer
    - Select "Install Proxmox VE (graphical)"
    - Select "I agree" during setup
    - Target Harddisk should be the internal NVME/SSD drive (should be a 256GB SSD). Select "Next"
    - Set the Country to United States and the timezone to America/Denver (change at your discretion if the server will operate elsewhere)
    - Make the password something you will remember, but secure. Google "passphrase" or "multi-word password" to learn more about secure, memorable passwords
    - Set the email to your personal email
        - This is for your server to send you notifications directly, if the server is later set up with access to your email provider
    - The hostname (FQDN) should use the following format:
        - [hostname/subdomain].[domain].[TLD]
            - For example: watch.lastname.local 
            - The hostname should reflect what you plan on using the server for. It is good for organization, especially if you have multiple servers
            - The domain name should be used to tie the server back to you somehow. You can use a combination of your firstname/lastname, a nickname, social media handle, or some other identifier
            - Top level domains (TLD) are the .com, .net, or .org you see in most URLs
                - Since your server will not be visible outside your home network without using a VPN or reverse proxy, use the .local TLD at the end of your FQDN
            - FQDNs should generally be lowercase and not contain underscores
            - Note that while this does look like a URL, it will not connect you to your server if you put it into a web browser, nor will it provide server access outside your home network
    - Leave the IP address, gateway, and DNS server as is
        - If you plugged in an Ethernet cable prior to setup, the installer will use DHCP (Dynamic Host Configuration Protocol) to automatically retrieve this information for you
    - Select install. The system will automatically reboot when finished
  
4. Set up Proxmox
    - Once the computer restarts, it will show some text, an IPv4 address, and a login prompt 
        - The IPv4 address should look something like this: "https://192.168.1.2:8006"
        - Make sure to record this IP address and the port number (the four numbers after the ":") so you can access the web interface!
    - Use a personal computer to connect to the server
        - Make sure you are on the same network as the server, and enter the IP address exactly as it appeared above (make sure to include the "https://")
        - You will likely see a security warning in the browser, click "Advanced" then "Accept the Risk and Continue" (this will vary depending on your browser)
            - The reason for the security warning is because Proxmox uses self-signed encryption certificates, which are generally not trusted by browsers as they tend to indicate security issues. Since your server is running on a home network and you are the server administrator, this is fine
        - After connecting, you will be prompted to login
            - Username: "root"
            - Password: the password you set in step 3
        - Click "OK" when prompted for No Subscription
        - In the left side menu, you will see a server node under "Datacenter" that has the hostname you set in step 3. Select this
        - There should be a new set of options. From this list, select the "Shell" option
            - This shell terminal is where you'll run any helper scripts or make command-line changes to your Proxmox configuration
            - In the shell, run the following command: bash -c "$(curl -fsSL https://raw.githubusercontent.com/FlexyRexy/BYU-IEEE-ServerProject/main/proxmox-post-install.sh)"
                - This command runs a bash script to remove enterprise-level package sources and adds the free/community sources, allowing you to add software packages to your server without a subscription
                - It also creates a Linux container (LXC) with the Debian operating system, into which Tailscale (a free VPN) is installed 
                - As part of this script, you will see some options appear:
                    - Opt out of telemetry/data sharing
                    - Select "Default Install"
                    - Type "y" and press enter when asked to add Tailscale to existing LXC Container
                    - Select container "100 debian" with the spacebar and press enter
        - Once the script has finished running, it will prompt you to restart the container
            - Under the server node in the left menu, you should see a new container labelled "100 (debian)"
            - Right-click the container and select "Reboot"

5. Set up Tailscale (this is so you can access the server outside your home network, if you have no intention of using your server outside your home network now or in the future, you can skip this step)
    - There are a few methods to enable Tailscale subnet routing so you only need to have one Tailscale instance installed on your machine and not on every container/VM you might want. There are a few solutions called Tailscale Serve and Tailscale Funnel that can be used to automate the process to some degree, depending on what you are trying to accomplish (you can read about them here: https://tailscale.com/docs/features/tailscale-serve)
    - I use the following method, as I have not yet had time to work on the previously mentioned methods:
        - From the left menu pane, select the "100 (debian)" container
        - Open the container "Console"
        - Run this command: bash -c "$(curl -fsSL https://raw.githubusercontent.com/FlexyRexy/BYU-IEEE-ServerProject/main/tailscale-subnet.sh)"
            - This script will enable subnet routing in Tailscale and activate the VPN service
        - A https link will be provided to connect to your tailscale account. Go to the provided link in a web browser and log in/create a tailscale account to connect
        - Once you have authenticated and connected the device to your tailscale account, the console should update
        - In your tailscale admin control panel (https://login.tailscale.com/admin/machines), you should see the debian container listed as connected
           - Click the three dots at the far right of the machine in the control panel
           - Select "Edit Route Settings"
           - Under "Subnet Routes" check the IPv4 address listed and click save.
        - From your laptop or another device, install and connect to Tailscale
        - Attempt to navigate to the IP address you recorded at the start of step 4

6. Add services to your server
    - Once you are able to connect to your server successfully from a browser, you no longer need to have a keyboard or monitor connected to your server. The server can be powered off simply by pressing the button on the machine, then it can be moved to the most convenient location in your home. As long as it maintains an active Ethernet connection, the IP address will not change, which can happen on ocassion, but will prevent you from accessing the server remotely
        - I would recommend learning how to set a static IP address on your router. Unfortunately, this depends on your router's make and model, so I cannot provide much detail on this. However, Google is your best friend here! Look up your router make and model and ask how to set a static IP address for your server
    - From here, you can use a helper script to create services, like media servers, photo storage, NAS, finance and budgeting, document/note organizers, and so much more!
        - PLEASE PLEASE PLEASE always check a script before using it! Most scripts can be viewed and you can see what it will be doing before running it. If you don't understand what a script is doing, look it up or don't use it! Scripts can very easily be modified to point to malicious sites or add security vulnerabilities to your system
        - With that in mind, the site I like to check for helper scripts on is https://community-scripts.org
        - Once you find a script, copy the install command (usually starts with "bash -c $...")
        - Back in your Proxmox control panel, select the server node (as seen by the hostname) in the left hand pane, and open the "Shell"
        - Paste the script into the shell window and follow the prompts to set it up accordingly.
            - If you don't understand what the installer is asking for, Google it!
        - Once the script finished, the terminal should provide an IP address and port number for you to access the service from. Before you close the shell, make sure you can access it and if you can, bookmark it!
