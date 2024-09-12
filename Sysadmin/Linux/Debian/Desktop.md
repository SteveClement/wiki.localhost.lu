# Raw Notes

```
# Debian specific, not needed on Ubuntu
su -
cat << EOF >> /etc/apt/sources.list
# To make your Debian stable unstable, add the following line to sources.list
deb http://deb.debian.org/debian/ unstable main contrib non-free
EOF

apt update
apt -y install sudo
usermod --append -G sudo steve
echo "Defaults	timestamp_timeout=240" |tee -a /etc/sudoers
exit
logout
# -----8<-------

sudo apt -y dist-upgrade
sudo apt -y autoremove

sudo apt -y remove gdm3 gnome* xfce4-session
sudo apt -y install amd64-microcode firmware-amd-graphics firmware-iwlwifi
sudo apt -y install slim etckeeper command-not-found rbenv fdisk zsh zsh-syntax-highlighting tmux mlocate trash-cli khard khal vdirsyncer ranger w3m w3m-img tmuxinator htop fzf ncdu mediainfo poppler-utils bat git pandoc
sudo reboot

#sudo vgscan
#sudo vgchange -ay
#sudo lvs

sudo apt -y install neovim -y
sudo apt -y install i3 suckless-tools dmenu i3lock i3lock-fancy feh xserver-xorg xinit network-manager mpv -y
sudo apt -y install s-tui -y
sudo apt -y install texlive-latex-base -y
cd
mkdir code
cd code
sudo apt -y install ruby-ronn sysstat make gcc lm-sensors alsa-utils
sudo apt -y install build-essential
sudo apt -y install autoconf autogen
sudo apt -y install gawk i3blocks
sudo apt -y install acpi
sudo apt -y install xbacklight pm-utils
sudo apt -y install chromium
# nm-connection-editor, nm-applet
sudo apt -y install murrine-themes
sudo apt -y install g++ libgtk-3-dev gtk-doc-tools gnutls-bin valac intltool libpcre2-dev libglib3.0-cil-dev libgnutls28-dev libgirepository1.0-dev libxml2-utils gperf libtool flake8
cd ~/code/
sudo vi /etc/gtk-2.0/gtkrc
sudo vi /etc/gtk-3.0/settings.ini

# Install Barrier (synergy fork)

sudo cp ~/bin/virtualenvwrapper* /usr/local/bin
sudo apt -y install virtualenvwrapper virtualenv python3-pip
sudo apt -y install rofi conky-all
cd ~/code
sudo apt -y install build-essential cmake cmake-data pkg-config libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python3-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev
sudo apt -y install libcurl4-openssl-dev libasound2-dev libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libjsoncpp-dev libmpdclient-dev libnl-genl-3-dev
git clone git@github.com:maestrogerardo/i3-gaps-deb.git
cd i3-gaps-deb
./i3-gaps-deb
sudo apt -y install neomutt dialog
sudo apt -y install qemu-kvm libvirt-daemon bridge-utils virtinst libvirt-daemon-system
sudo apt -y install libguestfs-tools libosinfo-bin qemu-system virt-manager # virt-top
sudo apt -y install nodejs npm
sudo modprobe vhost_net 
echo vhost_net | sudo tee -a /etc/modules 

# polybar:
sudo rm /etc/fonts/conf.d/70-no-bitmaps.conf
sudo fc-cache -f -v

# nerd-fonts
sudo apt -y install fonts-powerline fonts-font-awesome fonts-entypo

sudo apt -y install python3-dev libdbus-glib-1-dev libgirepository1.0-dev libcairo2-dev python3-venv python3-wheel

git clone https://github.com/erpalma/lenovo-throttling-fix.git
sudo ./lenovo-throttling-fix/install.sh

sudo apt -y install scrot compton rofi ffmpegthumbnailer transmission-cli transmission caca-utils

# Offlineimap: (this might not be needed anymore)

installCustOfflineImap () {
  sudo apt -y install maildir-utils msmtp
  sudo apt -y install pinentry-curses
  wget https://www.python.org/ftp/python/2.7.18/Python-2.7.18.tar.xz
  tar xf Python-2.7.18.tar.xz
  cd Python-2.7.18
  vi Modules/Setup.dist
  ./configure --prefix=${HOME}/opt/python2.7.18
  make -j8
  make -j8 install

  mkvirtualenv -p /home/steve/opt/python2.7.18/bin/python offlineimap
  pip install six
  pip install offlineimap
  sudo ln -s /home/steve/opt/libressl/lib/libssl.so.46 /usr/lib/libssl.so.46
  sudo ln -s /home/steve/opt/libressl/lib/libcrypto.so.44 /usr/lib/libcrypto.so.44
}

# muttils

```
hg clone https://hg.phloxic.productions/muttils
cd muttils
make && make install-home
pip3 install .
```

pip3 install --user pywal

sudo apt install offlineimap python3-pip polybar
mu init -m ~/.mail --my-address=steve@localhost.lu --my-address=steve.clement@circl.lu --my-address=steve@circl.lu --my-address=steve@ion.lu --my-address=sclement@gmail.com --my-address=steve.clement@securitymadein.lu ; mu index
```

