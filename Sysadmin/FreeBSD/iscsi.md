[Source](http://people.freebsd.org/~rse/iscsi/iscsi.txt)

# iSCSI on FreeBSD

## Client

```

# echo 'iscsi_initiator_load="YES"' >>/boot/loader.conf
# kldload /boot/kernel/iscsi_initiator.ko
# iscontrol -v -d targetaddress=10.0.0.1 initiatorname=`hostname` |grep Target
        TargetAlias=QNAP Target
        TargetPortalGroupTag=1
        SendTargets=All
        TargetName=iqn.2004-04.com.qnap:ts-1079:iscsi.virtualmachines.cb0dd4
        TargetAddress=10.0.0.1:3260,1
TargetName=iqn.2004-04.com.qnap:ts-1079:iscsi.virtualmachines.cb0dd4
TargetAddress=10.0.0.1:3260,1
```

## iscsi.conf

```
idisk1 {
    authmethod      = CHAP
    chapIName       = user1
    chapSecret      = secret123456
    initiatorname   = server.example.com
    TargetName      = iqn.2004-04.com.qnap:ts-1079:iscsi.virtualmachines.cb0dd4
    TargetAddress   = 10.0.0.1:3260,1
}
```

## Run iScsi initiator

```
# iscontrol -c /etc/iscsi.conf -n idisk1
```


## Format the Disk

```
# bsdlabel -w -B /dev/da0
# newfs -U -L idisk1 /dev/da0a
# mount /dev/ufs/idisk1 /mnt
```
