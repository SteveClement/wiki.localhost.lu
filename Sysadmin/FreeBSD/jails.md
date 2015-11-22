# Introduction

This document outlines the installation of a FreeBSD Jail

## pre-requisites

* Unix Skills (ION Unix Profile Level 4)

* Buildworld FreeBSD knowledge

* Networking knowledge


# currently main usable section

ports: jailer, jailutils

Bind all network services to the respective IP addresses. No *. Bindings allowed. disable rcpbind

```
export IP="80.90.47.183"
export ROUTER="80.90.47.161"
export FQDN="proton.pronto.lu" 
export HOST="proton" 
export NETIF="em0" 
```

## First jail

```
mkdir -p /usr/home/Jails/${HOST} && export JAILDIR="/usr/home/Jails/${HOST}" && export JAIL="${HOST}" && ln -s /usr/home/Jails /Jails 
```

## Follow up Jails

```
mkdir -p /usr/home/Jails/${HOST} && export JAILDIR="/usr/home/Jails/${HOST}" && export JAIL="${HOST}"

cd /usr/src 

# Makes sense on the first run, if more jails are needed only: make installworld is advised 

make world DESTDIR=${JAILDIR}
make distribution DESTDIR=${JAILDIR}
cp -pi /etc/defaults/devfs.rules /etc/

# Subsequent Jails after an initial world has been built

make installworld DESTDIR=${JAILDIR}
make distribution DESTDIR=${JAILDIR}


mount -t devfs devfs ${JAILDIR}/dev
ls -la ${JAILDIR}/dev
mkdir ${JAILDIR}/usr/ports
mkdir ${JAILDIR}/usr/src

cat << EOF >> /etc/fstab
/usr/src                ${JAILDIR}/usr/src nullfs rw          2 2
/usr/ports              ${JAILDIR}/usr/ports nullfs rw        2 2
EOF


mount ${JAILDIR}/usr/ports
mount ${JAILDIR}/usr/src
cp -pi /etc/resolv.conf ${JAILDIR}/etc/
ln -sf /dev/null ${JAILDIR}/kernel
touch ${JAILDIR}/etc/fstab
ifconfig ${NETIF} inet alias ${IP} netmask 255.255.255.255


## Still problemos here...
##devfs -m ${JAILDIR}/dev rule -s 4 applyset
```

## rc.conf on the Jail

```
cat << EOF >> ${JAILDIR}/etc/rc.conf
hostname="${FQDN}"    # Set this!
ifconfig_${NETIF}_alias0="inet ${IP} netmask 0xffffffff"
defaultrouter="${ROUTER}"        # Set to default gateway (or NO).
clear_tmp_enable="YES"  # Clear /tmp at startup.
# Once you set your jail up you may want to consider adding a good securelevel:
# Same as sysctl -w kern.securelevel=3
kern_securelevel_enable="YES"    # kernel security level (see init(8)),
kern_securelevel="3"
sshd_enable="YES"
EOF
```

== rc.conf on local machine hosting the Jail ==

=== Initial === 

```
cat << EOF >> /etc/rc.conf
## Adding jail support and initial jail

jail_enable="YES"        # Set to NO to disable starting of any jails
jail_list="${JAIL}"            # Space separated list of names of jails
jail_set_hostname_allow="NO" # Allow root user in a jail to change its hostname
jail_socket_unixiproute_only="YES" # Route only TCP/IP within a jail

## Jail definition for: ${JAILDIR}
jail_${JAIL}_rootdir="${JAILDIR}"
jail_${JAIL}_hostname="${FQDN}"
jail_${JAIL}_ip="${IP}"
jail_${JAIL}_exec_start="/bin/sh /etc/rc"
jail_${JAIL}_devfs_enable="YES"
jail_${JAIL}_devfs_ruleset="devfsrules_jail"
EOF
```

### Sub-sequent Jails

ADD THE JAIL TO jail_list in the Local rc.conf

```
jail_list="${JAIL}"            # Space separated list of names of jails
```

```
cat << EOF >> /etc/rc.conf

## Jail definition for: ${JAILDIR}
jail_${JAIL}_rootdir="${JAILDIR}"
jail_${JAIL}_hostname="${FQDN}"
jail_${JAIL}_ip="${IP}"
jail_${JAIL}_exec_start="/bin/sh /etc/rc"
jail_${JAIL}_devfs_enable="YES"
jail_${JAIL}_devfs_ruleset="devfsrules_jail"

EOF
```

```
## jail IP Address
##ifconfig_${NETIF}_aliasXYZ="inet ${IP} netmask 0xffffffff" # Don't forget to increment the index
```

