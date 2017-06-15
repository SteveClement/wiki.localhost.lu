# IpV6

[IPv6 Wikipedia](https://en.wikipedia.org/wiki/IPv6)

Always funny how at first you tell people how to disable a feature and then end up encouraging them to enable it again, Welcome to IPv6

To get IPv6 somewhat going at the moment you need to have any IPv6 Tunneling account.

You could go native but then you need to call you support guy at your local ISP and they might not really know what the heck you are talking about.


## IPv6 Address types

Unicast
 Packet sent to unicast address arrives exactly at the interface belonging to that address.

Anycast
 Syntactically the same to Unicast addresses but address a group of Interfaces (may only be used by routers) Packets destined for the unicast address will arrive at the nearest (in router metric) interface.

Multicast
 Identifies a group of interfaces. Packets destined for a multicast address arrive at all the interfaces belonging to the multicast group

## IPv6 Address

### Overview
The full form is 8 hexquad parcel of 16bits each written in lower case hex. (seperator - colon (:))

Example: 2001:0db8:382b:23c1:aa49:4592:4efe:9982

Leading 0's are omited. You are allowed one grouping of 0's via the :: notation.

Example: fe80:0000:0000:0000:0000:0000:0000:1

Short form: fe80::1

Another possibility is writing the last 32 bits in the well-known IPv4 notation.

Example: 2002::10.0.0.1

Long form: 2002:0000:0000:0000:0000:0000:0a00:0001

Canonical form: 2002::a00:1

# Auto conf

The auto configuration part of the protocol gets done via the Mac Address of the Interface (IEEE EUI-48(MAC)) which in turn will be a IEEE EUI-64

# Special IPv6 address ranges

```
:: (128) -> 0.0.0.0 default route and route solicitations
::1 (128) -> v6 localhost
::ffff:a.b.c.d (96) -> IPv4 mapped IPv6 address
fe80:: (10) -> link-local - unroutable autoconfigured address
fc00:: (7) -> unique local - Addresses used only within an (A)utonomeous (S)ystem unroutable globally (c.f NAT RFC1918)
ff:: (8) multicast
2000:: (3) global unicast

2001:db8:: (32) documentation examples - not to be routed
2001:0:: (32) Teredo tunnels - remaining bits come from a TEredo server and the client NAT device
2002:: (16) 6to4 tunnels - the next 32 btis are the client IPv4 Address
```

## 6to4

Currently IPv6 traffic is passed via a 4to6 tunnel. IPv4 protocol 41 encapsulation.

### point to point

Some companies provide free 6in4 tunneling services. (Hurricane Electric, SixXS, freenet6)

### anycast tunnels

Tunnel via 6to4 - RFC3068 - protocol 41 IP in IP - Public IPv4 needed - Relay Address is the special anycast destination 192.88.99.1 - IPv6 uses 2002::/8

### UDP over NAT tunnels

The Teredo protocol client is the Miredo package. It can be used by dual-stack clients on private IPv4 addresses behind NAT routers or firewalls.

## tests

 ping6 ipv6.google.com
 
 lynx http://[2001:7e8:2209:1000::2]

## References

 * Early 90' we ran out of IPv4 subnets, so we converted to Classless Inter Domain Routing (CIDR) RFC4632
 * Address depletion was countered by Network Address Translation NAT - RFC1918
 * Routing Tables are growing too big (still an issue to date)

## Keypoints IPv6 

 * 128bit Address Space, 2^40^ subnets organizing 2^50^ hosts
 * Smaller routing table due to better geographic and more hierarchical allocations. Generally 1/7th as many routes as IPv4 subnets.

 * Adress autoconf - RFC2462
 * Anycast address
 * Mandatory multicast address
 * IPsec
 * Simplified header structure
 * Mobile IP
 * IPv6-to-IPv4 transition mechanisms

https://www.freebsd.org/doc/en/books/developers-handbook/ipv6.html
v6 + oBsd
https://webcache.googleusercontent.com/search?q=cache:jr6Iq4J6sEoJ:kurt.seifried.org/2010/04/26/ipv6-and-openbsd-part-1/+&cd=10&hl=en&ct=clnk&gl=lu


