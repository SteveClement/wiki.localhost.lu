remove gdm3, xfce4-session

# Default editor

```
sudo update-alternatives --config editor
sudo select-editor
```


# Wayland or xorg

If you want to know whether you are running a Wayland or Xorg desktop the following come in handy.

```
$ loginctl
SESSION  UID USER  SEAT  TTY
      1 1000 steve seat0

1 sessions listed.

$ loginctl show-session 1 -p Type
Type=x11
```

```
sudo apt install slim
sudo apt install amd64-microcode
sudo apt install firmware-amd-graphics
```

# grub2 splashimages
```
sudo apt install grub2-splashimages
sudo update-grub
sudo vi /etc/default/grub
#GRUB_BACKGROUND="/usr/share/images/grub/Plasma-lamp.tga"
```

# WiFi Firmware
```
Intel Corporation Dual Band Wireless-AC 3168NGW
firmware-iwlwifi
```

# arandr
```
   sudo apt install python3-gi gobject-introspection gir1.2-gtk-3.0
   git clone https://gitlab.com/arandr/arandr
   cd arandr/
   ./arandr
```

# 8.5 E: Dynamic MMap ran out of room

Auf woody kann es bei mehreren Einträgen in der sources.list passieren, dass
aptitude update mit der Fehlermeldung

E: Dynamic MMap ran out of room

abbricht. Abhilfe dagegen schafft folgender Eintrag in der
/etc/apt/apt.conf:

```
APT::Cache-Limit 16777216;
```

Bei sehr vielen source-Zeilen muss die Zahl ggf. noch grösser sein.

# Etch GPG Key
```
> B5D0C804ADB11277 is the new signing key for the Etch release which is
> unfortunately not in the debian keyring package yet.

> If you want to fix it take the following steps:

> * As a user
> $ gpg --keyserver pgpkeys.pca.dfn.de --recv-keys B5D0C804ADB11277
> $ gpg --export -a B5D0C804ADB11277 > /tmp/etch

> * As root
> # apt-key add /tmp/etch
> # apt-get update

> For further information or if you encounter any problems take a look
> at "man apt-key" and http://wiki.debian.org/SecureApt (and maybe
> http://blog.madduck.net/debian/2006.01.08-apt-updates too).
```

# Removing ipv6 functions

edit **/etc/modprobe.d/blacklist**
add:
```
blacklist ipv6
```

# Installing vim
```
apt-get install vim
```

# Removing Kernels

Over time an awful lot of kernels gathe in Debian or Ubuntu.

To remove these obsolete kernels do:

```
uname -a
dpkg -l |grep kernel-image
apt-get remove --purge EXACT-OLD-KERNEL-NAME
update-grub
```

Example:

```
root@hsdpa:~# uname -a
Linux hsdpa 2.6.27-2-server #1 SMP Thu Aug 28 18:05:08 UTC 2008 i686 GNU/Linux
root@hsdpa:~# dpkg -l |grep kernel-image
ii  linux-image-2.6.24-19-server          2.6.24-19.34                  Linux kernel image for version 2.6.24 on x86
ii  linux-image-2.6.27-2-server           2.6.27-2.3                    Linux kernel image for version 2.6.27 on x86
ii  linux-image-server                    2.6.27.2.2                    Linux kernel image on Server Equipment.
root@hsdpa:~# apt-get remove --purge linux-image-2.6.24-19-server
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following packages will be REMOVED:
  linux-image-2.6.24-19-server* linux-ubuntu-modules-2.6.24-19-server*
0 upgraded, 0 newly installed, 2 to remove and 0 not upgraded.
After this operation, 77.7MB disk space will be freed.
Do you want to continue [Y/n]?
(Reading database ... 18945 files and directories currently installed.)
Removing linux-ubuntu-modules-2.6.24-19-server ...
update-initramfs: Generating /boot/initrd.img-2.6.24-19-server
Purging configuration files for linux-ubuntu-modules-2.6.24-19-server ...
Removing linux-image-2.6.24-19-server ...
Examining /etc/kernel/prerm.d.
run-parts: executing /etc/kernel/prerm.d/last-good-boot
Running postrm hook script /sbin/update-grub.
Searching for GRUB installation directory ... found: /boot/grub
Searching for default file ... found: /boot/grub/default
Testing for an existing GRUB menu.lst file ... found: /boot/grub/menu.lst
Searching for splash image ... none found, skipping ...
Found kernel: /boot/vmlinuz-2.6.27-2-server
Found kernel: /boot/last-good-boot/vmlinuz
Found kernel: /boot/memtest86+.bin
Replacing config file /var/run/grub/menu.lst with new version
Updating /boot/grub/menu.lst ... done

The link /vmlinuz.old is a damaged link
Removing symbolic link vmlinuz.old
 you may need to re-run your boot loader[grub]
The link /initrd.img.old is a damaged link
Removing symbolic link initrd.img.old
 you may need to re-run your boot loader[grub]
Purging configuration files for linux-image-2.6.24-19-server ...
Running postrm hook script /sbin/update-grub.
Searching for GRUB installation directory ... found: /boot/grub
Searching for default file ... found: /boot/grub/default
Testing for an existing GRUB menu.lst file ... found: /boot/grub/menu.lst
Searching for splash image ... none found, skipping ...
Found kernel: /boot/vmlinuz-2.6.27-2-server
Found kernel: /boot/last-good-boot/vmlinuz
Found kernel: /boot/memtest86+.bin
Updating /boot/grub/menu.lst ... done

root@hsdpa:~# update-grub
Searching for GRUB installation directory ... found: /boot/grub
Searching for default file ... found: /boot/grub/default
Testing for an existing GRUB menu.lst file ... found: /boot/grub/menu.lst
Searching for splash image ... none found, skipping ...
Found kernel: /boot/vmlinuz-2.6.27-2-server
Found kernel: /boot/last-good-boot/vmlinuz
Found kernel: /boot/memtest86+.bin
Updating /boot/grub/menu.lst ... done

root@hsdpa:~#
```

