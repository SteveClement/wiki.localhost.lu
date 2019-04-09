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

:warning: This will give VNC access without password

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

### List Disks
```
vboxmanage list hdds
```

### Delete disks
```
vboxmanage closemedium disk <uuid> --delete
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

## Create/Manage VirtualBox VMs from the Command Line

### Create the VM

```
VBoxManage createvm --name "io" --register
VBoxManage modifyvm "io" --memory 512 --acpi on --boot1 dvd
VBoxManage modifyvm "io" --nic1 bridged --bridgeadapter1 eth0
VBoxManage modifyvm "io" --macaddress1 XXXXXXXXXXXX
VBoxManage modifyvm "io" --ostype Debian
```

### Attach storage, add an IDE controller with a CD/DVD drive attached, and the install ISO inserted into the drive

```
VBoxManage createhd --filename ./io.vdi --size 10000
VBoxManage storagectl "io" --name "IDE Controller" --add ide

VBoxManage storageattach "io" --storagectl "IDE Controller"  \
    --port 0 --device 0 --type hdd --medium ./io.vdi

VBoxManage storageattach "io" --storagectl "IDE Controller" \
    --port 1 --device 0 --type dvddrive --medium debian-6.0.2.1-i386-CD-1.iso
```

### Starting the VM for installation

```
VBoxHeadless --startvm "io" &
```

### This starts the VM and a remote desktop server. Redirect RDP port if necessary,

```
ssh -L 3389:127.0.0.1:3389 <host>
```

### Shutting down the VM

```
VBoxManage controlvm "io" poweroff
```

### Remove install Media

```
VBoxManage modifyvm "io" --dvd none
```

### Alternatively install OS using the GUI, configure it then export is as an appliance upload to the server then import it using

```
VBoxManage export "io" --output ioClone.ovf
VBoxManage import ioClone.ovf
```

### Starting the VM

```
VBoxHeadless --startvm "io" --vrde off &
```
This starts the VM without remote desktop support.

### Delete the VM

```
VBoxManage unregistervm io --delete
```

### Mount Guest Additions

```
VBoxManage storageattach "io" --storagectl "IDE Controller" \
    --port 1 --device 0 --type hdd --medium /usr/share/virtualbox/VBoxGuestAdditions.iso
```

### Install Guest Additions

```
mkdir /mnt/dvd
mount -t iso9660 -o ro /dev/dvd /mnt/dvd
cd /mnt/dvd
./VBoxLinuxAdditions.run
```

### Adding/removing shared folders

```
vboxmanage sharedfolder add "io" --name share-name --hostpath /path/to/folder/ --automount
vboxmanage sharedfolder remove "io" --name share-name
```

### To mount it on the guest

```
sudo mount -t vboxsf -o uid=$UID share-name /path/to/folder/share/
```
