# MySQL Install on FreeBSD

```
echo "databases/mysql51-server: WITH_OPENSSL|WITH_CHARSET=utf8|WITH_COLLATION=utf8_general_ci|BUILD_OPTIMIZED" >> /usr/local/etc/ports.conf
portinstall databases/mysql51-server

echo mysql_enable=\"YES\" >> /etc/rc.conf
cp -pi /usr/local/share/mysql/my-medium.cnf /var/db/mysql/my.cnf
chgrp mysql /var/db/mysql/my.cnf
```

Edit my.cnf to bind MySQL to 127.0.0.1 add:

```
bind-address    = 127.0.0.1
```

```
/usr/local/etc/rc.d/mysql-server start
```

## MODIFY MYSQL ROOT PASSWORD NOW!!!

```
/usr/local/bin/mysqladmin -u root password 'mysql-root-pwd'
```

VERSION_INFO: mysql-5.1 was stable at the time of this writing, please check
whether or not that is still true!

## Knobs

You may use the following build options:

```
        WITH_CHARSET=charset    Define the primary built-in charset (latin1).
        WITH_XCHARSET=list      Define other built-in charsets (may be 'all').
        WITH_COLLATION=collate  Define default collation (latin1_swedish_ci).
        WITH_OPENSSL=yes        Enable secure connections.
        WITH_LINUXTHREADS=yes   Use the linuxthreads pthread library.
        WITH_PROC_SCOPE_PTH=yes Use process scope threads
                                (try it if you use libpthread).
        WITH_FAST_MUTEXES=yes   Replace mutexes with spinlocks.
        BUILD_OPTIMIZED=yes     Enable compiler optimizations
                                (use it if you need speed).
        BUILD_STATIC=yes        Build a static version of mysqld.
                                (use it if you need even more speed).
        WITH_NDB=yes            Enable support for NDB Cluster.
```