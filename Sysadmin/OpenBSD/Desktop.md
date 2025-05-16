# Building an OpenBSD 7.7 Desktop

Packages asking questions: irssi, conky, neomutt, urlview, pidgin, bitlbee, ghostscript. Can be avoided by adding options. (e.g: bitlbee--libpurple-otr or python--%3)

```bash
# mandatory password
echo "permit keepenv setenv { PKG_PATH ENV PS1 SSH_AUTH_SOCK } :wheel" > /etc/doas.conf
# nopass
echo "permit nopass keepenv setenv { PKG_PATH ENV PS1 SSH_AUTH_SOCK } :wheel" > /etc/doas.conf
```

## Heavy install
```bash
doas pkg_add -v xfce openbox fbpanel ntp munin-node gsed pkglocatedb
doas pkg_add -v firefox obconf obmenu leafpad pcmanfm-qt nitrogen xfce4-terminal intltool gnome-icon-theme conky--
doas pkg_add -v neovim dillo geany roxterm geeqie jhead ImageMagick mpv vlc smplayer file-roller bash zsh irssi filezilla
doas pkg_add -v youtube-dl scrot mplayer ubuntu-fonts
doas pkg_add -v gnome neomutt--gpgme-sasl terminator cups gimp-3.0.2 libreoffice
doas pkg_add -v alacritty xfce4-clipman st--scrollback vnstat mu dialog thunderbird chromium
doas pkg_add -v imapfilter urlview-- msmtp pidgin-- procmail dsh bitlbee--libpurple-otr findutils mairix ibus
doas pkg_add -v pidgin-otr pidgin-libnotify pidgin-guifications py3-pip
# Tools
doas pkg_add -v htop git
echo "alias vi=nvim" |tee -a ~/.profile
echo "alias vi=nvim" |tee -a ~/.zshrc
echo "alias vi=nvim" |doas tee -a /root/.profile
```

## Lighter install
```bash
doas pkg_add -v i3 i3status i3lock # others in-lieu of: i3, i3-mousedrag 
doas pkg_add -v arandr polybar rofi feh scrot munin-node gsed pkglocatedb
doas pkg_add -v firefox leafpad pcmanfm-qt nitrogen intltool conky--
doas pkg_add -v neovim dillo geany roxterm geeqie jhead ImageMagick mpv vlc smplayer ranger bash zsh irssi filezilla
doas pkg_add -v youtube-dl scrot mplayer ubuntu-fonts
doas pkg_add -v neomutt--gpgme-sasl terminator
# Tools
doas pkg_add -v htop git
# Print
doas pkg_add -v ghostscript--gtk
doas pkg_add -v cups
doas pkg_add -v gimp-3.0.2 libreoffice
doas pkg_add -v alacritty st--scrollback vnstat mu dialog thunderbird
doas pkg_add -v imapfilter urlview-- msmtp pidgin-- procmail dsh bitlbee--libpurple-otr findutils mairix ibus
doas pkg_add -v pidgin-otr pidgin-libnotify pidgin-guifications py3-pip
echo "alias vi=nvim" |tee -a ~/.profile
echo "alias vi=nvim" |tee -a ~/.zshrc
echo "alias vi=nvim" |doas tee -a /root/.profile
```

## CJK input foo

```bash
fcitx # arimasu
```

# one-liner of all the above (heavy)
```bash
doas pkg_add -v xfce openbox fbpanel munin-node gsed pkglocatedb firefox obconf obmenu leafpad pcmanfm nitrogen xfce4-terminal intltool gnome-icon-theme conky-- neovim dillo geany roxterm geeqie jhead ImageMagick mpv vlc smplayer file-roller bash zsh irssi filezilla youtube-dl scrot mplayer ubuntu-fonts gnome neomutt--gpgme-sasl terminator cups gimp libreoffice alacritty xfce4-clipman st vnstat mu dialog thunderbird chromium imapfilter urlview-- msmtp pidgin-- procmail dsh bitlbee--libpurple-otr findutils mairix ibus pidgin-otr pidgin-libnotify pidgin-guifications py3-pip py-pip
```

