# Pi-hole on OpenBSD

```
$ doas pkg_add -v dnscrypt-proxy
```

We need to edit the /etc/dnscrypt-proxy.toml with the relevant options, including making sure that the daemon is listening on the gateway for the alpine VM. The setup below is very secure, but adds extra overhead by negotiating new cryptographic keys with each DNS query. The default configuration file is very well commented, so we can adjust the parameters as necessary.

```
server_names = ['cloudflare']

listen_addresses = ['127.0.0.1:53', '10.0.0.1:53', '[::1]:53']

max_clients = 250

user_name = '_dnscrypt-proxy'

ipv4_servers = true

ipv6_servers = false

dnscrypt_servers = true

doh_servers = true

require_dnssec = true

require_nolog = true

require_nofilter = true

force_tcp = false

timeout = 2500
keepalive = 30

log_level = 2
log_file = '/var/log/dnscrypt-proxy.log'
use_syslog = false

cert_refresh_delay = 240
dnscrypt_ephemeral_keys = true
tls_disable_session_tickets = true

fallback_resolver = '9.9.9.9:53'
ignore_system_dns = false
```

```
$ echo 'inet 10.0.0.1 255.255.255.0' | doas tee -a /etc/hostname.vether1 && doas sh /etc/netstart vether1
```

Then we create an Ethernet bridge called bridge0:

```
$ echo 'add vether1' | doas tee -a /etc/hostname.bridge1 && doas sh /etc/netstart bridge1
```

Start and enable the daemon:

```
$ doas rcctl start dnscrypt_proxy &&  doas rcctl enable dnscrypt_proxy
```

Update the OpenBSD /etc/resolv.conf file to take advantage of encrypted DNS:

```
$ echo "nameserver 127.0.0.1
lookup file bind" | doas tee /etc/resolv.conf
```

We are assuming that we will use bridged networking with a virtual Ethernet for the alpine virtual machine in this case. This requires that ip.forwarding is enabled. We also want it to persist across reboots.

```
$ doas sysctl net.inet.ip.forwarding=1 && echo "net.inet.ip.forwarding=1" | doas tee -a /etc/sysctl.conf
```

We need to configure a virtual switch for the network. As usual, it helps to read the official OpenBSD documentation, but the basic setup is to create a bridge device and a vether interface. We want these to persist across reboots, so we can use the hostname.if configuration files to do so. First, we can create the virtual ethernet. In this case, we’ll call it vether0:

Next we need to edit our pf.conf to allow our packets to get to and from the virtual machine. The simplest addition to the default rules is the following, although more specific rules are certainly possible:

```
match out on egress from vether1:network to any nat-to (egress)
```

Now we configure the switch in our /etc/vm.conf. It is possible to set this up manually, but we need this for persistence anyway. We can name the switch whatever we want, in this case alpine_switch.At the top of the file add something such as:

```
switch "alpine_switch" {
    interface bridge1
}
```

Enable vmd to start at boot and start the daemon to boot the newly installed alpine VM:

```
$ doas rcctl enable vmd && doas rcctl start vmd
```

Download an alpine linux iso. Choose the “Standard” or “Extended” options, as the “Virtual” kernel seems to be having some difficulty with the serial console at the moment.

Create a virtual disk for the alpine installation:

```
$ vmctl create alpine.img -s 512M
```

Boot the alpine iso in vmm to install alpine to disk:

```
$ doas vmctl start -c \
    -d "/home/misp/alpine.iso" \
    -d "/home/misp/alpine.img" \
    -m 512M \
    -n "alpine_switch" alpine
```

Install alpine to the virtual disk using the serial console and enable ssh.

