# Install
```
apt-get install snmpd
```

# Configure
```
vi /etc/snmp/snmpd.conf
cd /etc/default
vi snmpd
```

# Start
```
/etc/init.d/snmpd start
```

# by source
```
./configure --enable-shared --enable-internal-md5 \
--with-default-snmp-version=3 --with-sys-contact=steve@ion.lu \
--with-sys-location=IONHQ --with-logfile=/var/log/snmpd.log \
--with-persistent-directory=/var/net-snmp --with-dummy-values \
--enable-embedded-perl --with-perl-modules --disable-ipv6 --prefix=/usr \
--mandir=/usr/share/man --infodir=/usr/share/info --sysconfdir=/etc/snmp
```

# Notes

http://www.cyberciti.biz/faq/debain-ubuntu-install-net-snmpd-server/
