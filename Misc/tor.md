# Tor Nodes

| Hostname             | Nickname         | AccessLine               | Type   |
| -------------------- | ---------------- | ------------------------ | ------ |
| tor.localhost.lu     |HelpCensoredOnes  |tor.localhost.lu:9001     | exit   |
| ector.localhost.lu   |HelpCensoredOnes2 |ector.localhost.lu:9001   | bridge |
| HomeMer.localhost.lu |HelpCensoredOnes3 |HomeMer.localhost.lu:9001 | NaN    |
| HomeStr.localhost.lu |HelpCensoredOnes5 |HomeStr.localhost.lu:9001 | NaN    |
| mobdsl1.localhost.lu |HelpCensoredOnesX |mobdsl1.localhost.lu:9001 | NaN    |
| mobdsl2.localhost.lu |HelpCensoredOnes7 |mobdsl2.localhost.lu:9001 | NaN    |

# Tor configs
## Bridge relay example

```
Nickname HelpCensoredOnes
HashedControlPassword 16:GENERATED_YOUR_OWN
ContactInfo yourContact at example dot com
MyFamily HelpCensoredOnes3, HelpCensoredOnes5

NumCPUs 1

ControlListenAddress 127.0.0.1
ControlPort 9051

ORPort 9001

DirListenAddress <PUBLIC_IP>
DirPort 9030
DirPortFrontPage /usr/share/doc/tor/tor-exit-notice.html

Log notice stdout

RelayBandwidthBurst 10MB
RelayBandwidthRate 5MB
BandwidthRate 40MB
BandwidthBurst 80MB
MaxAdvertisedBandwidth 100MB

SocksPort 0

AccountingMax 1TB
AccountingStart day 0:00

BridgeRelay 1
PublishServerDescriptor bridge
ExitPolicy reject *:*
```

## Exit Node example

```
Nickname HelpCensoredOnes
HashedControlPassword 16:GENERATED_YOUR_OWN
ContactInfo yourContact at example dot com

NumCPUs 1

ControlListenAddress 127.0.0.1
ControlPort 9051
ORPort 9001
DirListenAddress <PUBLIC_IP>
DirPort 9030
DirPortFrontPage /usr/share/doc/tor/tor-exit-notice.html

Log notice stdout

RelayBandwidthBurst 10MB
RelayBandwidthRate 5MB
BandwidthRate 40MB
BandwidthBurst 80MB
MaxAdvertisedBandwidth 100MB

SocksPort 0

AccountingMax 1TB
AccountingStart day 0:00

BridgeRelay 0
PublishServerDescriptor 1
ExitPolicy reject       *:25
ExitPolicy reject       *:119
ExitPolicy reject       *:135-139
ExitPolicy reject       *:445
ExitPolicy reject       *:465
ExitPolicy reject       *:587
ExitPolicy reject       *:1214
ExitPolicy reject       *:4661-4666
ExitPolicy reject       *:6346-6429
ExitPolicy reject       *:6699
ExitPolicy reject       *:6881-6999
ExitPolicy accept       *:*
```


# Client Installation

## Ubuntu

 * https://help.ubuntu.com/community/Tor

## iOS

 * http://sid77.slackware.it/iphone/

## Gentoo

 * http://gentoo-wiki.com/HOWTO_Anonymity_with_Tor_and_Privoxy

## Debian

 * http://www.debian-administration.org/articles/123


# References

 * http://wiki.chaostreff.ch/Onion_Routing_und_Tor


# OpenBSD Chroot

[[TOC]]
 * Copyright (c) 2005 tyranix
 * Distributed under the X11 license
 * See [wiki:doc/LegalStuff LegalStuff] for a full text

NEWS: There is now an '''UNSTABLE''' script to automate almost all of these steps. See [wiki:/TheOnionRouter/OpenbsdChrootedTorScript Script].
The script works with the latest tor alphas on OpenBSD 3.8.

