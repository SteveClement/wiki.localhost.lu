To upgrade to the stable release the announce document has an upgrade section:

 https://www.freebsd.org/releases/12.1R/announce.html

# Upgrading from 11.2-RELEASE to 12.0-RELEASE

```
root@dot60:~ # freebsd-update -r 12.0-RELEASE upgrade
Looking up update.FreeBSD.org mirrors... 3 mirrors found.
Fetching metadata signature for 11.2-RELEASE from update4.freebsd.org... done.
Fetching metadata index... done.
Fetching 1 metadata patches. done.
Applying metadata patches... done.
Inspecting system... done.

The following components of FreeBSD seem to be installed:
kernel/generic kernel/generic-dbg src/src world/base world/lib32

The following components of FreeBSD do not seem to be installed:
world/base-dbg world/doc world/lib32-dbg

Does this look reasonable (y/n)? y

Fetching metadata signature for 12.0-RELEASE from update6.freebsd.org... done.
Fetching metadata index... done.
Fetching 1 metadata patches. done.
Applying metadata patches... done.
Fetching 1 metadata files... done.
Inspecting system... done.
Fetching files from 11.2-RELEASE for merging... done.
Preparing to download files... done.
Fetching 41823 patches.....10....20....30....40....50....60....70....80....90....100....110....120....130....140....150....160....170....180....190....200....210....220....230....240....250....260....270....280....290....300....310....320....330....340....350....360....370....380....390....400....410....420....430....440....450....460....470....480....490....500....510....520....530....540....550....560....570....580....590....600....610....620....630....640....650....660....670....680....690....700....710....720....730....740....750....760....770....780....790....800....810....820....830....840....850....860....870....880....890....900....910....920....930....940....950....960....970....980....990.
---8<---
....47890....47900....47910....47920....47930....47940....47950....47960....47970....47980....47990....48000....48010....48020....48030....48040....48050....48060....48070....48080....48090....48100....48110....48120....48130....48140....48150....48160....48170....48180....48190....48200....48210....48220....48230....48240....48250....48260....48270....48280....48290....48300....48310....48320....48330....48340....48350....48360....48370....48380....48390....48400....48410....48420....48430....48440....48450....48460....48470....48480....48490....48500....48510.. done.
Applying patches... done.
Fetching 3566 files... done.
Attempting to automatically merge changes in files... done.
…
```

Fix whatever issues yielded above.

```
To install the downloaded upgrades, run "/usr/sbin/freebsd-update install".
root@dot60:~ # freebsd-update install
Installing updates...
ernel updates have been installed.  Please reboot and run
"/usr/sbin/freebsd-update install" again to finish installing updates.
```




# Upgrading from 10.3-RELEASE to 11.0-RELEASE

```
tart ~ # uname -a
FreeBSD tart 10.3-RELEASE-p18 FreeBSD 10.3-RELEASE-p18 #0: Tue Jul 28 11:41:12 UTC 2015     root@amd64-builder.daemonology.net:/usr/obj/usr/src/sys/GENERIC  i386
tart ~ # freebsd-update -r 11.0-RELEASE upgrade
Looking up update.FreeBSD.org mirrors... 4 mirrors found.
Fetching metadata signature for 10.3-RELEASE from update4.freebsd.org... done.
Fetching metadata index... done.
Fetching 1 metadata patches. done.
Applying metadata patches... done.
Inspecting system... done.

The following components of FreeBSD seem to be installed:
kernel/generic src/src world/base world/doc world/games

The following components of FreeBSD do not seem to be installed:

Does this look reasonable (y/n)? y

Fetching metadata signature for 11.0-RELEASE from update4.freebsd.org... done.
Fetching metadata index... done.
Fetching 1 metadata patches. done.
Applying metadata patches... done.
Fetching 1 metadata files... done.
Inspecting system... done.
Fetching files from 10.3-RELEASE for merging... done.
Preparing to download files... done.
Fetching 44043 patches.....10....20....30....40....50....60....70....80....90....100....110....120....130....140....150....160....170....180....190....200....210....220....230....240....250....260....270....280....290....300....310....320....330....340....350....360....370....380....390....400....410....420....
---8<---
....13890....13900....13910....13920....13930....13940....13950....13960....13970....13980....13990....14000....14010....14020....14030....14040....14050....44040. done.
Applying patches... done.
Fetching 12882 files... done.
Attempting to automatically merge changes in files... done.

The following file could not be merged automatically: /etc/mail/mailer.conf
Press Enter to edit this file in vim and resolve the conflicts
manually...
…
```

