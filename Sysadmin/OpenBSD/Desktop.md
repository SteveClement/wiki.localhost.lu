# Building an OpenBSD 6.3 Desktop

Random sources: http://www.taringa.net/post/info/14077505/Tutorial-Configurar-instalar-Openbox-en-OpenBSD-5-0.html


# OpenUP

https://www.mtier.org/solutions/apps/openup/

https://stable.mtier.org/openup

```
echo http://ftp.belnet.be/pub/OpenBSD/ > /etc/installurl
echo "permit keepenv setenv { PKG_PATH ENV PS1 SSH_AUTH_SOCK } :wheel" > /etc/doas.conf
doas pkg_add -v xfce openbox slim slim-themes fbpanel ntp munin-node gsed pkglocatedb
doas pkg_add -v firefox obconf obmenu leafpad pcmanfm nitrogen xfce4-terminal intltool gnome-icon-theme gnome-themes-standard conky
doas pkg_add -v vim dillo geany roxterm geeqie jhead ImageMagick mpv vlc smplayer file-roller bash zsh irssi filezilla
doas pkg_add -v youtube-dl scrot gstreamer-plugins-ugly mplayer ubuntu-fonts
doas pkg_add -v gnome neomutt terminator cups gimp libreoffice
doas pkg_add -v mrxvt rxvt-unicode xfce4-clipman st vnstat mu dialog thunderbird chromium
doas pkg_add -v imapfilter urlview msmtp pidgin procmail dsh bitlbee findutils mairix ibus
doas pkg_add -v pidgin-otr pidgin-libnotify pidgin-guifications py3-pip py-pip
doas mv /usr/bin/vi /usr/bin/vi-`date +%d%m%y`
doas ln -s /usr/local/bin/vim /usr/bin/vi
```

# The following new rcscripts were installed
```
/etc/rc.d/munin_asyncd /etc/rc.d/munin_node /etc/rc.d/xntpd
/etc/rc.d/messagebus /etc/rc.d/slim
/etc/rc.d/avahi_daemon /etc/rc.d/avahi_dnsconfd
/etc/rc.d/cups_browsed /etc/rc.d/cupsd /etc/rc.d/gdm /etc/rc.d/nmbd /etc/rc.d/samba /etc/rc.d/samba_ad_dc /etc/rc.d/saslauthd /etc/rc.d/smbd /etc/rc.d/winbindd
/etc/rc.d/vnstatd
```

# Package Messages
```
--- +python-2.7.13p0 -------------------
If you want to use this package as your default system python, as root
create symbolic links like so (overwriting any previous default):
 ln -sf /usr/local/bin/python2.7 /usr/local/bin/python
 ln -sf /usr/local/bin/python2.7-2to3 /usr/local/bin/2to3
 ln -sf /usr/local/bin/python2.7-config /usr/local/bin/python-config
 ln -sf /usr/local/bin/pydoc2.7  /usr/local/bin/pydoc
--- +cantarell-fonts-0.0.25 -------------------
You may wish to update your font path for /usr/local/share/fonts/cantarell
--- +hunspell-1.3.2p2 -------------------
Install mozilla dictionaries for extra hunspell languages.
e.g.
    # pkg_add mozilla-dicts-ca
--- +ruby-1.8.7.374p8 -------------------
If you want to use this package as your default system ruby, as root
create symbolic links like so (overwriting any previous default):
 ln -sf /usr/local/bin/ruby18 /usr/local/bin/ruby
 ln -sf /usr/local/bin/erb18 /usr/local/bin/erb
 ln -sf /usr/local/bin/irb18 /usr/local/bin/irb
 ln -sf /usr/local/bin/rdoc18 /usr/local/bin/rdoc
 ln -sf /usr/local/bin/ri18 /usr/local/bin/ri
 ln -sf /usr/local/bin/testrb18 /usr/local/bin/testrb
--- +smplayer-17.3.0 -------------------
Please note that the audio equaliser option can not be used with smplayer.
--- +ubuntu-fonts-0.83 -------------------
You may wish to update your font path for /usr/local/share/fonts/ubuntu
--- +ghostscript-fonts-8.11p3 -------------------
You may wish to update your font path for /usr/local/share/fonts/ghostscript
--- +webkit-gtk3-2.4.11p1v1 -------------------
!!! WARNING: WebKitGTK+ 2.4 is known to have many security vulnerabilities that
!!! will NOT be fixed. Avoid browsing with it.
--- +noto-emoji-20150929p0 -------------------
You may wish to update your font path for /usr/local/share/fonts/noto
--- +py-pip-9.0.1p0 -------------------
If you want to use this package as default pip, as root create a
symbolic link like so (overwriting any previous default):
    ln -sf /usr/local/bin/pip2.7 /usr/local/bin/pip
--- +py3-pip-9.0.1p0 -------------------
If you want to use this package as default pip, as root create a
symbolic link like so (overwriting any previous default):
    ln -sf /usr/local/bin/pip3.6 /usr/local/bin/pip
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
+       :datasize-max=2048M:\
+       :datasize-cur=2048M:\
        :maxproc-max=256:\
        :maxproc-cur=128:\
-        :openfiles-cur=512:\
+        :openfiles-cur=4096:\
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
# Make sure to disable xenodm by NOT setting the next flag
#xenodm_flags=
inetd_flags=NO
ntpd_flags="-s"
hotplugd_flags=""
multicast_host=YES
#pkg_scripts="messagebus avahi_daemon gdm"
pkg_scripts="messagebus avahi_daemon cupsd munin_node"
```

