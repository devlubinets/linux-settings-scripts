#!/bin/bash

# https://easylinuxtipsproject.blogspot.com/p/speed-mint.html
# https://easylinuxtipsproject.blogspot.com/p/ssd.html


# todo:
# different profile (backend, frontend)
# create test for those scripts

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

sudo apt update && sudo apt upgrade

# @todo: add two keyboard (ukraine and english)

# install light weight env
# sudo apt-get install lxde

#Install snap
sudo rm /etc/apt/preferences.d/nosnap.pref
sudo apt install snapd


echo -e "${Yellow}Removing apps start... ${Default}"
    sudo apt purge -y hexchat
    #todo: add additional software
    sleep 3
echo -e "${Green}Removing apps finish... ${Default}"


echo -e "${Yellow}Installing apt packages start... ${Default}"
    sudo add-apt-repository ppa:slimbook/slimbook -y
    sudo apt update && apt upgrade -y
        
#https://www.digitalocean.com/community/tutorials/how-to-install-php-7-4-and-set-up-a-local-development-environment-on-ubuntu-20-04
#https://www.linuxbabe.com/ubuntu/php-multiple-versions-ubuntu
#Switching PHP Version in Apache Virtual Host
#By default, Apache uses one PHP version across all virtual hosts. If you want to use a different PHP version in a particular virtual host, you will need to disable Apache PHP module and run PHP code via PHP-FPM. Check if mod_php is installed.

dpkg -l | grep libapache2-mod-php
    
    #php
    sudo apt install software-properties-common
    sudo add-apt-repository ppa:ondrej/php #@todo: add -y to auto install without user
    sudo apt update && apt upgrade -y

    APT_PACKAGES=(
"flameshot"
# @todo: separate common and job apt packages
"php8.1"
"php8.1-curl"
"php8.1-xml"
"php8.0"
"php7.4"
"php7.4-curl"
"php7.4-xml"
"php7.4-dom"
"php7.4-intl"
"php7.4-common"
"php7.4-mbstring"
"mint-meta-codecs"
"zsh"
    )

   for APT_PACKAGE in "${APT_PACKAGES[@]}"; do
    sudo apt-get install "$APT_PACKAGE" -y
    done

    #php
    sudo a2dismod php8.1
    sudo a2dismod mpm_prefork

    sleep 3
echo -e "${Green}Inserting finish... ${Default}" #todo: what is mean?

#@todo: add install xdebug for each version of php (or move php to container and run all code over there)

# Install Symfony CLI (https://symfony.com/download)
curl -sS https://get.symfony.com/cli/installer | bash
sudo  mv /home/${USER}/.symfony5/bin/symfony /usr/local/bin/symfony

# install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"


# todo: move to php developer profile
echo -e "${Yellow}Installing composer start... ${Default}" 
#todo: improve that by https://getcomposer.org/doc/faqs/how-to-install-composer-programmatically.md
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === 'e21205b207c3ff031906575712edab6f13eb0b361f2085f1f1237b7126d785e826a450292b6cfd1d64d92e6563bbde02') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
#make it globally
sudo mv composer.phar /usr/local/bin/composer
    sleep 3
echo -e "${Green}Installing composer finish... ${Default}"


echo -e "${Yellow}Installing base packages start... ${Default}" #todo: ERROR HERE
    sudo add-apt-repository ppa:peek-developers/stable #@todo: add -y to auto install without user
    
    sudo dpkg --set-selections < installed_packages.txt
    sudo apt-get dselect-upgrade

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

#install driver for hunio (https://www.huion.com/download/)


#install anydesk (@todo: doens't work without root') (http://deb.anydesk.com/howto.html)
sudo wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo apt-key add -
sudo echo "deb http://deb.anydesk.com/ all main" > /etc/apt/sources.list.d/anydesk-stable.list
apt update
apt install anydesk

echo -e "${Yellow}Installing deb packages start... ${Default}"
    DEB_PACKAGES=(
	    "balena-etcher;https://github.com/balena-io/etcher/releases/download/v1.18.12/balena-etcher_1.18.12_amd64.deb"
        "google-chrome;https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
        "teamviewer;https://download.teamviewer.com/download/linux/teamviewer_amd64.deb"
       # "anydesk;https://anydesk.com/en-gb/downloads/linux?dv=deb_64" #@todo: may be error, doesn't feet deb package'
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
       com.github.calo001.fondo
       com.ktechpit.orion #torrent
       app.ytmdesktop.ytmdesktop #youtube music
       com.viber.Viber
	   com.skype.Client
	   org.telegram.desktop
       com.getpostman.Postman
       org.kde.krita 
       io.typora.Typora #markdown
        org.inkscape.Inkscape
org.kde.kcachegrind
org.geany.Geany
org.kde.kdenlive
org.kde.filelight
com.obsproject.Studio
    );

    for FLATPAK_PACKAGE in ${FLATPAK_PACKAGES[*]}
    do
        sudo flatpak install -y flathub ${FLATPAK_PACKAGE}
    done
    sleep 3