# Tools by hand

## Issues

IPv6 connection reset foo: https://askubuntu.com/questions/905866/new-ubuntu-17-04-problem-your-connection-was-interrupted

## Termite on Debian

https://gist.github.com/crivotz/d5e43ebce09621906571f3720e676781

## Fonts

https://github.com/ryanoasis/nerd-fonts#font-installation

## Polybar

https://medium.com/@tatianaensslin/install-polybar-in-3-steps-on-debian-stretch-c64ab6157fb1

Dotfile: https://github.com/ycf83/dotfile

Needed: wal, powerlevel9k theme zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

https://github.com/maestrogerardo/i3-gaps-deb

wal -i someImage.jpg

BG: https://alpha.wallhaven.cc/wallpaper/690583

u need also this file scope.sh u can generate like this : ranger --copy-config=scope
https://github.com/ranger/ranger/wiki/Image-Previews

https://github.com/Airblader/i3/wiki/Compiling-&-Installing ; u install dep and build normal , after u customize :)https://github.com/Airblader/i3/wiki/Compiling-&-Installing ; u install dep and build normal , after u customize :)


git clone https://github.com/stark/siji && cd siji
  xset +fp /home/steve/.fonts
  xset fp rehash
```

# Install spacevim for nvim:

```
curl -sLf https://spacevim.org/install.sh | bash

bat:
Line numbers not readabel: https://github.com/sharkdp/bat/issues/219

mkdir -p ~/.config/bat/themes
cd ~/.config/bat/themes
wget https://raw.githubusercontent.com/sonph/onehalf/master/sublimetext/OneHalfDark.tmTheme
bat cache --init
bat --theme=OneHalfDark

sudo chmod 7455 /opt/Franz/chrome-sandbox

echo "deb http://ppa.launchpad.net/mdeslaur/pasaffe/ubuntu eoan main
deb-src http://ppa.launchpad.net/mdeslaur/pasaffe/ubuntu eoan main" |sudo tee /etc/apt/sources.list.d/pasaffe.list
sudo apt-key adv --keyserver hkps://keyserver.ubuntu.com --recv-keys 8CA686453D4DECBC
sudo apt update
sudo apt -y install pasaffe pass pass-git-helper pass-extension-tail pass-extension-otp
sudo apt -y install network-manager-l2tp network-manager-l2tp-gnome
wget https://protonmail.com/download/beta/protonmail-bridge_1.2.3-1_amd64.deb
sudo dpkg -i protonmail-bridge_1.2.3-1_amd64.deb ; sudo apt install -f
pass init steve@localhost.launchpad
pass git init
sudo apt install pavucontrol
```

# US International dead keys and Japanese input

```
sudo apt -y install ibus-mozc fonts-ipafont fonts-vlgothic  ibus-gtk ibus-gtk3

sudo dpkg-reconfigure keyboard-configuration
sudo service keyboard-setup restart
sudo apt remove --purge $(sudo dpkg -l | grep "^rc" | awk '{print $2}' | tr '\n' ' ')
```

# xinitrc or other

```
ibus-daemon -d -x -r -n i3
```

# Alacritty

```
sudo apt -y install alacritty
```
