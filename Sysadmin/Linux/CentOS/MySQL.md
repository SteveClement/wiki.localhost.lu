# MySQL on CentOS 5.2

I had a very weird phenomena where I tried to connect to a remote MySQL server with php5's mysqlconnect but I got a connection failure:

```
[Sun Oct 26 17:57:47 2008] [error] [client 83.99.12.22] PHP Warning:  mysql_connect() [<a href='function.mysql-connect'>function.mysql-connect</a>]: Can't connect to MySQL server on 'xenon.ion.lu' (13) in /var/www/vhosts/biketrip.lu/httpdocs/tools/adodb5/drivers/adodb-mysql.inc.php on line 363
```

on the command line everything was ok but over the scripts it was borked.

After some googling a guy suggested:

http://docs.fedoraproject.org/selinux-faq-fc3/index.html#id2825945

So I did:

```
system-config-securitylevel
```

and set SELinux to permissive and all was fine

# benchmark
```
cd mysql-src-dir/sql-bench
make install
cd /usr/local/sql-bench
vi README
portinstall p5-DBI p5-DBD-mysql
./run-all-tests --flags
```


# log rotation

Handy mysql log rotation script. 

For those not using any chroot environements, comment out both lines in #chroot section. 
Set MYSQL_HOME QUERYLOG SLOWLOG ERRLOG appropiately.

```
#!/bin/sh
###############################################
# MySQL log rotation
# mjaw@ipartners.pl
###############################################

# chroot
VIRTUAL="/virtual"
VIRTUAL_HOME="${VIRTUAL}/mysql"

# mysql
MYSQL_HOME="${VIRTUAL_HOME}/usr/local/mysql"
DATADIR="${MYSQL_HOME}/var"
LOGDIR="${MYSQL_HOME}/log"
QUERYLOG="${LOGDIR}/querylog"
SLOWLOG="${LOGDIR}/slowlog"
ERRLOG="${LOGDIR}/errlog"

# most universal method for calculating
yesterday's date in YYYYMMDD format
DATE=`/usr/bin/perl -e
"@a=localtime(time-86400);printf('%02d%02d%02d',@a[5]+1900,@a[4]+1,@a[3])"`

PID_FILE=$DATADIR/`/bin/hostname`.pid

if ! [ -s ${PID_FILE} ]; then
echo " Error: pid file not found."
exit 1;
fi

PID=`cat $PID_FILE`

echo -n "Rotating logs: "

if [ -e ${QUERYLOG} ]; then
echo -n "querylog "
/bin/mv ${QUERYLOG} ${QUERYLOG}.${DATE}
fi
if [ -e ${SLOWLOG} ]; then
echo -n "slowlog "
/bin/mv ${SLOWLOG} ${SLOWLOG}.${DATE}
fi
if [ -e ${ERRLOG} ]; then
echo -n "errlog "
/bin/mv ${ERRLOG} ${ERRLOG}.${DATE}
fi

/bin/kill -1 $PID
```

Run from cron at midnight.

# two way replication

 A two-way replication test setup

 I just used this thread as a reference for setting up my two-way setup (in
 addition to the mysql docs etc). Thought I'd post my complete setup to make
 it even easier for others to set up the same.

 Setup:
 --------
 Server 1: Behind firewall, fixed public IP address statically mapped to
 internal IP (i.e. a1.b1.c1.d1 <==> 10.56.0.5)
 Server 2: Behind firewall and NAT, fixed public IP address (a2.b2.c2.d2) on
 the public router interface + created a so-called "virtual server" (static
 NAT) from the public address to the inside address of server 2 (i.e.
 a2.b2.c2.d2:3306 => 192.168.0.10)
 Both servers run RedHat 8.0, with mysql 3.23.58

 In addition, both incoming and outgoing ports were opened in the firewalls to
 the other server, respectively.
 ---------

 To make it simple and to give you an idea of what's happening:
 1. When you start replicating, the database and the tables (incl. data) must
 be exact matches between slave and master *OR* slave must have an older
 version of the database and the master has had the bin-log option turned on
 while changes have been done. For the last case, you MUST have the
 replication log position from master at the point of taking the master
 snapshot (by running show master status
 2. The replication info has to match on both servers. Each master has a
 binary log file (servername-00x.bin) and each slave has an id telling where
 in the master's binary log to start replicating (show slave status.
 --------------

 The following steps are required:
 A. Edit my.cnf on both servers (do not restart mysqld yet)
 B. grant file privileges to replicate@a1.b1.c1.d1 on Server 2 and to
 replicate@a2.b2.c2.d2 on server 1 (grant file on *.* to replicate@a1.b1.c1.d2
 identified by 'password'
 C. Load one server with the database from the other to make sure they are
 exact duplicates. (Ex. mysqldump or as described on mysql.com)
 D. Finally: the most tricky: Make sure that the slave's log position is the
 position the master had when you took a snapshot of the database in #3. There
 are many ways to do this and that's why everything looks so complicated when
 described. However, when doing two-way replication, the easiest is to make
 sure that no writing is done to either database until everything works!
 -----------

 Server 1, my.cnf setup:
```
 [mysqld]
 datadir=/var/lib/mysql
 socket=/var/lib/mysql/mysql.sock
 log-bin
 binlog-do-db=repltest
 server-id=2
 master-host=a2.b2.c2.d2
 master-user=replicate
 master-password=password
 replicate-do-db=repltest
```

 Server 2, my.cnf setup:
```
 [mysqld]
 datadir=/var/lib/mysql
 socket=/var/lib/mysql/mysql.sock
 log-bin
 binlog-do-db=repltest
 server-id=3
 master-host=a1.b1.c1.d1
 master-user=replicate
 master-password=password
 replicate-do-db=repltest
```

 Please note that I have used server-id 2 and 3. This is just because I have a
 third server that has #3...
 -----------
 For C, an mysqldump (as described in this thread) or a binary file copying
 can be done (described in mysql's official replication how-to).

 Read all alternatives before you do anything:
 - If you are starting both servers from scratch (no previous bin-log), you
   can now restart mysqld on both servers. You should be done!
   - If you have both servers offline (no writes), but had bin-log turned on
     from earlier, you can restart mysqld on both servers, then run reset
     slave; and reset master; (both commands on both servers). If you are not
     able to get the servers in sync, follow the next step
     - If you have both servers offline (no writes), you can alternatively use
       show master status; and show slave status; on both servers. Run the
       following on each slave: change master to master_log_pos="position of
       the master);
       - If you have one server (the original master) still running writes,
         you restart the other server, then run create master to
         master_log_pos="the position to noted when taking the dump earlier";
         Then start slave; When it has finished replication, you can restart
         the previous master.
         - If you have writes on both servers, good luck! (mysql replication
           does not support locking, so if one field has been changed on both
           servers, you have no guarantee for what will happen...)

           A note at the end: Due to the lack of locking, you should make sure
           that the applications writing to the two servers cannot write the
           same field/row to both servers with different data before the
           replication has happened.
