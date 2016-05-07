# Building an OpenBSD 5.9 Desktop

Random sources: http://www.taringa.net/post/info/14077505/Tutorial-Configurar-instalar-Openbox-en-OpenBSD-5-0.html

```
echo installpath=http://ftp.belnet.be/pub/OpenBSD/5.9/packages/i386/ > /etc/pkg.conf
echo "permit keepenv { PKG_PATH ENV PS1 SSH_AUTH_SOCK } :wheel" > /etc/doas.conf
doas pkg_add -v lsof ntp munin-node gsed pkglocatedb
doas pkg_add -v openbox slim slim-themes fbpanel
doas pkg_add -v firefox obconf obmenu leafpad pcmanfm nitrogen gnash xfce4-terminal intltool gnome-icon-theme gnome-themes-standard conky
doas pkg_add -v vim dillo geany roxterm geeqie jhead ImageMagick mpv vlc smplayer file-roller bash zsh irssi filezilla
doas pkg_add -v toad youtube-dl scrot gstreamer-plugins-ugly mplayer ubuntu-fonts
doas pkg_add -v gnome xfce4 mutt terminator cups xfprint gimp libreoffice
doas pkg_add -v mrxvt rxvt-unicode xfce4-clipman st vnstat
doas mv /usr/bin/vi /usr/bin/vi-`date +%d%m%y`
doas ln -s /usr/local/bin/vim /usr/bin/vi
```

/etc/login.conf
```
--- /etc/login.conf     Fri Mar  7 19:28:16 2014
+++ /etc/login.conf     Fri Mar  7 19:32:31 2014
@@ -43,8 +43,8 @@
 default:\
        :path=/usr/bin /bin /usr/sbin /sbin /usr/X11R6/bin /usr/local/bin /usr/local/sbin:\
        :umask=022:\
-       :datasize-max=512M:\
-       :datasize-cur=512M:\
+       :datasize-max=1024M:\
+       :datasize-cur=1024M:\
        :maxproc-max=256:\
        :maxproc-cur=128:\
        :openfiles-cur=512:\
```

/etc/fstab
```
/dev/wd0a / ffs rw,noatime,softdep 1 1
```


rc.local
```
echo -n ' ntpdate'
/usr/local/sbin/ntpdate -b pool.ntp.org >/dev/null
xntpd_flags="-p /var/run/ntpd.pid"
echo -n ' ntpd'; /usr/local/sbin/ntpd ${xntpd_flags}
if [ -x /usr/local/bin/slim ]; then
        echo -n ' slim'; ( sleep 5; /usr/local/bin/slim -nodaemon ) &
fi
```

rc.conf.local
```
# Make sure to disable xdm by NOT setting the next flag
#xdm_flags=
inetd_flags=NO
ntpd_flags="-s"
hotplugd_flags=""
multicast_host=YES
#pkg_scripts="messagebus avahi_daemon toadd gdm"
pkg_scripts="messagebus avahi_daemon toadd cupsd munin_node"
```

ntp.conf
```
#
# $FreeBSD: release/10.0.0/etc/ntp.conf 259975 2013-12-27 23:13:38Z delphij $
#
# Default NTP servers for the FreeBSD operating system.
#
# Don't forget to enable ntpd in /etc/rc.conf with:
# ntpd_enable="YES"
#
# The driftfile is by default /var/db/ntpd.drift, check
# /etc/defaults/rc.conf on how to change the location.
#

#
# The following three servers will give you a random set of three
# NTP servers geographically close to you.
# See http://www.pool.ntp.org/ for details. Note, the pool encourages
# users with a static IP and good upstream NTP servers to add a server
# to the pool. See http://www.pool.ntp.org/join.html if you are interested.
#
# The option `iburst' is used for faster initial synchronization.
#
server 0.freebsd.pool.ntp.org iburst
server 1.freebsd.pool.ntp.org iburst
server 2.freebsd.pool.ntp.org iburst
#server 3.freebsd.pool.ntp.org iburst

#
# If you want to pick yourself which country's public NTP server
# you want sync against, comment out the above servers, uncomment
# the next ones and replace CC with the country's abbreviation.
# Make sure that the hostnames resolve to a proper IP address!
#
# server 0.CC.pool.ntp.org iburst
# server 1.CC.pool.ntp.org iburst
# server 2.CC.pool.ntp.org iburst

#
# Security:
#
# By default, only allow time queries and block all other requests
# from unauthenticated clients.
#
# See http://support.ntp.org/bin/view/Support/AccessRestrictions
# for more information.
#
restrict default kod nomodify notrap nopeer noquery
restrict -6 default kod nomodify notrap nopeer noquery
#
# Alternatively, the following rules would block all unauthorized access.
#
#restrict default ignore
#restrict -6 default ignore
#
# In this case, all remote NTP time servers also need to be explicitly
# allowed or they would not be able to exchange time information with
# this server.
#
# Please note that this example doesn't work for the servers in
# the pool.ntp.org domain since they return multiple A records.
#
#restrict 0.pool.ntp.org nomodify nopeer noquery notrap
#restrict 1.pool.ntp.org nomodify nopeer noquery notrap
#restrict 2.pool.ntp.org nomodify nopeer noquery notrap
#
# The following settings allow unrestricted access from the localhost
restrict 127.0.0.1
restrict -6 ::1
restrict 127.127.1.0

#
# If a server loses sync with all upstream servers, NTP clients
# no longer follow that server. The local clock can be configured
# to provide a time source when this happens, but it should usually
# be configured on just one server on a network. For more details see
# http://support.ntp.org/bin/view/Support/UndisciplinedLocalClock
# The use of Orphan Mode may be preferable.
#
#server 127.127.1.0
#fudge 127.127.1.0 stratum 10
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

## lxappearance

```
doas pkg_add -v gmake
cd work
wget http://downloads.sourceforge.net/project/lxde/LXAppearance/lxappearance-0.6.2.tar.xz\?r\=https%3A%2F%2Fsourceforge.net%2Fprojects%2Flxde%2Ffiles%2FLXAppearance%2F\&ts\=1462583628\&use_mirror\=heanet -O lxappearance-0.6.2.tar.xz
unxz lxappearance-0.6.2.tar.xz
tar xfv lxappearance-0.6.2.tar
cd lxappearance-0.6.2
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

## htop

```
doas pkg_add -v automake autoconf libtool git
cd
mkdir work && cd work
git clone https://github.com/hishamhm/htop
cd htop
export AUTOMAKE_VERSION=1.15
export AUTOCONF_VERSION=2.69
./autogen.sh
./configure
make
doas make install
```

## US Internation Keyboard

Src: https://unix.stackexchange.com/questions/227756/how-to-use-accent-keys-with-us-keyboard-on-openbsd-5-7

```
setxkbmap -option compose:menu
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
