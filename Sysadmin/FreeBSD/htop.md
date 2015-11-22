# Installing htop on FreeBSD

To install htop you need to enable linux compatibility and install linux base.

## Quick start

```
echo 'linux_enable="YES"' >> /etc/rc.conf
kldload linux
echo 'linproc /compat/linux/proc linprocfs rw 0 0' >> /etc/fstab
cd /usr/ports/emulators/linux_base-f10 && make install clean
mount linproc
cd /usr/ports/sysutils/htop && make install clean
```