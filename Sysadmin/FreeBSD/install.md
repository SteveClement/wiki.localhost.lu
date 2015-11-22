# Installing FreeBSD made easy

Download ISO

Create new VM
 Allocate at least 512MB RAM
 Allocate at least 4 GB Harddisk
 Allocate at least 12MB Video RAM
 Set Hardware Clock to UTC option
 Disable Audio
 Disable Floppy Boot
Load ISO to boot from

Start VM

Boot Default from Menu

Select Country

Select Keymap

Select (S)tandard Install

On the FDISK Screen press: a
Then: q

Select non-interactive Boot Manager

## Disklabel Editor

The most interesting and tricky part of the setup.

If you want to play around with FreeBSD it is safe to Press: a

This will do the following layout on a 4GB Disk (512M RAM):

```
ad0s1a /    563M
ad0s1b swap 153M
ad0s1d /var 870M
ad0s1e /tmp 217M
ad0s1f /usr 2292M
```


This is what it looks like on a 8GB Disk (512M RAM):

```
ad0s1a /    716M
ad0s1b swap 429M
ad0s1d /var 1945M
ad0s1e /tmp 486M
ad0s1f /usr 4614M
```

This is what it looks like on a 8GB Disk (1G RAM):

```
ad0s1a /    691M
ad0s1b swap 783M
ad0s1d /var 1766M
ad0s1e /tmp 441M
ad0s1f /usr 4510M
```


In my personal experience this is not an optimal layout.
To play around no problem but for serious servers a big no go.

## Defining Disk Layout

What server do I want to Install?

* Database
* Web
* File
* Malware
* Log

In each scenario you should be aware that different directories grow differently in sizes.

Pro & Contra of this setup 

Potentially more flexible. Better for restoration. Better for Management. 

But what about just making this layout:

```
ad0s1a /    4.5G
ad0s1b swap 512M
```

For the sake of this exercise we do a Kern-Developer Install (Gives us all the goodies we need and can be extended easily afterwards)


 Would you like to configure any Ethernet network devices?

Sure :)

 IPv6 AutoConf?

Naj

 DHCP?

For real!

 Hostname! (reverse DNS #foo)
 DomainName (.lan/.local)

 Gateway?

You nuts?

 inetd?

get a life!

 SSH?

yep


 Anonymous FTP?

pr0n?

 NFS Server?

nope

 NFS Client?

Njet!

 Console Settings Customizations?

Better not.

 TimeZone?

Yeah (UTC)

 TZ?

Depends where you at. Europe/Luxembourg for us.

 Mouse?

Cmon' you a n00b

 FreeBSD Package Collection?

No, we have ports.

 Add additional User?

Yes. (add group for $LUSER)
Put $LUSER into wheel

Reboot. (eject Media)
