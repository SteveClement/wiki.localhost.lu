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