```
$ doas vmctl console alpine
Connected to /dev/ttyp0 (speed 115200)

Welcome to Alpine Linux 3.8
Kernel 4.14.79-0-vanilla on an x86_64 (/dev/ttyS0)

localhost login: root
Welcome to Alpine!

The Alpine Wiki contains a large amount of how-to guides and general
information about administrating Alpine systems.
See <http://wiki.alpinelinux.org>.

You can setup the system with the command: setup-alpine

You may change this message by editing /etc/motd.

localhost:~# setup-alpine

Follow the prompts from the setup-alpine script, making sure to setup the network, change the root password and pick an installation mirror. Install and enable openssh when prompted.

An example network configuration is below.

Enter system hostname (short form, e.g. 'foo') [alpine]:
Available interfaces are: eth0.
Enter '?' for help on bridges, bonding and vlans.
Which one do you want to initialize? (or '?' or 'done') [eth0]
Ip address for eth0? (or 'dhcp', 'none', '?') [dhcp] 10.0.0.3/24
Gateway? (or 'none') [10.0.0.1]
Configuration for eth0:
  type=static
  address=10.0.0.3
  netmask=255.255.255.0
  gateway=10.0.0.1
Do you want to do any manual network configuration? [no] 
DNS domain name? (e.g 'bar.com') [] 
DNS nameserver(s)? [] 10.0.0.1
```

Choose the virtual disk when prompted, and then pick either sys for persistent disk installation or lvmsys to setup lvm.

```
Available disks are:
  vda   (6.4 GB 0x0b5d )
Which disk(s) would you like to use? (or '?' for help or 'none') [none] vda
The following disk is selected:
  vda   (6.4 GB 0x0b5d )
How would you like to use it? ('sys', 'data', 'lvm' or '?' for help) [?] lvmsys
WARNING: The following disk(s) will be erased:
  vda   (6.4 GB 0x0b5d )
WARNING: Erase the above disk(s) and continue? [y/N]: y
Creating file systems...
  Physical volume "/dev/vda2" successfully created.
  Logical volume "lv_swap" created.
  Logical volume "lv_root" created.
 * service lvm added to runlevel boot
Installing system on /dev/vg0/lv_root:
/mnt/boot is device /dev/vda1
100% ############################################==> initramfs: creating /boot/initramfs-virt
/boot is device /dev/vda1

Installation is complete. Please reboot.
alpine:~# poweroff
```

Edit /etc/vm.conf on OpenBSD with the options required to set up your virtual machine automatically on boot:

```
vm "alpine" {
	cdrom "/path/to/alpine.iso"
	disk "/path/to/alpine.img"
	owner <user>
	memory 2G
	interface { switch "alpine_switch" }
	enable # this is the default / change to "disable" to not start the vm at boot
}
```

Connect to the serial console again to install an ssh key on the alpine VM. Also setup the apk repositories to use HTTPS and enable community and testing and update the system:

alpine:~# cat >/etc/apk/repositories<<_EOF && apk upgrade -U
https://alpine.mirror.wearetriple.com/edge/main
https://alpine.mirror.wearetriple.com/edge/community
https://alpine.mirror.wearetriple.com/edge/testing
_EOF
fetch https://alpine.mirror.wearetriple.com/edge/main/x86_64/APKINDEX.tar.gz
fetch https://alpine.mirror.wearetriple.com/edge/community/x86_64/APKINDEX.tar.gz
fetch https://alpine.mirror.wearetriple.com/edge/testing/x86_64/APKINDEX.tar.gz
OK: 290 MiB in 67 packages

Install, enable, and start Docker and whatever other nice-to-haves on alpine:

alpine:~# apk add docker tmux iproute2 tcpdump tshark wireguard-tools &&
    rc-update add docker &&
    /etc/init.d/docker start
