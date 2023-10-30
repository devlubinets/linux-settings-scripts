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


echo -e "${Green}Installing job apps start... ${Default}"
	sudo apt-get update
	sudo apt update
	sudo apt install -y git
	
    # https://github.com/nagygergo/jetbrains-toolbox-install
    #todo: add install phpstorm automaticaly
	curl -fsSL https://raw.githubusercontent.com/nagygergo/jetbrains-toolbox-install/master/jetbrains-toolbox.sh | bash
	
	sleep 3
echo -e "${Green}Installing job apps finish... ${Default}"

echo -e "${Green}Configuration git start... ${Default}"
	git config --global user.name "Lubynets Kyrylo"
	git config --global user.email "dev.lubinets@gmail.com"
	git config --global core.autocrlf true

	cp -R ../.ssh ~/.ssh

    #Show git config
    git config --list --show-origin
    # Add ssh keys
    sudo chmod 700 ~/.ssh
    sudo chmod 644 ~/.ssh/known_hosts
    sudo chmod 644 ~/.ssh/config #  I need create config directory
    sudo chmod 600 ~/.ssh/dev-github
    sudo chmod 644 ~/.ssh/dev-github.pub
    sudo chmod 600 ~/.ssh/ideal4finance
    sudo chmod 644 ~/.ssh/ideal4finance.pub
    sudo chmod -R 0644 *.pub
    ssh-add *.pub
    #Show add ssh keys 
	ssh-add -l
    sleep 5 ## add send information to slack or another messenger
echo -e "${Green}Configuration git finish... ${Default}"



echo -e "${Green}Installing docker start... ${Default}"
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common gnupg-agent
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/docker.gpg > /dev/null
	echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu jammy stable" | sudo tee /etc/apt/sources.list.d/docker.list

	sudo mkdir /etc/docker
	sudo touch /etc/docker/daemon.json
	echo '{"default-address-pools": [{"base":"172.17.0.0/16","size":24, "dns":["192.168.67.36","192.168.67.26","8.8.8.8"]}]}' |\
		sudo tee /etc/docker/daemon.json > /dev/null

	sudo apt update
	sudo apt install -y docker-ce
	sudo usermod -aG docker $USER
	
	sleep 3
echo -e "${Green}Installing docker finish... ${Default}"



echo -e "${Green}Installing docker compose start... ${Default}"
	compose_version=$(curl --silent https://api.github.com/repos/docker/compose/releases/latest | grep -Po '"tag_name": "\K.*\d')
	sudo curl -L https://github.com/docker/compose/releases/download/$compose_version/docker-compose-$(uname -s)-$(uname -m) -o '/usr/local/bin/docker-compose'
	sudo chmod +x '/usr/local/bin/docker-compose'
	sleep 3
echo -e "${Green}Installing docker compose finish... ${Default}"

#Install docker desktop
	sudo apt -y install gnome-terminal
	sudo apt remove docker-desktop
	rm -r $HOME/.docker/desktop
	sudo rm /usr/local/bin/com.docker.cli
	sudo apt purge docker-desktop
	
	wget -O docker-desktop.deb 'https://desktop.docker.com/linux/main/amd64/docker-desktop-4.13.1-amd64.deb?utm_source=docker&utm_medium=webreferral&utm_campaign=docs-driven-download-linux-amd64'
	sudo apt-get install ./docker-desktop.deb #todo: add -y to install without user interaction
	
	
read -p -e "${Purple}Finish installation. Press any key to continue... ${Default}" -n1 -s

echo -e "${Green}Installing VMware start... ${Default}"
#Install VMWare 
wget -O VMware-Player 
sudo apt -y install build-essential
xdg-open https://customerconnect.vmware.com/en/downloads/details?downloadGroup=WKST-PLAYER-1624&productId=1039&rPId=91446
sleep 3 #wait download file
chmod +x ~/Downloads/VMware-Player*
sudo ~/Downloads/VMware-Player*
echo -e "${Green}Installing VMware finish... ${Default}"

#Install Studio3T Free for work with MongoDB
xdg-open https://studio3t.com/download/
sleep 3 #wait download file
tar -xvzf studio-3t-linux-x64.tar.gz
 ~/Downloads/studio-3t-linux-x64.sh
 
 #Install Redis GUI client
sudo snap install redis-gui

#Install guake terminal
sudo apt-get install guake -y