# starting it for real

```
/etc/rc.d/jail start ${JAIL}
```


# entering jail

```
[root@woodstock /usr/src]# jls
   JID  IP Address      Hostname                      Path
     3  80.90.47.187    sugar.ion.lu                  /usr/home/Jails/sugar
     2  80.90.47.186    wiki.ion.lu                   /usr/home/Jails/wiki
[root@woodstock /usr/src]# jexec 3 /bin/sh
#
```

# change root passwd
```
passwd
```

# add user

```
pw useradd steve -c "Steve Clement" -G wheel && mkdir -p /usr/home && ln -s /usr/home /home && mkdir -p -m 700 /home/steve && chown steve:steve /home/steve
passwd steve
```

# Test starting Jail

```
jail ${JAILDIR} ${FQDN} ${IP} /bin/sh
```

now you are at a # prompt and no network is available and you are still heriting your original environment so all the Variables are preserved


configuring jail:

sysinstall

sysctl note:

security.jail.set_hostname_allowed enabled by default conside disabling it.

# maintenance in jail

jls

jexec 1 /bin/sh

update world as usual

integrating portaudit:

metaportaudit.sh

```
#!/bin/sh

JAILDIR=/Jails/
JAILS="devel"
TMPDIR="/tmp"

# First lets audit the root server
/usr/local/sbin/portaudit -a

# Now Lets create temp files of ports in the jails,
# audit the root server all jails
# and delete the temp files
cd $TMPDIR
for jail in $JAILS; do
  echo ""
  echo "Checking for packages with security vulnerabilities in jail \"$jail\":"
  echo ""
  ls -1 $JAILDIR/$jail/var/db/pkg > $TMPDIR/$jail.paf
  /usr/local/sbin/portaudit -f $TMPDIR/$jail.paf
  rm $TMPDIR/$jail.paf
done
```

Now lets edit /usr/local/etc/periodic/security on about line 55
you'll want to change:

```
echo
echo /usr/local/sbin/portaudit -a |
         su -fm "${daily_status_security_portaudit_user:-nobody}" || rc=$?
```

to

```
echo
echo /root/bin/metaportaudit.sh -a |
         su -fm "${daily_status_security_portaudit_user:-nobody}" || rc=$?
```

Populating jail with host packages:

After this we have to make sure we have the same packages in the jail as on our host. So we create a temporary package directory:

```
mkdir -p /Jails/devel/tmp/packages
```

Then we fill this directory with the packages installed on the host:

```
cd /Jails/devel/tmp/packages
pkg_info | cut -f1 -d" " | xargs -n 1 pkg_create -j -b 
```

Make sure that you bind network services to the jail IP Address e.g: ssh

```
vi /etc/ssh/sshd_config

ListenAddress 80.90.47.167
```

to find out what listens on *


sockstat |grep "\*:[0-9]"

inetd

rc.conf flags, -a $hostname

mysql: my.cnf

bind-address=80.90.47.67

samba

interfaces = 80.90.47.67/24
socket address = 80.90.47.67
bind interfaces only = yes

syslogd

rc.conf
syslogd_flags="-s -s"
syslogd_flags="-a 80.90.47.167"

To further fine tune the jail make.conf can be used, see example of all the flags



## Removing un-necessary files

files to remove:

while read file; do rm -rfv /path/to/jail$file; done < jail_remove.txt

Dummy Files Required in Jails:

Programs (hard link to /usr/bin/true): /sbin/init

## cleaning up Jail cron Reports

FreeBSD 6.x/7.x

 1. Put a periodic.conf like this one in /etc
 1. Remove the line with adjkerntz from your crontab


# Upgrading a Jail from Source

I've seen tons of questions online about how to upgrade a jail using make buildworld. Here's how I do mine.

