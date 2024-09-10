# General update notes on FreeBSD

It is common to start daemon in /etc/rc.conf nowadays by putty say:

```
sshd_enable=YES 
```

into the config. (That is the new rcNG scipting)
More and more ports adopt that nomenclature. So even if you
install or upgrade something put it into the rc.conf if it is to be started
automatically. This will prevent failures once the port adopts to such system.

Apache:

To upgrade apache 1.3.x from ports in the ION Way:

```
mkdir -p /home/bup/update/apache13
tar cfvpj /home/bup/update/apache13/apache-`date +%d%m%y`.tbz /home/apache
tar cfvpj /home/bup/update/apache13/apache-etc-`date +%d%m%y`.tbz /usr/local/etc/apache/
```
Check /etc/make.conf for:

```
APACHE_DATADIR=/home/apache
APACHE_DOCUMENT_ROOT=/home/apache/hosts/ion.lu/$HOSTNAME
```

```
portupgrade -Rri apache
```

A quick clean-up:
```
cd /home/apache ; ln -s /usr/local/etc etc ; ln -s /usr/local/etc/apache/ conf ; ln -s /usr/local/libexec libexec ; mkdir logs ; rm -rvf proxy
```

Tada done!

php* after having upped apache just upgrade all the php* stuff


Apache13 to Apache13-modssl:

Tricky one you need to redo all the php* stuff aswell...

Deinstall apache13 reinstall apache13-modssl

```
cd /usr/ports/www/apache13 && make deinstall
cd /usr/ports/www/apache13-modssl && make WITH_APACHE_MODACCEL=yes WITH_APACHE_MODDEFLATE=yes WITH_APACHE_PERF_TUNING=no reinstall
```

for MODACCEL you need some specific config.
uncomment: mod_freeze and mod_ranban

```
cd /usr/ports/lang/php5 && make deinstall && make reinstall
some php5* modules might need update: portupgrade -fi php5-\* pecl-pdflib mod_dav
```

Sometimes you hit the problem that mod_php is installed and you require
CMD-Line php or pear, do this:

```
cd /usr/ports/www/mod_php5 (or 4)
make deinstall
cd /usr/ports/lang/php5 (or 4)
make install
```
That port will install a mod_php and command line php.

======================================================================================================================

Upping qmail-scanner-queue.sh:

Files to be aware of: /var/qmail/bin/qmail-scanner-queue.sh /var/spool/qmailscan/

Backup:
```
mv /var/qmail/bin/qmail-scanner-queue.pl /var/qmail/bin/qmail-scanner-queue.pl-`date +%d%m%y`
cd /var/spool && mv qmailscan qmailscan-`date +%d%m%y`
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

Alter: 
```
  $sa_delete='6';
  $spamc_subject="{SPAM?}";
  $sa_alt='0';
```

$ qmailctl restart

HURRAY ON 07022005 THIS ACTUALLY WORKED SEAMLESSLY :) ON LINION
HURRAY ON 28062005 THIS ACTUALLY WORKED SEAMLESSLY :) ON REDX

clamav update:

```
( OLD STUFF
cp clamav.conf /home/bup/clamav/clamav.conf-`date +%d%m%y`
CONFIG FILE CHANGE FROM 0.7x to 0.8x clamav.conf -> clamd.conf
OLD STUFF )
transferlogtransferlogtransferlogtransferlogtransferlogtransferlogtransferlotransferlogg
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

