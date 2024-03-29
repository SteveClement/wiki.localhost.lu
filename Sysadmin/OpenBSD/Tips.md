# Some general need know stuff on OpenBSD for the every-day sysadmin.

:warning: Once OpenBSD is installed you should update it immediately, if needed.

```
doas syspatch
```

## Virtualbox Guest custom resolution

You probably need the following in sysctl.conf

```
machdep.allowaperture=2
```

```
VBoxManage setextradata "OpenBSD VM Name" CustomVideoMode1 1360x768x32
# Double check
VBoxManage getextradata "OpenBSD VM Name"
# Remove CustomVideoMode1
VBoxManage setextradata "OpenBSD VM Name" CustomVideoMode1
```

```
$ doas mkdir -p /etc/X11/xorg.conf.d
echo '# X11 configuration for VirtualBox
Section "Device"
  Identifier   "VirtualBox-Card"
  Driver       "vesa"
  VendorName   "InnoTek"
  BoardName    "VirtualBox Graphics Adapter"
EndSection
Section "Monitor"
  Identifier   "VirtualBox-Monitor"
  VendorName   "InnoTek"
  ModelName    "VirtualBox Screen"
  HorizSync    1.0 - 1000.0
  VertRefresh  1.0 - 1000.0
EndSection
Section "Screen"
  Identifier   "VirtualBox-Screen"
  Device       "VirtualBox-Card"
  Monitor      "VirtualBox-Monitor"
  DefaultDepth 24
  SubSection "Display"
    Viewport   0 0
    Depth      24
    #Modes "1368x768" "1360x768" "1280x800" "1024x768"
    Modes  "1360x768"
  EndSubSection
EndSection' |doas sudo tee /etc/X11/xorg.conf.d/00-virtualbox-monitor.conf
```

## Log directory empty

If the log directory seems empty, this will re-create all the relevant files, plus munin

```
cd /var/log
doas touch authlog daemon daily.out failedlogin ftpd lastlog lpd-errs maillog messages pflog secure security.out weekly.out wtmp xferlog
doas mkdir munin rdist
doas touch munin/munin-node.log
doas chmod 640 authlog daemon ftpd lpd-errs maillog xferlog
doas chmod 600 daily.out failedlogin pflog secure security.out weekly.out
doas chmod 644 lastlog messages wtmp munin/munin-node.log
```

# PiHole on OpenBSD

Src: https://bghost.xyz/post/pihole_on_openbsd/

# Blocking Ads using unbound

Src: https://www.tumfatig.net/20190405/blocking-ads-using-unbound8-on-openbsd/

## OpenBSD Desktop

### 

Investigate: gnome-session —disable-acceleration

**gnome-session** will fail if no 3D accelation is enabled in xorg

See:

```
May  3 10:59:18 oBuilder gnome-session-binary[6625]: WARNING: software acceleration check failed: Child process exited with code 1
```

## Serial over USB on OpenBSD

Usually I use screen on Linux boxes to connect via serial. This sux under OpenBSD, use 'cu'

```
cu -s 19200 -l /dev/cuaU0
```
Exit with ~. or ~^D

/dev/cuaU0 -> USB-to-Serial Device
cu -> means 'call UNIX'

## Sensorsd on OpenBSD

Src: https://calomel.org/sensorsd_config.html

This works for a Soekris box.

```
cat <<EOF > /etc/sensorsd.conf
hw.sensors.cpu0.temp0:high=90C
# CPU temperature (degrees Celsius)
#hw.sensors.lm0.temp1:high=36C:command=echo "%2 \( high=%4 \)" \
   | mail -s "`hostname` sensorsd WARNING \(cpu temp\)" root
EOF
```

## munin

### munin-node

```
doas pkg_add -v munin-node
/usr/local/sbin/munin-node-configure --shell | sh
```
Edit /etc/munin/munin-node.conf to allow the server to poll your host.

### munin-server

```
doas pkg_add -v munin-server
```

If this fails with:

```
Can't install cairo-1.14.6 because of libraries
|library X11.16.1 not found
| not found anywhere
|library Xau.10.0 not found
| not found anywhere
…
```

You are missing the X headers, install them like so:

```
$ su -
# wget http://ftp.belnet.be/pub/OpenBSD/7.2/amd64/xbase72.tgz
# wget http://ftp.belnet.be/pub/OpenBSD/7.2/amd64/xshare72.tgz
# tar -C / -xzphf xbase72.tgz
# tar -C / -xzphf xshare72.tgz
rm xbase72.tgz xshare72.tgz
```