# The following new rcscripts were installed
```
/etc/rc.d/avahi_daemon
/etc/rc.d/avahi_dnsconfd
/etc/rc.d/gdm
/etc/rc.d/nmbd
/etc/rc.d/samba
/etc/rc.d/smbd
/etc/rc.d/winbindd
/etc/rc.d/cups_browsed
/etc/rc.d/cupsd
/etc/rc.d/xntpd
/etc/rc.d/bitlbee
/etc/rc.d/vnstatd
/etc/rc.d/messagebus
/etc/rc.d/munin_asyncd
/etc/rc.d/munin_node
/etc/rc.d/saslauthd
/etc/rc.d/gitdaemon
```

# New and changed readme(s):
```
        /usr/local/share/doc/pkg-readmes/glib2
        /usr/local/share/doc/pkg-readmes/consolekit2
        /usr/local/share/doc/pkg-readmes/dbus
        /usr/local/share/doc/pkg-readmes/libinotify
        /usr/local/share/doc/pkg-readmes/munin-node
        /usr/local/share/doc/pkg-readmes/terminus-font
        /usr/local/share/doc/pkg-readmes/firefox
        /usr/local/share/doc/pkg-readmes/ffmpeg
        /usr/local/share/doc/pkg-readmes/gtk+2
        /usr/local/share/doc/pkg-readmes/gtk+3
        /usr/local/share/doc/pkg-readmes/gtk+4
        /usr/local/share/doc/pkg-readmes/neovim
        /usr/local/share/doc/pkg-readmes/sdl2
        /usr/local/share/doc/pkg-readmes/xdg-utils
        /usr/local/share/doc/pkg-readmes/mplayer
        /usr/local/share/doc/pkg-readmes/gnupg
        /usr/local/share/doc/pkg-readmes/cups
        /usr/local/share/doc/pkg-readmes/cups-filters
        /usr/local/share/doc/pkg-readmes/foomatic-db-engine
        /usr/local/share/doc/pkg-readmes/thunderbird
        /usr/local/share/doc/pkg-readmes/bitlbee
        /usr/local/share/doc/pkg-readmes/gtk+2
        /usr/local/share/doc/pkg-readmes/ibus
        /usr/local/share/doc/pkg-readmes/ntp
        /usr/local/share/doc/pkg-readmes/xfce
        /usr/local/share/doc/pkg-readmes/firefox
        /usr/local/share/doc/pkg-readmes/chromium
        /usr/local/share/doc/pkg-readmes/avahi
        /usr/local/share/doc/pkg-readmes/gnome
        /usr/local/share/doc/pkg-readmes/samba
        /usr/local/share/doc/pkg-readmes/texlive_base
        /usr/local/share/doc/pkg-readmes/upower
        /usr/local/share/doc/pkg-readmes/git
```

# Package Messages

```
--- +hunspell-1.7.2 -------------------
Install mozilla dictionaries for extra hunspell languages.
e.g.
    # pkg_add mozilla-dicts-ca
--- +smplayer-24.5.0 -------------------
Please note that the audio equaliser option can not be used with smplayer.
--- +i3status-2.15 -------------------
Before running i3status, a configuration file needs to be created.
Copy the provided /usr/local/share/examples/i3status/i3status.conf
to ~/.i3status.conf and modify as necessary.
--- +flite-2.2 -------------------
The festival lite package was modified from the original source.
You can find the modifications on
https://cvsweb.openbsd.org/ports/audio/flite/patches/
```


/etc/login.conf
```
--- /etc/login.conf
+++ /etc/login.conf
@@ -41,12 +41,12 @@ auth-ftp-defaults:auth-ftp=passwd:
 default:\
        :path=/usr/bin /bin /usr/sbin /sbin /usr/X11R6/bin /usr/local/bin /usr/local/sbin:\
        :umask=022:\
-       :datasize-max=1536M:\
-       :datasize-cur=1536M:\
+       :datasize-max=2048M:\
+       :datasize-cur=2048M:\
        :maxproc-max=256:\
        :maxproc-cur=128:\
        :openfiles-max=1024:\
-       :openfiles-cur=512:\
+       :openfiles-cur=4096:\
        :stacksize-cur=4M:\
        :localcipher=blowfish,a:\
        :tc=auth-defaults:\
```

