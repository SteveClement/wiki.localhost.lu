# dotProject Notes
## dotProject is a Project Management Web Suite

This is the [FreeBSD Ports](https://www.freebsd.org/ports/) output:

```
It is suggested that you add the following to httpd.conf:

    Alias /dotproject/ "/usr/local/www/dotproject/"

You may also need to add read permission for the directory:

    <Directory "/usr/local/www/dotproject">
        Options Indexes FollowSymlinks MultiViews
        AllowOverride All
        Order allow,deny
        Allow from all
    </Directory>

Previous version of dotProject had bugs when using MySQL 4.x.  If you
are already using MySQL 4.x, you may install databases/mysql323-server
in a jail to avoid conflicts, or consider upgrading to MySQL 5.  Also,
see http://www.dotproject.net/vbulletin/archive/index.php/t-5292.html

Visit http://<host>/dotproject/ and follow instructions to complete
the installation.
===>   Registering installation for dotproject-devel-2.1.r1
```