ntp.conf
```
#
# $FreeBSD: releng/11.0/etc/ntp.conf 294773 2016-01-26 07:06:44Z cy $
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
restrict default limited kod nomodify notrap nopeer noquery
restrict -6 default limited kod nomodify notrap nopeer noquery
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

# See http://support.ntp.org/bin/view/Support/ConfiguringNTP#Section_6.14.
# for documentation regarding leapfile. Updates to the file can be obtained
# from ftp://time.nist.gov/pub/ or ftp://tycho.usno.navy.mil/pub/ntp/.
# Use either leapfile in /etc/ntp or weekly updated leapfile in /var/db.
#leapfile "/etc/ntp/leap-seconds"
leapfile "/var/db/ntpd.leap-seconds.list"
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

## htop

```
doas pkg_add -v automake autoconf libtool git
cd
mkdir work
cd work
git clone https://github.com/hishamhm/htop
cd htop
export AUTOMAKE_VERSION=1.15
export AUTOCONF_VERSION=2.69
./autogen.sh
./configure
make
doas make install
```

## znc

### binary: doas pkg_add -v znc

### From source

```
doas pkg_add -v automake autoconf libtool git gcc g++ swig python
cd
mkdir work
cd work
export AUTOMAKE_VERSION=1.15
export AUTOCONF_VERSION=2.69
git clone https://github.com/swig/swig.git
cd swig
./autogen.sh
./configure
make
doas make install
git clone https://github.com/znc/znc.git --recursive
cd znc
./bootstrap.sh

CPPFLAGS="-I/usr/local/include " LDFLAGS="-L/usr/local/lib" python_LIBS="`pkg-config --libs python-3.6`" python_CFLAGS="`pkg-config --cflags python-3.6`" ac_cv_path_GNUMAKE=gmake CXX=egcc ./configure --disable-charset --disable-optimization

configure --enable-charset --enable-optimization --prefix=/usr/local --sysconfdir=/etc --mandir=/usr/local/man --infodir=/usr/local/info --localstatedir=/var --disable-silent-rules --disable-gtk-doc


gmake -j4
doas gmake install
```

## rbenv
```
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
cd ~/.rbenv && src/configure && make -C src
# rbenv install
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
```

## virtualenv

```
doas ln -sf /usr/local/bin/pip3.6 /usr/local/bin/pip
doas ln -s /usr/local/bin/python3.6 /usr/local/bin/python
doas pip install virtualenvwrapper virtualenv
```

## lxappearance

```
doas pkg_add -v gmake
cd work
wget -O lxappearance-0.6.3.tar.xz https://downloads.sourceforge.net/project/lxde/LXAppearance/lxappearance-0.6.3.tar.xz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Flxde%2Ffiles%2FLXAppearance%2F&ts=1492517080&use_mirror=freefr
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
http://sourceforge.net/projects/bleachbit/files/bleachbit-1.12.tar.bz2

```
tar xfvz bleachbit-1.12.tar.gz
cd bleachbit-1.12
make -C po local
python2.7 bleachbit/GUI.py
```

## winff

https://docs.google.com/uc?authuser=0&id=0B8HoAIi30ZDkMHlvVkVtNHJnLVE&export=download
https://github.com/WinFF/winff/tree/master/winff

```
doas pkg_add -v lazarus
git clone https://github.com/WinFF/winff.git
cd winff/winff
lazbuild --lazarusdir=/usr/local/share/lazarus -B winff.lpr
# https://code.google.com/archive/p/winff/downloads
# presets-libavcodec54_v3.wff
```
