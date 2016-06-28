# Introduction

This document outlines the steps to perform an MAJOR upgrade from FreeBSD versions.

## Requirements

 * In-Depth Unix knowledge and specifically FreeBSD expertise.
 * Internet
 * access to the localhost.lu tools
 * Level 0 Dump
 * Machine Info (pkg's, users, services etc...)
 * READ /usr/src/UPDATING !!!


## Getting Started

First things first, you SHOULD have good level 0 dumps in order to do an new
world thing.

In case something breaks, don't blame me. AND:

 PRINT THIS DOCUMENT, IT WILL BE EASIER, ALSO PRINT PKG_LIST AND SO ON!!!

NOW Open the Backup Document to take Snapshot of your data.


Do a detailed list of ALL used services and packages.
Do a detailed list of ALL files that are valuable to you.
Read /usr/src/UPDATING to see what changed and if any NEW things/steps have
come up!

I will go through all of this with an example of upgrading my Laptop from:

8.0-RELEASE to 9.0-CURRENT (aka. HEAD)

But bare in mind the best thing is always to: Backup your data reinstall the machine.
Not convenient but most safe.
Also don't forget to read: /usr/src/UPDATING and /usr/ports/UPDATING

/home is always a good way to start of as it may contain stuff like
apache/irc and the like. But first do a: du -sh /home/

Eeek mine is 21Gig so I have to clean up a bit.

Once done I tar up everything to /dump make sure it has enough space

python packages...

/usr/local/lib/python2.5/site-packages
OR
/usr/local/lib/python2.6/site-packages
OR any other newer version (2.7/3.3/3.4/3.5

```
 mkdir /dump
 uname -a > /dump/uname.all
 hostname > /dump/hostname.txt
 pkg info  > /dump/pkg_info.txt
 tar cfvpj /dump/root.tbz /root/
 tar cfvpj /dump/tmp.tbz /tmp/
 tar cfvpj /dump/py27-site-packages.tbz /usr/local/lib/python2.7/site-packages/
 tar cfvpj /dump/py33-site-packages.tbz /usr/local/lib/python3.3/site-packages/
 tar cfvpj /dump/py34-site-packages.tbz /usr/local/lib/python3.4/site-packages/
 tar --exclude var/db/portsnap/files/* -c -v -p -j -f /dump/var.tbz /var/
# /etc is always good to backup aswell
 tar cfvpj /dump/etc.tbz /etc/
# /usr/local/etc too
 tar cfvpj /dump/local-etc.tbz /usr/local/etc/
 tar cfvpj /dump/local-www.tbz /usr/local/www/

 tar cfvpj /dump/home.tbz /home/
 mkdir /dump/packages ; cd /dump/packages/

 crontab -l > /dump/crontab.txt

 pkg_info | cut -f1 -d" " | xargs -n 1 pkg_create -j -b
```

Take a look into  /usr/local and see what is to be backed up there:

```
ls -la /usr/local |grep -v bin |grep -v share |grep -v man |grep -v lib |grep -v include |grep -v info |grep -v etc |grep -v include |grep -v src

for a in `ls -b /usr/local |grep -v bin |grep -v share |grep -v man |grep -v lib |grep -v include |grep -v info |grep -v etc |grep -v include |grep -v src`; do tar cfvpj /dump/usr-local-$a.tbz /usr/local/$a; done
```

now that's already quite a bunch. BUT as we all know we sometimes make
mistakes and I tend to put too much stuff into /tmp , so ls -la /tmp and see
if anything valuable is still in there. (on Solaris this is done for you on
each reboot on some other unices too)

pkg info tells you the stat of each package that is installed via ports/pkg's

pkg version |awk {'print $1'} > /dump/INSTALLED.pkg

This will give you an exact list of all the package base names that are
installed. It will be easier for later importing. The command will take a
while due to the fact that it checks the version on every package.

In that file we have to clean up the doubles and take out evident dependency
packages in mine I removed the following:
autoconf, docbook, automake, ORBit, aalib, atk, automake, bison, bonobo,
coreutils, lib*, p5-*, py*, xorg*, gcc, gconf, and a bunch of other stuff that
is not needed during initial install.

Now to the kernel SOURCE, /usr/src should be backed up if you have done any
hacks to it and the least should be your KERNCONF.

Careful: i386 for Std. Intels amd64 for the other or any other supported Arch.

```
mkdir /dump/src-conf && cp /usr/src/sys/i386/conf/* /dump/src-conf
```

/var is also good to keep if you need any old logs or the like, other parts of
the Filesystem should be kept aswell but that depends on your custom config.


CryptedFS mounts should be kept aswell. Usually they reside in the users
homedir.
Other things like certs or external confs should be kept too.

/usr is a good one to forget, on FreeBSD quite a bit goes into it. If you
installed apache out of the box and used it make sure /usr/local/www is backed
up.

Now for the actual migration:

Make sure /usr/src/ is at the level you want it to be!

```
 cd /usr/src
 make buildworld
 make buildkernel
 make installkernel
 reboot (single user mode)

uname -a (to make sure the booted kernel is the FreeBSD version you want)
```


## Examine /etc/make.conf

Typically you want to copy CFLAGS and NO_PROFILE

```
 cd /usr/src
 mergemaster -p (when prompted to delete /var/tmp/temproot say NO)
 reboot ; boot -s
 fsck -p
 mount -u /
 mount -a -t ufs
 swapon -a
 adjkerntz -i
 cd /usr/src
 make installworld
 mergemaster
 reboot
```

Once you build the world some of our customizations will be lost and we need
to redo some stuff:

- qmail (mailer.conf qmail-enable etc)
- vim
- sshd-localhost
- ssh tweaks
- portsnap in /etc/daily.local
- /etc/profile

OPTIONAL_MANPATH /var/qmail/man
# added by use.perl 2006-06-22 18:21:08
OPTIONAL_MANPATH       /usr/local/lib/perl5/5.8.8/man
OPTIONAL_MANPATH       /usr/local/lib/perl5/5.8.8/perl/man

```
 cp /etc/cvsupfile-6_0 /etc/cvsupfile-6_2
 vi /etc/daily.local
 vi /etc/make.conf
 diff -u ../src-31072007/sys/i386/conf/GENERIC sys/i386/conf/GENERIC |less
 diff -u ../src-31072007/sys/i386/conf/GENERIC ../src-31072007/sys/i386/conf/CRLA-VPN-SERVER
 if no diff between old-gen and old-conf:
 cp sys/i386/conf/GENERIC sys/i386/conf/CRLA-VPN-SERVER
 make kernel
```
