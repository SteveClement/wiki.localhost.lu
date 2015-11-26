:warning: Obsolete.

# OpenVPN in Gentoo
## Kernel conf

```
Network Device Support:
-> Universal TUN/TAP Driver
```

either ass module (tun.o) or compiled in, as you wish.

```
echo tun >> /etc/modules.autoload.d/kernel-2.6
```

all files must reside in /etc/openvpn/*/

where * is a "config name" like my-vpn

/etc/openvpn/my-vpn/
-> certs
-> bin
local.conf

local.conf is the usual openvpn.conf

don't forget to check if tun.o is loaded automatically...
also /dev/net/tun must exist
the route command is different on Linux:

```
route add -net $NET netmask $MASK gw $GW
```