/etc/fstab
```
12cba83c3f56c5cc.a / ffs rw,noatime,softdep 1 1
```


rc.local
```
echo -n ' ntpdate'
/usr/local/sbin/ntpdate -b pool.ntp.org >/dev/null
```

rc.conf.local
```
xenodm_flags=
inetd_flags=NO
hotplugd_flags=""
multicast_host=YES
#pkg_scripts="messagebus avahi_daemon gdm"
pkg_scripts="messagebus avahi_daemon cupsd munin_node"
```

.xinitrc
```
exec openbox-session
```

/etc/xdg/openbox/autostart
```
DESKTOP_ENV="OPENBOX"
if which /usr/local/libexec/openbox-xdg-autostart >/dev/null; then
  /usr/local/libexec/openbox-xdg-autostart $DESKTOP_ENV & conky & fbpanel & nitrogen --restore /home/background.jpg &
fi
```

## LaTeX

```
doas pkg_add -v texlive_texmf-full texlive_base texworks
```

## Chromium
```
doas pkg_add -v chromium
```

## znc

### binary: doas pkg_add -v znc

### From source

```
doas pkg_add -v libtool git gcc--%11 g++--%11 g++ swig python--%3 gmake autoconf--%2.72 automake--%1.17 cmake
cd
mkdir code
cd code
export AUTOMAKE_VERSION=1.17
export AUTOCONF_VERSION=2.72
git clone https://github.com/znc/znc.git --recursive
cd znc
mkdir build
cd build
cmake ..
make
doas make install
```

## rbenv
```
cd
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
cd ~/.rbenv && src/configure && make -C src
# rbenv install
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
```

## lxappearance

### pkg

```
doas pkg_add -v lxappearance
```

### From source

```
doas pkg_add -v gmake
cd
cd code
wget -O lxappearance-0.6.3.tar.xz "https://downloads.sourceforge.net/project/lxde/LXAppearance/lxappearance-0.6.3.tar.xz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Flxde%2Ffiles%2FLXAppearance%2F&ts=1492517080&use_mirror=freefr"
unxz lxappearance-0.6.3.tar.xz
tar xfv lxappearance-0.6.3.tar
cd lxappearance-0.6.3
./configure --enable-dbus
gmake
doas gmake install
```

/etc/rc.shutdown
```
powerdown=Yes
```

.config/fbpanel/default

Change sudo to doas (if you do not require a password)

```
            item {
                name = Reboot
                icon = gnome-session-reboot
                action = doas reboot
            }
            item {
                name = Shutdown
                icon = gnome-session-halt
                action = doas shutdown -h +0
            }
```

.config/pcmanfm/main
```
[General]

[Window]
width=604
height=472
splitterPos=160
maximized=0

[Desktop]
showDesktop=1
```

.config/nitrogen/bg-saved.cfg
```
[:0.0]
file=/home/steve/background.jpg
mode=0
bgcolor=#3f3f3f
```

.Xdefaults (! == comment)
```
URxvt*font: xft:Terminus:pixelsize=12,xft:Inconsolata\ for\ Powerline:pixelsize=12
!URxvt*font: xft:Terminess Powerline:size=12
!URxvt*font: xft:Inconsolata-dz\ for\ Powerline:size=12
!URxvt*font: xft:Inconsolata\ For\ Powerline:size=11
!URxvt*font: xft:Source\ Code\ Pro\ Medium:pixelsize=13:antialias=true:hinting=true,xft:Source\ Code\ Pro\ Medium:pixelsize=13:antialias=true:hinting=true
```

## vim

```
mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
cd ~/.vim/bundle && git clone git://github.com/tpope/vim-sensible.git && git clone https://github.com/vim-airline/vim-airline ~/.vim/bundle/vim-airline
mkdir .fonts
cd .fonts
git clone https://github.com/powerline/fonts.git
mv fonts/* .
mv fonts/.git .
rmdir fonts
fc-cache -vf ~/.fonts
```

