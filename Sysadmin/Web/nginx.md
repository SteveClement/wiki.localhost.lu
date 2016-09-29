# Installing nginx

## FreeBSD

```
portinstall nginx
portinstall lang/php5
portinstall www/spawn-fcgi
portinstall sysutils/daemontools
```

## Ubuntu

```
sudo apt-get install nginx php7.0-cgi php7.0-cli spawn-fcgi daemontools-run
```

### php7 integration


:warning: You should have "cgi.fix_pathinfo = 0;" in php.ini

```

sudo vi /etc/nginx/sites-enabled/default

# Uncomment the PHP lines:

…

        # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
        #
        location ~ \.php$ {
                include snippets/fastcgi-php.conf;
        #
        #       # With php7.0-cgi alone:
                fastcgi_pass 127.0.0.1:9000;
        #       # With php7.0-fpm:
        #       fastcgi_pass unix:/run/php/php7.0-fpm.sock;
        }
…
```

#### Monitoring php-cgi

Installation of spawn-fcgi into /etc/sv can be done as follow:

```
server:# mkdir -p /etc/sv/spawn-fcgi
server:# cd /etc/sv/spawn-fcgi
```

The run script


In directory /etc/sv/spawn-fcgi, that we will call the service directory, we need a run script that will be read by the supervise program to start the processes. This run script contains the command line to start spawn-fcgi. An important argument to add is the -n switch, that will prevent spawn-fcgi to fork.

My run script for spawn-fcgi looks like the following:

```
server:/etc/sv/spawn-fcgi# cat run
#!/bin/sh
exec /usr/bin/spawn-fcgi -n -a 127.0.0.1 -p 9000 -u www-data -g www-data -C 5 /usr/bin/php-cgi


server:/etc/sv/spawn-fcgi# chmod +x run
server:/etc/sv/spawn-fcgi# initctl start svscan
server:/etc/sv/spawn-fcgi# update-service --add /etc/sv/spawn-fcgi spawn-fcgi
server:# ps -edf
[ ... ]
root     25995 19315  0 09:39 ?        00:00:00 supervise spawn-fcgi
www-data 26231 25995  0 09:54 ?        00:00:00 /usr/bin/php-cgi
www-data 26233 26231  0 09:54 ?        00:00:00 /usr/bin/php-cgi
www-data 26234 26231  0 09:54 ?        00:00:00 /usr/bin/php-cgi
www-data 26235 26231  0 09:54 ?        00:00:00 /usr/bin/php-cgi
www-data 26236 26231  0 09:54 ?        00:00:00 /usr/bin/php-cgi
www-data 26237 26231  0 09:54 ?        00:00:00 /usr/bin/php-cgi


update-service has created a symlink into /etc/service and internal control files into /var/lib/supervise.

server# ls -l /etc/service
total 0
lrwxrwxrwx 1 root root 22  1 sept. 10:34 spawn-fcgi -> /etc/sv/spawn-fcgi

server# ls -l /var/lib/supervise/spawn-fcgi/
total 4
prw------- 1 root root  0  1 sept. 10:34 control
-rw------- 1 root root  0  1 sept. 10:34 lock
prw------- 1 root root  0  1 sept. 10:34 ok
-rw-r--r-- 1 root root 18  1 sept. 10:36 status
```

Control the service

The program svc can be used to control (start, stop) the service. It takes two arguments: the signal to send and the service directory.

To stop a service:

```
server:# svc -d /etc/service/spawn-fcgi
```

And to start it again:

```
server:# svc -u /etc/service/spawn-fcgi
```


## nginx config

```
        root /usr/share/nginx/www;
        index index.html index.htm index.php;


…

        # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
        #
        location ~ \.php$ {
                fastcgi_pass 127.0.0.1:9000;
                fastcgi_index index.php;
                fastcgi_param  SCRIPT_FILENAME  /usr/share/nginx/www/$fastcgi_script_name;
                include fastcgi_params;
        }
```
