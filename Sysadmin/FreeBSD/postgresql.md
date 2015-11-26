# Postgreasql on FreeBSD

## Install it

```
portinstall databases/postgresql74-server
```

## Configure it

```
echo postgresql_enable=\"YES\" >> /etc/rc.conf
```

```
vi ~pgsql/data/postgresql.conf
```

### to get TCP/IP going

```
tcpip_socket = true
```

### add a line to

```
~pgsql/data/pg_hba.conf
```

## To add users, you have to add them locally with passwords

```
/usr/local/etc/rc.d/010.pgsql.sh initdb
/usr/local/etc/rc.d/010.pgsql.sh start
```