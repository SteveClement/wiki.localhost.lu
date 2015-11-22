## Downloading the Requirements

The first step, of course, is to download VMware Server 1.0.6. You’ll want to download the .tar.gz version.  This command can be used for a direct download:
```
    wget -c http://download3.vmware.com/software/vmserver/VMware-server-1.0.6-91891.tar.gz
```

The second step is to install some development tools that we’ll need to get things running. Use the following command or click the package names to install the requirements:

```
    sudo aptitude install build-essential linux-kernel-devel linux-headers-server xinetd xorg-dev
    ln -s /usr/src/linux-headers-2.6.24-19-server /usr/src/linux
```

You will also need to generate a serial number to run VMware Server. Visit this link to register and generate the number of codes you might want. Remember to print the codes or write them down because in my experience they are not emailed to you.

OK, at this point we should have all of the requirements, now we can get to work…

## Installation and Configuration

Let’s unpack the VMware archive that we downloaded and run the VMware installer.

```
    tar xf VMware-server-1.0.6-*.tar.gz
    cd vmware-server-distrib
    sudo ./vmware-install.pl
```

## The Last Step

If you attempt to run vmware at this point you might notice that it spits out some nasty errors and complains at you. There is one more thing we need to setup.

Basically VMware is missing and complaining about some cairo libraries and gcc. 
```
    sudo ln -sf /usr/lib/gcc/i486-linux-gnu/4.2.3/libgcc_s.so /usr/lib/vmware/lib/libgcc_s.so.1/libgcc_s.so.1
    sudo ln -sf /usr/lib/libpng12.so.0 /usr/lib/vmware/lib/libpng12.so.0/libpng12.so.0
```

## VMWARE ESXi SSH

ESXi 3.5 does ship with the ability to run SSH, but this is disabled by default (and is not supported).

1) At the console of the ESXi host, press ALT-F1 to access the console window.
2) Enter unsupported in the console and then press Enter. You will not see the text you type in.
3) If you typed in unsupported correctly, you will see the Tech Support Mode warning and a password prompt. Enter the password for the root login.
4) You should then see the prompt of ~ #. Edit the file inetd.conf (enter the command vi /etc/inetd.conf).
5) Find the line that begins with #ssh and remove the #. Then save the file. If you're new to using vi, then move the cursor down to #ssh line and then press the Insert key. Move the cursor over one space and then hit backspace to delete the #. Then press ESC and type in :wq to save the file and exit vi. If you make a mistake, you can press the ESC key and then type it :q! to quit vi without saving the file.
6) Once you've closed the vi editor, run the command /sbin/services.sh restart to restart the management services. You'll now be able to connect to the ESXi host with a SSH client.
