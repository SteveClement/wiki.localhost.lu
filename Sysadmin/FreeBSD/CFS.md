# This file explains how to do Crypted FS on FreeBSD


## DOESN'T COMPILE ON 7.x YET

```
cd /usr/ports/security/cfs && make install clean

        echo "/usr/local/cfsd-bootstrap localhost" >> /etc/exports
```

add this to rc.conf:

```
cat << EOF >> /etc/rc.conf
## Global Config
cfsd_enable="YES"
cfsd_nfs_flags="noinet6"    # nfs options
EOF
```

```
cat << EOF >> /etc/rc.conf
## 5.x 6.x Specific
single_mountd_enable="YES"
mountd_flags="-r"
rpcbind_enable="YES" ## This is only on >=5.3 necessary, portmapper replacement
rpcbind_flags="-L"
EOF
```

```
cat << EOF >> /etc/rc.conf
## 4.x Specific
portmap_enable="YES"
portmap_program="/usr/sbin/portmap"
EOF
```


Create the /crypt dir:

```
mkdir /crypt
```

### noinet6 is only needed if IPv6 isn't in use to avoid the following error:
[udp6] localhost:/var/tmp: NFSPROC_NULL: RPC: Unable to receive; errno =
Connection refused


Either reboot or:

```
## 5.x 6.x Specific
rpcbind -L
mountd -r
```

```
## 4.x Specific
/usr/sbin/portmap
```


now patch cfsd rc script

```
cd /usr/local/etc/rc.d
patch -p0 < ~steve/work/plumbum-ion-sysadmin/trunk/patches/cfsd-ports.diff

/usr/local/etc/rc.d/cfsd start
```

Once done go to the location where you wanna create your disk as $LUSER or
root if you want a root cfs:

cmkdir crypt
Now you HAVE TO enter a passphrase of 16Chars at least.

cattach crypt mysafestorage

Where crypt is the "physical" directory and mysafestorage ANY name of your
choice that's going to appear in /crypt

Enter your passphrase.

And now you can access: /crypt/mysafestorage and put sensitive data on it.

cdetach mysafestorage

Detaches the crypted FS.

Timing out the Attached FS can be achieved with simple acivity monitoring
scripts.