Merge conflicts et al.

```
freebsd-update install
Installing updates...
```

```
cd /usr/src && make kernel
```


# Upgrading from 9.1-RELEASE to 9.2-RELEASE

```
 # freebsd-update -r 9.2-RELEASE upgrade
…

WARNING: This system is running a "aggli" kernel, which is not a
kernel configuration distributed as part of FreeBSD 9.2-RELEASE.
This kernel will not be updated: you MUST update the kernel manually
before running "/usr/sbin/freebsd-update install".

So do as the man says: cd /usr/src && make kernel

…
 # freebsd-update install
 # reboot
 # freebsd-update install
```

The system must be rebooted with the newly installed kernel before continuing.

:warning: And this is where it begins to be important!

If you reboot and you are STILL running 9.1 DO NOT PROCEED!

re-compile a new 9.2 Kernel.


# Upgrading from 8.2-RELEASE to 9.0-RELEASE

```
 # freebsd-update -r 9.0-RELEASE upgrade
...

WARNING: This system is running a "aggli" kernel, which is not a
kernel configuration distributed as part of FreeBSD 8.2-RELEASE.
This kernel will not be updated: you MUST update the kernel manually
before running "/usr/sbin/freebsd-update install".

So do as the man says: cd /usr/src && make kernel

...
 # freebsd-update install
 # reboot
```

The system must be rebooted with the newly installed kernel before continuing.

:warning: And this is where it begins to be important! 

If you reboot and you are STILL running 8.2 DO NOT PROCEED!

re-compile a new 9.0 Kernel.

By default FreeBSD compiles ALL modules. To persuade it to NOT compile certain modules add this to /etc/make.conf

```
 WITHOUT_MODULES = linux sound ntfs zfs
```

This will omit the "linux sound ntfs zfs" modules during a Kernel build.

And to be 100% sure you will reboot the right kernel check the timestamp

```
 # date
 Sun May  9 22:02:14 CEST 2010
 # ls -la /boot/kernel/kernel            
 -r-xr-xr-x  1 root  wheel  4648089 May  9 22:01 /boot/kernel/kernel
```





To upgrade to the stable release the announce document has an upgrade section:

 http://www.freebsd.org/releases/9.0R/announce.html


# Upgrading from 7.2-RELEASE to 8.0-RELEASE

I had massive problems with that upgrade and advise everyone to be very careful at the following.

```
 # freebsd-update -r 8.0-RELEASE upgrade
 # freebsd-update install
 # reboot
```

The system must be rebooted with the newly installed kernel before continuing.

:warning: And this is where it begins to be important! 

If you reboot and you are STILL running 7.2 DO NOT PROCEED!

What I had to do is re-compile a new 8.0 Kernel.
When trying this I had problems with the zfs module.
By default FreeBSD compiles ALL modules. To persuade it to NOT compile certain modules add this to /etc/make.conf

```
 WITHOUT_MODULES = linux sound ntfs zfs
```

This will omit the "linux sound ntfs zfs" modules during a Kernel build.

And to be 100% sure you will reboot the right kernel check the timestamp

```
 # date
 Sun May  9 22:02:14 CEST 2010
 # ls -la /boot/kernel/kernel            
 -r-xr-xr-x  1 root  wheel  4648089 May  9 22:01 /boot/kernel/kernel
```


# Upgrading to BETA