AT THIS POINT IT STILL DOESNT WORK :((( set User=root in clamd.conf

Squirrelmail:

Backup your Squirreldir:

```
mkdir -p /home/bup/update
tar cfvpj /home/bup/update/squirrelmail-`date +%d%m%y`.tbz /home/apache/hosts/croix-rouge.lu/webmail-lite
tar cfvpj /home/bup/update/squirrelmail-`date +%d%m%y`.tbz /home/apache/hosts/ion.lu/webmail-lite

cd /usr/ports/mail/squirrelmail/
WITH_DATABASE=YES WITH_LDAP=YES SQUIRRELDIR=/home/apache/hosts/ion.lu/webmail-lite make
make install clean
SQUIRRELDIR=/home/apache/hosts/healthnet.lu/webmail-lite make install
php.ini FileUploads=on

```
An older version of default_pref exists in
/var/spool/squirrelmail/pref, you may want to
compare it with the one in /home/apache/hosts/ion.lu/webmail-lite/data

If you have problems with SquirrelMail saying "you must login" after
you just have, the following php.ini option may help:
session.auto_start = 1

In order to do your administrative configuration you need to 
cd /home/apache/hosts/ion.lu/webmail-lite && ./configure
SquirrelMail will not work until this has been done.


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
=======


======================================================================================================================



Usermin:

```
mkdir -p /home/bup/update
tar cfvpj /home/bup/update/usermin-`date +%d%m%y`.tbz /usr/local/etc/usermin
portupgrade -Rri usermin
```

Virtualmin:

```
mkdir -p /home/bup/update
tar cfvpj /home/bup/update/usermin-`date +%d%m%y`.tbz /usr/local/etc/webmin/virtual-server
portupgrade -Rri virtualmin
```

Webmin:

```
mkdir -p /home/bup/update/webmin
tar cfvpj /home/bup/update/webmin/webmin-`date +%d%m%y`.tbz /usr/local/etc/webmin
cp -p /usr/local/etc/rc.d/webmin.sh /home/bup/update/webmin
portupgrade -Rri webmin
```

Nagios/-plugins update:

```
mkdir -p /home/bup/update
tar cfvpj /home/bup/update/nagios-`date +%d%m%y`.tbz /usr/local/etc/nagios
tar cfvpj /home/bup/update/nagios-plugins-`date +%d%m%y`.tbz /usr/local/libexec/nagios
portupgrade -Rr nagios
```




Phpmyadmin:

```
mkdir -p /home/bup/update/phpMy
tar cfvpj /home/bup/update/phpMy/phpMy-`date +%d%m%y`.tbz /home/apache/hosts/ion.lu/question/phpMy
```




phpMyAdmin-2.6.1.r1 has been installed into:

    /usr/local/www/phpMyAdmin

    Please edit config.inc.php to suit your needs.

    To make phpMyAdmin available through your web site, I suggest
    that you add the following to httpd.conf:

        Alias /phpmyadmin/ "/usr/local/www/phpMyAdmin/"

cp config.inc.php into new blabla

phpicalendar:

```
mkdir -p /home/bup/update/phpicalendar
tar cfvpj /home/bup/phpicalendar/phpicalendar-`date +%d%m%y`.tbz /home/apache/hosts/ion.lu/question/phpicalendar
```


Squid and Dansg upgrade:


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


proftpd upgrade:

```
mkdir -p /home/bup/update/proftpd
tar cfvpj /home/bup/update/proftpd/proftpd-`date +%d%m%y`.tbz /usr/local/etc/proftpd.conf /usr/local/proftpd
portupgrade -Rri proftpd
```

openldap upgrade:

```
mkdir -p /home/bup/update
tar cfvpj /home/bup/update/openldap-`date +%d%m%y`.tbz /usr/local/etc/openldap
tar cfvpj /home/bup/update/openldap-data-`date +%d%m%y`.tbz /var/db/openldap-data
portupgrade -Rri openldap22-client openldap22-server
```

cfs upgrade:

```
mkdir -p /home/bup/update/cfs
cp -p /usr/local/etc/rc.d/cfsd.sh /home/bup/update/cfs/cfsd.sh-`date +%d%m%y` 
portupgrade -Rri cfs
diff -u /usr/local/etc/rc.d/cfsd.sh /home/bup/update/cfs/cfsd.sh-`date +%d%m%y`
cp -p /home/bup/update/cfs/cfsd.sh-`date +%d%m%y` /usr/local/etc/rc.d/cfsd.sh

mount -o port=3049,noinet6 -i -2 localhost:/var/tmp /crypt
```



pdflib upgrade:

```
mkdir -p /home/bup/update/pdflib
cp /usr/local/share/pdflib/fonts/pdflib.upr /home/bup/update/pdflib/pdflib.upr
portupgrade -Rri pdflib
diff -u /home/bup/update/pdflib/pdflib.upr /usr/local/share/pdflib/fonts/pdflib.upr
echo -n "Smack da enter key " ; read
cp /home/bup/update/pdflib/pdflib.upr /usr/local/share/pdflib/fonts/pdflib.upr
```


amavisd-new update:
```
cp /usr/local/etc/rc.d/amavis* /home/bup/update/
cp /usr/local/etc/amavis* /home/bup/update/
```



dcc-dccd update:

```
mkdir -p /home/bup/update/dcc-dccd
tar cfvpj /home/bup/update/dcc-dccd/dcc-`date +%d%m%y`.tbz /usr/local/dcc
portupgrade -Rri dcc-dccd
```

spamass update:

```
files of interest: /usr/local/etc/rc.d/spamd.sh /usr/local/etc/mail/spamassassin /usr/local/share/doc/

mkdir -p /home/bup/update/spamassassin
cp -p /usr/local/etc/rc.d/sa-spamd.sh /home/bup/update/spamassassin/sa-spamd.sh-`date +%d%m%y`
tar cfvpj /home/bup/update/spamassassin/spamassassin-`date +%d%m%y`.tbz /usr/local/etc/mail
portupgrade -Rri p5-Mail-SpamAssassin
nohup spamd -x -q -u qscand -r /var/run/spamd/spamd.pid --syslog=stderr 2>&1 | /usr/local/bin/setuidgid qscand /usr/local/bin/multilog t s1000000 n20 /var/log/spamd  &
```


CYRUS 3modules:

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



Upgrade Netatalk:

```
mkdir -p /home/bup/update
tar cfvpj /home/bup/update/NetAtalk-`date +%d%m%y`.tbz /usr/local/etc/AppleVolumes.default /usr/local/etc/AppleVolumes.system /usr/local/etc/afpd.conf /usr/local/etc/afppasswd /usr/local/etc/atalkd.conf /usr/local/etc/papd.conf
cp /usr/local/etc/rc.d/netatalk.sh /home/bup/update
portupgrade -Rri net/netatalk
```

cups update:

```
mkdir -p /home/bup/update/cups
tar cfvpj /home/bup/update/cups/cups-`date +%d%m%y`.tbz /usr/local/etc/cups
cp -p /usr/local/etc/rc.d/cups.sh /home/bup/update/cups/cups.sh-`date +%d%m%y`
cp -p /etc/printcap /home/bup/update/cups/printcap-`date +%d%m%y`
```

openssl update openssl.cnf

gnupg update

Maildrop update
```
mkdir -p /home/bup/update/maildrop
cp -p /usr/local/etc/maildroprc /home/bup/update/maildrop/maildroprc-`date +%d%m%y`
cp /etc/mailfilter /home/bup/update/maildrop/mailfilter-`date +%d%m%y`
(user file: .mailfilter )
```



Amavisd-new update

FreeTDS update

Dansguardian. Squid update ...

p5-XML-Parser Problems

some programs fail to recognize perl dependencies correctly including perl5.8
itself do this:

cd /usr/ports/lang/perl5.8 && make deinstall && portupgrade defunct/module
Sorted same for p5-XML-Parser problems (make sure perl is ok)


courier-imap:
```
mkdir -p /home/bup/update/courier-imap
tar cfvpj  /home/bup/update/courier-imap/courier-imap-etc-`date +%d%m%y`.tbz /usr/local/etc/courier-imap/
tar cfvpj  /home/bup/update/courier-imap/libexec-courier-imap-`date +%d%m%y`.tbz /usr/local/libexec/courier-imap/
tar cfvpj  /home/bup/update/courier-imap/courier-rcd-`date +%d%m%y`.tbz /usr/local/etc/rc.d/courier* /usr/local/etc/rc.d/imap*
```


courier-authlib:
```
mkdir -p /home/bup/update/courier-authlib
tar cfvpj  /home/bup/update/courier-authlib/courier-authlib-etc-`date +%d%m%y`.tbz /usr/local/etc/authlib/
tar cfvpj  /home/bup/update/courier-authlib/courier-rcd-`date +%d%m%y`.tbz /usr/local/etc/rc.d/courier* /usr/local/etc/rc.d/imap*
tar cfvpj  /home/bup/update/courier-authlib/libexec-courier-authlib-`date +%d%m%y`.tbz /usr/local/libexec/courier-authlib/
tar cfvpj  /home/bup/update/courier-authlib/lib-courier-authlib-`date +%d%m%y`.tbz /usr/local/lib/courier-authlib/
/usr/local/libexec/courier
authlib/
```


vpopmail: VERY CAREFULL WITH THE OPTIONS (SQL/NON-SQL etc)
Do a Backup first:

```
mkdir -p /home/bup/update/vpopmail
tar cfvpj /home/bup/update/vpopmail/vpopmail-`date +%d%m%y`.bz2 /usr/local/vpopmail
tar cfvpj /home/bup/update/vpopmail/vpopmail-bin-`date +%d%m%y`.bz2 /usr/local/vpopmail-bin
cd /usr/ports/mail/vpopmail
WITH_QMAIL_EXT=yes make WITH_SINGLE_DOMAIN=YES WITHOUT_ROAMING_USERS=YES WITH_CLEAR_PASSWD=YES WITH_AUTH_LOG=YES WITH_VALIAS=YES WITH_MYSQL=NO WITH_SQL_LOG=NO WITH_DOMAIN_QUOTAS=YES WITHOUT_PASSWD=YES RELAYCLEAR=30 LOGLEVEL=p make
```

:%s/usr\/local\/www/home\/apache\/hosts\/cartuning.lu\/webmail/g
:%s/usr\/local\/www\/horde/home\/apache\/hosts\/ion.lu\/webmail/g

horde update and so on (imp/turba/kronolith/etc...)

horde 3.0.x:

WITH_PHP5=YES make 

Information for horde-3.0.4_1:

Install notice:
```
************************************************************************
Horde has been installed in /usr/local/www/horde with your blank
configuration files.

If you want Horde to access a database, you have to run the
appropriate scripts located in /usr/local/www/horde/scripts/sql.
It is recommended that you change the password of the 'hordemgr'
user used to connect to the horde database.
Horde is setup by default to access MySQL.

WARNING! if you are upgrading from Horde v. 2.2.x, you have to alter your
******** database schemas. Please read the doc UPGRADING.

You can now access Horde without a password at <http://localhost/horde/>,
and you will be logged in as an administrator. You should first configure
a real authentication backend.  Click on "Setup" in the "Administration"
menu and configure Horde. Start in the "Authentication" tab.
See the doc in /usr/local/share/doc/horde for details.
(tip: if you plan to install IMP, just keep "Automatic authentication as
a certain user", add your login to be treated as administrator, and once
IMP will be installed, switch to "Let a Horde application handle auth").
Select a log driver; if you keep 'file', do not forget to add a line
in /etc/newsyslog.conf.
Then select and configure a preferences driver.

Your /usr/local/etc/apache/httpd.conf has been updated,
you have to restart Apache.

When everything is OK, you should be able to access Horde from
<http://localhost/horde/>.
(If <http://localhost/horde/> does not run, but
 <http://localhost/horde/index.php> is OK, then you have
  to define index.php as a DirectoryIndex in
  /usr/local/etc/apache/httpd.conf.)

  There is a testing script at <http://localhost/horde/test.php>.
  ************************************************************************
```


Imp:

```
linion imp # make WITH_HTML=yes WITH_COURIER-IMAP=yes reinstall
===>  Installing for imp-4.0.3
===>   imp-4.0.3 depends on file: /usr/local/share/pear/Auth/SASL.php - found
===>   imp-4.0.3 depends on file: /usr/local/www/horde/turba/minisearch.php -
not found
===>    Verifying reinstall for /usr/local/www/horde/turba/minisearch.php in
/usr/ports/mail/turba
===>  Installing for turba-2.0.2
===>   turba-2.0.2 depends on file: /usr/local/www/horde/rpc.php - found
===>   Generating temporary packing list
===> Documentation installed in /usr/local/share/doc/turba.

************************************************************************
Turba has been installed in /usr/local/www/horde/turba with your blank
configuration files.

Horde must be configured; if not, see `pkg_info -D -x horde'.

Then, you might have to tune the configuration files located in
/usr/local/www/horde/turba/config/, specially the file sources.php.

Then, you must login to Horde as a Horde Administrator to finish the
configuration.

You have to create a table in your database; please see
/usr/local/www/horde/turba/scripts/.
You might create a LDAP schema: please see the doc LDAP.

WARNING! if you are upgrading from Turba v. 1.2.x, you have to alter your
******** schemas. Please read the doc UPGRADING.

To protect your configuration files, you have to restart Apache.
************************************************************************

===>   Registering installation for turba-2.0.2
===>   Returning to build of imp-4.0.3
===>   imp-4.0.3 depends on file: /usr/local/www/horde/ingo/filters.php - not
found
===>    Verifying reinstall for /usr/local/www/horde/ingo/filters.php in
/usr/ports/mail/ingo
===>  Extracting for ingo-1.0.1
=> Checksum OK for ingo-h3-1.0.1.tar.gz.
===>  Patching for ingo-1.0.1
===>  Configuring for ingo-1.0.1
===>  Installing for ingo-1.0.1
===>   ingo-1.0.1 depends on file: /usr/local/www/horde/rpc.php - found
===>   ingo-1.0.1 depends on file: /usr/local/include/php/main/php.h - found
===>   ingo-1.0.1 depends on file: /usr/local/lib/php/20020429/imap.so - found
===>   Generating temporary packing list
===> Documentation installed in /usr/local/share/doc/ingo.

************************************************************************
Ingo has been installed in /usr/local/www/horde/ingo with your blank
configuration files.

Horde must be configured; if not, see `pkg_info -D -x horde'.

Finally, you must login to Horde as a Horde Administrator to finish the
configuration.

To protect your configuration files, you have to restart Apache.
************************************************************************

===>   Registering installation for ingo-1.0.1
===>   Returning to build of imp-4.0.3
===>   imp-4.0.3 depends on file: /usr/local/www/horde/nag/data.php - not
found
===>    Verifying reinstall for /usr/local/www/horde/nag/data.php in
/usr/ports/deskutils/nag
===>  Extracting for nag-2.0
=> Checksum OK for nag-h3-2.0.tar.gz.
===>  Patching for nag-2.0
===>  Configuring for nag-2.0
===>  Installing for nag-2.0
===>   nag-2.0 depends on file: /usr/local/www/horde/rpc.php - found
===>   Generating temporary packing list
===> Documentation installed in /usr/local/share/doc/nag.

************************************************************************
Nag has been installed in /usr/local/www/horde/nag with your blank
configuration files.

Horde must be configured; if not, see `pkg_info -D -x horde'.

Then, you have to create the table nag_tasks, from the SQL script
/usr/local/www/horde/nag/scripts/sql/nag.sql.
For example, if your database is MySQL, you may run
mysql --user=root --password=yourpass horde < nag.sql

WARNING! if you are upgrading from Nag v. 1.1.x, you have to alter your
******** schemas. Please read the doc /usr/local/share/doc/nag/UPGRADING.

Finally, you must login to Horde as a Horde Administrator to finish the
configuration.

To protect your configuration files, you have to restart Apache.
************************************************************************

===>   Registering installation for nag-2.0
===>   Returning to build of imp-4.0.3
===>   imp-4.0.3 depends on file: /usr/local/bin/gpg - found
===>   imp-4.0.3 depends on file: /usr/local/bin/aspell - found
===>   imp-4.0.3 depends on file: /usr/local/share/pear/HTTP/Request.php -
found
===>   imp-4.0.3 depends on file: /usr/local/include/php/main/php.h - found
===>   imp-4.0.3 depends on file: /usr/local/lib/php/20020429/imap.so - found
===>   imp-4.0.3 depends on file: /usr/local/bin/deliverquota - found
===>   Generating temporary packing list
===>  Checking if mail/imp already installed
pkg_info: package bsdpan-MailTools-1.62 has no origin recorded
pkg_info: package bsdpan-Term-ReadLine-Perl-1.0203 has no origin recorded
pkg_info: package bsdpan-TermReadKey-2.21 has no origin recorded
pkg_info: package bsdpan-libnet-1.19 has no origin recorded
===> Documentation installed in /usr/local/share/doc/imp.

************************************************************************
IMP has been installed in /usr/local/www/horde/imp with your blank
configuration files.

Horde must be configured and the tables created; if not, see
`pkg_info -D -x horde'.

Then, you might have to tune the configuration files located in
/usr/local/www/horde/imp/config/, specially the file servers.php.

Then, you must login to Horde as a Horde Administrator to finish the
configuration. Please read /usr/local/share/doc/imp/INSTALL.

Warning: the filter system of IMP 3.x has been replaced by a separate
******** application => check the port mail/ingo. Ingo provides a script
         to migrate the existing filter rules from IMP 3.x, see Ingo's
         documentation.

To protect your configuration files, you have to restart Apache.

To secure your installation, it is at least recommended that you change
the default database password used by horde and imp.
Then, you might change the 'session.save_path' setting in php.ini to a
directory only readable and writeable by your webserver.
************************************************************************

===>   Registering installation for imp-4.0.3
```

backup /usr/local/etc/horde and the webroot.

```
mkdir -p /home/bup/update/horde
tar cfvpj /home/bup/update/horde/horde-etc-`date +%d%m%y`.tbz /usr/local/etc/horde
```

cclient update
just update no config needed

php update: php.ini's Backup

sudo update

qpopper update

wu-ftpd update

powerdns update
files to bup: pdns.conf
mkdir -p /home/bup/update/powerdns
cp -p /usr/local/etc/pdns.conf /home/bup/update/powerdns/

bind update

mysql update:

update all db's

```
mkdir -p /home/bup/update/sql/

for a in `/usr/local/bin/mysqlshow |/usr/bin/cut -f2 -d\| |/usr/bin/grep -v "\-\-\-\-\-\-\-"|/usr/bin/grep -v Databases |/usr/bin/grep -v dblogging`; do /usr/local/bin/mysqldump -e -q -a $a > /home/bup/update/sql/$a-UPDATE-`date +%d%m%y`.sql ; done
cd /home/bup/update/sql/ && tar cfvz db-`date +%d%m%y`.tgz *.sql && rm *.sql
cp -p /usr/local/etc/rc.d/mysql-server.sh /home/bup/update/sql/mysql-server-`date +%d%m%y`.sh
/usr/local/etc/rc.d/mysql-server.sh start
```

now you can safely update

samba update:

```
mkdir -p /home/bup/update/samba
cp -p /usr/local/etc/smb.conf /home/bup/update/samba/smb.conf-`date +%d%m%y`
cp -p /usr/local/etc/recycle.conf /home/bup/update/samba/recycle.conf-`date +%d%m%y`
cp -p /usr/local/etc/rc.d/samba.sh /home/bup/update/samba/samba.sh-`date +%d%m%y`
cp -rp /usr/local/private /home/bup/update/samba/private-`date +%d%m%y`
```

phpgroupware update

Backup htdocs and maybe any DAtabases.

moregroupware update

Backup htdocs and maybe any DAtabases.

imap-uw: just update

engmail upgrade:

You have to manually delete the components database (compreg.dat), located in
your profile directory in order to use enigmail.

If you upgraded Mozilla/Thunderbird from a previous release you have to
remove also the XUL.mfasl file and the content of the chrome subdirectory.


php4-php5 upgrade:

Check what is running on that box and assure youself that the switch will be
flawless.

```
 pkg_delete php4-ctype-4.3.11  php4-domxml-4.3.11 php4-ftp-4.3.11
 php4-gd-4.3.11 php4-gettext-4.3.11 php4-iconv-4.3.11 php4-imap-4.3.11
 php4-ldap-4.3.11  php4-mbstring-4.3.11 php4-mcal-4.3.11 php4-mcrypt-4.3.11
 php4-mhash-4.3.11 php4-mysql-4.3.11 php4-openssl-4.3.11  php4-pcre-4.3.11
 php4-pear-4.3.11 php4-session-4.3.11  php4-xml-4.3.11 php4-zlib-4.3.11
```

mysql40-mysql41:

Not very difficult but you need a DUMP of your database.

```
mkdir -p /home/bup/update/sql/
mysqldump -e -q -a -A  > /home/bup/update/sql/`hostname`-`date +%d%m%y`.sql
for a in `/usr/local/bin/mysqlshow |/usr/bin/cut -f2 -d\| |/usr/bin/grep -v "\-\-\-\-\-\-\-"|/usr/bin/grep -v Databases |/usr/bin/grep -v dblogging`; do /usr/local/bin/mysqldump -e -q -a $a > /home/bup/update/sql/$a-UPDATE-`date +%d%m%y`.sql ; done
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

WITH_HELP=NO WITH_DOMAIN_AUTOFILL=NO WITH_SPAM_DETECTION=NO WITH_MODIFY_QUOTA=NO PREFIX=/home/apache CGIBINDIR=cgi-bin CGIBINSUBDIR= CGIBINURL=/cgi-bin WEBDATADIR=hosts/ion.lu WEBDATASUBDIR=qmailadmin make install
```


razor-agents: just update...

mrtg update:
```
mkdir -p /home/bup/update/mrtg
tar cfvpj /home/bup/update/mrtg/mrtg-`date %%d%m%y`.tbz /usr/local/etc/mrtg
```

qmailmrtg7: 
```
/usr/local/etc/qmailmrtg*
```

php update:

```
mkdir -p /home/bup/update/php
cp -rp /usr/local/etc/php /home/bup/update/php
cp -p /usr/local/etc/php* /home/bup/update/php
```


qmail-ion-spamfilter upgrade:

 - Qmail patch-level

```
FreeBSD ports applied patches:

x x [X] QMAILQUEUE_PATCH       run a QMAILQUEUE
x x [X] BIG_TODO_PATCH         enable big_todo
x x [X] BIG_CONCURRENCY_PATCH  use a concurrency
x x [X] OUTGOINGIP_PATCH       set the IP address
x x [ ] QMTPC_PATCH            send email using
x x [ ] BLOCKEXEC_PATCH        block many windows
x x [ ] DISCBOUNCES_PATCH      discard

x x [ ] LOCALTIME_PATCH        emit dates in the
x x [ ] MAILDIRQUOTA_PATCH     Maildir++ support
x x [ ] SPF_PATCH              Implement SPF
x x [ ] RCDLINK                create
```


stock qmail upgrade:
```
cd /usr/ports/mail/qmail
make config 
```
Check if all clear.
```
portupgrade -Rri qmail
```

isc-dhcp upgrade:
```
mkdir -p /home/bup/update/isc-dhcp3
cp -p /usr/local/etc/dhcpd.conf /home/bup/update/isc-dhcp3/dhcpd.conf-`date +%d%m%y`
cp -p /usr/local/etc/rc.d/isc-dhcpd.sh /home/bup/update/isc-dhcp3/isc-dhcpd.sh-`date +%d%m%y`
```

apache13 to apache2 upgrade:

build apache2 first and make backups of everything.
Make sure your root stays: /home/apache
make deinstall old apache, make install new apache
Recompile all possible dependencies. (php and the like)

apache2 upgrade:

```
mkdir -p /home/bup/update/apache2
tar cfvpj /home/bup/update/apache2/home-apache-`date +%d%m%y`.tbz /home/apache /usr/local/www
cp -p /usr/local/etc/rc.d/apache2.sh /home/bup/update/apache2/apache2.sh-`date +%d%m%y`
```

qmrtg upgrade:

