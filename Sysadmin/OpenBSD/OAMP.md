Install Apache, MySQL And PHP On OpenBSD 6.1

```
$ su -
# echo "permit nopass keepenv setenv { PKG_PATH ENV PS1 SSH_AUTH_SOCK } :wheel" > /etc/doas.conf
# echo "https://ftp.bit.nl/pub/OpenBSD/" > /etc/installurl
# ^D
$ doas pkg_add -v apache-httpd
$ doas pkg_add -v php-mysqli
$ doas pkg_add -v mariadb-server
$ doas mysql_install_db
$ doas rcctl start mysqld
$ doas /usr/local/bin/mysql_secure_installation
$ doas vi /etc/apache2/httpd2.conf
```

$ doas vi /etc/php-fpm.conf



```
(...)
error_log = "syslog"
(...)
listen = 127.0.0.1:9000
(...)
chroot = /var/www
(...)
```

```
$ doas rcctl enable php70_fpm
$ doas rcctl start php70_fpm
$ doas rcctl enable mysqld
$ doas rcctl start mysqld

$ doas ln -sf /var/www/conf/modules.sample/php-7.0.conf \
        /var/www/conf/modules/php.conf
```

mysqld reset password

```
$ doas rcctl set mysqld flags --skip-grant-tables
$ doas rcctl restart mysqld
$ doas /usr/local/bin/mysql_secure_installation
$ doas rcctl set mysqld flags
$ doas rcctl restart mysqld
```

OHMP - use native httpd

minimal /etc/httpd.conf

```
server "default" {
        listen on egress port 80
}

types {
        text/css                css
        text/html               html htm
        text/txt                txt
        image/gif               gif
        image/jpeg              jpeg jpg
        image/png               png
        application/javascript  js
        application/xml         xml
}
```

$ doas /etc/rc.d/httpd -f start

