# Notes Regarding HeadLess VirtualBox installation

If you want to see what Operating System Types are supported by your VirtualBox this command helps:

```
# VBoxManage list ostypes
```

### Registering the system
```
export VBOX_NAME="ubuntu-devel"

VBoxManage createvm --name ${VBOX_NAME} --ostype Ubuntu_64 --register
Virtual machine 'ubuntu-devel' is created and registered.
UUID: bb2192c5-8f2f-4be1-9aa9-aa7dae5941b5
Settings file: '/home/steve/VirtualBox VMs/ubuntu-devel/ubuntu-devel.vbox'
```

### Adding some memory to the system
```
VBoxManage modifyvm ${VBOX_NAME} --memory 4000 --acpi on --boot1 dvd
```

### Creating the filesystem for the system
```
VBoxManage createhd --filename ~/VirtualBox\ VMs/${VBOX_NAME}/${VBOX_NAME}.vdi --size 30000
0%...10%...20%...30%...40%...50%...60%...70%...80%...90%...100%
Disk image created. UUID: 269b084c-58b8-471e-b35b-135068f885f1
```

### Add an IDE controller to the system
```
VBoxManage storagectl ${VBOX_NAME} --name "IDE Controller" --add ide --controller PIIX4
```

### Attach the disk image to the IDE controller
```
VBoxManage storageattach ${VBOX_NAME} --storagectl "IDE Controller" --port 0 --device 0 --type hdd --medium ~/VirtualBox\ VMs/${VBOX_NAME}/${VBOX_NAME}.vdi
```

### Set the NAT for the installation
```
VBoxManage modifyvm ${VBOX_NAME} --nic1 nat
```

### (installation) set the iso image of the Ubuntu installer on the DVD
```
VBoxManage storageattach ${VBOX_NAME} --storagectl "IDE Controller" --port 0 --device 1 --type dvddrive --medium ubuntu-12.04-beta1-server-amd64.iso
```

### Enable VNC access

/!\ This will give VNC access without password

```
VBoxHeadless --startvm ${VBOX_NAME} -n -m 5900
Oracle VM VirtualBox Headless Interface 4.0.4_OSE
(C) 2008-2011 Oracle Corporation
All rights reserved.

23/08/2011 10:42:39 Listening for VNC connections on TCP port 3389
Set framebuffer: buffer=7f7889186010 w=800 h=600 bpp=32
Set framebuffer: buffer=7f787edbe000 w=640 h=480 bpp=32
Set framebuffer: buffer=221ce70 w=720 h=400 bpp=32
Set framebuffer: buffer=20f0e60 w=640 h=480 bpp=32
```

### Starting the system
```
VBoxHeadless --startvm ${VBOX_NAME}
```

### Remove bootable CDROM to setting the medium to none !
```
VBoxManage storageattach ${VBOX_NAME} --storagectl "IDE Controller" --port 0 --device 1 --type dvddrive --medium none
```

### Move from NAT to Bridged configuration
```
VBoxManage modifyvm ${VBOX_NAME} --nic1 bridged --bridgeadapter1 eth0
```


### cut n' paste
```
wget http://ubuntu.mirror.root.lu/ubuntu-releases//precise/ubuntu-12.04-beta1-server-amd64.iso
export VBOX_NAME="ubuntu-devel"
VBoxManage createvm --name ${VBOX_NAME} --ostype Ubuntu_64 --register
VBoxManage modifyvm ${VBOX_NAME} --memory 4000 --acpi on --boot1 dvd
VBoxManage createhd --filename ~/VirtualBox\ VMs/${VBOX_NAME}/${VBOX_NAME}.vdi --size 30000
VBoxManage storagectl ${VBOX_NAME} --name "IDE Controller" --add ide --controller PIIX4
VBoxManage storageattach ${VBOX_NAME} --storagectl "IDE Controller" --port 0 --device 0 --type hdd --medium ~/VirtualBox\ VMs/${VBOX_NAME}/${VBOX_NAME}.vdi
VBoxManage modifyvm ${VBOX_NAME} --nic1 nat
VBoxManage storageattach ${VBOX_NAME} --storagectl "IDE Controller" --port 0 --device 1 --type dvddrive --medium ubuntu-12.04-beta1-server-amd64.iso
VBoxHeadless --startvm ${VBOX_NAME} -n -m 5900
```

### destroy
```
rm -r ~/VirtualBox\ VMs/${VBOX_NAME}
```
