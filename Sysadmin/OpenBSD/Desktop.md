# Building an OpenBSD 5.9 Desktop

Random sources: http://www.taringa.net/post/info/14077505/Tutorial-Configurar-instalar-Openbox-en-OpenBSD-5-0.html

```
echo installpath=http://ftp.belnet.be/pub/OpenBSD/5.9/packages/i386/ > /etc/pkg.conf
echo "permit keepenv { PKG_PATH ENV PS1 SSH_AUTH_SOCK } :wheel" > /etc/doas.conf
pkg_add -v lsof ntp munin-node gsed pkglocatedb
pkg_add -v openbox slim slim-themes 
pkg_add -v firefox obconf obmenu leafpad pcmanfm nitrogen gnash xfce4-terminal intltool obmenu obconf gnome-icon-theme gnome-themes-standard nitrogen conky
pkg_add -v vim dillo geany roxterm geeqie jhead imagemagick mpv vlc smplayer file-roller bash zsh pcmanfm irssi filezilla
pkg_add -v toadd youtube-dl scrot gstreamer-plugins-ugly mplayer ubuntu-fonts
pkg_add -v gnome mutt muttprint terminator cups xfprint
pkg_add -v urxvt mrxvt rxvt-unicode xfce4-clipman st 
mv /usr/bin/vi /usr/bin/vi-`date +%d%m%y`
ln -s /usr/local/bin/vim /usr/bin/vi
```

rc.local
```
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

.xinitrc
```
exec openbox-session
```

.Xdefaults (! == comment)
```
URxvt*font: xft:Terminus:pixelsize=12,xft:Inconsolata\ for\ Powerline:pixelsize=12
!URxvt*font: xft:Terminess Powerline:size=12
!URxvt*font: xft:Inconsolata-dz\ for\ Powerline:size=12
!URxvt*font: xft:Inconsolata\ For\ Powerline:size=11
!URxvt*font: xft:Source\ Code\ Pro\ Medium:pixelsize=13:antialias=true:hinting=true,xft:Source\ Code\ Pro\ Medium:pixelsize=13:antialias=true:hinting=true
```

/etc/xdg/openbox/autostart.sh 
```
# Run XDG autostart things.  By default don't run anything desktop-specific 
# See xdg-autostart --help more info 
DESKTOP_ENV="OPENBOX" 
if which /usr/local/lib/openbox/xdg-autostart >/dev/null; then 
  /usr/local/lib/openbox/xdg-autostart $DESKTOP_ENV & conky & fbpanel & sudo nitrogen --restore /home/2.jpg & 
fi 
```

## htop

```
pkg_add -v automake autoconf libtool git
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

/etc/conky.conf
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
```
