# OpenID on FreeBSD

We will now investigate the OpenID implementations in FreeBSD 7.0 Ports.

some ports to note:

```
security/phpmyid
security/py-openid
security/p5-Net-OpenID-Server
security/pear-Auth_OpenID
```


# phpmyid

To install it:

```
portinstall security/phpmyid
portinstall math/php5-bcmath # phpmyid recommends this particular port
```

This creates:

```
/usr/local/www/phpMyID
```

all included there
