```
sudo apt-get install pptpd
```

Now edit pptpd's config (/etc/pptpd.conf). At the bottom you'll find settings for localip and remoteip. Here's what mine looks like:

```
localip 172.198.1.4
remoteip 172.198.2.50-51
```

localip is the IP of an adapter in the server (yours might be 192.168.0.10 for example)
remoteip: the IPs that clients are allowed to use (i allowed mine to use 172.198.2.50 through 172.198.2.51)

Now we'll set up some users, so edit the chap-config config file(/etc/ppp/chap-secrets). I want to allow two users, so my chap-secrets file looks like this:

```
# client        server  secret                  IP addresses
rich             pptpd   apassword                80.40.0.0/13
geoff             pptpd   apassword                212.219.0.0/14
```

... which allows users rich and geoff, with the passwords 'apassword' to be accepted from those IP subnets. * can be used to allow all IPs. see pppd/chap-secrets man page for more info

You may be good to go at this point. Restart pptpd (sudo /etc/init.d/pptpd restart) and attempt to connect. If it doesn't work, check /var/log/messages for a notice that looks a bit like this:

```
Apr 10 09:49:42 beryllium pppd[9619]: Plugin /usr/lib/pptpd/pptpd-logwtmp.so is for pppd version 2.4.3, this is 2.4.4
```

If you see that, then we need to change pptpd-logwtmp's version number.

This info kindly lifted from CyberAngel at the Ubuntuforums.

We now need a few more things:

```
sudo apt-get install libwrap0-dev debhelper
sudo apt-get source pptpd
cd pptpd-1.3.0/plugins
sudo vim patchlevel.h
```

Change:

```
#define VERSION         "2.4.3"
```

To:

```
#define VERSION         "2.4.4"
```

Save the file and now do:

```
cd ../../
sudo apt-get -b source pptpd
sudo dpkg -i pptpd_1.3.0-1ubuntu1_i386.deb
sudo dpkg -i bcrelay_1.3.0-1ubuntu1_i386.deb
```

Done! Now restart pptpd:

```
sudo /etc/init.d/pptpd restart
```

And you should be good to go!

All you need to do now is add a VPN network connection and connect with the username/password that you set up. Don't forget to hit the IPv4 TCP/IP settings on your client machines for the VPN connection and to untick "Use default gateway on remote network" if you need to (you probably will).

You will also need to change some security settings (image):

```
VPN Connection > Properties > [Security Tab] -> Advanced
```

Allow these protocols: (tick) Microsoft CHAP Version2