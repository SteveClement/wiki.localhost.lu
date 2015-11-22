# Updating Asterisk 1.4 from Source and Stuffing it with BRI
## check out source
```
cd /usr/src/
svn co http://svn.digium.com/svn/
/branches/1.4/
-1.4-stable
```

## update source
```
cd
-1.4-stable
svn up
svn status
```

## BRIstuff
get Junghanns.Net BRIstuff, http://www.junghanns.net/en/download.html

The support for 1.4 is considered Experimental under Junghanns. Out of experience I can say that I run a 10 Phone '''Asterisk''' Company Server on this code without issues.

http://www.junghanns.net/downloads/bristuff-0.4.0-RC1.tar.gz

tar xfvz bristuff it has a "handy" installer script that I wouldn't use, instead do it manually:

Some version infos for the 0.4.0 release,

ZAP_VER=1.4.7.1 PRI_VER=1.4.3 AST_VER=1.4.17 ADD_VER=1.4.5

./download.sh

## compile and install
```
./configure --without-h323 --without-odbc --without-tds --without-postgres --with-ogg --without-radius --with-netsnmp --with-iksemel --with-sqlite
make
make install
```

Once installed it gives you a Warning Notice:
```
Your
 modules directory, located at
 /usr/lib/
/modules
 contains modules that were not installed by this
 version of
. Please ensure that these
 modules are compatible with this version before
 attempting to run
.

    app_addon_sql_mysql.so
    app_ldap.so
    app_notify.so
    app_saycountpl.so
    cdr_addon_mysql.so
    chan_capi.so
    chan_ooh323.so
    format_mp3.so
    res_config_mysql.so
```
So do as the man says and recompile the important stuff

## asterisk-addons recompile
```
cd /usr/src/
# Can be skipped if you have an already checked-out version
svn co http://svn.digium.com/svn/
-addons/branches/1.4/
-addons-1.4-stable
cd
-addons-1.4-stable
svn up
svn status
./configure
make
make install
```

## app_ldap
```
cd /home/software/unpacked/app_ldap-2.0rc1
make clean
make
make install
```

## app_notify
```
cd /home/software/unpacked/app_notify-2.0rc1
make clean
make
make install
```

## rx_fax
you need cmake get: http://garr.dl.sourceforge.net/sourceforge/agx-ast-addons/agx-ast-addons-1.4.5.tar.bz2 unpack apply patch:
```
--- app_devstate.c.old  2007-11-19 09:27:20.000000000 +0100
+++ app_devstate.c      2008-05-31 15:49:40.000000000 +0200
@@ -58,9 +58,9 @@
     snprintf(devName, sizeof(devName), "DS/%s", argv[1]);
     if (argc == 4) {
         ast_log(LOG_NOTICE, "devname %s cid %s\n", devName, argv[3]);
-       ast_device_state_changed_literal(devName);
+       ast_device_state_changed_literal(devName, NULL, NULL);
     } else {
-       ast_device_state_changed_literal(devName);
+       ast_device_state_changed_literal(devName, NULL, NULL);
     }
     return RESULT_SUCCESS;
 }
@@ -93,7 +93,7 @@
     }

     snprintf(devName, sizeof(devName), "DS/%s", device);
-    ast_device_state_changed_literal(devName);
+    ast_device_state_changed_literal(devName, NULL, NULL);

     return 0;
 }
```

run: ./build.sh
## /usr/src/agx-ast-addons
## restart asterisk
```
tail -F /var/log/
/messages &
/etc/init.d/
 restart
```

## debian
```
./configure --without-h323 --without-odbc --without-tds
--without-postgres --with-ogg --without-radius --with-netsnmp --with-iksemel
--with-sqlite

apt-get install \
libiksemel-dev \
libsnmp-dev9 \
libogg-dev \
libsqlite3-dev \
libsqlite0-dev
```