## installing gnome latest
```
aptitude install xorg gnome (or xfce4 xfce4-goodies)
```
# Building from Source

I frequently need to recompile stuff under Ubuntu.

My **favorite** ./configure line so far is:

```
 ./configure  --datadir=/usr --prefix=/usr --localstatedir=/var --sysconfdir=/etc
```

If you get:

```
 warning: macro `AM_GCONF_SOURCE_2' not found in library
```

all you need to do is:

```
 sudo apt-get install libgconf2-dev
```

Thanks to:

[Milinda Pathirage](http://mpathirage.com/fixing-macro-am_gconf_source_2-not-found-in-library-in-ubuntu/)

# Adding **add-apt-repository**

```
sudo apt-get install software-properties-common
```

# Clean install

## Some of my essential Packages

```
vim git-core
virtualbox virtualbox-guest-additions-iso 
ipython3-notebook ipython-notebook htop vim mercurial git ntpdate python3-pip geany geany-plugin-lua geany-plugin-prettyprinter geany-plugin-latex geany-plugin-spellcheck python-imaging rrdtool curl wget lynx zip unzip unrar-free nmap gnupg rsync rdiff-backup smartmontools tmux build-essential ca-certificates molly-guard sshfs chromium-browser vlc python-dev python-numpy munin-node python3-dev python3-numpy
```

## Additionals

firefox extensions

# Ignoring packages

To bar/ignore a package on apt, the tzdata package for example:

```
echo tzdata hold | sudo dpkg --set-selections
```

To "unhold" do:

```
echo tzdata install | sudo dpkg --set-selections
```

# Removing Kernels

Over time an awful lot of kernels gather in Debian or Ubuntu.

To remove these obsolete kernels do:

```
uname -a
dpkg -l |grep linux-
sudo apt-get remove --purge EXACT-OLD-KERNEL-NAME
sudo update-grub
```

:warning: Be careful not to remove the currently installed kernel!

# Remove broken packages

## Display them
```
sudo dpkg -l | grep "^iU"
```

## Remove them
```
sudo apt-get -f install
sudo apt-get remove --purge $(sudo dpkg -l | grep "^iU" | awk '{print $2}' | tr '\n' ' ')
```

# Remove residual packages (rc)

## Display them
```
sudo dpkg -l | grep "^rc"
```

## Remove them
```
sudo apt-get remove --purge $(sudo dpkg -l | grep "^rc" | awk '{print $2}' | tr '\n' ' ')
```


# postfix redirect


```
myhostname = myhost.local
alias_maps = hash:/etc/aliases
alias_database = hash:/etc/aliases
mydestination = myhost.local, myhost, localhost.local, localhost
relayhost = [172.16.100.118]
mynetworks = 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128
mailbox_command = procmail -a "$EXTENSION"
mailbox_size_limit = 0
recipient_delimiter = +
inet_interfaces = loopback-only
inet_protocols = all
masquerade_domains = myhost.local example.com
masquerade_classes = envelope_sender, envelope_recipient, header_sender, header_recipient
```

# sublime

## For Sublime-Text-2

```
sudo add-apt-repository ppa:webupd8team/sublime-text-2
sudo apt-get update
sudo apt-get install sublime-text
```

## For Sublime-Text-3

```
sudo add-apt-repository ppa:webupd8team/sublime-text-3
sudo apt-get update
sudo apt-get install sublime-text-installer
Source: https://gist.github.com/dantoncancella/4977978
```

# git
## Upgrade to more recent git

```
sudo apt-get remove git
sudo add-apt-repository ppa:git-core/ppa
sudo apt-get update
sudo apt-get install git
git --version
```