## sudo removed, doas introduced

http://www.openbsd.org/faq/faq10.html#doas

A very basic doas.conf(5) might look like this:
```
permit keepenv setenv { PKG_PATH ENV PS1 SSH_AUTH_SOCK } :wheel
```

This file gives users in the wheel group root-level access to all commands, with the environment variables PKG_PATH, ENV, PS1 and SSH_AUTH_SOCK passed through to the program they are invoking. The user will be asked to verify their password before the command is run.

## OpenSMTPd

Sources:

https://calomel.org/opensmtpd.html
http://technoquarter.blogspot.lu/2015/02/openbsd-mail-server-part-2-opensmtpd.html

Just add this into your /etc/mail/smtpd.conf and restart.
Where 192.168.0.123 is your local, port 25 reachable, outgoing relay.

```
echo 'action "outbound" relay host smtp://192.168.0.123” >> /etc/mail/smtpd.conf
rcctl enable smtpd && rcctl start smtpd
```

If you need to auth against an Internet relay do:

```
cd /etc/mail
echo "label relay@gmail.com:This is my s3cur3 outbound password" >> /etc/mail/secrets
makemap secrets
chmod 640 secrets*
chown root:_smtpd secrets*
vi /etc/smtpd.conf
# Add: table secrets db:/etc/mail/secrets.db
echo 'action "outbound" relay host smtp+tls://label@mail.outgoing.com:587 auth <secrets>' >> /etc/mail/smtpd.conf

rcctl enable smtpd && rcctl start smtpd
```

## Looking for a binary in OpenBSD ports

```
doas pkg_add -v pkglocatedb
pkglocate formail
```

## Forward user mails via ~/.forward

```
$ cat .forward
steve@apple.com
```

## Forward mbox mails

Src: http://giantdorks.org/alain/resend-mail-thats-locally-stored-in-a-mbox-format-on-a-linux-box-to-a-working-email-address/

```
doas pkg_add -v procmail
myemail=steve@apple.com
cat /var/mail/root |formail -k -X From: -X Subject: -X Message-Id: -X Date: -X To: -I "To: $myemail" -s /usr/sbin/sendmail -t -f $myemail
cat /var/mail/steve |formail -k  -X From: -X Subject: -X Message-Id: -X Date: -X To: -I "To: $myemail" -s /usr/sbin/sendmail -t -f $myemail
cat ˜/mbox |formail -k  -X From: -X Subject: -X Message-Id: -X Date: -X To: -I "To: $myemail" -s /usr/sbin/sendmail -t -f $myemail
```

## adding a new disk

src: https://jreypo.wordpress.com/2011/03/07/how-to-create-a-new-file-system-in-openbsd/

