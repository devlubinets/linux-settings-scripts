#!/bin/bash

Default='\033[0m'         # Text Reset
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White
sudo echo -e "${Purple}Begin instalation... ${Default}"

sudo apt-get -y update

#Install snap
sudo rm /etc/apt/preferences.d/nosnap.pref
sudo apt install snapd


echo -e "${Yellow}Removing apps start... ${Default}"
    sudo apt purge -y hexchat
    sleep 3
echo -e "${Green}Removing apps finish... ${Default}"



echo -e "${Yellow}Inserting disk config start... ${Default}"
    VOLUMES=("windows_data;ntfs-3g" "unix_data;ext4")
    for VOLUME in ${VOLUMES[*]}
    do
        VOLUME_DATA=(${VOLUME//;/ }) NAME=${VOLUME_DATA[0]} FILESYSTEM=${VOLUME_DATA[1]}
        mkdir /home/$USER/${NAME}
        sudo chown -R $USER:$USER /home/$USER/${NAME}/
        sudo chmod -R 777 /home/$USER/${NAME}/
        echo LABEL=${NAME} /home/$USER/${NAME} ${FILESYSTEM} nosuid,nodev,nofail,x-gvfs-show 0 0 | sudo tee -a /etc/fstab > /dev/null
    done
    sleep 3
echo -e "${Green}Inserting disk config finish... ${Default}"



echo -e "${Yellow}Installing start... ${Default}"
    #wget -O- https://download.teamviewer.com/download/linux/signature/TeamViewer2017.asc | gpg --dearmor | sudo tee /usr/share/keyrings/teamviewer.gpg > /dev/null
    #echo "deb [signed-by=/usr/share/keyrings/teamviewer.gpg] https://linux.teamviewer.com/deb stable main" | sudo tee /etc/apt/sources.list.d/teamviewer.list
    sudo add-apt-repository ppa:slimbook/slimbook -y
    sudo apt update && apt upgrade -y
    sleep 3
echo -e "${Green}Inserting finish... ${Default}"



echo -e "${Yellow}Installing base packages start... ${Default}"
    PACKAGES=(
       numlockx
       gparted
       htop
       mint-meta-codecs
       hardinfo
       papirus-icon-theme
       adapta-gtk-theme
       adapta-kde
       openresolv
       easy-rsa
       network-manager-openvpn
       bind9
       fprintd
       libpam-fprintd
       notepadqq
       slimbookbattery
       dconf-editor
	   redshift
	   redshift-gtk
	   flameshot
	   arc-theme
	   qt5ct
    )
    for PACKAGE in ${PACKAGES[*]}
    do
        sudo apt install -y ${PACKAGE}
    done

    echo "
    ; Global settings
    [redshift]
    temp-day=5700
    temp-night=3500
    transition=3
    gamma=0.8:0.7:0.8
    location-provider=manual
    adjustment-method=vidmode

    ; The location provider and adjustment method settings are in their own sections.
    [manual]
    lat=46.482952
    lon=30.712481

    ; In this example screen 1 is adjusted by vidmode. Note that the numbering starts from 0, so this is actually the second screen.
    [vidmode]
    screen=1
    " | sudo tee -a ~/.config/redshift.conf > /dev/null
    sleep 3
echo -e "${Green}Installing base packages finish... ${Default}"



echo -e "${Yellow}Installing deb packages start... ${Default}"
    DEB_PACKAGES=(
        "google-chrome;https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
#        "teamviewer;https://download.teamviewer.com/download/linux/teamviewer_amd64.deb"
    )
    for DEB_PACKAGE in ${DEB_PACKAGES[*]}
    do
        PACKAGE_DATA=(${DEB_PACKAGE//;/ }) NAME=${PACKAGE_DATA[0]} URL=${PACKAGE_DATA[1]}
        wget -P ~/Downloads -O ~/Downloads/${NAME}.deb ${URL}
        sudo dpkg -i ~/Downloads/${NAME}.deb
    done
    sudo apt install -f -y
    sleep 3
echo -e "${Green}Installing deb packages finish... ${Default}"



echo -e "${Yellow}Installing flatpak packages start... ${Default}"
    FLATPAK_PACKAGES=(
       #com.google.Chrome
       com.viber.Viber
	   com.skype.Client
	   org.telegram.desktop
       com.getpostman.Postman
       org.kde.krita 
    );

    for FLATPAK_PACKAGE in ${FLATPAK_PACKAGES[*]}
    do
        sudo flatpak install -y flathub ${FLATPAK_PACKAGE}
    done
    sleep 3
echo -e "${Green}Installing flatpak packages finish... ${Default}"

echo -e "${Yellow}Settings theme configs start... ${Default}"
    echo "
    [Greeter]
    draw-grid=true
    stretch-background-across-monitors=true
    activate-numlock=true
    theme-name=Arc-Dark
    icon-theme-name=ePapirus
	clock-format=%A, %B %Y-%m-%d /  %H:%M:%S
	" | sudo tee -a /etc/lightdm/slick-greeter.conf > /dev/null
	

    echo "
    #set Track Piont speed
    xinput --set-prop 'ETPS/2 Elantech TrackPoint' 'libinput Accel Speed' -0.5" | sudo tee -a ~/.xsessionrc > /dev/null

    gsettings set org.cinnamon.theme name "Adapta-Nokto"
    gsettings set org.cinnamon.desktop.interface gtk-theme "Arc-Dark"
    gsettings set org.cinnamon.desktop.interface cursor-theme "Adwaita"
    gsettings set org.cinnamon.desktop.interface icon-theme "ePapirus"
    gsettings set org.cinnamon.desktop.wm.preferences theme "Arc-Dark"
    sleep 3
echo -e "${Green}Settings theme configs finish... ${Default}"



echo -e "${Yellow}Fix slimbook ppa key start... ${Default}"
	sudo apt-key list # see last id symbols
	sudo apt-key export 981017FC | sudo gpg --dearmour -o /usr/share/keyrings/slimbook.gpg
	echo "deb [signed-by=/usr/share/keyrings/slimbook.gpg] http://ppa.launchpad.net/slimbook/slimbook/ubuntu jammy main" | sudo tee /etc/apt/sources.list.d/slimbook.list
	sudo apt update
	sudo apt-key del 981017FC
	sudo rm /etc/apt/sources.list.d/slimbook-slimbook-jammy.list
    sleep 3
echo -e "${Green}Fix slimbook ppa key finish... ${Default}"Adapta-Eta


#fprintd-enroll
#sudo pam-auth-update


#/usr/bin/flatpak run --branch=stable --arch=x86_64 --command=/app/bin/skype --file-forwarding com.skype.Client -startintray @@u %U @@
#/usr/bin/flatpak run --branch=stable --arch=x86_64 --command=telegram-desktop --file-forwarding org.telegram.desktop -startintray  -- @@u %u @@
#/usr/bin/flatpak run --branch=stable --arch=x86_64 --command=viber com.viber.Viber -startintray StartMinimized

#%A, %B %Y-%m-%d /  %H:%M:%S
read -p -e "${Purple}Finish installation. Press any key to continue... ${Default}" -n1 -s


#install Dropbox
cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
~/.dropbox-dist/dropboxd

#install Gparted
sudo apt-get install -y gparted

#Install Okular PDF reader
sudo apt install -y okular

#Install Peek for make GIF
sudo add-apt-repository ppa:peek-developers/stable
sudo apt-get update
sudo apt-get install peek

#install Console Tool ZSH
sudo apt-get install -y zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
###########NEDD to add copy zshrc config fil
#mysql client for check connecton to server
sudo apt install -y  mysql-client

#Text editor GUI VIM
sudo apt install vim-gtk3
