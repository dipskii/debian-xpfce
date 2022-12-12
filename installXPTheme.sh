#!/bin/bash
# Install dependencies
sudo apt-get install -y git fakeroot rename x11-apps cmake gettext g++ pkg-config glib-2.0 gtk+-3.0 xfce4-dev-tools gtk-doc-tools libxfce4util-dev libgarcon-1.0-dev libgarcon-gtk3-1-dev libexo-2-dev libwnck-3-dev dpkg-dev exo-utils libdbusmenu-glib4 libdbusmenu-gtk3-4 libxfce4panel-2.0 ruby-sass xfwm4 libxpresent1 xfce4 xdg-utils thunderbird xfce4-terminal curl npm 

# Clone repo
git clone https://github.com/rozniak/xfce-winxp-tc --recurse-submodules
cd ./xfce-winxp-tc/

# Build and install stuff from ./packaging

./packaging/deb/cursors/packcurs.sh with-shadow/standard
sudo dpkg -i cursor-theme-with-shadow-standard.deb

./packaging/deb/fonts/packfnts.sh
sudo dpkg -i wintc-fonts-xp.deb

./packaging/deb/libs/packlibs.sh comgtk
sudo dpkg -i libcomgtk.deb

./packaging/deb/libs/packlibs.sh exec
sudo dpkg -i libexec.deb

./packaging/deb/libs/packlibs.sh shllang
sudo dpkg -i libshllang.deb

# Fix broken file with sed

sed 's/dpkg_architecture/dpkg-architecture/' ./submodules/xfce-winxp-tc-panel/packaging/pack-libxfce4panel-2.0.sh >> ./submodules/xfce-winxp-tc-panel/packaging/panel.sh
chmod +x ./submodules/xfce-winxp-tc-panel/packaging/panel.sh

# Installing more debs...

./submodules/xfce-winxp-tc-panel/packaging/panel.sh
sudo dpkg -i libxfce4panel-2.0-4.deb

./submodules/xfce-winxp-tc-panel/packaging/pack-xfce4-panel.sh
sudo dpkg -i xfce4-panel.deb

./packaging/deb/panel/packplug.sh shell/start shell/systray
sudo dpkg -i shell-start-plugin.deb shell-systray-plugin.deb

./packaging/deb/programs/packprog.sh shell/run shell/winver
sudo dpkg -i shell-winver.deb shell-run.deb

./packaging/deb/sounds/packsnds.sh
sudo dpkg -i wintc-sound-theme-xp.deb

# Checking out feat-13 for the other themes

git checkout feat-13

./packaging/deb/themes/packthem.sh luna/blue native professional
sudo dpkg -i wintc-theme-luna-blue.deb wintc-theme-native.deb wintc-theme-professional.deb

# Checking out feat-72 for the icon pack

git checkout feat-72

./packaging/deb/icons/packicon.sh luna
sudo dpkg -i icon-theme-luna.deb

# Retvrning to master

git checkout master

cd ..

# Adding Palemoon repo

echo 'deb http://download.opensuse.org/repositories/home:/stevenpusser/Debian_11/ /' | sudo tee /etc/apt/sources.list.d/home:stevenpusser.list
curl -fsSL https://download.opensuse.org/repositories/home:stevenpusser/Debian_11/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_stevenpusser.gpg > /dev/null
sudo apt-get update
sudo apt-get install -y palemoon

# WelcomeXP Greeter
# Installing Dependancies

sudo apt-get install -y build-essential libgirepository1.0-dev liblightdm-gobject-1-0 liblightdm-gobject-dev libcairo2-dev

sudo curl -fsSL https://deb.nodesource.com/setup_16.x >> ./nodejs16.sh
sudo ./nodejs.sh
sudo apt-get install -y nodejs

# Cloning nody-greeter repo

git clone --recursive https://github.com/JezerM/nody-greeter.git
cd nody-greeter
git checkout 1.5.1
npm install
npm run rebuild
npm run build
sudo node make install

echo "set 'greeter-session=nody-greeter' in /etc/lightdm/lightdm.conf"
read

# Cloning WelcomeXP repo

git clone https://github.com/mshernandez5/WelcomeXP.git
mkdir ./WelcomeXP/fonts
cp ./xfce-winxp-tc/fonts/ttf/tahoma.ttf ./WelcomeXP/fonts
cp ./xfce-winxp-tc/fonts/ttf/tahomabd.ttf ./WelcomeXP/fonts
cp ./xfce-winxp-tc/fonts/ttf/framdit.ttf ./WelcomeXP/fonts

# Copying theme files into proper directory

sudo cp -R WelcomeXP /usr/share/web-greeter/themes

sudo chmod -R 755 /usr/share/web-greeter/themes/WelcomeXP

sudo mv /etc/lightdm/web-greeter.yml/ /etc/lightdm/web-greeter_edit.yml
sudo sed 's/theme: gruvbox/theme: WelcomeXP/' /etc/lightdm/web-greeter_edit.yml >> web-greeter.yml
sudo mv ~/web-greeter.yml /etc/lightdm/
sudo rm /etc/lightdm/web-greeter_edit.yml

# install plymouth juust in case it isnt already

sudo apt-get install -y plymouth

# Cloning very epic plymouth theme

git clone https://github.com/Liftu/WindozeXP-1080-Plymouth-theme
cd ./WindozeXP-1080-Plymouth-theme
./install.sh

# i dunno how to automate this so theres just a message telling u what to do

echo "install moonfox theme!!"
echo "https://github.com/Lootyhoof/moonfox3"