The jail needs to be shutdown before this is run (unless you're the daring type). This assumes you've already upgraded (installed and all) the base system to the same version of FreeBSD as your jail and you have the new version built in /usr/src. See the FreeBSD manual for how to do this.

export JAILDIR=/usr/home/Jails/JAILNAME

echo $JAILDIR

cd /usr/src && make installworld DESTDIR=${JAILDIR} && mergemaster -i -C -D ${JAILDIR}

Yup, it's that simple. Naturally if you've cleaned up your jail this'll put all those files back.

I may be missing something. Let me know.


# Jail Tuning and Performance

Here's a list of some tuning issues to keep in mind when running many (20+) jails on a system. This is written with FreeBSD 5.x in mind, but much of it applies to 4.x as well. Depending on your system load the values below may need to be tweaked some. Basic Tuning

I've found the need to increase the process and IPC tunables with some settings like this in /boot/loader.conf:

kern.ipc.somaxconn=512 kern.maxfiles=15360

Process 'exec' Overload

A large amount of processes started at the same exact time can overwhelm a FreeBSD system. The limit of 16 processes is normally enough. However with jails running cron jobs at exactly the same time (such as the daily periodic/security scripts) this can be an issue (you'll see an 'Abort Trap'). There's two ways to solve this:

A large amount of processes started at the same exact time can overwhelm a FreeBSD system. The limit of 16 processes is normally enough. However with jails running cron jobs at exactly the same time (such as the daily periodic/security scripts) this can be an issue (you'll see an 'Abort Trap'). There's two ways to solve this:

Add 'jitter' to cron: cron allows you to specify a jitter by starting it up with a -j and -J flags. This slightly randomizes the exact time cron jobs are started. See the cron man page for more details. Adding the following line to each jail's /etc/rc.conf effects this:

cron_flags="-J 15"

Increase the 'exec' limit: In FreeBSD 5.4 and later you can increase the exec limit by adding a line like the following to /boot/loader.conf:

vm.exec_map_entries=64

## Running many Postgres databases

When running multiple jails with PostgreSQL or other SysV IPC intensive apps you'll probably run out of SysV IPC space. To fix this you need to add lines like the following to /boot/loader.conf:

kern.ipc.shmmni=2048 kern.ipc.shmseg=2048 kern.ipc.semmni=128 kern.ipc.semmns=512

Naturally you'll also need to add the following line to /etc/sysctl.conf. This is covered in more detail in the jail man page.

security.jail.sysvipc_allowed=1

# Some Jail Security Tips

Most of this is directed at FreeBSD 5, but applies in some form or another to 4.x too. System Message Buffer

By default jails can read the system message buffer (ie: the console buffer). In many cases this isn't desired. Add the following line to /etc/sysctl.conf to turn it off:

security.bsd.unprivileged_read_msgbuf=0

# Jail Host Names
You probably don't want jails to be able to change their host name which is used as the jail identifier in many cases. Add this to /etc/sysctl.conf:

security.jail.set_hostname_allowed=0

# Jail devfs

To get the necessary devices for running a jail system you usually mount a devfs at /dev within the jail. This needs to be a paired down version so that the jailed processes can't gain access to resources outside the jail. Here's how:

```
# JAIL=/path/to/jail 
# SET=100 
# mount_devfs devfs $JAIL/dev 
# devfs rule -s $SET add hide 
# devfs rule -s $SET add path log unhide 
# devfs rule -s $SET add path null unhide 
# devfs rule -s $SET add path zero unhide 
# devfs rule -s $SET add path crypto unhide 
# devfs rule -s $SET add path random unhide 
# devfs rule -s $SET add path urandom unhide 
# devfs rule -s $SET add path ptyp* unhide 
# devfs rule -s $SET add path ptyq* unhide 
# devfs rule -s $SET add path ptyr* unhide 
# devfs rule -s $SET add path ptys* unhide 
# devfs rule -s $SET add path ptyP* unhide 
# devfs rule -s $SET add path ptyQ* unhide 
# devfs rule -s $SET add path ptyR* unhide 
# devfs rule -s $SET add path ptyS* unhide 
# devfs rule -s $SET add path ttyp* unhide 
# devfs rule -s $SET add path ttyq* unhide 
# devfs rule -s $SET add path ttyr* unhide 
# devfs rule -s $SET add path ttys* unhide 
# devfs rule -s $SET add path ttyP* unhide 
# devfs rule -s $SET add path ttyQ* unhide 
# devfs rule -s $SET add path ttyR* unhide 
# devfs rule -s $SET add path ttyS* unhide 
# devfs rule -s $SET add path fd unhide 
# devfs rule -s $SET add path fd/* unhide 
# devfs rule -s $SET add path stdin unhide 
# devfs rule -s $SET add path stdout unhide 
# devfs rule -s $SET add path stderr unhide 
# devfs -m $JAIL/dev rule -s $SET applyset 
# devfs -m $JAIL/dev ruleset $SET 
# ln -sf /var/run/log $JAIL/dev/log
```

See the man pages for details on the above. $SET is an arbitrary number for a rule-set. It can be the same for all your jails. Environment Variable Leakage

In most cases you don't want the full set of environment variables from the host system being carried over into the jail /etc/rc script. So use env or the jstart utility (from jailutils) to clear the environment.