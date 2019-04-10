# Resize qcow2 image

virsh shutdown hostname
qemu-img resize ubuntu-server.qcow2 +5GB
virsdh edit hostname

http://gparted.sourceforge.net/download.php

Add boot cd:

<boot dev='cdrom'/>
<source file='/mnt/iso/gparted-live-0.16.1-1-i486.iso'/>
<target dev='hdc' bus='ide'/>
<readonly/>
</disk>