A tutorial for setting up a Tor client on OpenBSD in a chroot. At the end, there are instructions for running the Tor client in a chroot and using a systrace policy.
These instructions describe both static and dynamic linked versions with a section to help you decide which you should use.

The table of contents makes this tutorial look long but each section is short. These are complete instructions for how to do the entire operation from downloading, building, and starting Tor.

## Assumptions

 * You are installing '''Tor'''
 * You are running '''OpenBSD 5.1'''
 * You want to install the files to run into '''/home/chrooted/tor'''
 * You do not want syslog entries from tor messages because if Tor misbehaves, you want it to affect the system as little as possible
 * You will use '''ksh''' as the shell for both your user account and root in these examples (nothing permanent).
 * You have a normal user who will do the build process called '''youruser''' who belongs to '''yourgroup'''.

Make adjustments accordingly if your setup differs.

These instructions are based on [http://pestilenz.org/~bauerm/tor-openbsd-howto.html] with some changes. Note that baurem's version can be used for a client or server while these instructions are (currently) only for a client.
It also includes a few parts from [wiki:/TheOnionRouter/TorInChroot|TorInChroot]. The rest is new.

If you are using the unstable branch then you will want to install a newer version of libevent. The libevent included with OpenBSD is very old and said to contain bugs/problems.

This tutorial is setup so that the root and non-root commands are clearly identified. It tries to do as much in non-root mode as possible.

----------

# Commands as root or sudo

### Create initial chroot area

I use "/home/chrooted" so other applications can be located in subdirectories.
I setup the directory for a user to install into.
There could easily be an exploit in the Makefile so I don't build anything
as root. We will fix the permissions later.

```
su - root
ksh
mkdir -p /home/chrooted/tor/{dev,etc,usr/lib,usr/libexec,var/lib/tor,var/log/tor}
chmod -R 0700 /home/chrooted
chown -R youruser:yourgroup /home/chrooted
```

### Optional: Turn on encrypted swap

Encrypting pages that go to swap is very easy in OpenBSD. Simply edit
`/etc/sysctl.conf` and uncomment this line
```
#vm.swapencrypt.swap=1 # 1=Encrypt pages that go to swap.
```
and it will take affect the next time you reboot.

Or you can enable it interactively with `sysctl -w vm.swapencrypt.enable=1`

## Install other needed packages

### From the ports system

Install gpg which is necessary so you can verify the Tor package signature.
Install gmake which is necessary for the Tor compilation.
Install privoxy which is needed to clean HTTP traffic.
Install dante to access IRC with irssi (use anywhere you would use tsocks).
```
cd /usr/ports/security/gnupg2 && make install clean
cd /usr/ports/devel/gmake && make install clean
cd /usr/ports/www/privoxy && make install clean
cd /usr/ports/security/dante && make install clean
cd /usr/ports/net/wget && make install clean
```

### Or from the FTP pre-built packages

Or install the package from the FTP. These are the current versions. You may want to login to the FTP and verify these are the latest. Also note that the ports system may have updated versions that are not built into packages yet. You'll also need the dependencies for these files.
```
pkg_add -v ftp://ftp.openbsd.org/pub/OpenBSD/5.1/packages/i386/ \
 {gmake-3.80p0,gnupg-1.4.1,privoxy-3.0.3p0,dante-1.1.15p0}.tgz
```

== Add a _tor user to chroot to ==

Note: Do '''NOT''' use -L daemon because that is meant for root only! It is more free than you want a user to be, despite the misleading name.

This will be entered into the system database. We will later make a copy for the chrooted version.
```
groupadd _tor
useradd -g _tor -d /nonexistent -c "tor anonymizer" -s /sbin/nologin _tor
```

## Create a virtual filesystem for devices

Note: This part is from the [wiki:/TheOnionRouter/TorInChroot TorInChroot] wiki page.

Creates a virtual file system so that you do not have to change your "/home" mount permissions.
```
# On flashrd installs use: vnd1c
cd /home/chrooted/tor
dd if=/dev/zero of=devfs bs=1024 count=256
vnconfig -c -v /dev/vnd0c devfs
newfs /dev/rvnd0c
mount -o nosuid,softdep /dev/vnd0c /home/chrooted/tor/dev
```
You can later release this device with `umount /home/chrooted/tor/dev` and then
`vnconfig -u /dev/vnd0c` You can double check it is removed with
`vnconfig -l`

## Add necessary devices

You want to have "*random", "stdin", "stdout", "stderr", "null", and "zero".
You should remove all others.
```
cd /home/chrooted/tor/dev
sh /dev/MAKEDEV random
sh /dev/MAKEDEV std
rm console drum klog kmem ksyms mem tty xf86
```

----------

# Commands as a normal user

== Create temporary build space ==

For all commands, you should use ksh.

Assumed that your username is the creative '''youruser'''.
```
su - youruser
ksh
mkdir /home/youruser/tmp
cd /home/youruser/tmp
```

== Download the source code and GPG signature ==

```
wget http://www.torproject.org/dist/tor-VERSION.tar.gz{.asc,}
# https://www.torproject.org/dist/tor-0.2.2.35.tar.gz{.asc}
# https://www.torproject.org/dist/tor-0.2.3.15-alpha.tar.gz{.asc}
```

## Verify the file

```
gpg --verify tor-VERSION.tar.gz{.asc,}
```

### If you cannot verify it

If this reports "Can't check signature: public key not found" then you need to get the key from a keyserver.

This should present you with a list of keys. In this case, only one from the developer Roger Dingledine. Enter '1' when the list appears and it will download the key into your keyring.

This makes an outgoing connection to port 11371 so make sure your firewall is setup properly.
```
gpg --keyserver subkeys.pgp.net --search-keys 0x28988BF5
```

### Retry verifying it

Now you can verify the download. If all is well, it will say
Good signature from ...
```
gpg --verify tor-VERSION.tar.gz{.asc,}
```

## Compiling and installing Tor

### Option 1: Build the static linked executable

Tell configure that you will install it in /. You will actually install the files into /home/chrooted/tor but Tor uses this prefix internally. If you said the prefix is /tor, then it will look for /tor/etc/tor/torrc and so on.

Also, build a static binary so we don't have to copy dynamic libraries to the chrooted area.
```
tar -zxvf tor-VERSION.tar.gz
cd tor-0.0.9.5
env CFLAGS=-static ./configure --prefix=/
```

=== Option 2: Build the dynamically linked executable ===

You can do the normal dynamic linking if you desire. In this case, you have to copy over more system files to the chrooted area.

However, it would make more sense to use this approach if you have lots of different programs in the directory `/home/chrooted/$PROGNAME`. When you update the libraries for a bug fix, you could just copy in the new libraries instead of rebuilding all of the executables.

With static linking, you would have to rebuild each executable in order for library changes to happen.

```
tar -zxvf tor-VERSION.tar.gz
cd tor-VERSION
./configure --prefix=/
```

You will need to build the tor executable (this will '''not''' install it anywhere) so you can find out which libraries you need to move.
```
gmake
ldd src/or/tor
```

#### Find the system libraries

The ldd output will look like this:
```
src/or/tor:
tor:
        Start    End      Type Ref Name
        00000000 00000000 exe   1  src/or/tor
        0a5d6000 2a5de000 rlib  1  /usr/lib/libz.so.4.0
        0d51e000 2d529000 rlib  1  /usr/lib/libssl.so.9.0
        02fcc000 22ffc000 rlib  1  /usr/lib/libcrypto.so.11.0
        0216b000 221a2000 rlib  1  /usr/lib/libc.so.34.2
        0ed2c000 0ed2c000 rtld  1  /usr/libexec/ld.so
```

This tells you that tor uses libz, libssl, libcrypto, and libc all of which you will need to copy to the chrooted area. You also need to copy ld.so.

#### Copy the system libraries to chrooted area

Remember this has to be available to tor when you chroot into the directory `/home/chrooted/tor` so we will need to copy these shared libraries into `/home/chrooted/tor/usr/lib/`.

```
cp /usr/lib/lib{z,ssl,crypto,c}.so.* /home/chrooted/tor/usr/lib/
cp /usr/libexec/ld.so /home/chrooted/tor/usr/libexec
```

=== Install it into /home/chrooted/tor ===

Build and install it into /home/chrooted/tor. If you forget DESTDIR, then it will fail to install because the prefix is set to '/'. This is good because if you were using sudo/root and forgot it, it would install in the system "/etc", "/var" and so on.
```
gmake DESTDIR=/home/chrooted/tor install
```

== Create password databases for chroot ==

Make a copy of "master.passwd" for tor. Use this method instead of using root and copying parts. That way you avoid costly mistakes with your system version. The most a user can do is copy it.

The "master.passwd" file has extra fields (login class, password change time, and account expiration time) that we need to insert into the line.

'''NOTE''': This only works because you are not adding a user with a password.
If you have a user with a password, the sed expression is not enough. The master.passwd will contain the encrypted version of the password. However, when there is no password, a "*" is in both passwd and master.passwd.

### Create the template master.passwd file

```
cd /home/chrooted/tor/etc
grep "^_tor:" /etc/master.passwd | sed -e 's/:tor/::0:0:tor/' > newpasswd
```

### Create the password files (master.passwd, passwd, and dbs)

This will create master.passwd, spwd.db, pwd.db, and passwd from newpasswd.
The existing file newpasswd will be renamed to master.passwd. The fields we added with the above sed line will be removed so passwd is a 6th edition style password database.
```
pwd_mkdb -p -d /home/chrooted/tor/etc newpasswd
```

### Create a group file

Copy over the _tor group from the system's group file
```
grep "^_tor:" /etc/group > group
```

== Create a Tor config ==

Copy the sample to create a real config. Add lines that represent this setup.
```
cp tor/torrc.sample tor/torrc
cat <<EOF>> tor/torrc
User _tor
Group _tor
RunAsDaemon 1
EOF
```

You'll also need to make another change so that it doesn't use the user's home directory for the private data. Uncomment this line in the config `tor/torrc` so that it looks like this:
```
DataDirectory //var/lib/tor
```

## Copy other network files

Copy network files that are useful. Note: localtime is a symlink so we should copy what it points to with "-H".

```
cp -H /etc/{resolv.conf,hosts,localtime} /home/chrooted/tor/etc/
chmod 744 /home/chrooted/tor/etc/{resolv.conf,hosts}
```

----------

# More commands as root

## Fix permissions

With the above command, you'll notice there were errors because we executed it as a normal user. As root or with sudo, now set the proper permissions.
Basically, make the chrooted area owned by root except for a few locations tor needs to write to.

NOTE: I use full paths here because you are root/sudo and a typo is costly if I put `chown ... var` and you misread it `chown ... /var`
```
su - root
ksh
cd /home/chrooted/tor
chown -R root:wheel /home/chrooted/tor
chown root:_shadow /home/chrooted/tor/etc/spwd.db
chmod 0755 /home/chrooted/tor/{dev,etc,var} /home/chrooted/tor/var/{lib,log}
```

Only do this step if you are using the dynamically linked executable:
```
chmod -R 0755 /home/chrooted/tor/usr
chmod 0444 /home/chrooted/tor/usr/lib/*
chmod 0555 /home/chrooted/tor/usr/libexec/*
```

Don't allow anyone but root into "/home/chrooted"
```
chown root:wheel /home/chrooted
chmod 0700 /home/chrooted
```

But allow "_tor" when it is in a chroot environment.
```
chmod 0755 /home/chrooted/tor
```

A select few files and directories must be writable by the "_tor" user.
```
chown -R _tor:_tor /home/chrooted/tor/var/{log,lib}/tor
touch /home/chrooted/tor/etc/tor/dirservers
chown _tor:_tor /home/chrooted/tor/etc/tor/dirservers
```

## Start Tor

Start tor to see if it works
```
chroot -u _tor -g _tor /home/chrooted/tor /bin/tor -f /etc/tor/torrc
```

### If Tor fails

If you get permission denied, make sure that the entire search path is readable by the user from `/home/chrooted/tor` up to the filename.

If you are using the dynamic linked version and it returns with the message `Abort` it most likely means the libraries are not readable by tor. Check directory and file permissions from `/home/chrooted/tor` down to the specific library or ld.so.

== Configure Privoxy ==

Configure privoxy to forward everything through tor:
```
vi /etc/privoxy/config
```
search for the socks4a-forward section and add
```
forward-socks4a / localhost:9050 .
```

Unfortunately, privoxy has a default logging scheme that logs '''all'''
URLs you visit. Such a debugging flag should be turned off for tor.
Thanks arma for pointing this out.

In the section about debug, comment out this line so it looks like this:
```
#debug 1 # Do NOT show each GET/POST/CONNECT request.
```

You may also want to comment out the section that keeps a cache of all
the cookies.
```
# jarfile jarfile # Don't store cookies locally
```

### Optional: Edit your privoxy config again

As you will note, your user agent is not changed. Here is a quick and easy way to tell Privoxy to munge some of your headers.

Note: This makes all requests look like they came from the default install of lynx in OpenBSD.

```
cat <<EOF>> /etc/privoxy/user.action
{ +hide-referrer{block} +hide-forwarded-for-headers +hide-user-agent{Lynx/2.8.5rel.2 libwww-FM/2.14 SSL-MM/1.4.1 OpenSSL/0.9.7d} }
/
EOF
```

The items enclosed in `{ ... }` define an action and the second line defines where it applies. A "/" means for all sites.

## Start Privoxy

Start privoxy
```
/usr/local/sbin/privoxy
```

== Configure Lynx or other web browser ==

Configure your browser to use [http://localhost:8118/] as proxy for everything. For lynx, it's sufficient to set
```
export http_proxy="http://127.0.0.1:8118/"
```

=== Test out your configuration ===

You should be able to go to [http://www.junkbuster.com/cgi-bin/privacy] and your IP will be different than the one you normally see.

```
export http_proxy=http://127.0.0.1:8118/
lynx http://www.junkbuster.com/cgi-bin/privacy
```

## Edit your dante config

tsocks is a popular recommendation for Tor users but it doesn't compile cleanly for OpenBSD users. It's not in the ports but it is simple to compile after a few changes (mostly changing function prototypes and removing the dependency on libdl).

Instead of going through that, you can use dante. Since dante is in the ports tree, it is very easy to setup. Here is a config to let you use Tor from irssi:

```
route {
        from: 0.0.0.0/0   to: 0.0.0.0/0  via: 127.0.0.1  port = 9050
        proxyprotocol: socks_v4
}
```

Now you can execute:
```
socksify irssi
```

This is strictly for client connections. Although there is a dante server, I am not using it. Dante's client just sends requests to Tor.

## Optional: Use socat instead of dante

I now use socat instead of dante for most things. Socat is much nicer because you don't have to rely on the application logic to correctly connect to a server.

For instance, irssi will sometimes reconnect to an IRC server directly instead of using the proxy settings with dante. However, if you use socat, the choice is not up to irssi to make.

See the [wiki:/TheOnionRouter/TorifyHOWTO#socat Torify Socat] for more information on how to compile and use socat on OpenBSD.

== Optional: Force clients to use Tor ==

You can force clients to use Tor by removing their ability to normally contact services. For instance, irssi may reconnect without using socks. So let's setup PF to block such access in ```etc/pf.conf```:

```
# Change for your device mentioned in the rest of your firewall rules.
int_if = xl0

block in log quick on $int_if proto { tcp, udp } from any port { irc, 6667 } to any
block out log quick on $int_if proto { tcp, udp } from any to any port { irc, 6667 }
```

Now irssi will not be able to reconnect to any IRC server without using a proxy such as Tor. Note that the above is only a portion of the ```/etc/pf.conf``` file and you should definitely have other non-Tor related rules. Also IRC is technically assigned to port 194 but most servers listen on 6667.

## Edit /etc/rc.local to start both at boot

If it works, add startup code to /etc/rc.local. Tor should start first because Privoxy will forward to it:

NOTE: Privoxy does not accept `_privoxy:_privoxy` and it requires
`_privoxy._privoxy`
```

if [ -f /home/chrooted/tor/devfs -a -b /dev/svnd0c ]; then
     echo -n 'tordevfs: ';
     /usr/sbin/vnconfig -c -v /dev/svnd0c /home/chrooted/tor/devfs
     /sbin/mount -o softdep /dev/svnd0c /home/chrooted/tor/dev
fi

if [ -x /home/chrooted/tor/bin/tor ]; then
     echo -n 'tor: ';
     /usr/sbin/chroot -u _tor -g _tor /home/chrooted/tor /bin/tor -f /etc/tor/torrc
fi

if [ -x /usr/local/sbin/privoxy ]; then
    echo -n 'privoxy: ';
    /usr/local/sbin/privoxy --user _privoxy._privoxy /etc/privoxy/config
fi
```

## Using an unchrooted systrace with the chrooted Tor client

### Generating a policy

Here are example policies for a Tor client. Note: You will have to change the uid (1001) if that does not match your system.

First, here is how I got the base configuration:
```
su - root
ksh
systrace -A -t chroot -u _tor -g _tor /home/chrooted/tor /bin/tor -f /etc/tor/torrc
```

Then after using Tor for a while (including with privoxy), I shut down Tor:

```
ps awwux | grep _tor
kill # whatever pid
```

Now you will have systrace policy files in `/root/.systrace` under the names
`/root/.systrace/bin_tor` and `/root/systrace/usr_sbin_chroot`.

You will only have to modify the uid in `/root/systrace/usr_sbin_chroot` and the rest can stay the same.

For `/root/.systrace/bin_tor`, you will want to make the configuration more general.
For instance, the generated file will have an entry with connecting to a specific IP:port but you want to make it a wildcard match *:port. Otherwise, you would have to hardcode every value in.

### Example policies

Here are my example policies. These work fine for me using Tor as a client with requests to IRC and websites.

`/root/.systrace/bin_tor` contains:
```
Policy: /bin/tor, Emulation: native
        native-__sysctl: permit
        native-break: permit
# Memory
        native-mmap: permit
        native-mprotect: permit
        native-mquery: permit
        native-munmap: permit
# Files
        native-chdir: filename eq "/var/lib/tor" then permit
        native-close: permit
        native-dup2: permit
        native-fcntl: permit
        native-fstat: permit
        native-getdirentries: permit
        native-ioctl: permit
        native-lseek: permit
        native-pread: permit
        native-read: permit
        native-write: permit
# File reads
        native-fsread: filename match "/<non-existent filename>: *" then deny
        native-fsread: filename eq "/dev/crypto" then permit
        native-fsread: filename eq "/dev/null" then permit
        native-fsread: filename eq "/dev/srandom" then permit
        native-fsread: filename eq "/etc/group" then permit
        native-fsread: filename eq "/etc/pwd.db" then permit
        native-fsread: filename eq "/etc/spwd.db" then permit
        native-fsread: filename eq "/etc/tor/torrc" then permit
        native-fsread: filename eq "/etc/malloc.conf" then permit
        native-fsread: filename eq "/etc/localtime" then permit
        native-fsread: filename eq "/usr/lib" then permit
        native-fsread: filename match "/usr/lib/libc.so*" then permit
        native-fsread: filename match "/usr/lib/libcrypto.so*" then permit
        native-fsread: filename match "/usr/lib/libssl.so*" then permit
        native-fsread: filename match "/usr/lib/libz.so*" then permit
        native-fsread: filename eq "/usr/share/nls/C/libc.cat" then permit
        native-fsread: filename match "/usr/share/zoneinfo/*" then permit
        native-fsread: filename eq "/var/lib/tor" then permit
        native-fsread: filename match "/var/lib/tor/*" then permit
        native-fsread: filename eq "/var/log/tor" then permit
        native-fsread: filename match "/var/log/tor/*" then permit
# Time
        native-gettimeofday: permit
# User ID and group ID.  Change these as needed.
        native-getuid: permit
        native-setgid: gid eq "1001" then permit
        native-setuid: uid eq "1001" and uname eq "_tor" then permit
# Resource limits
        native-getrlimit: permit
        native-setrlimit: permit
# Process
        native-exit: permit
        native-fork: permit
        native-pipe: permit
# Permission bits
        native-getpid: permit
        native-geteuid: permit
        native-issetugid: permit
        native-setsid: permit
# Signals
        native-sigaction: permit
        native-sigprocmask: permit
        native-sigreturn: permit
# File writes
        native-fswrite: filename match "/<non-existent filename>: *" then deny
        native-fswrite: filename eq "/dev/crypto" then permit
        native-fswrite: filename eq "/dev/null" then permit
        native-fswrite: filename match "/var/log/tor/*" then permit
        native-fswrite: filename match "/var/lib/tor/*" then permit
        native-rename: filename match "/var/lib/tor/cached-directory*" and filename[1] match "/var/lib/tor/cached-directory*" then permit
# Networking
        native-bind: sockaddr eq "inet-[127.0.0.1]:9050" then permit
        native-socket: sockdom eq "AF_INET" and socktype eq "SOCK_STREAM" then permit
        native-socket: sockdom eq "AF_UNIX" and socktype eq "SOCK_DGRAM" then permit
        native-setsockopt: permit
        native-listen: permit
        native-poll: permit
        native-getsockopt: permit
        native-accept: permit
        native-recvfrom: permit
        native-sendto: true then permit
# Without socketpair, you cannot access Tor hidden services.
        native-socketpair: permit
# List of ports to connect to.  These are needed for the server list and potentially
# using a tor server.
        native-connect: sockaddr match "inet-*:80" then permit
        native-connect: sockaddr match "inet-*:443" then permit
# Typically, tor servers are in the range of 8,000 - 10,000.  This below lets tor
# connect to any unpriv port.
# Match ports 1024 through 1999
        native-connect: sockaddr re "inet-.*:102[4-9]$" then permit
        native-connect: sockaddr re "inet-.*:10[3-9][0-9]$" then permit
        native-connect: sockaddr re "inet-.*:1[1-9][0-9]{2}$" then permit
# Match 2000 - 9999
        native-connect: sockaddr re "inet-.*:[2-9][0-9]{3}$" then permit
# Match ports 10000 - 65535
        native-connect: sockaddr re "inet-.*:[1-9][0-9]{4}$" then permit

```

`/root/.systrace/usr_sbin_chroot` contains:
```
Policy: /usr/sbin/chroot, Emulation: native
        native-__sysctl: permit
        native-fsread: filename eq "/etc/malloc.conf" then permit
        native-issetugid: permit
        native-mmap: permit
        native-break: permit
        native-mprotect: permit
        native-fsread: filename eq "/etc/spwd.db" then permit
        native-fcntl: permit
        native-fstat: permit
        native-read: permit
        native-pread: permit
        native-close: permit
        native-fsread: filename eq "/etc/group" then permit
        native-setgid: gid eq "1001" then permit
        native-setgroups: permit
        native-chroot: filename eq "/home/chrooted/tor" then permit
        native-chdir: filename eq "/" then permit
        native-getsid: permit
        native-getpid: permit
        native-setsid: permit
        native-setuid: uid eq "1001" and uname eq "_tor" then permit
        native-execve: filename eq "/bin/tor" and argv eq "/bin/tor -f /etc/tor/torrc" then permit
```

### Executing with the policy

Since these policies are specific to the chrooted tor, you could put them into
`/home/chrooted/policies` and then execute systrace with `-d`.
That way your root user does not have these chroot specific policies for it:

Note: I use `/home/chrooted/tor/etc/tor/systrace` instead of `/home/chrooted/tor/etc/systrace` which would mirror the system version. I did this because the Tor version will be readable by `_tor` whereas
the system version is not.

```
su - root
ksh

# Copy the files over
mkdir -p /home/chrooted/tor/etc/tor/systrace/
chmod 0755 /home/chrooted/tor/etc/tor/systrace/
cp /root/.systrace/{bin_tor,usr_sbin_chroot} /home/chrooted/tor/etc/tor/systrace/

# Allow _tor to read it since systrace will be running as that user.
chmod 0444 /home/chrooted/tor/etc/tor/systrace/*
```

Now you can execute systrace like this:
```
/bin/systrace -a -d /home/chrooted/tor/etc/tor/systrace /usr/sbin/chroot -u _tor -g _tor /home/chrooted/tor /bin/tor -f /etc/tor/torrc
```

And `systrace` will watch system calls that both `/usr/sbin/chroot` and `/home/chrooted/tor/bin/tor` make.

You will want to replace the above section for `/etc/rc.local` with this new one:

```
if [ -x /home/chrooted/tor/bin/tor -a -f /home/chrooted/tor/etc/tor/systrace/bin_tor -a -f /home/chrooted/tor/etc/tor/systrace/usr_sbin_chroot ]; then
     echo -n 'tor: ';
     /bin/systrace -a -d /home/chrooted/tor/etc/tor/systrace /usr/sbin/chroot -u _tor -g _tor /home/chrooted/tor /bin/tor -f /etc/tor/torrc
else
     echo 'Incorrect setup for Tor!';
fi
```

## XXX Work in Progress -- Using a chrooted systrace with a chrooted Tor client

The above systrace version works. This version below does '''NOT''' work yet.
Systrace complains about /dev/null not existing and Tor shuts down because of it.

Someone who has time to debug this, please do.

A big disadvantage to the above command is that `systrace` must run as root in order for the chroot command to work.

A better way would be to do the following:

 * chroot to /home/chrooted/tor
 * call systrace on Tor

That way systrace will be running as `_tor:_tor` instead of `root:wheel`.

It also allows you to run `systrace` as `_tor:_tor` even while creating the policy file. For that, you will have to use -d so
that systrace writes the files into the correct spot.

### Chrooting systrace

Systrace is statically linked so it's just a simple matter of copying it to the right location along
with its device and config file:

```
su - root
ksh

# Copy the executable
cp /bin/systrace /home/chrooted/tor/bin/

# Create the device
cd /home/chrooted/tor/dev
sh /dev/MAKEDEV systrace
```

### Executing the chrooted systrace with chrooted Tor

The only thing left is to tell `systrace` where the policy files are relative to the chroot.

```
if [ -x /home/chrooted/tor/bin/tor -a -f /home/chrooted/tor/etc/tor/systrace/bin_tor -a -f /home/chrooted/tor/etc/tor/systrace/usr_sbin_chroot ]; then
     echo -n 'tor: ';
     /usr/sbin/chroot -u _tor -g _tor /home/chrooted/tor /bin/systrace -a -d /etc/tor/systrace /bin/tor -f /etc/tor/torrc
else
     echo 'Incorrect setup for Tor!';
fi
```