```
# dmesg |grep SCSI
sd0 at scsibus1 targ 0 lun 0: <ATA, Samsung SSD 840, DXT0> SCSI3 0/direct fixed naa.500253855010569a
sd1 at scsibus1 targ 1 lun 0: <ATA, KingSpec KSM-mSA, 1110> SCSI3 0/direct fixed t10.ATA_KingSpec_KSM-mSATA.5-032SJ_MSA0511122700021_
# fdisk -i sd3
Do you wish to write new MBR and partition table? [n] y
Writing MBR at offset 0.
# disklabel -E sd3
Label editor (enter '?' for help at any prompt)
> z
> p
OpenBSD area: 64-62524980; size: 62524916; free: 62524916
#                size           offset  fstype [fsize bsize  cpg]
  c:         62533296                0  unused
> a
partition: [a]
offset: [64]
size: [62524916]
FS type: [4.2BSD]
Rounding size to bsize (32 sectors): 62524896
> q
Write new label?: [y] y
# disklabel sd3
# /dev/rsd3c:
type: ESDI
disk: ESDI/IDE disk
label: KingSpec KSM-mSA
duid: 66aa81aa4da28b05
flags:
bytes/sector: 512
sectors/track: 63
tracks/cylinder: 255
sectors/cylinder: 16065
cylinders: 3892
total sectors: 62533296
boundstart: 64
boundend: 62524980
drivedata: 0

16 partitions:
#                size           offset  fstype [fsize bsize  cpg]
  a:         62524896               64  4.2BSD   2048 16384    1
  c:         62533296                0  unused
# newfs /dev/rsd3a
/dev/rsd3a: 30529.7MB in 62524896 sectors of 512 bytes
151 cylinder groups of 202.47MB, 12958 blocks, 25984 inodes each
super-block backups (for fsck -b #) at:
 32, 414688, 829344, 1244000, 1658656, 2073312, 2487968, 2902624, 3317280,
 3731936, 4146592, 4561248, 4975904, 5390560, 5805216, 6219872, 6634528,
 7049184, 7463840, 7878496, 8293152, 8707808, 9122464, 9537120, 9951776,
 10366432, 10781088, 11195744, 11610400, 12025056, 12439712, 12854368,
 13269024, 13683680, 14098336, 14512992, 14927648, 15342304, 15756960,
 16171616, 16586272, 17000928, 17415584, 17830240, 18244896, 18659552,
 19074208, 19488864, 19903520, 20318176, 20732832, 21147488, 21562144,
 21976800, 22391456, 22806112, 23220768, 23635424, 24050080, 24464736,
 24879392, 25294048, 25708704, 26123360, 26538016, 26952672, 27367328,
 27781984, 28196640, 28611296, 29025952, 29440608, 29855264, 30269920,
 30684576, 31099232, 31513888, 31928544, 32343200, 32757856, 33172512,
 33587168, 34001824, 34416480, 34831136, 35245792, 35660448, 36075104,
 36489760, 36904416, 37319072, 37733728, 38148384, 38563040, 38977696,
 39392352, 39807008, 40221664, 40636320, 41050976, 41465632, 41880288,
 42294944, 42709600, 43124256, 43538912, 43953568, 44368224, 44782880,
 45197536, 45612192, 46026848, 46441504, 46856160, 47270816, 47685472,
 48100128, 48514784, 48929440, 49344096, 49758752, 50173408, 50588064,
 51002720, 51417376, 51832032, 52246688, 52661344, 53076000, 53490656,
 53905312, 54319968, 54734624, 55149280, 55563936, 55978592, 56393248,
 56807904, 57222560, 57637216, 58051872, 58466528, 58881184, 59295840,
 59710496, 60125152, 60539808, 60954464, 61369120, 61783776, 62198432,
# mkdir /ssd
# mount /dev/sd3a /ssd
# df -kh /ssd
Filesystem     Size    Used   Avail Capacity  Mounted on
/dev/sd1a     29.3G    2.0K   27.9G     0%    /ssd
# sysctl hw.disknames # Identify 
hw.disknames=sd0:52059ef2c26253c1,sd1:72950db7c2c6d489
echo "72950db7c2c6d489.a /ssd ffs rw,nodev,nosuid,softdep 1 2" >> /etc/fstab
```

## Encrypt USB Disk or other disk

src: https://stephenmaxwell.me/blog/openbsd_encryption.html

```
A quick example runthrough of the steps follows, with sd3 being the USB drive.
# dd if=/dev/random of=/dev/rsd3c bs=1m
# fdisk -iy sd3
Writing MBR at offset 0.
# disklabel -E sd3  # (create an "a" RAID partition, see above for more info)
Label editor (enter '?' for help at any prompt)
> a a
offset: [64]
size: [62524916]
FS type: [4.2BSD] RAID
> q
Write new label?: [y] y
# bioctl -c C -l sd3a softraid0
New passphrase:
Re-type passphrase:
sd4 at scsibus3 targ 1 lun 0: <OPENBSD, SR CRYPTO, 005> SCSI2 0/direct fixed
sd4: 30529MB, 512 bytes/sector, 62524388 sectors
softraid0: CRYPTO volume attached as sd4
# dd if=/dev/zero of=/dev/rsd4c bs=1m count=1
# disklabel -E sd4 (create an "i" partition, see above for more info)
Label editor (enter '?' for help at any prompt)
> a i
offset: [0]
size: [62524388]
FS type: [4.2BSD]
Rounding size to bsize (32 sectors): 62524384
> p
OpenBSD area: 0-62524388; size: 62524388; free: 4
#                size           offset  fstype [fsize bsize  cpg]
  c:         62524388                0  unused
  i:         62524384                0  4.2BSD   2048 16384    1
> q
Write new label?: [y] y
# newfs sd4i
# mkdir -p /mnt/secretstuff
# mount /dev/sd4i /mnt/secretstuff
# mv planstotakeovertheworld.txt /mnt/secretstuff/
# umount /mnt/secretstuff
# bioctl -d sd3
```

## htop from source

```
pkg_add -v automake autoconf libtool git
git clone https://github.com/hishamhm/htop
cd htop
export AUTOMAKE_VERSION=1.16
export AUTOCONF_VERSION=2.69
./autogen.sh
./configure
make
doas make install
```

## Building xenocara-stable

```
doas user mod -G wsrc YOUR_USER
# Eventually log out and in again
cd /usr/
doas mkdir -p xenocara
doas chgrp wsrc xenocara
doas chmod 775  xenocara
cvs -qd anoncvs@anoncvs.openbsd.org:/cvs checkout -rOPENBSD_7_2 -P xenocara
cd /usr/xenocara
doas make bootstrap
doas make obj
doas make build
```

## Current X.Org version on OpenBSD 6.6

```
# X -version

X.Org X Server 1.20.5
X Protocol Version 11, Revision 0
Build Operating System: OpenBSD 6.6 amd64 
Current Operating System: OpenBSD tokyo.office.lan 6.6 GENERIC.MP#0 amd64
Build Date: 12 October 2019  11:22:22AM
 
Current version of pixman: 0.38.4
	Before reporting problems, check http://wiki.x.org
	to make sure that you have the latest version.
```

cvsup xenoncara version from: 26.11.2019:

```
$ X -version

X.Org X Server 1.20.5
X Protocol Version 11, Revision 0
Build Operating System: OpenBSD 6.6 amd64 
Current Operating System: OpenBSD cdn.openbsd.org 6.6 GENERIC#3 amd64
Build Date: 26 November 2019  11:42:27AM
 
Current version of pixman: 0.38.4
	Before reporting problems, check http://wiki.x.org
	to make sure that you have the latest version.
```
 
This is done through CVSup and takes time.

OpenBSD is not meant to be set up in 5 minutes and your done. It aims at System Administrators that are actually interested in their Systems security.

# Install reposync

```
$ doas pkg_add -v reposync
$ doas useradd cvs
$ doas install -d -o cvs /home/cvs /var/db/reposync
$ doas -u cvs reposync rsync://anoncvs.jp.openbsd.org/cvs /home/cvs
```

## Make sure you can run everything as your non-privileged user
```
doas user mod -G wsrc YOUR_USER
# Eventually log out and in again
cd /usr/
# xenocara and ports need manual permissions
doas mkdir -p xenocara ports
doas chgrp wsrc xenocara ports
doas chmod 775  xenocara ports
```

## Checkout the repos
```
# If /usr/src exist, checkout with local repo
$ cd /usr/src
$ cvs -d /home/cvs up -Pd
$ cd /usr
$ cvs -d /home/cvs checkout -P src
$ cvs -d /home/cvs checkout -P ports
$ cvs -d /home/cvs checkout -P xenocara
```

## Update the repos
```
$ cd /usr/src
$ cvs up -Pd
```

## dir sizes after reposync
```
OpenBSD-all
    All available OpenBSD collections (~6.6GB)
OpenBSD-src
    The source distribution (~2.9GB)
OpenBSD-ports
    The ports distribution (~1.1GB)
OpenBSD-www
    The OpenBSD web pages (~787MB)
OpenBSD-xenocara
    The current X.Org v7 tree (~1.7GB)

$ du -sh /home/cvs/*
176M	/home/cvs/CVSROOT
1.1G	/home/cvs/ports
2.9G	/home/cvs/src
787M	/home/cvs/www
1.7G	/home/cvs/xenocara
```

# Making a new world
:warning: Read this: https://openbsd.org/faq/upgrade66.html
:warning: Make sure to skim through the document and use sysmerge as well as "2. Files to delete" (if coming from prior versions)

## Compile a new Kernel; build a new world
```
# cp -i /bsd /bsd.old
# cd /usr/src
# make clean
# cd /usr/src/sys/arch/i386/conf/
# config GENERIC
Don't forget to run "make depend"
# cd ../compile/GENERIC
# make clean && make depend && make && make install
# reboot
# rm -rf /usr/obj/*
# cd /usr/src
# make obj
# cd /usr/src/etc && env DESTDIR=/ make distrib-dirs
# cd /usr/src
# make build
# rm -rf /usr/obj/*
```

Total time for make build on a 2.60GHz processor was 75 minutes.

