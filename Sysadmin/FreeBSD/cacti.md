# Install cacti on FreeBSD

Install Lighttpd and lang/php5 !

enable mysql or use different server

```
echo "mysql_enable=\"YES\"" >> /etc/rc.conf
portinstall cacti
```

1. Create the MySQL database:
```
myqladmin create dbcacti
```

2. Create a mysql user/password for cacti:
   (change user and/or password if requered)
```
echo "GRANT ALL ON dbcacti.* TO cactiuser@localhost IDENTIFIED BY 'cactiuser'; FLUSH PRIVILEGES;" | mysql
echo "GRANT ALL ON dbcacti.* TO cactiuser@192.168.0.13 IDENTIFIED BY 'cactiuser'; FLUSH PRIVILEGES;" | mysql
```

3. Import the default cacti database:
```
mysql -u cactiuser -p dbcacti < /usr/local/share/cacti/cacti.sql
mysql -u cactiuser -p -h curion.ion.lu dbcacti < /usr/local/share/cacti/cacti.sql
```

4. Edit /usr/local/share/cacti/include/config.php

5. Add a line to your /etc/crontab file similar to:
```
*/5 * * * * /usr/local/bin/php /usr/local/share/cacti/poller.php > /dev/null 2>&1
```

6. Add alias in apache config for the cacti dir:
```
Alias /cacti "/usr/local/share/cacti/"
alias.url = ( "/cacti/" => "/usr/local/share/cacti/" )
```

7. Be sure apache gives an access to the directory ('Allow from' keywords).

8. Open a cacti login page in your web browser and login with admin/admin.

If you update cacti, open a login page, an updating process
will start automatically.

If you are using PLUGIN option set, in file
```
/usr/local/share/cacti/include/config.php
```
change the follow line

```
$config["url_path"] = '/';
```

with location where your cacti is available. E.g.:

```
$config["url_path"] = '/cacti/';
```

if your URL is http://example.com/cacti

In a Jail:

To get proc/meminfo going:

```
linprocfs /compat/linux/proc linprocfs rw 0 0
/compat/linux/proc      /usr/home/Jails/cacti/proc nullfs rw        2 2
```
