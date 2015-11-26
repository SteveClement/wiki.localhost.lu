To Install the latest bind you need to compile from source on Debian (sarge)

First make sure you have the deb-src package in your sources.list

Make sure your up2date
```
apt-get update; apt-get upgrade
```

to compile bind 9.5 with MySQL DLZ support you need the compile environment aswell as the mysql headers:

```
apt-get install devscripts libmysqlclient15-dev

mkdir ~/bind95-dlz
cd ~/bind95-dlz
```

Now compile and install lsb;
```
apt-get -y build-dep lsb-base
apt-get source lsb-base -b
dpkg-i lsb-base*.deb 
```

Now get bind 9.5:
```
apt-get -y build-dep bind9
apt-get source bind9
cd bind9-9.5*/debian
vi rules
# now find :  --with-dlz-mysql=no \
# and set it to yes
apt-get source bind9 -b
dpkg -i *.deb 
```