# Update X.org
```
# rm -rf /usr/xobj/*
# cd /usr/xenocara
# make bootstrap
# make obj
# make build
# rm -rf /usr/xobj/*
```

Total time for make build on a p4 2.60GHz processor was 75 minutes.


# Troubleshooting
## When Kernel Building Goes Bad
If the newly installed kernel will not boot then boot into a previous bootable kernel.

### When you restart the system wait until you see something similar to the below
```
Using drive 0, partition 3.
Loading...
probing : pc0 com0 apm mem[634K 319M a20=on]
disk: fd0 hd0+
>> OpenBSD/i386 BOOT 3.01
boot>
```

### at this point boot into a previous bootable kernel
```
Using drive 0, partition 3.
Loading...
probing : pc0 com0 apm mem[634K 319M a20=on]
disk: fd0 hd0+
>> OpenBSD/i386 BOOT 3.01
boot> bsd.old
```

## Single user mode
To go into single user mode and recover a root password:

 1. When you restart the system wait until you see something similar to the below

```
Using drive 0, partition 3.
Loading...
probing : pc0 com0 apm mem[634K 319M a20=on]
disk: fd0 hd0+
>> OpenBSD/i386 BOOT 3.01
boot>
```

at this point you are going to want to enter into single user mode:

```
Using drive 0, partition 3.
Loading...
probing : pc0 com0 apm mem[634K 319M a20=on]
disk: fd0 hd0+
>> OpenBSD/i386 BOOT 3.01
boot> boot -s
```

 1. Now run fsck on all partitions, to make sure things are okay for changes

Enter pathname of shell or RETURN for sh: <press enter>

```
# fsck -p
```

 1. Mount all filesystems

```
# mount -a
```

export the TERM environmental variable only if you need to edit files:

```
# export TERM=vt220
```

 1. Reset root's password and then reboot

```
# passwd
Changing local password for root.
New password: ILikeMonkeys
Retype new password: ILikeMonkeys
# shutdown -r now
```

## Disable root logins

:warning: This is a configuration option during install

 1. add a regular user and his SSH keys:

```
# useradd -v -m -G wheel steve
# vi /home/steve/.ssh/authorized_keys
```

 2. Edit the entry in the /etc/ssh/sshd_config file from

```
#PermitRootLogin yes
```

to:
```
PermitRootLogin no
```

now restart sshd so the changes take effect without rebooting:
```
# kill -HUP `cat /var/run/sshd.pid`
```

## Encrypting swap

:warning: is by default set to 1 in 4.5

```
# sysctl -w vm.swapencrypt.enable=1
```

Edit /etc/sysctl.conf from
```
#vm.swapencrypt.enable=1
```

to:

```
vm.swapencrypt.enable=1
```


## Adding binary packages

### bash

 1. Add the package for the BASH shell via pkg_add as a binary
```
# pkg_add -v bash
```

 2. Setting BASH as your login shell
```
# chsh -s bash
```

## via the ports system

:warning: This will compile bash from source
```
$ cd /usr/ports/shells/bash
$ make
$ doas make install clean
# This might do nothing, in that case it is already installed perhaps as a binary via pkg_add
```

## Locking A User Out of Their Account

There will come a time when an administrator needs to prevent a user from using their account.

Locking the user nathan out of his account. As root
```
# chsh -s nologin nathan
```

Unlocking the user nathan from his account. As root
```
# chsh -s sh nathan
```

## Deleting a user account

A better way of locking a user out of their account is by using the userdel command which will not only change the user shell to a nologin shell but the user's password will be changed to an "impossible'' one. Also, the user's home directory will not be removed.

Locking the user nathan out of his account. As root
```
# userdel -p true nathan
```
Locking All Users Out of Their Accounts

There will come a time when an administrator needs to prevent all users from using their accounts. Root does not fall under the default login class and will not be locked out.

Locking all users from their accounts. As root
```
# touch /etc/nologin
```

Allowing logins again. As root
```
# rm /etc/nologin
```

The login program is controlled by /etc/login.conf and can be tweaked to meet your needs, including setting default user environmental variables and fine-tuning your system security.

If you end up with a /usr/src with files that end in ,v you have done a cvsup without a checkout.
Make sure to either add a tag or place your cvs tree in a separate directory.

