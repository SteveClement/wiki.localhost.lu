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
sudo apt install amd64-microcode firmware-amd-graphics firmware-iwlwifi slim etckeeper command-not-found rbenv fdisk zsh zsh-syntax-highlighting tmux mlocate trash-cli khard khal vdirsyncer ranger tmuxinator htop fzf ncdu mediainfo poppler-utils
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
# nm-connection-editor, nm-applet
sudo apt install murrine-themes 
sudo apt install -y g++ libgtk-3-dev gtk-doc-tools gnutls-bin valac
sudo apt install autogen
sudo apt-get install -y git g++ libgtk-3-dev gtk-doc-tools gnutls-bin valac intltool libpcre2-dev libglib3.0-cil-dev libgnutls28-dev libgirepository1.0-dev libxml2-utils gperf libtool
cd ~/code/
git clone --recursive https://github.com/thestinger/termite.git
git clone https://github.com/thestinger/vte-ng.git
export LIBRARY_PATH="/usr/include/gtk-3.0:$LIBRARY_PATH"
cd vte-ng/
# https://github.com/GNOME/vte/commit/53690d5cee51bdb7c3f7680d3c22b316b1086f2c#diff-09af37e3a14d365cf086df3ead32aa7f
echo "diff --git a/bindings/vala/app.vala b/bindings/vala/app.vala
index 8663d63c..a6b0259f 100644
--- a/bindings/vala/app.vala
+++ b/bindings/vala/app.vala
@@ -819,6 +819,7 @@ class App : Gtk.Application
 
   public struct Options
   {
+    public int dummy;
     public static bool audible = false;
     public static string? command = null;
     private static string? cjk_ambiguous_width_string = null;" |tee /tmp/vte.patch
cat /tmp/vte.patch |patch -p1
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
sudo apt install virtualenvwrapper virtualenv python3-pip
sudo apt install rofi conky-all
cd ~/code
sudo apt install build-essential git cmake cmake-data pkg-config libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev
sudo apt install libcurl4-openssl-dev libasound2-dev libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libjsoncpp-dev libmpdclient-dev libnl-genl-3-dev
git clone git@github.com:maestrogerardo/i3-gaps-deb.git
cd i3-gaps-deb
make clean
./build.sh
sudo apt install neomutt dialog
sudo apt -y install qemu-kvm libvirt-daemon  bridge-utils virtinst libvirt-daemon-system
sudo apt -y install virt-top libguestfs-tools libosinfo-bin  qemu-system virt-manager
sudo modprobe vhost_net 
echo vhost_net | sudo tee -a /etc/modules 

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
wget https://www.python.org/ftp/python/2.7.17/Python-2.7.17.tar.xz
tar xf Python-2.7.17.tar.xz
cd Python-2.7.17
vi Modules/Setup.dist
./configure --prefix=${HOME}/opt/python2.7.17
make -j8
make -j8 install


mkvirtualenv -p /home/steve/opt/python2.7.17/bin/python offlineimap
pip install six
pip install offlineimap
sudo ln -s /home/steve/opt/libressl/lib/libssl.so.46 /usr/lib/libssl.so.46
sudo ln -s /home/steve/opt/libressl/lib/libcrypto.so.44 /usr/lib/libcrypto.so.44

pip3 install --user pywal

Tools by hand

Issues: 

IPv6 connection reset foo: https://askubuntu.com/questions/905866/new-ubuntu-17-04-problem-your-connection-was-interrupted

Termite on Debian:

https://gist.github.com/crivotz/d4e43ebce09621906571f3720e676781<Paste>

Fonts:
https://github.com/ryanoasis/nerd-fonts#font-installation<Paste>

Polybar: 

https://medium.com/@tatianaensslin/install-polybar-in-3-steps-on-debian-stretch-c64ab6157fb1

Ranger: apt-get install ranger

Dotfile: https://github.com/ycf83/dotfile

Needed: wal, powerlevel9k theme zsh

https://github.com/maestrogerardo/i3-gaps-deb

wal -i someImage.jpg

BG: https://alpha.wallhaven.cc/wallpaper/690583

ranger deps: install w3m w3m-img
u need also this file scope.sh u can generate like this : ranger --copy-config=scope
https://github.com/ranger/ranger/wiki/Image-Previews<Paste>


https://github.com/Airblader/i3/wiki/Compiling-&-Installing ; u install dep and build normal , after u customize :)https://github.com/Airblader/i3/wiki/Compiling-&-Installing ; u install dep and build normal , after u customize :)



sudo apt install scrot compton rofi ffmpegthumbnailer transmission-cli transmission caca-utils

git clone https://github.com/stark/siji && cd siji
  xset +fp /home/steve/.fonts
  xset fp rehash


IF: tput: unknown terminal "xterm-termite"
tic -x /home/steve/tmp/termite/termite.terminfo 


Install spacevim for nvim:

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
sudo apt install pasaffe pass pass-git-helper pass-extension-tail pass-extension-otp
sudo apt install network-manager-l2tp network-manager-l2tp-gnome
wget https://protonmail.com/download/beta/protonmail-bridge_1.2.3-1_amd64.deb
sudo dpkg -i protonmail-bridge_1.2.3-1_amd64.deb ; sudo apt install -f
pass init steve@localhost.launchpad
pass git init
sudo apt install pavucontrol

# US International dead keys and Japanese input

sudo apt install ibus-mozc fonts-ipafont fonts-vlgothic  ibus-gtk ibus-gtk3

dpkg-reconfigure keyboard-configuration
sudo apt-get remove --purge $(sudo dpkg -l | grep "^rc" | awk '{print $2}' | tr '\n' ' ')

# xinitrc or other
ibus-daemon -d -x -r -n i3


# Alacritty

git clone https://github.com/alacritty/alacritty.git
cd alacritty
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup override set stable
rustup update stable
sudo apt-get install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev python3
cargo build --release
infocmp alacritty
sudo tic -xe alacritty,alacritty-direct extra/alacritty.info
sudo cp target/release/alacritty /usr/local/bin # or anywhere else in $PATH
sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
sudo desktop-file-install extra/linux/Alacritty.desktop
sudo update-desktop-database
sudo mkdir -p /usr/local/share/man/man1
gzip -c extra/alacritty.man | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null
mkdir -p ${ZDOTDIR:-~}/.zsh_functions
cp extra/completions/_alacritty ${ZDOTDIR:-~}/.zsh_functions/_alacritty
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/local/bin/alacritty 100
# GNOME specific (dconf rather)
gsettings set org.gnome.desktop.default-applications.terminal exec /usr/local/bin/alacritty
gsettings set org.gnome.desktop.default-applications.terminal exec-arg "-e"
```