```
eight# freebsd-update -r 8.0-BETA4 upgrade
Looking up update.FreeBSD.org mirrors... 3 mirrors found.
Fetching metadata signature for 8.0-BETA2 from update5.FreeBSD.org... done.
Fetching metadata index... done.
Fetching 1 metadata files... done.
Inspecting system... done.

The following components of FreeBSD seem to be installed:
kernel/generic world/base world/dict world/doc world/games world/info
world/manpages

The following components of FreeBSD do not seem to be installed:
src/base src/bin src/cddl src/contrib src/crypto src/etc src/games
src/gnu src/include src/krb5 src/lib src/libexec src/release src/rescue
src/sbin src/secure src/share src/sys src/tools src/ubin src/usbin
world/catpages world/proflibs

Does this look reasonable (y/n)? y

              
Fetching metadata signature for 8.0-BETA4 from update5.FreeBSD.org... done.
Fetching metadata index... done.
Fetching 1 metadata patches. done.
Applying metadata patches... done.
Fetching 1 metadata files... done.
Inspecting system... done.
Fetching files from 8.0-BETA2 for merging... done.
Preparing to download files... done.
Fetching 7952 patches.....10....20....30....40....50....60....70....80....90....100...............7950. done.
Applying patches... done.
Fetching 137 files... done.
Attempting to automatically merge changes in files... done.


The following changes, which occurred between FreeBSD 8.0-BETA2 and
FreeBSD 8.0-BETA4 have been merged into /etc/group:
--- current version
+++ new version
@@ -1,6 +1,6 @@
-# $FreeBSD: src/etc/group,v 1.35 2007/06/11 18:36:39 ceri Exp $
+# $FreeBSD: src/etc/group,v 1.35.10.1 2009/08/03 08:13:06 kensmith Exp $
 #
 wheel:*:0:root,steve
 daemon:*:1:
 kmem:*:2:
 sys:*:3:
Does this look reasonable (y/n)? y

The following changes, which occurred between FreeBSD 8.0-BETA2 and
FreeBSD 8.0-BETA4 have been merged into /etc/master.passwd:
--- current version
+++ new version
@@ -1,6 +1,6 @@
-# $FreeBSD: src/etc/master.passwd,v 1.40 2005/06/06 20:19:56 brooks Exp $
+# $FreeBSD: src/etc/master.passwd,v 1.40.22.1 2009/08/03 08:13:06 kensmith Exp $
 #
 root:$1$Jso2G5aC$cyVVolqIiIk5qAtVvMPsI1:0:0::0:0:Charlie &:/root:/bin/csh
 toor:*:0:0::0:0:Bourne-again Superuser:/root:
 daemon:*:1:1::0:0:Owner of many system processes:/root:/usr/sbin/nologin
 operator:*:2:5::0:0:System &:/:/usr/sbin/nologin
Does this look reasonable (y/n)? y

The following changes, which occurred between FreeBSD 8.0-BETA2 and
FreeBSD 8.0-BETA4 have been merged into /etc/passwd:
--- current version
+++ new version
@@ -1,6 +1,6 @@
-# $FreeBSD: src/etc/master.passwd,v 1.40 2005/06/06 20:19:56 brooks Exp $
+# $FreeBSD: src/etc/master.passwd,v 1.40.22.1 2009/08/03 08:13:06 kensmith Exp $
 #
 root:*:0:0:Charlie &:/root:/bin/csh
 toor:*:0:0:Bourne-again Superuser:/root:
 daemon:*:1:1:Owner of many system processes:/root:/usr/sbin/nologin
 operator:*:2:5:System &:/:/usr/sbin/nologin
Does this look reasonable (y/n)? y

The following files will be removed as part of updating to 8.0-BETA4-p0:
/etc/pam.d/gdm
/lib/libalias.so.6
/lib/libavl.so.1
/lib/libbegemot.so.3
/lib/libbsdxml.so.3
/lib/libbsnmp.so.4
/lib/libcam.so.4
/lib/libcrypt.so.4
/lib/libcrypto.so.5
/lib/libctf.so.1
/lib/libdevstat.so.6
/lib/libdtrace.so.1
/lib/libedit.so.6
/lib/libgeom.so.4
/lib/libipsec.so.3
/lib/libipx.so.4
/lib/libkiconv.so.3
/lib/libkvm.so.4
/lib/libmd.so.4
/lib/libncurses.so.7
/lib/libncursesw.so.7
/lib/libnvpair.so.1
/lib/libpcap.so.6
/lib/libreadline.so.7
/lib/libsbuf.so.4

The following files will be updated as part of updating to 8.0-BETA4-p0:

/.cshrc
/.profile
/COPYRIGHT
/bin/[
/bin/cat
/bin/chflags
/bin/chio
/bin/chmod
/bin/cp
/bin/csh
/bin/date
/bin/dd
/bin/df
/bin/domainname
/bin/echo
/bin/ed
/bin/expr
/bin/getfacl
/bin/hostname
/bin/kenv
/bin/kill
/bin/link
/bin/ln
/bin/ls
/bin/mkdir
...
eight# 

# freebsd-update install
# shutdown -r now
# freebsd-update install
# shutdown -r now
```