(1/18) Installing libmnl (1.0.4-r0)
(2/18) Installing jansson (2.11-r0)
(3/18) Installing libnftnl-libs (1.1.1-r0)
(4/18) Installing iptables (1.6.2-r0)
(5/18) Installing libltdl (2.4.6-r5)
(6/18) Installing libseccomp (2.3.3-r1)
(7/18) Installing docker (18.06.1-r0)
Executing docker-18.06.1-r0.pre-install
(8/18) Installing docker-openrc (18.06.1-r0)
(9/18) Installing libelf (0.8.13-r3)
(10/18) Installing iproute2 (4.19.0-r0)
Executing iproute2-4.19.0-r0.post-install
(11/18) Installing libpcap (1.8.1-r1)
(12/18) Installing tcpdump (4.9.2-r4)
(13/18) Installing ncurses-terminfo-base (6.1_p20180818-r1)
(14/18) Installing ncurses-terminfo (6.1_p20180818-r1)
(15/18) Installing libevent (2.1.8-r6)
(16/18) Installing ncurses-libs (6.1_p20180818-r1)
(17/18) Installing tmux (2.7-r0)
(18/18) Installing wireguard-tools (0.0.20181018-r0)
Executing busybox-1.29.3-r2.trigger
OK: 293 MiB in 71 packages
 * service docker added to runlevel default
 * Starting docker ...                                                    [ ok ]

Pull the Pi-hole docker image to the host:

alpine:~# docker pull pihole/pihole
latest: Pulling from pihole/pihole
f17d81b4b692: Pull complete 
f173a7e32ba0: Pull complete 
789a21c8d73f: Pull complete 
18b9c4527d4c: Pull complete 
fb59b1419096: Pull complete 
1579ff407b87: Pull complete 
a177c6f65516: Pull complete 
5e9feae54ea7: Pull complete 
Digest: sha256:1f0e73d50ef5d824f24f90ccf71a4039ecd23aa18d9b6a329f2e6f78d407e859
Status: Downloaded newer image for pihole/pihole:latest

We need a directory on the alpine VM that we can map to the Pi-hole Docker container which will contain persistent configuration information. An obvious choice would be to put it in /etc/pihole:

alpine:~# mkdir /etc/pihole

Create a script with the appropriate parameters for launching the Pi-hole Docker container. We can put it in /usr/local/bin/launch_pihole or so. A good explanation of all of the options and environment variables is in the pi-hole/docker-pi-hole GitHub repository.

#!/bin/sh

DOCKER_CONFIGS="/etc/pihole"
IP="10.0.0.3"

docker run -d \
    --name pihole \
    -p 53:53/tcp -p 53:53/udp \
    -p 80:80 \
    -p 443:443 \
    -v "${DOCKER_CONFIGS}/pihole/:/etc/pihole/" \
    -v "${DOCKER_CONFIGS}/dnsmasq.d/:/etc/dnsmasq.d/" \
    -e ServerIP="${IP}" \
    -e WEBPASSWORD= \
    --restart=unless-stopped \
    --dns=127.0.0.1 \
    -e DNS1=10.0.0.1 \
    -e DNS2=no \
    -e IPv6=False \
    pihole/pihole:latest

We have disabled IPv6 and the password for the web admin interface, as well as the Pi-hole’s built-in DHCP server. Additionally, we are setting the upstream DNS provider as the instance of dnscrypt-proxy running on the OpenBSD host. Now we want to bring up this new ad blocker:

alpine:~# chmod +x /usr/local/bin/launch_pihole && launch_pihole

Now we can check if it’s running:

alpine:~# docker ps --format 'table {{.Image}}\t{{.Names}}\t{{.Status}}' &&
    docker ps --format  'table {{.Ports}}'
IMAGE                  NAMES               STATUS
pihole/pihole:latest   pihole              Up 2 minutes (healthy)
PORTS
0.0.0.0:53->53/tcp, 0.0.0.0:80->80/tcp, 0.0.0.0:443->443/tcp, 0.0.0.0:53->53/udp, 67/udp

Next we want to check if the web interface is working from our OpenBSD host:

$ chrome --enable-unveil "10.0.0.3/admin"

Finally, we must change the DNS on OpenBSD such that we are benefiting from the Pi-hole. First we can edit the /etc/dhclient.conf so that it will override the DNS servers advertised by various WiFi Access Points. Keep in mind that this may cause connectivity issues in certain instances.

$ echo 'supersede domain-name-servers 10.0.0.3;' | doas tee -a /etc/dhclient.conf &&
    doas sh /etc/netstart

Now we can verify that we are using Cloudflare’s DNS server:

are blocking ads without a browser extension:

And are benefiting from DNSSEC:

