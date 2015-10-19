# NfSen - Netflow Sensor

[NfSen](http://nfsen.sourceforge.net/)

```
sudo apt-get install libsocket6-perl nginx php5-cgi spawn-fcgi rrdtool librrds-perl nfdump flow-tools fprobe gcc php5 php5-cli libmailtools-perl perl bison flex byacc librrd-dev
sudo useradd nfsen
sudo chown -R nfsen /usr/nfsen
sudo /usr/bin/nfsen start

wget "http://downloads.sourceforge.net/project/nfdump/stable/nfdump-1.6.5/nfdump-1.6.5.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fnfdump%2F&ts=1328557767&use_mirror=switch"
mv nfdump-1.6.5.tar.gz\?r\=http\:%2F%2Fsourceforge.net%2Fprojects%2Fnfdump%2F\&ts\=1328557767\&use_mirror\=switch nfdump-1.6.5.tar.gz
tar xfvz nfdump-1.6.5.tar.gz
cd nfdump-1.6.5
./configure --enable-nfprofile --enable-nftrack --prefix=/usr --datadir=/usr --localstatedir=/var --sysconfdir=/etc
make
sudo make install
wget "http://downloads.sourceforge.net/project/nfsen/stable/nfsen-1.3.6p1/nfsen-1.3.6p1.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fnfsen%2F&ts=1328559148&use_mirror=kent"
mv nfsen-1.3.6p1.tar.gz\?r\=http\:%2F%2Fsourceforge.net%2Fprojects%2Fnfsen%2F\&ts\=1328559148\&use_mirror\=kent nfsen-1.3.6p1.tar.gz
tar xfvz nfsen-1.3.6p1.tar.gz
cd nfsen-1.3.6p1
vi etc/nfsen-dist.conf
sudo ./install.pl etc/nfsen-dist.conf
```


nfsen-dist.conf.patch

```
--- etc/nfsen-vanilla.conf  2012-02-06 21:13:54.140689326 +0100
+++ etc/nfsen-dist.conf 2012-02-06 21:21:37.488663132 +0100
@@ -18,7 +18,7 @@
 
 #
 # Required for default layout
-$BASEDIR = "/data/nfsen";
+$BASEDIR = "/usr";
 
 #
 # Where to install the NfSen binaries
@@ -30,13 +30,13 @@
 
 #
 # Where to install the config files
-$CONFDIR="${BASEDIR}/etc";
+$CONFDIR="/etc/nfsen";
 
 #
 # NfSen html pages directory:
 # All php scripts will be installed here.
 # URL: Entry point for nfsen: http://<webserver>/nfsen/nfsen.php
-$HTMLDIR    = "/var/www/nfsen/";
+$HTMLDIR    = "/var/www/nginx-default/nfsen/";
 
 #
 # Where to install the docs
@@ -47,7 +47,7 @@
 $VARDIR="${BASEDIR}/var";
 
 # directory for all pid files
-# $PIDDIR="$VARDIR/run";
+$PIDDIR="/var/run/nfsen";
 #
 # Filter directory
 # FILTERDIR="${VARDIR}/filters";
@@ -60,15 +60,15 @@
 #
 # The Profiles stat directory, where all profile information
 # RRD DBs and png pictures of the profile are stored
-$PROFILESTATDIR="${BASEDIR}/profiles-stat";
+$PROFILESTATDIR="${BASEDIR}/nfsen/profiles-stat";
 
 #
 # The Profiles directory, where all netflow data is stored
-$PROFILEDATADIR="${BASEDIR}/profiles-data";
+$PROFILEDATADIR="${BASEDIR}/nfsen/profiles-data";
 
 #
 # Where go all the backend plugins
-$BACKEND_PLUGINDIR="${BASEDIR}/plugins";
+$BACKEND_PLUGINDIR="${BASEDIR}/nfsen/plugins";
 
 #
 # Where go all the frontend plugins
@@ -76,7 +76,7 @@
 
 #
 # nfdump tools path
-$PREFIX  = '/usr/local/bin';
+$PREFIX  = '/usr/bin';
 
 #
 # nfsend communication socket
@@ -88,12 +88,12 @@
 # This may be a different or the same uid than your web server.
 # Note: This user must be in group $WWWGROUP, otherwise nfcapd
 #       is not able to write data files!
-$USER    = "netflow";
+$USER    = "nfsen";
 
 # user and group of the web server process
 # All netflow processing will be done with this user
-$WWWUSER  = "www";
-$WWWGROUP = "www";
+$WWWUSER  = "www-data";
+$WWWGROUP = "www-data";
 
 # Receive buffer size for nfcapd - see man page nfcapd(1)
 $BUFFLEN = 200000;
@@ -160,9 +160,9 @@
 # Ident strings must be 1 to 19 characters long only, containing characters [a-zA-Z0-9_].
 
 %sources = (
-    'upstream1'    => { 'port' => '9995', 'col' => '#0000ff', 'type' => 'netflow' },
-    'peer1'        => { 'port' => '9996', 'IP' => '172.16.17.18' },
-    'peer2'        => { 'port' => '9996', 'IP' => '172.16.17.19' },
+    'upstream'    => { 'port' => '555', 'col' => '#0000ff', 'type' => 'netflow' },
+#    'peer1'        => { 'port' => '9996', 'IP' => '172.16.17.18' },
+#    'peer2'        => { 'port' => '9996', 'IP' => '172.16.17.19' },
 );
 
 #
@@ -213,6 +213,9 @@
 @plugins = (
     # profile    # module
     # [ '*',     'demoplugin' ],
+##    [ 'live', 'SURFmap' ],
+##    [ 'live', 'nfsight' ],
+##    [ 'live', 'PortTracker' ],
 );
 
 %PluginConf = (
@@ -228,15 +231,36 @@
        # array
        'mary had a little lamb' 
    ],
+        nfsight => {
+                path => "/usr/nfsen/plugins/nfsight",
+                expiration => "180",
+                network => {
+                        "192.168.218.0" => "24",
+                },
+                scanner_limit => "5",
+                print_int_scanner => "1",
+                print_ext_scanner => "1",
+                print_int_client => "0",
+                print_ext_client => "0",
+                print_int_server => "1",
+                print_ext_server => "0",
+                print_int_invalid => "0",
+                print_ext_invalid => "0",
+                sql_host => "127.0.0.1",
+                sql_port => "3306",
+                sql_user => "nfsight",
+                sql_pass => 'yourPassWord',
+                sql_db => "dbnfsight",
+        },
 );
 
 #
 # Alert module: email alerting:
 # Use this from address 
-$MAIL_FROM   = 'your@from.example.net';
+$MAIL_FROM   = 'rootmails@example.com';
 
 # Use this SMTP server
-$SMTP_SERVER = 'localhost';
+$SMTP_SERVER = 'zimbra.iongroup.lu';
 
 # Use this email body:
 # You may have multiple lines of text.
```


## References

http://nfsen.sourceforge.net/#mozTocId853803

http://code.google.com/p/installnfsen/wiki/InstallNetFlowWithNfSen
