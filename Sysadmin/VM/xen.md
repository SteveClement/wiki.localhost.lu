Dirt xen-server notes

install without ext4

```
apt-get remove --purge grub2\*
rm -rf /boot/grub/*
apt-get install grub
grub-install /dev/sda
update-grub
```

remove quiet splash from  /boot/grub/menu.lst, run update-grub again

reboot with grub1

```
sudo cp /etc/init/tty1.conf /etc/init/hvc0.conf
vim /etc/init/hvc0.conf #change tty1 -> hvc0
sudo ln -s . /boot/boot

shutdown

xe vm-list

uuid=xxxxxxxxxxxxxx

xe vm-param-set uuid=$uuid HVM-boot-policy=

xe vm-param-set uuid=$uuid PV-bootloader=pygrub

xe vm-param-set  uuid=$uuid PV-args="console=tty0 xencons=tty"



xe vm-disk-list uuid=$uuid

uuiddisk=xxxxxxxxxxxxx
xe vbd-param-set uuid=$uuiddisk bootable=true
```



start, it will be PV mode, ensure :

```
ps axfwwwww|grep xen
```



## Force shutdown

```
xe task-list
xe vm-shutdown vm=204\ tor.localhost.lu force=true
xe vm-list uuid=d694b3a4-6f82-a27f-5cf1-e4a9bd25b6f0
xe task-list
xe vm-reset-powerstate vm=204\ tor.localhost.lu --force
xe vm-reset-powerstate vm=204\ tor.localhost.lu --force
xe vm-reboot -u root vm-name="204 tor.localhost.lu"
list_domains
xe vm-reboot -u root vm-id=d694b3a4-6f82-a27f-5cf1-e4a9bd25b6f0
xe vmlist
list_domains
/opt/xensource/debug/destroy_domain -domid 18
xe vm-reboot uuid=d694b3a4-6f82-a27f-5cf1-e4a9bd25b6f0 --force
```
