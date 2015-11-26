# Introduction

This document outlines the steps to perform an Reinstall of FreeBSD and
maintain all your settings and data from the previous System.

## Requirements

* In-Depth Unix knowledge and specifically FreeBSD expertise.
* Internet
* subversion access to plumbum-ion-sysadmin
* Level 0 Dump
* Machine Info (pkg's, users, services etc...)


## Getting Started

First things first, you SHOULD have good level 0 dumps in order to do any
system level stuff.

In case something breaks, don't blame me. AND:

 '''PRINT THIS DOCUMENT, IT WILL BE EASIER, ALSO PRINT PKG_LIST AND SO ON!!!'''


* Do a detailed list of ALL used services and packages.
* Do a detailed list of ALL files that are valuable to you.
* Read /usr/src/UPDATING /usr/ports/UPDATING to see what changed and if any NEW things/steps have come up!

I will go through all of this with an example of upgrading my Laptop from:

'''6.2 to 7.0-STABLE'''

/home is always a good way to start of as it may contain stuff like

''apache/irc''

and the like. 

But first do a: 

```
du -sh /home/
```

Eeek mine is 50Gig so I have to clean up a bit.

Obviously I had movies and the like in my home so I had no other choice than to copy my stuff to a server

Once done I tar up everything to /dump, '''make sure it has enough space'''

```
 mkdir /dump
 hostname > /dump/hostname.txt
 tar Lcfvpj /dump/home.tbz /home/
 #/etc is always good to backup aswell
 tar cfvpj /dump/etc.tbz /etc/
 #/usr/local/etc too
 tar cfvpj /dump/local-etc.tbz /usr/local/etc/
```

Take a look into  /usr/local and see what is to be backed up there:

```
 ls -la /usr/local |grep -v bin |grep -v share |grep -v man |grep -v lib |grep -v include |grep -v info |grep -v etc |grep -v include |grep -v src
 for a in `ls -b /usr/local |grep -v bin |grep -v share |grep -v man |grep -v lib |grep -v include |grep -v info |grep -v etc |grep -v include |grep -v src`; do tar cfvpj /dump/usr-local-$a.tbz /usr/local/$a; done
```

now that's already quite a bunch. BUT as we all know we sometimes make
mistakes and I tend to put '''too much stuff into /tmp''' , so

```
ls -la /tmp 
```
and see if anything valuable is still in there. (on Solaris this is done for you on each reboot on some other unices probably too)

pkg_info tells you the stat of each package that is installed via ports/pkg's

```
 pkg_version |awk {'print $1'} |sort |uniq | grep -v -e autoconf -e docbook -e automake -e ORBit -e aalib, -e atk, -e automake -e bison -e bonobo -e coreutils -e gconf > /dump/INSTALLED.pkg
```

This will give you an exact list of all the package base names that are
installed. It will be easier for later importing. The command will take a
while due to the fact that it checks the version on every package.

In that file we have to clean up the doubles and take out evident dependency
packages in mine I removed the following:

```
-e lib*, -e p5-*, -e py*, -e xorg*, -e gcc
autoconf, docbook, automake, ORBit, aalib, atk, automake, bison, bonobo, coreutils, lib*, p5-*, py*, xorg*, gcc, gconf
```

and a bunch of other stuff that
is not needed during initial install.

Now to the kernel SOURCE, /usr/src should be backed up if you have done any
hacks to it and the least should be your KERNCONF.

Careful: i386 for Std. Intels amd64 for the other or any other supported Arch.

```
mkdir /dump/src-conf && cp /usr/src/sys/`uname -m`/conf/* /dump/src-conf
```

/var is also good to keep if you need any old logs or the like, other parts of
the Filesystem should be kept aswell but that depends on your custom config.

```
du -sh /var
```

Bare in mind this includes lib/mysql and is not recommended to be backed up in an "hot" state.

```
tar cfvpj /dump/var.tbz /var/
```

/root is to be backed up too.

```
tar cfvpj /dump/root.tbz /root/
```

CryptedFS mounts should be kept aswell. Usually they reside in the users homedir.
Other things like certs or external confs should be kept too.

/usr is a good one to forget, on FreeBSD quite a bit goes into it. If you
installed apache out of the box and used it make sure /usr/local/www is backed up.


Now for the actual migration:

Examine /etc/make.conf

Typically you want to copy CFLAGS and NO_PROFILE

Once you build the world some of our customizations will be lost and we need
to redo some stuff:

qmail (mailer.conf qmail-enable etc)
vim
sshd-localhost
ssh tweaks
portsnap in /etc/daily.local
/etc/profile

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
