```
echo "net-mgmt/net-snmp: WITH_IPV6|NET_SNMP_SYS_CONTACT=\"snmp@yourdomain.lu\"|NET_SNMP_SYS_LOCATION=\"Luxembourg\"|DEFAULT_SNMP_VERSION=3|BATCH=\"YES\"|NET_SNMP_LOGFILE=\"/var/log/snmpd.log\"" >> /usr/local/etc/ports.conf
echo "snmpd_enable=\"YES\"" >> /etc/rc.conf

portinstall net-mgmt/net-snmp
```

```
snmpconf -i
```

creates /usr/local/etc/snmp/snmpd.conf

Do not use snmp Version 1 unless you know that it is all plaintext

We use snmp Version 3 with Users and Passwords

```
Default read user: leame
Default password: emael3_v2


Default write user: reame
Default password: rmael3_v2
```

RRD Tool for very basic Bandwidth monitoring.

```
portinstall rrdtool

mkdir /usr/local/rrd && cd /usr/local/rrd
rrdtool create bandwidth.rrd --start N DS:in:COUNTER:600:U:U DS:out:COUNTER:600:U:U RRA:AVERAGE:0.5:1:432

snmpwalk -v 2c -c readme localhost
snmpget -v 2c -c readme -Oqv localhost IF-MIB::ifInOctets.1 IF-MIB::ifOutOctets.1
rrdupdate /usr/local/rrd/bandwidth.rrd N:\
      `/usr/local/bin/snmpget -v 1 -c <your community string> -Oqv localhost
      IF-MIB::ifInOctets.1`:\
            `/usr/local/bin/snmpget -v 1 -c <your community string> -Oqv
            localhost IF-MIB::ifOutOctets.1`
```


```
#!/bin/sh
/usr/local/bin/rrdtool graph /usr/local/rrd/bandwidth.png -a PNG -h 125 -s -129600 -v "Data Throughput" \
    'DEF:in=/usr/local/rrd/bandwidth.rrd:in:AVERAGE' \
    'DEF:out=/usr/local/rrd/bandwidth.rrd:out:AVERAGE' \
    'CDEF:kbin=in,1024,/' \
    'CDEF:kbout=out,1024,/' \
    'AREA:in#00FF00:Bandwidth In' 'LINE1:out#0000FF:Bandwidth Out\j' \
    'GPRINT:kbin:LAST:Last Bandwidth In\:    %3.2lf KBps' 'GPRINT:kbout:LAST:Last Bandwidth Out\:   %3.2lf KBps\j' \
    'GPRINT:kbin:AVERAGE:Average Bandwidth In\: %3.2lf KBps' 'GPRINT:kbout:AVERAGE:Average Bandwidth Out\:%3.2lf KBps\j'
```


## Crontab entry

```
0-55/5 * * * * /usr/local/bin/rrdupdate /usr/local/rrd/bandwidth.rrd N:`/usr/local/bin/snmpget -v 1 -c <your community string> -Oqv localhost IF-MIB::ifInOctets.1`:`/usr/local/bin/snmpget -v 1 -c <your community string> -Oqv localhost IF-MIB::ifOutOctets.1`
```


## net-snmp port pkg-message

```
**** This port installs snmp daemon, header files and libraries but don't
     invokes snmpd by default.
     If you want to invoke snmpd and/or snmptrapd at startup, put these
     lines into /etc/rc.conf.

        snmpd_enable="YES"
        snmpd_flags="-a -p /var/run/snmpd.pid"
        snmptrapd_enable="YES"
        snmptrapd_flags="-a -p /var/run/snmptrapd.pid"

**** You may specify the following make variables:

        NET_SNMP_SYS_CONTACT="kuriyama@FreeBSD.org"
        NET_SNMP_SYS_LOCATION="Tokyo, Japan"
        DEFAULT_SNMP_VERSION=3
        NET_SNMP_MIB_MODULES="host smux mibII/mta_sendmail ucd-snmp/diskio"
        NET_SNMP_LOGFILE=/var/log/snmpd.log
        NET_SNMP_PERSISTENTDIR=/var/net-snmp

     to define default values (or overwriting defaults).  At least
     setting first two variables, you will not be prompted during
     configuration process.  You may also set

        BATCH="yes"

     to avoid interactive configuration.
```


## adding apache2 support

```
cd /tmp
wget http://mesh.dl.sourceforge.net/sourceforge/mod-apache-snmp/mod_ap2_snmp_1.04.tar.gz
tar xfvz mod_ap2_snmp_1.04.tar.gz

echo "net-mgmt/net-snmp: WITHOUT_IPV6|NET_SNMP_MIB_MODULES=ap2_snmp" >> /usr/local/etc/ports.conf
cd /usr/ports/net-mgmt/net-snmp
make clean extract
cd work/net-snmp-5.2.3/
cp -r /tmp/mod_ap2_snmp_1.04/net-snmp-module agent/mibgroup/apache2
cp /tmp/mod_ap2_snmp_1.04/extra/ap2_snmp.h agent/mibgroup/
cp /tmp/mod_ap2_snmp_1.04/mib/APACHE2-MIB.TXT mibs/
cd /usr/ports/net-mgmt/net-snmp
make configure
WITH_IPV6=yes NET_SNMP_SYS_CONTACT="snmp@yourdomain.lu"
NET_SNMP_SYS_LOCATION="Luxembourg" DEFAULT_SNMP_VERSION=3 BATCH="YES"
NET_SNMP_MIB_MODULES_LIST=ap2_snmp make configure



cd /tmp/mod_ap2_snmp_1.04
libs_net_snmp="/usr/local/lib"
incs_net_snmp="/usr/local/include"
/usr/local/sbin/apxs -a -i -c -L$libs_net_snmp -I$incs_net_snmp mod_ap2_snmp.c -lnetsnmp -lcrypto -O2
```


## adding legacy apache 1.3 support

### This will core dump

```
echo "www/apace13-modssl: WITH_APACHE_MODSNMP|WITHOUT_APACHE_IPV6|WITH_APACHE_MODACCEL|WITH_APACHE_MODDEFLATE" >> /usr/local/etc/ports.conf
```


## I suggest updating to apache 2

### ASTERISK

```
http://www.voipphreak.ca/archives/382
```