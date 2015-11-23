# General update notes on FreeBSD via ports

It is common to start daemons in /etc/rc.conf

For ssh add:

```
  sshd_enable="YES"
```

into the rc.conf. (That is the new rcNG scipting) More and more ports adopt that nomenclature. So even if you install or upgrade something put it into the rc.conf if it is to be started automatically. This will prevent failures once the port adopts to rcNG.

So do check wether you port that you're upgrading is in rc.conf.

# Backups
Throughout the document we tried to apply all the necessary precautions to do a full roll-back if it fails. But even the biggest caution sometimes ends in a mess. Please don't blame US for your lack of Backups. The documentation assumes /home/bup to be the place for update-backups, this might grow enormous after some time.

# Todo
The To-Do list of this document is fairly short but then again the few things that need to be done are more of an ongoing house keeping thing. Adding more clever Backup Syntax, using excludes for large data. Removing, declaring obsolete certain ports, so to speak introducing a life-time for the different Sections.

# security updates ONLY
```
for a in `portaudit -a |grep Affected |cut -f 2 -d : |cut -f 1 -d-`; do portupgrade -Rri $a; done
```

# apache13

To upgrade apache 1.3.x (SSL) from ports:
```
 mkdir -p /home/bup/update/apache13
 tar -c -v -p -j --exclude /home/apache/hosts --exclude /home/apache/logs -f /home/bup/update/apache13/apache-`date +%d%m%y`.tbz /home/apache
 tar cfvpj /home/bup/update/apache13/apache-etc-`date +%d%m%y`.tbz /usr/local/etc/apache/
 pkg_create -v -x -b apache /home/bup/update/apache13/pkg-`date +%d%m%y`.tbz
 httpd -l > /home/bup/update/apache13/httpd.modules
 httpd -L >> /home/bup/update/apache13/httpd.modules
```

Check /etc/make.conf for:
```
 APACHE_DATADIR=/home/apache
 APACHE_DOCUMENT_ROOT=/home/apache/hosts/ion.lu/$HOSTNAME
```
( Obsolete!!!! Once you start the upgrade you will see a list of: WITH_APACHE options if you require one of them PLEASE put it in: /etc/make.conf )

Please put all the APACHE_ variables in /etc/make.conf and all the WITH_APACHE tuneables into ports.conf (if used)

All that needs to be done now is update the port in question and it's dependencies:

```
portupgrade -Rri www/apache13
```
A quick clean-up, this is only needed in an ION Install, it makes sure Apache resides in /home/apache and the necessary links are made to /usr/local/etc and removes the proxy directory.

```
cd /home/apache ; ln -s /us r/local/etc etc ; ln -s /usr/local/etc/apache/ conf ; ln -s /usr/local/libexec libexec ; mkdir logs ; rm -rvf proxy
```
Depending on your mod_* setup (php or dav for instance) you need to re-compile them.

# Apache13 to Apache13-modssl
This is a bit trickier, and the php modules need to be rebuilt aswell.

In brief:

Deinstall apache13 reinstall apache13-modssl

```
 cd /usr/ports/www/apache13 && make deinstall
 cd /usr/ports/www/apache13-modssl && make WITH_APACHE_MODACCEL=yes WITH_APACHE_MODDEFLATE=yes WITH_APACHE_PERF_TUNING=no reinstall
```
Bare in mind that we strongly recommend putting WITH_APACHE's into portsconf (portinstall ports-mgmt/portconf if not installed yet)

Attention:

 . For MODACCEL to work you need some specific config. uncomment: mod_freeze and mod_ranban

Update php, please follow the procedure http://php-link Update mod_dav, please follow the procedure http://mod_dav-link Update mod_*, please follow the procedure http://mod_*-link

# qmail-scanner-queue.sh
This might be obsolete

Files to be aware of: /var/qmail/bin/qmail-scanner-queue.sh /var/spool/qmailscan/

Backup files:

```
cp /var/qmail/bin/qmail-scanner-queue.pl /var/qmail/bin/qmail-scanner-queue.pl-`date +%d%m%y`
cd /var/spool && cp -rp qmailscan qmailscan-`date +%d%m%y`
cd ~software/unpacked && mv qmail-scanner-1.24 qmail-scanner-1.24-`date +%d%m%y`

cd ~software/archives && wget http://dl.sourceforge.net/sourceforge/qms-analog/qms-analog-0.4.4.tar.gz
cd ~software/archives && wget http://dl.sourceforge.net/sourceforge/qmail-scanner/qmail-scanner-1.25.tgz
cd ~software/unpacked && tar xfvz ../archives/qms-analog-0.4.4.tar.gz && tar xfvz ../archives/qmail-scanner-1.25.tgz

cd qms-analog-0.4.4/
gmake all
cp qmail-scanner-1.25-st-qms-20050618.patch ../qmail-scanner-1.25/
cd ../qmail-scanner-1.25/
patch -p1 < qmail-scanner-1.25-st-qms-20050618.patch
diff -u qms-config ../qmail-scanner-1.24-`date +%d%m%y`/qms-config
cp ../qmail-scanner-1.24-`date +%d%m%y`/qms-config .
chmod 755 qms-config
./qms-config
./qms-config install
diff -u /var/spool/qmailscan-`date +%d%m%y`/quarantine-attachments.txt /var/spool/qmailscan/quarantine-attachments.txt |grep -v \# |less
cp /var/spool/qmailscan-`date +%d%m%y`/quarantine-attachments.txt /var/spool/qmailscan/quarantine-attachments.txt
vi /var/spool/qmailscan/quarantine-attachments.txt
setuidgid qscand /var/qmail/bin/qmail-scanner-queue.pl -z
setuidgid qscand /var/qmail/bin/qmail-scanner-queue.pl -g
##chown -R qscand:qscand /var/spool/qmailscan

diff -u /var/qmail/bin/qmail-scanner-queue.pl /var/qmail/bin/qmail-scanner-queue.pl-`date +%d%m%y` |grep -v \# |less
vi /var/qmail/bin/qmail-scanner-queue.pl
```
sa_alt for sql support!!!

 . Alter: $sa_delete='6';
  . $spamc_subject="{SPAM?}"; $sa_alt='0';
 qmailctl restart