## PF
```
pfctl -d                    Diable the packet filter
pfctl -e                    Enable the packet filter
pfctl -Fa -f /etc/pf.conf   Flush all (nat, filter, queue, state, info, table) rules and reload from the file /etc/pf.conf
pfctl -s rules                  Report on the currently loaded filter ruleset.
pfctl -s nat                    Report on the currently loaded nat ruleset.
pfctl -s state                  Report on the currently running state table (very useful).
pfctl -v -n -f /etc/pf.conf This does not actually load any rules, but allows you to check for errors in the file before you do load the ruleset. This is obviously good for testing.
```

## VPN
```
# sysctl net.inet.esp.enable
net.inet.esp.enable=1
# sysctl net.inet.ah.enable
net.inet.ah.enable=1
# sysctl net.inet.ip.forwarding=1
net.inet.ip.forwarding: 0 -> 1
# sysctl net.inet.ipcomp.enable=1
net.inet.ipcomp.enable: 0 -> 1

/etc/sysctl.conf to make it perm

# ifconfig enc0 up

echo up > /etc/hostname.enc0
```

```
CA-server # openssl req -x509 -days 365 -newkey rsa:1024 -keyout /etc/ssl/private/ca.key -out /etc/ssl/ca.crt
Generating a 1024 bit RSA private key
........................................++++++
......++++++
writing new private key to '/etc/ssl/private/ca.key'
Enter PEM pass phrase: <passphrase>
Verifying - Enter PEM pass phrase: <passphrase>
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) []: LU
State or Province Name (full name) []: Luxembourg
Locality Name (eg, city) []: Luxembourg
Organization Name (eg, company) []: Kernel Panic Inc.
Organizational Unit Name (eg, section) []: IPsec
Common Name (eg, fully qualified host name) []: CA.kernel-panic.it
Email Address []: danix@kernel-panic.it
CA-server #

```

```
VPN1# openssl req -new -key /etc/isakmpd/private/local.key -out /etc/isakmpd/private/1.2.3.4.csr
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) []: LU
State or Province Name (full name) []: Luxembourg
Locality Name (eg, city) []: Luxembourg
Organization Name (eg, company) []: Kernel Panic Inc.
Organizational Unit Name (eg, section) []: IPsec
Common Name (eg, fully qualified host name) []: 1.2.3.4
Email Address []: danix@kernel-panic.it

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []: <enter>
An optional company name []: <enter>
VPN1-server #
```

```
CA-server # cd /etc/isakmpd/private
CA-server # env CERTIP=1.2.3.4 openssl x509 -req -days 365 -in 1.2.3.4.csr -out 1.2.3.4.crt -CA /etc/ssl/ca.crt -CAkey /etc/ssl/private/ca.key -CAcreateserial -extfile /etc/ssl/x509v3.cnf -extensions x509v3_IPAddr
Signature ok
subject=/C=IT/ST=Italy/L=Milan/O=Kernel Panic Inc./OU=IPsec/CN=1.2.3.4/emailAddress=danix@kernel-panic.it
Getting CA Private Key
Enter pass phrase for /etc/ssl/private/ca.key: <passphrase>
CA-server #
```

```
cd /etc/isakmpd/private
cp 188.115.7.251.crt /etc/isakmpd/certs/
cp /etc/ssl/ca.crt /etc/isakmpd/ca/
```


```
/etc/ipsec.conf VPN1
# Macros
ext_if      = "rl0"                               # External interface (1.2.3.4)
local_net   = "172.16.0.0/24"                     # Local private network
remote_gw   = "5.6.7.8"                           # Remote IPsec gateway
remote_nets = "{192.168.0.0/24, 192.168.1.0/24}"  # Remote private networks

# Set up the VPN between the gateway machines
ike esp from $ext_if to $remote_gw
# Between local gateway and remote networks
ike esp from $ext_if to $remote_nets peer $remote_gw
# Between the networks
ike esp from $local_net to $remote_nets peer $remote_gw
```

```
/etc/ipsec.conf VPN2
# Macros
ext_if     = "rl0"                               # External interface (5.6.7.8)
local_nets = "{192.168.0.0/24, 192.168.1.0/24}"  # Local private networks
remote_gw  = "1.2.3.4"                           # Remote IPsec gateway
remote_net = "172.16.0.0/24"                     # Remote private network

# Set up the VPN between the gateway machines
ike esp from $ext_if to $remote_gw
# Between local gateway and remote network
ike passive esp from $ext_if to $remote_net peer $remote_gw
# Between the networks
ike esp from $local_nets to $remote_net peer $remote_gw
```


On both VPN: 
```
# isakmpd -K -d
# ipsecctl -n -f /etc/ipsec.conf
# ipsecctl -f /etc/ipsec.conf
```

```
/etc/rc.conf.local VPN1/VPN2
isakmpd_flags="-K"    # Avoid keynote(4) policy checking
ipsec=YES             # Load ipsec.conf(5) rules
```

```
/etc/pf.conf border-router
# Allow ESP encapsulated IPsec traffic on the external interface
pass in  on $ext_if proto esp from $remote_gw to $ext_if
pass out on $ext_if proto esp from $ext_if to $remote_gw
# Allow isakmpd(8) traffic on the external interface
pass in  on $ext_if proto udp from $remote_gw to $ext_if port {isakmp, ipsec-nat-t}
pass out on $ext_if proto udp from $ext_if to $remote_gw port {isakmp, ipsec-nat-t}
# Allow IP-in-IP traffic between the gateways on the enc(4) interface
pass in  on enc0 proto ipencap from $remote_gw to $ext_if keep state (if-bound)
pass out on enc0 proto ipencap from $ext_if to $remote_gw keep state (if-bound)
# Filter unencrypted VPN traffic on the enc(4) interface
pass in  on enc0 from $remote_nets to $int_if:network keep state (if-bound)
pass out on enc0 from $int_if:network to $remote_nets keep state (if-bound)
```

# (fucking) sendmail
## redirecting root mails behind NAT <firewall>

source: http://wiki.stocksy.co.uk/wiki/Simple_sendmail_configuration_on_OpenBSD

The trick is to add your local SMTP relay between [brackets] to be sure no DNS lookups are done.
Plus, you make sure that everything is sent straight to your SMARTHOST (msp)
Then we masquerade the mail and add OUR domain to everything meaning:

```
$ mail turd
```

Get's sent to the Smarthost as: turd@example.com

