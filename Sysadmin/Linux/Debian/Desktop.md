# Raw Notes

```
su -
cat << EOF >> /etc/apt/sources.list
deb http://deb.debian.org/debian/ bullseye main contrib non-free
deb-src http://deb.debian.org/debian/ bullseye main contrib non-free

deb http://security.debian.org/debian-security bullseye/updates main contrib non-free
deb-src http://security.debian.org/debian-security bullseye/updates main contrib non-free

deb http://deb.debian.org/debian/ unstable main contrib non-free
EOF
apt update
apt install sudo
usermod --append -G sudo steve
echo "Defaults	timestamp_timeout=240" |tee -a /etc/sudoers
exit
logout
sudo apt remove gdm3 gnome* xfce4-session
sudo apt install amd64-microcode firmware-amd-graphics firmware-iwlwifi slim etckeeper command-not-found rbenv fdisk zsh zsh-syntax-highlighting tmux mlocate trash-cli khard khal vdirsyncer ranger
sudo apt dist-upgrade
sudo apt autoremove
sudo reboot

#sudo vgscan
#sudo vgchange -ay
#sudo lvs
sudo apt install neovim
sudo apt install i3 suckless-tools dmenu i3lock feh xserver-xorg xinit network-manager
sudo apt install s-tui
sudo apt install texlive-latex-base
cd
mkdir code
cd code
sudo apt install ruby-ronn sysstat make gcc lm-sensors alsa-utils
sudo apt install build-essential 
sudo apt install autoconf
sudo apt install gawk
git clone git://github.com/vivien/i3blocks
cd i3blocks/
./autogen.sh 
./configure --datadir=/usr --prefix=/usr --localstatedir=/var --sysconfdir=/etc
make
sudo make install
sudo apt install acpi
sudo apt install xbacklight pm-utils
sudo apt install chromium
# nm-connection-editor 
sudo apt install murrine-themes 
sudo apt install -y g++ libgtk-3-dev gtk-doc-tools gnutls-bin valac
sudo apt install autogen
sudo apt-get install -y git g++ libgtk-3-dev gtk-doc-tools gnutls-bin valac intltool libpcre2-dev libglib3.0-cil-dev libgnutls28-dev libgirepository1.0-dev libxml2-utils gperf libtool
cd ~/code/
git clone --recursive https://github.com/thestinger/termite.git
git clone https://github.com/thestinger/vte-ng.git
export LIBRARY_PATH="/usr/include/gtk-3.0:$LIBRARY_PATH"
cd vte-ng/
./autogen.sh 
./configure --datadir=/usr --prefix=/usr --localstatedir=/var --sysconfdir=/etc
make
sudo make install
cd ../termite/
make
sudo make install
sudo ldconfig
sudo mkdir -p /lib/terminfo/x; sudo ln -s /usr/local/share/terminfo/x/xterm-termite /lib/terminfo/x/xterm-termite
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/local/bin/termite 60
sudo vi /etc/gtk-2.0/gtkrc
sudo vi /etc/gtk-3.0/settings.ini

sudo dpkg -i Downloads/synergy_1.10.1.stable_b87+8941241e_debian_amd64.deb 
sudo apt --fix-broken install
cd ~/code
wget https://raw.githubusercontent.com/maestrogerardo/i3-gaps-deb/master/i3-gaps-deb

sudo cp ~/bin/virtualenvwrapper* /usr/local/bin
sudo apt install virtualenvwrapper virtualenv python-pip3
sudo apt install rofi conky-all
cd ~/code
sudo apt install build-essential git cmake cmake-data pkg-config libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev
sudo apt install libcurl4-openssl-dev libasound2-dev libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libjsoncpp-dev libmpdclient-dev libnl-genl-3-dev
git clone git@github.com:maestrogerardo/i3-gaps-deb.git
cd i3-gaps-deb
make clean
./build.sh
sudo apt install neomutt dialog
sudo apt install virtualbox virtualbox-ext-pack virtualbox-guest-additions-iso

polybar:
sudo rm /etc/fonts/conf.d/70-no-bitmaps.conf
sudo fc-cache -f -v

nerd-fonts
sudo apt install fonts-powerline fonts-font-awesome fonts-entypo

sudo apt install git build-essential python3-dev libdbus-glib-1-dev libgirepository1.0-dev libcairo2-dev python3-venv python3-wheel
git clone https://github.com/erpalma/lenovo-throttling-fix.git
sudo ./lenovo-throttling-fix/install.sh
sudo apt install scrot compton rofi ffmpegthumbnailer transmission-cli transmission caca-utils

Offlineimap:

sudo apt install maildir-utils msmtp
sudo apt install pinentry-curses
wget https://www.python.org/ftp/python/2.7.15/Python-2.7.15.tar.xz
tar xf Python-2.7.15.tar.xz
cd Python-2.7.15
vi Modules/Setup.dist
./configure --prefix=${HOME}/opt/python2.7.15
make -j8
make -j8 install


mkvirtualenv -p /home/steve/opt/python2.7.15/bin/python offlineimap
pip install six
pip install offlineimap
sudo ln -s /home/steve/opt/libressl/lib/libssl.so.46 /usr/lib/libssl.so.46
sudo ln -s /home/steve/opt/libressl/lib/libcrypto.so.44 /usr/lib/libcrypto.so.44

```
