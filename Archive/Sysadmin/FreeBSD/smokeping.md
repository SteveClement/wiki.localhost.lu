# Installing smokeping

```
portinstall smokeping
```

## pkg-message

```
=================================================================

SmokePing has now been installed in /usr/local/smokeping/.

NOTE: A set of sample configuration files have been installed:

  /usr/local/etc/smokeping/config
  /usr/local/etc/smokeping/smokemail
  /usr/local/etc/smokeping/basepage.html
  /usr/local/etc/smokeping/tmail

You *MUST* edit these to suit your requirements. Please read the
manpages 'smokeping_install' and 'smokeping_config' for further
details on installation and configuration.

If you are upgrading from a previous version of Smokeping, the
manpage 'smokeping_upgrade' may be of help.

Once configured, you can start SmokePing by adding:

  smokeping_enable="YES"

to /etc/rc.conf, and then running, as root:

 /usr/local/etc/rc.d/smokeping start

To enable Apache web access, add the following to your
~apache/conf/httpd.conf:

  ScriptAlias /smokeping.cgi /usr/local/smokeping/htdocs/smokeping.cgi
  Alias /smokeimg/ /usr/local/smokeping/htdocs/img/

Enjoy!

=================================================================
```

## httpd.conf

```
ScriptAlias /smokeping.cgi /usr/local/smokeping/htdocs/smokeping.cgi
Alias /smokeimg/ /usr/local/smokeping/htdocs/img/
Alias /css/ /usr/local/smokeping/htdocs/css/
Alias /nav_btn.gif /usr/local/smokeping/htdocs/nav_btn.gif
<Directory "/usr/local/smokeping/htdocs/">
    Options ExecCGI
    Order allow,deny
    Allow from all
</Directory>
```

## speedy_cgi

## custom hacks

Navigation bar hack see svn+ssh://plumbum.ion.lu/home/svn/plumbum-ion-sysadmin/trunk/patches/smokeping

copy directory contents over existing stuff