echo -e "${Green}Installing flatpak packages finish... ${Default}"


echo -e "${Yellow}Installing spapd packages start... ${Default}"
    sudo add-apt-repository ppa:peek-developers/stable
    PACKAGES=(
    bare
    core
    core18
    core20
    filezilla
    freemind
    gnome-3-28-1804
    gnome-3-34-1804
    gnome-3-38-2004
    gtk-common-themes
    json-tool
    ngrok
    notepad-plus-plus
    notion-snap
    qt515-core20
    sftpclient
    slack
    snapd
    termius-app
    todoist
    zoom-client
    pomotroid #productive timer
    whatsie
    wine-platform-7-devel-core20
    wine-platform-runtime-core20
    ngrok
    #code #@todo: add varaint add options (( sudo snap install code --classic ))
    )
    for PACKAGE in ${PACKAGES[*]}
    do
        sudo snap install ${PACKAGE}
    done
	sudo snap install filezilla --beta
	sudo snap install pycharm-community --classic
    sudo snap install code --classic
echo -e "${Green}Installing snapd packages finish... ${Default}"

#todo:move php.ini config
#todo: move bashrc and zshrc

#install AnyDesk #http://deb.anydesk.com/howto.html #@todo: doesn't work
wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | apt-key add -
echo "deb http://deb.anydesk.com/ all main" > /etc/apt/sources.list.d/anydesk-stable.list
apt update
apt install -y anydesk

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

    #todo: make small panel size
    gsettings set org.cinnamon.theme name "Adapta-Nokto"
    gsettings set org.cinnamon.desktop.interface gtk-theme "Arc-Dark"
    gsettings set org.cinnamon.desktop.interface cursor-theme "Adwaita"
    gsettings set org.cinnamon.desktop.interface icon-theme "ePapirus"
    gsettings set org.cinnamon.desktop.wm.preferences theme "Arc-Dark"
    sleep 3
echo -e "${Green}Settings theme configs finish... ${Default}"

echo -e "${Yellow}Fix slimbook ppa key start... ${Default}" #todo: Doesn't work properly E: The repository 'http://ppa.launchpad.net/slimbook/slimbook/ubuntu jammy InRelease' is not signed.

	sudo apt-key list # see last id symbols
	sudo apt-key export 981017FC | sudo gpg --dearmour -o /usr/share/keyrings/slimbook.gpg
	echo "deb [signed-by=/usr/share/keyrings/slimbook.gpg] http://ppa.launchpad.net/slimbook/slimbook/ubuntu jammy main" | sudo tee /etc/apt/sources.list.d/slimbook.list
	sudo apt update
	sudo apt-key del 981017FC
	sudo rm /etc/apt/sources.list.d/slimbook-slimbook-jammy.list
    sleep 3
echo -e "${Green}Fix slimbook ppa key finish... ${Default}"


#@todo: move .config file, and etc (doesn't work)
cp -R ../common_hiden_file ~/



echo -e "${Yellow}Install none deb and spand packages... ${Default}"

echo -e "${White}Dropbox ${Default}" #todo: WARNING, dropbox started, I need chage it like daemon work, because after that any code doesn't execute
cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
~/.dropbox-dist/dropboxd

echo -e "${White}Install node and nvm... ${Default}"
# Install node #todo: check last version of script
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
source ~/.bashrc
nvm install --lts

# Update npm up to last version
npm install npm@latest -g

# Install global packages
# Read the list of global packages from the saved file
while IFS= read -r package; do
  # Remove any leading whitespace
  package="$(echo -e "${package}" | sed -e 's/^[[:space:]]*//')"

  # Install the global package
  npm install -g "$package"
done < global-packages.txt #todo: get in correct way global packages (because know I got it fancy list) and it tries install empty string
echo -e "${Green}Finish install and setup NodeJS ${Default}"

# install signal messenger (https://signal.org/download/#)
wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg
cat signal-desktop-keyring.gpg | sudo tee /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' |\
sudo tee /etc/apt/sources.list.d/signal-xenial.list
sudo apt update && sudo apt install signal-desktop


read -p -e "${Purple}Finish base installation. Press any key to continue... ${Default}" -n1 -s

#@todo: copy projects without vendor folders


#@todo: provide config for vim https://github.com/alanhamlett/dotfiles


#@todo: add next file to job installation

#@todo: add rebot after installation