HURRAY ON 07022005 THIS ACTUALLY WORKED SEAMLESSLY :) ON LINION HURRAY ON 28062005 THIS ACTUALLY WORKED SEAMLESSLY :) ON REDX

# clamav
```
 mkdir -p /home/bup/update/clamav
 cp -p /usr/local/etc/rc.d/clamav-clamd.sh /home/bup/update/clamav/clamav-clamd.sh-`date +%d%m%y`
 cp -p /usr/local/etc/rc.d/clamav-freshclam.sh /home/bup/update/clamav/clamav-freshclam.sh-`date +%d%m%y`
 cp -p /usr/local/etc/clamd.conf /home/bup/update/clamav/clamd.conf-`date +%d%m%y`
 cp -p /usr/local/etc/freshclam.conf /home/bup/update/clamav/freshclam.conf-`date +%d%m%y`
 portupgrade -Rri clamav
 diff -u /usr/local/etc/rc.d/clamav-clamd.sh /home/bup/update/clamav/clamav-clamd.sh-`date +%d%m%y`
 diff -u /usr/local/etc/rc.d/clamav-freshclam.sh /home/bup/update/clamav/clamav-freshclam.sh-`date +%d%m%y`
 diff -u /usr/local/etc/clamd.conf /home/bup/update/clamav/clamd.conf-`date +%d%m%y`
 nohup clamd 2>&1 | /usr/local/bin/multilog t s100000 n20 /var/log/clamav &
```
AND AGAIN LOGGING TO STDOUT FAILS!!! 0.9 is a show stopper AT THIS POINT IT STILL DOESNT WORK :((( set User=root in clamd.conf

# Squirrelmail
Backup your Squirreldir:

```
 mkdir -p /home/bup/update/squirrelmail
 tar cfvpj /home/bup/update/squirrelmail/squirrelmail-`date +%d%m%y`.tbz /home/apache/hosts/croix-rouge.lu/webmail-lite
 tar cfvpj /home/bup/update/squirrelmail/squirrelmail-`date +%d%m%y`.tbz /home/apache/hosts/ion.lu/webmail-lite

 cd /usr/ports/mail/squirrelmail/
 WITH_DATABASE=YES WITH_LDAP=YES SQUIRRELDIR=/home/apache/hosts/ion.lu/webmail-lite make
 make install clean
 SQUIRRELDIR=/home/apache/hosts/healthnet.lu/webmail-lite make install
```
CLEANUP NEEDED

 . php.ini FileUploads=on

An older version of default_pref exists in /var/spool/squirrelmail/pref, you may want to compare it with the one in /home/apache/hosts/ion.lu/webmail-lite/data

If you have problems with SquirrelMail saying "you must login" after you just have, the following php.ini option may help: session.auto_start = 1

In order to do your administrative configuration you need to  cd /home/apache/hosts/ion.lu/webmail-lite && ./configure SquirrelMail will not work until this has been done.

CLEANUP

Change default version of ruby to 1.8 on i386

```
pkg_delete portupgrade-\* && cd /usr/ports/sysutils/portupgrade && make install clean

portupgrade -fr lang/ruby16
portupgrade -f lang/ruby18
pkg_deinstall -ri lang/ruby16 ##### This will deinstall ruby 1.6 Stuff handle with care
```
Change default version of perl to 5.8 on i386

```
portupgrade -o lang/perl5.8 -f perl-5.6.1_15
portupgrade -f p5-\*   ### Will upgrade all p5-* modules
```
Change default version of X_WINDOW_SYSTEM to xorg on i386

```
echo X_WINDOW_SYSTEM=xorg >> /etc/make.conf ### IF NOT ALREADY THERE. CHK FIRST
pkg_delete -f /var/db/pkg/imake-4* /var/db/pkg/XFree86-*
cd /usr/ports/x11/wrapper && make deinstall
cd /usr/ports/x11/xorg && make install clean
pkgdb -F
```

# Usermin
```
 mkdir -p /home/bup/update
 tar cfvpj /home/bup/update/usermin-`date +%d%m%y`.tbz /usr/local/etc/usermin
 portupgrade -Rri usermin
```

# Virtualmin
```
 mkdir -p /home/bup/update
 tar cfvpj /home/bup/update/usermin-`date +%d%m%y`.tbz /usr/local/etc/webmin/virtual-server
 portupgrade -Rri virtualmin
```

# Webmin
```
 mkdir -p /home/bup/update/webmin
 tar cfvpj /home/bup/update/webmin/webmin-`date +%d%m%y`.tbz /usr/local/etc/webmin
 cp -p /usr/local/etc/rc.d/webmin.sh /home/bup/update/webmin
 portupgrade -Rri webmin
```

# Nagios/-plugins
```
 mkdir -p /home/bup/update
 tar cfvpj /home/bup/update/nagios-`date +%d%m%y`.tbz /usr/local/etc/nagios
 tar cfvpj /home/bup/update/nagios-plugins-`date +%d%m%y`.tbz /usr/local/libexec/nagios
 portupgrade -Rr nagios
```

# phpMyAdmin
```
mkdir -p /home/bup/update/phpMy
tar cfvpj /home/bup/update/phpMy/phpMy-`date +%d%m%y`.tbz /home/apache/hosts/ion.lu/question/phpMy
```
phpMyAdmin-2.6.1.r1 has been installed into:

 . /usr/local/www/phpMyAdmin Please edit config.inc.php to suit your needs. To make phpMyAdmin available through your web site, I suggest that you add the following to httpd.conf:
  . Alias /phpmyadmin/ "/usr/local/www/phpMyAdmin/"

cp config.inc.php into new blabla

# phpicalendar
```
 mkdir -p /home/bup/update/phpicalendar
 tar cfvpj /home/bup/phpicalendar/phpicalendar-`date +%d%m%y`.tbz /home/apache/hosts/ion.lu/question/phpicalendar
```

# Squid and Dansguardian
```
 mkdir -p /home/bup/update/squid
 tar cfvpj /home/bup/update/squid/squid-`date +%d%m%y`.tbz /usr/local/etc/squid
 cp /usr/local/etc/rc.d/squid.sh /home/bup/update/squid/squid.sh-`date +%d%m%y`
 portupgrade -Rri squid


 mkdir -p /home/bup/update/dansguardian
 tar cfvpj /home/bup/update/dansguardian/dansguardian-`date +%d%m%y`.tbz /usr/local/etc/dansguardian
 cp /usr/local/etc/rc.d/start-dg.sh /home/bup/update/dansguardian/start-dg.sh-`date +%d%m%y`
```

FETCH DANSG:

# proftpd
```
mkdir -p /home/bup/update/proftpd
# Following step is only required on some installs
#tar cfvpj /home/bup/update/proftpd/proftpd-`date +%d%m%y`.tbz /usr/local/etc/proftpd.conf /usr/local/proftpd
cp /usr/local/etc/proftpd.conf /home/bup/update/proftpd/proftpd.conf-`date +%d%m%y`
portupgrade -Rri proftpd
```

# openldap
```
mkdir -p /home/bup/update/openldap
tar cfvpj /home/bup/update/openldap/openldap-`date +%d%m%y`.tbz /usr/local/etc/openldap
tar cfvpj /home/bup/update/openldap/openldap-data-`date +%d%m%y`.tbz /var/db/openldap-data
/usr/local/sbin/slapcat -l /home/bup/update/openldap/ldap-`date +%d%m%y`.ldif && tar cfvpj /home/bup/update/openldap/ldap-`date +%Y%m%d`.tbz /home/bup/update/openldap/ldap-`date +%d%m%y`.ldif && rm /home/bup/update/openldap/ldap-`date +%d%m%y`.ldif
pkg_info |grep openldap > /home/bup/update/openldap/openldap-version.info-`date +%d%m%y`
pkg_info |grep db4 >> /home/bup/update/openldap/openldap-version.info-`date +%d%m%y`

/usr/local/libexec/openldap
/usr/local/libexec/slapd
/usr/local/libexec/slurpd

portupgrade -Rri openldap23-client openldap23-server
```

# cfs
```
mkdir -p /home/bup/update/cfs
cp -p /usr/local/etc/rc.d/cfsd.sh /home/bup/update/cfs/cfsd.sh-`date +%d%m%y`
portupgrade -Rri cfs
diff -u /usr/local/etc/rc.d/cfsd.sh /home/bup/update/cfs/cfsd.sh-`date +%d%m%y`
cp -p /home/bup/update/cfs/cfsd.sh-`date +%d%m%y` /usr/local/etc/rc.d/cfsd.sh

mount -o port=3049,noinet6 -i -2 localhost:/var/tmp /crypt
```

# pdflib
```
mkdir -p /home/bup/update/pdflib
cp /usr/local/share/pdflib/fonts/pdflib.upr /home/bup/update/pdflib/pdflib.upr
portupgrade -Rri pdflib
diff -u /home/bup/update/pdflib/pdflib.upr /usr/local/share/pdflib/fonts/pdflib.upr
echo -n "Smack da enter key " ; read
cp /home/bup/update/pdflib/pdflib.upr /usr/local/share/pdflib/fonts/pdflib.upr
```

# amavisd-new
```
cp /usr/local/etc/rc.d/amavis* /home/bup/update/
cp /usr/local/etc/amavis* /home/bup/update/
```

# dcc-dccd update
```
mkdir -p /home/bup/update/dcc-dccd
tar cfvpj /home/bup/update/dcc-dccd/dcc-`date +%d%m%y`.tbz /usr/local/dcc
portupgrade -Rri dcc-dccd
```

# spamass update
files of interest: /usr/local/etc/rc.d/spamd.sh /usr/local/etc/mail/spamassassin /usr/local/share/doc/

```
mkdir -p /home/bup/update/spamassassin
cp -p /usr/local/etc/rc.d/sa-spamd.sh /home/bup/update/spamassassin/sa-spamd.sh-`date +%d%m%y`
tar cfvpj /home/bup/update/spamassassin/spamassassin-`date +%d%m%y`.tbz /usr/local/etc/mail
portupgrade -Rri p5-Mail-SpamAssassin
tail -F /var/log/spamd/current &
svc -d /var/service/spamd
svc -u /var/service/spamd
```
(OLD STYLE nohup spamd -x -q -u qscand -r /var/run/spamd/spamd.pid --syslog=stderr 2>&1 | /usr/local/bin/setuidgid qscand /usr/local/bin/multilog t s1000000 n20 /var/log/spamd  & )

CYRUS 3 modules:

cyrus-imapd2 - cyrus-sasl2 - cyrus-sasl2-saslauthd:

```
mkdir -p /home/bup/update/cyrus
cp /usr/local/etc/cyrus.conf /home/bup/update/cyrus/cyrus.conf-`date +%d%m%y`
cp /usr/local/etc/imapd.conf /home/bup/update/cyrus/imapd.conf-`date +%d%m%y`
cp /usr/local/etc/rc.d/imapd.sh /home/bup/update/cyrus/imapd.sh-`date +%d%m%y`
cp /usr/local/etc/rc.d/saslauthd.sh /home/bup/update/cyrus/saslauthd.sh-`date +%d%m%y`
cp /usr/local/etc/sasldb2 /home/bup/update/cyrus/sasldb2-`date +%d%m%y`
cp /usr/local/etc/sasldb2.db /home/bup/update/cyrus/sasldb2.db-`date +%d%m%y`
tar cfvpj /home/bup/update/cyrus/cyrus-`date +%d%m%y`.tbz /usr/local/cyrus
```

# netatalk
```
mkdir -p /home/bup/update
tar cfvpj /home/bup/update/NetAtalk-`date +%d%m%y`.tbz /usr/local/etc/AppleVolumes.default /usr/local/etc/AppleVolumes.system /usr/local/etc/afpd.conf /usr/local/etc/afppasswd /usr/local/etc/atalkd.conf /usr/local/etc/papd.conf
cp /usr/local/etc/rc.d/netatalk.sh /home/bup/update
portupgrade -Rri net/netatalk
```

# cups
```
mkdir -p /home/bup/update/cups
tar cfvpj /home/bup/update/cups/cups-`date +%d%m%y`.tbz /usr/local/etc/cups
cp -p /usr/local/etc/rc.d/cupsd /home/bup/update/cups/cupsd-`date +%d%m%y`
cp -p /etc/printcap /home/bup/update/cups/printcap-`date +%d%m%y`

portupgrade -Rri print/cups-base
```

# openssl
update openssl.cnf

# gnupg

# maildrop
```
mkdir -p /home/bup/update/maildrop
cp -p /usr/local/etc/maildroprc /home/bup/update/maildrop/maildroprc-`date +%d%m%y`
cp /etc/mailfilter /home/bup/update/maildrop/mailfilter-`date +%d%m%y`
(user file: .mailfilter )

tar cfpj /home/bup/update/maildrop/maildrop-`date +%d%m%y`.tbz \
/usr/local/bin/deliverquota \
/usr/local/bin/lockmail \
/usr/local/bin/mailbot \
/usr/local/bin/maildirmake \
/usr/local/bin/maildrop \
/usr/local/bin/makemime \
/usr/local/bin/reformail \
/usr/local/bin/reformime
```
Amavisd-new update

FreeTDS update

Dansguardian. Squid update ...

p5-XML-Parser Problems

some programs fail to recognize perl dependencies correctly including perl5.8 itself do this:

```
cd /usr/ports/lang/perl5.8 && make deinstall && portupgrade defunct/module
Sorted same for p5-XML-Parser problems (make sure perl is ok)
```

# courier-imap
[Changelog](http://www.courier-mta.org/imap/changelog.html)

[Freshports](http://www.freshports.org/mail/courier-imap)

```
 mkdir -p /home/bup/update/courier-imap
 tar cfvpj  /home/bup/update/courier-imap/courier-imap-etc-`date +%d%m%y`.tbz /usr/local/etc/courier-imap/
 tar cfvpj  /home/bup/update/courier-imap/libexec-courier-imap-`date +%d%m%y`.tbz /usr/local/libexec/courier-imap/
 tar cfvpj  /home/bup/update/courier-imap/courier-rcd-`date +%d%m%y`.tbz /usr/local/etc/rc.d/courier* /usr/local/etc/rc.d/imap*
 pkg_create -v -x -b courier-imap /home/bup/update/courier-imap/pkg-`date +%d%m%y`.tbz

 /usr/local/etc/rc.d/courier-imap-imapd-ssl.sh restart
 /usr/local/etc/rc.d/courier-imap-pop3d-ssl.sh restart
 /usr/local/etc/rc.d/courier-imap-imapd.sh restart
 /usr/local/etc/rc.d/courier-imap-pop3d.sh restart
```

# courier-authlib-base
[Changelog](http://www.courier-mta.org/authlib/changelog.html)

 . Do not delete the user as you update the package.

```
 mkdir -p /home/bup/update/courier-authlib
 tar cfvpj  /home/bup/update/courier-authlib/courier-authlib-etc-`date +%d%m%y`.tbz /usr/local/etc/authlib/
 tar cfvpj  /home/bup/update/courier-authlib/courier-rcd-`date +%d%m%y`.tbz /usr/local/etc/rc.d/courier* /usr/local/etc/rc.d/imap*
 tar cfvpj  /home/bup/update/courier-authlib/libexec-courier-authlib-`date +%d%m%y`.tbz /usr/local/libexec/courier-authlib/
 tar cfvpj  /home/bup/update/courier-authlib/lib-courier-authlib-`date +%d%m%y`.tbz /usr/local/lib/courier-authlib/
 pkg_create -v -x -b courier-authlib /home/bup/update/courier-authlib/pkg-`date +%d%m%y`.tbz

 /usr/local/etc/rc.d/courier-authdaemond restart
```

# courier-authlib-base

[Changelog](http://www.courier-mta.org/authlib/changelog.html)

```
 mkdir -p /home/bup/update/courier-authlib
 tar cfvpj  /home/bup/update/courier-authlib/courier-authlib-etc-`date +%d%m%y`.tbz /usr/local/etc/authlib/
 tar cfvpj  /home/bup/update/courier-authlib/courier-rcd-`date +%d%m%y`.tbz /usr/local/etc/rc.d/courier* /usr/local/etc/rc.d/imap*
 tar cfvpj  /home/bup/update/courier-authlib/libexec-courier-authlib-`date +%d%m%y`.tbz /usr/local/libexec/courier-authlib/
 tar cfvpj  /home/bup/update/courier-authlib/lib-courier-authlib-`date +%d%m%y`.tbz /usr/local/lib/courier-authlib/

 /usr/local/etc/rc.d/courier-authdaemond restart
```

# courier-authlib-vchkpw
 . This get's backed up by -base and can be update without worries.

# vpopmail
 . VERY CAREFULL WITH THE OPTIONS (SQL/NON-SQL etc)

[Changelog](http://www.inter7.com/vpopmail/ChangeLog)

[Freshports](http://www.freshports.org/mail/vpopmail)

Do a Backup first:

```
mkdir -p /home/bup/update/vpopmail
tar cfvpj /home/bup/update/vpopmail/vpopmail-`date +%d%m%y`.bz2 /usr/local/vpopmail
tar cfvpj /home/bup/update/vpopmail/vpopmail-bin-`date +%d%m%y`.bz2 /usr/local/vpopmail/bin
cd /usr/ports/mail/vpopmail
WITH_QMAIL_EXT=yes make WITH_SINGLE_DOMAIN=YES WITHOUT_ROAMING_USERS=YES WITH_CLEAR_PASSWD=YES WITH_AUTH_LOG=YES WITH_VALIAS=YES WITH_MYSQL=NO WITH_SQL_LOG=NO WITH_DOMAIN_QUOTAS=YES WITHOUT_PASSWD=YES RELAYCLEAR=30 LOGLEVEL=p make
```

```
 mkdir -p /home/bup/update/vpopmail
 #tar cfvpj /home/bup/update/vpopmail/vpopmail-domains-`date +%d%m%y`.bz2 /usr/local/vpopmail/domains
 /usr/local/bin/rdiff-backup -v5 --print-statistics ~vpopmail/ malium-backup@plumbum.ion.lu::bup/home-vpopmail-rdiff
 tar --exclude /usr/local/vpopmail/domains -c -v -p -j -f /home/bup/update/vpopmail/vpopmail-`date +%d%m%y`.bz2 /usr/local/vpopmail
 pkg_create -v -x -b vpopmail /home/bup/update/vpopmail/pkg-`date +%d%m%y`.tbz
cd /usr/ports/mail/vpopmail
WITH_QMAIL_EXT=yes WITH_SINGLE_DOMAIN=YES WITHOUT_ROAMING_USERS=YES WITH_CLEAR_PASSWD=YES WITH_AUTH_LOG=YES WITH_VALIAS=YES WITH_MYSQL=NO WITH_SQL_LOG=NO WITH_DOMAIN_QUOTAS=YES WITHOUT_PASSWD=YES RELAYCLEAR=30 LOGLEVEL=p make
```

Upgrading to vpopmail-5.4.18

----------
For all SQL back ends you must change the length of the domain or pw_domain field from 64 to 96 characters to reflect the maximum size allowed in vpopmail.

If you are storing limits in mysql you must add the following items to the limits table:

 . disable_spamassassasin  tinyint(1) NOT NULL DEFAULT 0 delete_spam             tinyint(1) NOT NULL DEFAULT 0
  . The following assumes --enable-many-domains (the default) is used.  If you use --disable-many-domains then you need to replace the alter command for the 'vpopmail' table with one for each of your domain tables.  Also, the ip_alias_map, vlog and limits tables only exist if various configuration options are enabled, so they may or may not be relevant on your system.

```
    ALTER TABLE `dir_control` CHANGE `domain` `domain` CHAR(96) NOT NULL;
    ALTER TABLE `ip_alias_map` CHANGE domain domain CHAR(96) NOT NULL;
    ALTER TABLE `lastauth` CHANGE domain domain CHAR(96) NOT NULL;
    ALTER TABLE `valias` CHANGE domain domain CHAR(96) NOT NULL;
    ALTER TABLE `vlog` CHANGE domain domain CHAR(96) NOT NULL;
    ALTER TABLE `vpopmail` CHANGE domain domain CHAR(96) NOT NULL;

    ALTER TABLE `limits` CHANGE domain domain CHAR(96) NOT NULL,
        ADD `disable_spamassassin` TINYINT(1) DEFAULT '0' NOT NULL AFTER `disable_smtp`,
        ADD `delete_spam` TINYINT(1) DEFAULT '0' NOT NULL AFTER `disable_spamassassin`;
```

# horde

```
 mkdir -p /home/bup/update/horde
 tar cfvpj /home/bup/update/horde/horde-`date +%d%m%y`.tbz /usr/local/etc/horde /home/apache/hosts /usr/local/www/horde
```

```
:%s/usr\/local\/www/home\/apache\/hosts\/croix-rouge.lu\/webmail/g :%s/usr\/local\/www\/horde/home\/apache\/hosts\/ion.lu\/webmail/g
```

horde update and so on (imp/turba/kronolith/etc...)

# horde 3.0.x

```
WITH_PHP5=YES make
```

Information for horde-3.0.4_1:


Install notice:
```
************************************************************************ Horde has been installed in /usr/local/www/horde with your blank configuration files.

If you want Horde to access a database, you have to run the appropriate scripts located in /usr/local/www/horde/scripts/sql. It is recommended that you change the password of the 'hordemgr' user used to connect to the horde database. Horde is setup by default to access MySQL.

WARNING! if you are upgrading from Horde v. 2.2.x, you have to alter your ******** database schemas. Please read the doc UPGRADING.

You can now access Horde without a password at <http://localhost/horde/>, and you will be logged in as an administrator. You should first configure a real authentication backend.  Click on "Setup" in the "Administration" menu and configure Horde. Start in the "Authentication" tab. See the doc in /usr/local/share/doc/horde for details. (tip: if you plan to install IMP, just keep "Automatic authentication as a certain user", add your login to be treated as administrator, and once IMP will be installed, switch to "Let a Horde application handle auth"). Select a log driver; if you keep 'file', do not forget to add a line in /etc/newsyslog.conf. Then select and configure a preferences driver.

Your /usr/local/etc/apache/httpd.conf has been updated, you have to restart Apache.

When everything is OK, you should be able to access Horde from <http://localhost/horde/>. (If <http://localhost/horde/> does not run, but

 . <http://localhost/horde/index.php> is OK, then you have
  . to define index.php as a DirectoryIndex in /usr/local/etc/apache/httpd.conf.)
  There is a testing script at <http://localhost/horde/test.php>.
  * ***********************************************************************
```

# imp

```
linion imp # make WITH_HTML=yes WITH_COURIER-IMAP=yes reinstall 
===>  Installing for imp-4.0.3 
===>   imp-4.0.3 depends on file: /usr/local/share/pear/Auth/SASL.php - found ===>   imp-4.0.3 depends on file: /usr/local/www/horde/turba/minisearch.php - not found 
===>    Verifying reinstall for /usr/local/www/horde/turba/minisearch.php in /usr/ports/mail/turba 
===>  Installing for turba-2.0.2 
===>   turba-2.0.2 depends on file: /usr/local/www/horde/rpc.php - found ===>   Generating temporary packing list 
===> Documentation installed in /usr/local/share/doc/turba.

************************************************************************ Turba has been installed in /usr/local/www/horde/turba with your blank configuration files.

Horde must be configured; if not, see `pkg_info -D -x horde'.
```

Then, you might have to tune the configuration files located in /usr/local/www/horde/turba/config/, specially the file sources.php.

Then, you must login to Horde as a Horde Administrator to finish the configuration.

You have to create a table in your database; please see /usr/local/www/horde/turba/scripts/. You might create a LDAP schema: please see the doc LDAP.

```
WARNING! if you are upgrading from Turba v. 1.2.x, you have to alter your ******** schemas. Please read the doc UPGRADING.

To protect your configuration files, you have to restart Apache. ************************************************************************

===>   Registering installation for turba-2.0.2 
===>   Returning to build of imp-4.0.3 
===>   imp-4.0.3 depends on file: /usr/local/www/horde/ingo/filters.php - not found 
===>    Verifying reinstall for /usr/local/www/horde/ingo/filters.php in /usr/ports/mail/ingo 
===>  Extracting for ingo-1.0.1 => Checksum OK for ingo-h3-1.0.1.tar.gz. ===>  Patching for ingo-1.0.1 
===>  Configuring for ingo-1.0.1 
===>  Installing for ingo-1.0.1 
===>   ingo-1.0.1 depends on file: /usr/local/www/horde/rpc.php - found 
===>   ingo-1.0.1 depends on file: /usr/local/include/php/main/php.h - found ===>   ingo-1.0.1 depends on file: /usr/local/lib/php/20020429/imap.so - found ===>   Generating temporary packing list ===> Documentation installed in /usr/local/share/doc/ingo.

************************************************************************ Ingo has been installed in /usr/local/www/horde/ingo with your blank configuration files.

Horde must be configured; if not, see `pkg_info -D -x horde'.
```

Finally, you must login to Horde as a Horde Administrator to finish the configuration.

```
To protect your configuration files, you have to restart Apache. ************************************************************************

===>   Registering installation for ingo-1.0.1 
===>   Returning to build of imp-4.0.3 
===>   imp-4.0.3 depends on file: /usr/local/www/horde/nag/data.php - not found 
===>    Verifying reinstall for /usr/local/www/horde/nag/data.php in /usr/ports/deskutils/nag 
===>  Extracting for nag-2.0 => Checksum OK for nag-h3-2.0.tar.gz. 
===>  Patching for nag-2.0 
===>  Configuring for nag-2.0 
===>  Installing for nag-2.0 
===>   nag-2.0 depends on file: /usr/local/www/horde/rpc.php - found 
===>   Generating temporary packing list ===> Documentation installed in /usr/local/share/doc/nag.

************************************************************************ Nag has been installed in /usr/local/www/horde/nag with your blank configuration files.

Horde must be configured; if not, see `pkg_info -D -x horde'.
```

Then, you have to create the table nag_tasks, from the SQL script /usr/local/www/horde/nag/scripts/sql/nag.sql. For example, if your database is MySQL, you may run mysql --user=root --password=yourpass horde < nag.sql

```
WARNING! if you are upgrading from Nag v. 1.1.x, you have to alter your ******** schemas. Please read the doc /usr/local/share/doc/nag/UPGRADING.

Finally, you must login to Horde as a Horde Administrator to finish the configuration.

To protect your configuration files, you have to restart Apache. ************************************************************************

===>   Registering installation for nag-2.0 
===>   Returning to build of imp-4.0.3 
===>   imp-4.0.3 depends on file: /usr/local/bin/gpg - found 
===>   imp-4.0.3 depends on file: /usr/local/bin/aspell - found 
===>   imp-4.0.3 depends on file: /usr/local/share/pear/HTTP/Request.php - found 
===>   imp-4.0.3 depends on file: /usr/local/include/php/main/php.h - found ===>   imp-4.0.3 depends on file: /usr/local/lib/php/20020429/imap.so - found ===>   imp-4.0.3 depends on file: /usr/local/bin/deliverquota - found ===>   Generating temporary packing list ===>  Checking if mail/imp already installed pkg_info: package bsdpan-MailTools-1.62 has no origin recorded pkg_info: package bsdpan-Term-ReadLine-Perl-1.0203 has no origin recorded pkg_info: package bsdpan-TermReadKey-2.21 has no origin recorded pkg_info: package bsdpan-libnet-1.19 has no origin recorded 
===> Documentation installed in /usr/local/share/doc/imp.

************************************************************************ IMP has been installed in /usr/local/www/horde/imp with your blank configuration files.

Horde must be configured and the tables created; if not, see `pkg_info -D -x horde'.

Then, you might have to tune the configuration files located in /usr/local/www/horde/imp/config/, specially the file servers.php.

Then, you must login to Horde as a Horde Administrator to finish the configuration. Please read /usr/local/share/doc/imp/INSTALL.

Warning: the filter system of IMP 3.x has been replaced by a separate ******** application => check the port mail/ingo. Ingo provides a script

 . to migrate the existing filter rules from IMP 3.x, see Ingo's documentation.

To protect your configuration files, you have to restart Apache.

To secure your installation, it is at least recommended that you change the default database password used by horde and imp. Then, you might change the 'session.save_path' setting in php.ini to a directory only readable and writeable by your webserver. ************************************************************************

===>   Registering installation for imp-4.0.3
```

backup /usr/local/etc/horde and the webroot.

```
mkdir -p /home/bup/update/horde tar cfvpj /home/bup/update/horde/horde-etc-`date +%d%m%y`.tbz /usr/local/etc/horde
```

cclient update just update no config needed

# php
The main thing to backup is the extension.ini and php.ini in case you made any tunings and in case the ports maintainer decided to blatt your config. At the end we diff' the config files to see if anything changed or rather something erased our custom conf. Please note that php.ini-dist and php.ini-recommended will be rewritten to, for convenience we copied and diffed them too, so you see if anything new has been added.

```
 mkdir -p /home/bup/update/php
 tar cfvpj /home/bup/update/php/etc-php-`date +%d%m%y`.tbz /usr/local/etc/php cp /usr/local/etc/php.ini /home/bup/update/php/php.ini-`date +%d%m%y` cp /usr/local/etc/php.ini-* /home/bup/update/php/ cp /usr/local/etc/php/extensions.ini /home/bup/update/php/php.ini-`date +%d%m%y` cp /usr/local/etc/php.conf /home/bup/update/php/php.conf-`date +%d%m%y` portupgrade -Rri php5-\* diff -u /usr/local/etc/php.ini /home/bup/update/php/php.ini-`date +%d%m%y` diff -u /usr/local/etc/php/extensions.ini /home/bup/update/php/php.ini-`date +%d%m%y` diff -u /usr/local/etc/php.conf /home/bup/update/php/php.conf-`date +%d%m%y` diff -u /usr/local/etc/php.ini-dist /home/bup/update/php/php.ini-dist diff -u /usr/local/etc/php.ini-recommended /home/bup/update/php/php.ini-recommended
```

Apache x.y updaters:

As you need to reinstall php follow this simple step:

```
 cd /usr/ports/lang/php5 && make deinstall && make reinstall
```

some php5* modules might need a recompile, check wether functionality is still given, if not procede with the -f (force) flag.

```
 portupgrade -fi php5-\* pecl-pdflib
```

# sudo

# qpopper

# wu-ftpd

# powerdns update files to bup pdns.conf
```
 mkdir -p /home/bup/update/powerdns cp -p /usr/local/etc/pdns.conf /home/bup/update/powerdns/
```

# bind9
```
 mkdir -p /home/bup/update/bind9 tar cfvpj /home/bup/update/bind9/var-named-`date +%d%m%y`.tbz /var/named tar cfvpj /home/bup/update/bind9/etc-namedb-`date +%d%m%y`.tbz /etc/namedb upgrade
```

# mysql
```
mkdir -p /home/bup/update/sql/

for a in `/usr/local/bin/mysqlshow |/usr/bin/cut -f2 -d\| |/usr/bin/grep -v "\-\-\-\-\-\-\-"|/usr/bin/grep -v Databases |/usr/bin/grep -v dblogging`; do /usr/local/bin/mysqldump -e -q -a $a > /home/bup/update/sql/$a-UPDATE-`date +%d%m%y`.sql ; done
cd /home/bup/update/sql/ && tar cfvz db-`date +%d%m%y`.tgz *.sql && rm *.sql
cp -p /usr/local/etc/rc.d/mysql-server /home/bup/update/sql/mysql-server-`date +%d%m%y`
portupgrade -Rri databases/mysql50-server
/usr/local/etc/rc.d/mysql-server restart
diff -u /usr/local/etc/rc.d/mysql-server /home/bup/update/sql/mysql-server-`date +%d%m%y`
```
************************************************************************

Remember to run mysql_upgrade (with the optional --datadir=<dbdir> flag) the first time you start the MySQL server after an upgrade from an earlier version.

************************************************************************

# samba
```
mkdir -p /home/bup/update/samba smbstatus cp -p /usr/local/etc/smb.conf /home/bup/update/samba/smb.conf-`date +%d%m%y` cp -p /usr/local/etc/rc.d/samba /home/bup/update/samba/samba-`date +%d%m%y` tar cfvpj /home/bup/update/samba/etc-samba-`date +%d%m%y`.tbz /usr/local/etc/samba portupgrade -Rri net/samba3 /usr/local/etc/rc.d/samba restart /usr/local/etc/rc.d/samba status
```

```
Obsolete: ( cp -p /usr/local/etc/rc.d/samba.sh /home/bup/update/samba/samba.sh-`date +%d%m%y` cp -p /usr/local/etc/recycle.conf /home/bup/update/samba/recycle.conf-`date +%d%m%y` cp -rp /usr/local/private /home/bup/update/samba/private-`date +%d%m%y` )
```

# phpgroupware
Backup htdocs and maybe any Databases.

# moregroupware
Backup htdocs and maybe any Databases.

# imap-uw
Just Update

# enigmail
You have to manually delete the components database (compreg.dat), located in your profile directory in order to use enigmail.

If you upgraded Mozilla/Thunderbird from a previous release you have to remove also the XUL.mfasl file and the content of the chrome subdirectory.

# php4-php5
Check what is running on that box and assure youself that the switch will be flawless.

```
 pkg_delete php4-ctype-4.3.11  php4-domxml-4.3.11 php4-ftp-4.3.11 php4-gd-4.3.11 php4-gettext-4.3.11 php4-iconv-4.3.11 php4-imap-4.3.11 php4-ldap-4.3.11  php4-mbstring-4.3.11 php4-mcal-4.3.11 php4-mcrypt-4.3.11 php4-mhash-4.3.11 php4-mysql-4.3.11 php4-openssl-4.3.11  php4-pcre-4.3.11 php4-pear-4.3.11 php4-session-4.3.11  php4-xml-4.3.11 php4-zlib-4.3.11
 for a in `pkg_info |grep php |awk {' print $1 '}`; do
  pkg_delete $a
 done
```

  it will barf on things like horde squirrelmail and so on, to be perfectly sure reinstall them too:

```
pkg_delete nag-2.0.4  ingo-1.0.2  turba-2.0.5
pkg_delete imp-4.0.4_1 horde-3.0.9
pkg_delete squirrelmail-1.4.5
```

quite a few pear packages in the way, deleting them too:

```
pkg_delete pecl-fileinfo-1.0_1 pear-1.4.5_2        PEAR framework for PHP pear-Auth-1.2.3_1   PEAR class for creating an authentication system pear-Auth_SASL-1.0.1_1 PEAR abstraction of various SASL mechanism responses pear-Cache-1.5.4    PEAR framework for caching of arbitrary data pear-DB-1.7.6,1     PEAR Database Abstraction Layer pear-Date-1.4.3     PEAR Date and Time Zone Classes pear-File-1.2.0,1   PEAR common file and directory routines pear-HTTP_Request-1.2.4 PEAR classes providing an easy way to perform HTTP requests pear-Log-1.9.2      PEAR logging utilities pear-Mail-1.1.6     PEAR class that provides multiple interfaces for sending em pear-Mail_Mime-1.3.1 PEAR classes to create and decode MIME messages pear-Net_DIME-0.3   The PEAR::Net_DIME class implements DIME encoding pear-Net_SMTP-1.2.6_1 PEAR class that provides an implementation of the SMTP prot pear-Net_Socket-1.0.6 PEAR Network Socket Interface pear-Net_URL-1.0.14 Easy parsing of URLs pear-SOAP-0.9.1     PEAR SOAP Client/Server for PHP pear-Services_Weather-1.3.2 PEAR interface to various online weather-services pear-XML_Parser-1.2.6 PEAR XML parsing class based on PHP's bundled expat pear-XML_Serializer-0.16.0 PEAR Swiss-army knive for reading and writing XML files pear-XML_Util-1.1.0 PEAR XML utility class

 for a in `pkg_info |grep pear |awk {' print $1 '}`; do
   pkg_delete $a
 done 
```

you have to run the for loop a couple of time to delete all of it... (3 times in my case)

Now update to php5:

```
portinstall lang/php5 DONT FORGET TO REINSTALL YOUR PACKAGES!!!
portinstall squirrelmail (pulls in a couple pear things and php5-* stuff)
```

# mysql40-mysql41

Not very difficult but you need a DUMP of your database.

```
mkdir -p /home/bup/update/sql/ mysqldump -e -q -a -A  > /home/bup/update/sql/`hostname`-`date +%d%m%y`.sql

for a in `/usr/local/bin/mysqlshow |/usr/bin/cut -f2 -d\| |/usr/bin/grep -v "\-\-\-\-\-\-\-"|/usr/bin/grep -v Databases |/usr/bin/grep -v dblogging`; do

 /usr/local/bin/mysqldump -e -q -a $a > /home/bup/update/sql/$a-UPDATE-`date +%d%m%y`.sql ; done 
 cd /home/bup/update/sql/ && tar cfvz db-`date +%d%m%y`.tgz *.sql && rm *.sql 
 cp -p /usr/local/etc/rc.d/mysql-server.sh /home/bup/update/sql/mysql-server-`date +%d%m%y`.sh

cd /usr/ports/databases/mysql40-server && make deinstall
cd /usr/ports/databases/mysql40-client && make deinstall
cd /usr/ports/databases/mysql41-server && make install
cd /usr/ports/databases/mysql41-client && make install

/usr/local/etc/rc.d/mysql-server.sh start
```

qmailadmin, it's a web-based app (cgi-bin) so only the code needs to be bupped:
```
mkdir -p /home/bup/update/qmailadmin

tar cfvpj /home/bup/update/qmailadmin/home-apache-cgi-bin-`date +%d%m%y`.tbz /home/apache/cgi-bin
tar cfvpj /home/bup/update/qmailadmin/home-apache-hosts-qmailadmin-`date +%d%m%y`.tbz /home/apache/hosts/ion.lu/qmailadmin

WITH_IDX_SQL=YES WITH_HELP=NO WITH_DOMAIN_AUTOFILL=NO WITH_SPAM_DETECTION=YES SPAM_COMMAND="|/usr/local/bin/dspam --user \$EXT@\$HOST --deliver=innocent --mode=teft --feature=chained,noise,whitelist " WITH_MODIFY_QUOTA=NO PREFIX=/home/apache CGIBINDIR=cgi-bin CGIBINSUBDIR= CGIBINURL=/cgi-bin WEBDATADIR=hosts/ion.lu WEBDATASUBDIR=qmailadmin make install
```

SPAM_COMMAND='' doesnt work passing $HOST parameter... ''

## razor-agents

just update...

## mrtg update
```
mkdir -p /home/bup/update/mrtg tar cfvpj /home/bup/update/mrtg/mrtg-`date %%d%m%y`.tbz /usr/local/etc/mrtg
```

## qmailmrtg7

/usr/local/etc/qmailmrtg*

## php update

```
mkdir -p /home/bup/update/php cp -rp /usr/local/etc/php /home/bup/update/php cp -p /usr/local/etc/php* /home/bup/update/php
```

## qmail-ion-spamfilter upgrade

 - Qmail patch-level

## FreeBSD ports applied patches

```
x x [X] QMAILQUEUE_PATCH       run a QMAILQUEUE 
x x [X] BIG_TODO_PATCH         enable big_todo 
x x [X] BIG_CONCURRENCY_PATCH  use a concurrency 
x x [X] OUTGOINGIP_PATCH       set the IP address 
x x [ ] QMTPC_PATCH            send email using 
x x [ ] BLOCKEXEC_PATCH        block many windows 
x x [ ] DISCBOUNCES_PATCH      discard
```

```
x x [ ] LOCALTIME_PATCH        emit dates in the 
x x [ ] MAILDIRQUOTA_PATCH     Maildir++ support 
x x [ ] SPF_PATCH              Implement SPF 
x x [ ] RCDLINK                create
```

## stock qmail upgrade
```
mkdir -p /home/bup/update/qmail cd /usr/ports/mail/qmail make config
tar cfvpj /home/bup/update/qmail/qmail-`date +%d%m%y`.tbz /var/qmail
# Check if all clear.
portupgrade -Rri qmail
```

## isc-dhcp3 upgrade
```
mkdir -p /home/bup/update/isc-dhcp3 
cp -p /usr/local/etc/dhcpd.conf /home/bup/update/isc-dhcp3/dhcpd.conf-`date +%d%m%y` 
cp -p /usr/local/etc/rc.d/isc-dhcpd.sh /home/bup/update/isc-dhcp3/isc-dhcpd.sh-`date +%d%m%y` 
portupgrade -Rri net/isc-dhcp3-server && /usr/local/etc/rc.d/isc-dhcpd.sh restart ; /usr/local/etc/rc.d/isc-dhcpd.sh status 
```

:warning: IF CHROOT ENABLED PORTUPGRADE WILL FAIL!!! UNCOMMENT THE TOUCH LINE FROM create-data-files IN THE MAKEFILE!!!

# apache13 to apache2
build apache2 first and make backups of everything. Make sure your root stays: /home/apache make deinstall old apache, make install new apache Recompile all possible dependencies. (php and the like)

# apache22
```
```

# qmrtg upgrade

# dspam upgrade
```
```

# ezmlm-idx update
```
```

# update qmail-autoresponder
```
```

## Buggy stuff
```
cd /usr/ports/databases/ruby-bdb && make deinstall && cd ../../port-mgmt/portupgrade && make deinstall reinstall clean
```

# stunnel update
```
```

# joomla update

# backup www dir

# cacti update
```
```

# roundcube
```
```

# lighttpd
```
```

# asterisk
```
```

# asterisk-addons
```
```

# trac
```
```

# gallery2
```
```

# moinmoin
```
```
