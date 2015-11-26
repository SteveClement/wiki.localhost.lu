Should you get:

[Wed Jan 30 10:23:57 2008] [warn] (2)No such file or directory: Failed to enable the 'httpready' Accept Filter

Then you are missing the accf_http_load module, simply load it:

```
kldload accf_http
```

then restart apache:

```
/usr/local/etc/rc.d/apache22 restart
```

and make it permanent:

```
echo "accf_http_load=\"YES\"" >> /boot/loader.conf
```