```
define(`SMART_HOST', `[192.168.1.1]')
MASQUERADE_AS(`example.com')
FEATURE(`masquerade_envelope')
FEATURE(always_add_domain)
…
FEATURE(`msp', `[192.168.1.1]')dnl
```


### config file

```
# cd /usr/share/sendmail/cf
# vi openbsd-submit.mc 
# make openbsd-submit.cf
# cp openbsd-submit.cf /etc/mail/submit.cf
# kill -HUP `head -1 /var/run/sendmail.pid`
```

## redirect rootmails

Edit the /etc/mail/aliases file to redirect email which would otherwise go to you or the root user to somewhere else: 

```
# Basic system aliases -- these MUST be present
MAILER-DAEMON: postmaster
postmaster: root
root: rootmails@example.com
```

## Debug
```
tail -f /var/log/maillog &
```

# pkg

pkg collisions, same checksum:

```
<root@obsd:41># pkg_add -v libiconv                                                                                  
Collision in libiconv-1.14: the following files already exist
        /usr/local/bin/iconv from libiconv-1.14 (same checksum)
        /usr/local/include/iconv.h from libiconv-1.14 (same checksum)
        /usr/local/include/libcharset.h from libiconv-1.14 (same checksum)
        /usr/local/include/localcharset.h from libiconv-1.14 (same checksum)
        /usr/local/lib/charset.alias from libiconv-1.14 (same checksum)
        /usr/local/lib/libcharset.a from libiconv-1.14 (same checksum)
        /usr/local/lib/libcharset.la from libiconv-1.14 (same checksum)
        /usr/local/lib/libcharset.so.1.1 from libiconv-1.14 (same checksum)
        /usr/local/lib/libiconv.a from libiconv-1.14 (same checksum)
        /usr/local/lib/libiconv.la from libiconv-1.14 (same checksum)
        /usr/local/lib/libiconv.so.6.0 from libiconv-1.14 (same checksum)
        /usr/local/man/man1/iconv.1 from libiconv-1.14 (same checksum)
        /usr/local/man/man3/iconv.3 from libiconv-1.14 (same checksum)
        /usr/local/man/man3/iconv_close.3 from libiconv-1.14 (same checksum)
        /usr/local/man/man3/iconv_open.3 from libiconv-1.14 (same checksum)
        /usr/local/man/man3/iconv_open_into.3 from libiconv-1.14 (same checksum)
        /usr/local/man/man3/iconvctl.3 from libiconv-1.14 (same checksum)
        /usr/local/share/doc/libiconv/iconv.1.html from libiconv-1.14 (same checksum)
        /usr/local/share/doc/libiconv/iconv.3.html from libiconv-1.14 (same checksum)
        /usr/local/share/doc/libiconv/iconv_close.3.html from libiconv-1.14 (same checksum)
        /usr/local/share/doc/libiconv/iconv_open.3.html from libiconv-1.14 (same checksum)
        /usr/local/share/doc/libiconv/iconv_open_into.3.html from libiconv-1.14 (same checksum)
        /usr/local/share/doc/libiconv/iconvctl.3.html from libiconv-1.14 (same checksum)
<root@obsd:42># pkg_add -v -F repair libiconv 
Collision in libiconv-1.14: the following files already exist
        /usr/local/bin/iconv from libiconv-1.14 (same checksum)
        /usr/local/include/iconv.h from libiconv-1.14 (same checksum)
        /usr/local/include/libcharset.h from libiconv-1.14 (same checksum)
        /usr/local/include/localcharset.h from libiconv-1.14 (same checksum)
        /usr/local/lib/charset.alias from libiconv-1.14 (same checksum)
        /usr/local/lib/libcharset.a from libiconv-1.14 (same checksum)
        /usr/local/lib/libcharset.la from libiconv-1.14 (same checksum)
        /usr/local/lib/libcharset.so.1.1 from libiconv-1.14 (same checksum)
        /usr/local/lib/libiconv.a from libiconv-1.14 (same checksum)
        /usr/local/lib/libiconv.la from libiconv-1.14 (same checksum)
        /usr/local/lib/libiconv.so.6.0 from libiconv-1.14 (same checksum)
        /usr/local/man/man1/iconv.1 from libiconv-1.14 (same checksum)
        /usr/local/man/man3/iconv.3 from libiconv-1.14 (same checksum)
        /usr/local/man/man3/iconv_close.3 from libiconv-1.14 (same checksum)
        /usr/local/man/man3/iconv_open.3 from libiconv-1.14 (same checksum)
        /usr/local/man/man3/iconv_open_into.3 from libiconv-1.14 (same checksum)
        /usr/local/man/man3/iconvctl.3 from libiconv-1.14 (same checksum)
        /usr/local/share/doc/libiconv/iconv.1.html from libiconv-1.14 (same checksum)
        /usr/local/share/doc/libiconv/iconv.3.html from libiconv-1.14 (same checksum)
        /usr/local/share/doc/libiconv/iconv_close.3.html from libiconv-1.14 (same checksum)
        /usr/local/share/doc/libiconv/iconv_open.3.html from libiconv-1.14 (same checksum)
        /usr/local/share/doc/libiconv/iconv_open_into.3.html from libiconv-1.14 (same checksum)
        /usr/local/share/doc/libiconv/iconvctl.3.html from libiconv-1.14 (same checksum)
libiconv-1.14: ok                                                                                                    
<root@obsd:43># 
```

# OpenVPN

http://www.kimiushida.com/bitsandpieces/articles/openbsd_openvpn_quickstart/

# OpenBSD ports
## ports tree on external location

If your ports tree is NOT in /usr/ports but symlinks to somewhere else (or is a Network Share) add the following to your /etc/mk.conf

```
echo "PORTSDIR=/home/ports" >> /etc/mk.conf
ln -s /home/ports /usr/ports
```

## listing ports to be updated
```
$ cd /usr/ports/infrastructure/bin/
$ ./pkg_outdated
Collecting installed packages: ok                                                                                                                                 
Collecting port versions: ok                                                                                                                                      
Collecting port signatures: ok 
Outdated ports:
www/mozilla-firefox         # 3.0.6 -> 3.0.7
$
```

## updating all out-dated ports

This works on OpenBSD 6.x

```
cd /usr/ports/infrastructure/bin
for port in `./pkg_outdated |awk '{ print $1 }'`; do
    if [[ "$port" == "" ]]; then
       continue
    fi
    echo "Updating '$port' - Enter to continue."
    read
    cd /usr/ports/${port}
    doas make clean update
done
```

## Updating single port
### Firefox seem out-of-date to update
```
$ find /usr/ports/ -name mozilla-firefox
$ cd /usr/ports/www/mozilla-firefox/
$ doas make update
```
