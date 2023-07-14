# Installing lighttpd on Ubuntu

## Install via apt-get
```
sudo apt-get install php5-cgi lighttpd
```

## Enable FastCGI and php5 the ubuntu way
```
cd /etc/lighttpd/conf-enabled
ln -s ../conf-available/10-fastcgi.conf
```