.vimrc
```
execute pathogen#infect()
syntax on
filetype plugin indent on
set enc=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf8,prc
let g:airline_powerline_fonts = 1
```

## oh-my-zsh

```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

https://jijoejv.wordpress.com/2012/06/22/workaround-slowness-of-oh-my-zsh-git-plugins-on-large-repositories/

## US Internation Keyboard

Src: https://unix.stackexchange.com/questions/227756/how-to-use-accent-keys-with-us-keyboard-on-openbsd-5-7

```
setxkbmap -option compose:menu
```

Use ibus!

```
ibus-setup
```

/etc/conky/conky.conf
```
alignment top_right
background yes
border_width 1
cpu_avg_samples 2
default_color black
default_outline_color white
default_shade_color blue
draw_borders yes
draw_graph_borders yes
draw_outline no
draw_shades no
use_xft yes
xftfont DejaVu Sans Mono:size=10
gap_x 5
gap_y 60
minimum_size 5 5
net_avg_samples 2
no_buffers yes
out_to_console no
out_to_stderr no
extra_newline no
own_window no
own_window_class Conky
own_window_type desktop
stippled_borders 0
update_interval 1.0
uppercase no
use_spacer none
show_graph_scale no
show_graph_range no

TEXT
${scroll 16 $nodename - $sysname $kernel on $machine | }
$hr
${color grey}Uptime:$color $uptime
${color grey}Frequency (in MHz):$color $freq
${color grey}Frequency (in GHz):$color $freq_g
${color grey}RAM Usage:$color $mem/$memmax - $memperc% ${membar 4}
${color grey}Swap Usage:$color $swap/$swapmax - $swapperc% ${swapbar 4}
${color grey}CPU Usage:$color $cpu% ${cpubar 4}
${color grey}Processes:$color $processes  ${color grey}Running:$color $running_processes
$hr
${color grey}File systems:
 / $color${fs_used /}/${fs_size /} ${fs_bar 6 /}
${color grey}Networking:
Up:$color ${upspeed eth0} ${color grey} - Down:$color ${downspeed eth0}
$hr
${color grey}Name              PID   CPU%   MEM%
${color lightgrey} ${top name 1} ${top pid 1} ${top cpu 1} ${top mem 1}
${color lightgrey} ${top name 2} ${top pid 2} ${top cpu 2} ${top mem 2}
${color lightgrey} ${top name 3} ${top pid 3} ${top cpu 3} ${top mem 3}
${color lightgrey} ${top name 4} ${top pid 4} ${top cpu 4} ${top mem 4}
```

## Bleachbit

https://www.bleachbit.org/
https://www.bleachbit.org/download/source
http://sourceforge.net/projects/bleachbit/files/bleachbit-2.0.tar.bz2
https://sourceforge.net/projects/bleachbit/files/bleachbit/5.0.0/bleachbit-5.0.0.tar.bz2/download

```
cd
cd work
wget -O bleachbit-5.0.0.tar.bz2 https://sourceforge.net/projects/bleachbit/files/bleachbit/5.0.0/bleachbit-5.0.0.tar.bz2/download
tar xfvj bleachbit-5.0.0.tar.bz2
cd bleachbit-5.0.0
make -C po local
python3 bleachbit/GUI.py
```

# Archive

/!\ not maintained

## winff (defunct, lazarus not in OpenBSD 6.6)

https://docs.google.com/uc?authuser=0&id=0B8HoAIi30ZDkMHlvVkVtNHJnLVE&export=download
https://github.com/WinFF/winff/tree/master/winff

```
doas pkg_add -v lazarus # 6.1< only
git clone https://github.com/WinFF/winff.git
cd winff/winff
lazbuild --lazarusdir=/usr/local/share/lazarus -B winff.lpr
# https://code.google.com/archive/p/winff/downloads
# presets-libavcodec54_v3.wff
```
