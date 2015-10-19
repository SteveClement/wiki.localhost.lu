# lighttpd - lighty

[Lighttpd](http://www.lighttpd.net/)

```
====================
MySQL-based vhosting
====================

-----------------------
Module: mod_mysql_vhost
-----------------------

.. meta::
  :keywords: lighttpd, mysql, vhost

.. contents:: Table of Contents

Description
===========

With MySQL-based vhosting you can store the path to a given host's
document root in a MySQL database.

.. note:: Keep in mind that only one vhost module should be active at a time.
          Don't mix mod_simple_vhost with mod_mysql_vhost.

Options
=======

Example: ::

  mysql-vhost.db             = "lighttpd"
  mysql-vhost.user           = "lighttpd"
  mysql-vhost.pass           = "secret"
  mysql-vhost.sock           = "/var/run/mysqld/mysqld.sock"
  mysql-vhost.sql            = "SELECT docroot FROM domains WHERE domain='?';"
  mysql-vhost.hostname           = "localhost"
  mysql-vhost.port           = 3306

If specified, mysql-vhost.host overrides mysql-vhost.sock.

MySQL setup: ::

  GRANT SELECT ON lighttpd.* TO lighttpd@localhost IDENTIFIED BY 'secret';

  CREATE DATABASE lighttpd;

  USE lighttpd;

  CREATE TABLE domains (
    domain varchar(64) not null primary key,
    docroot varchar(128) not null
  );

  INSERT INTO domains VALUES ('host.dom.ain','/http/host.dom.ain/');

```


## Per-vhost configuration

I wanted to be able to add configuration directives per vhost.  This is how I did it.

```
CREATE TABLE IF NOT EXISTS domains (
  domain varchar(64) NOT NULL PRIMARY KEY,
  docroot varchar(128) NOT NULL,
  config text
);
```


then I added this line to my mysql-vhost.conf (but you can use lighttpd.conf)

```
include_shell "/usr/share/lighttpd/mysql_vhost.py lighttpd lighttpd secret"
```



the parameters are just the info above.  I didn't know how to pass the actual variables (maybe someone else does?) so I just repeated their values.

I then made a script called /usr/share/lighttpd/mysql_vhost.py, which just prints the info.  You could write this in perl, php, or bash, if you want.

it should output this format:

```
$HTTP["host"] == "<DOMAIN_FROM_DATABASE>" {
<CONFIG_FROM_DATABASE>
}
```

mine looks like this:

```
#!/usr/bin/env python
import sys
import MySQLdb

# load configuration data from the database
db=MySQLdb.connect(host='localhost', db=sys.argv[1], user=sys.argv[2], passwd=sys.argv[3])
cur = db.cursor()
cur.execute("SELECT * FROM domains")
rs=cur.fetchall()
db.close()

for domain in rs:    

    print "$HTTP[\"host\"] == \"%s\" {\nserver.document-root = \"%s\"\n%s\n}" % (domain[0], domain[1], domain[2])
```

Now, you can put whatever directives you want in the config field.
Make sure to restart your server to enable the settings, if you change them in the database.

## The simple way

If you use lighttpd 1.3.8 and above, you can use a conditional to protect your images.

```
# deny access for all image stealers
$HTTP["referer"] !~ "^($|http://www\.example\.org)" {
  url.access-deny = ( ".jpg", ".jpeg", ".png" )
}
```

## Remembering their IPs

[mod_trigger_b4_dl](http://www.lighttpd.net/documentation/trigger_b4_dl.html) might match your needs more directly.
As long as the user didn't access your main site, he will be redirected to another URL. After he checks that URL, he will get access to the files.

IP or the IP behind the Proxy is stored in a database (gdbm or memcached) and will timeout after it is no longer used anymore:

```
$HTTP["host"] == "www.example.org" {
  #trigger-before-download.gdbm-filename = "/var/www/servers/www.example.org/trigger.db"
  trigger-before-download.memcache-hosts = ( "127.0.0.1:11212" )
  trigger-before-download.debug = "disable"

  trigger-before-download.deny-url = "http://www.example.org/"
  trigger-before-download.trigger-timeout = 10
  trigger-before-download.trigger-url = "(/$|\.php)"
  trigger-before-download.download-url = "(\.mpe?g|\.wmv)"
}
```

## Using links that timeout

Let's assume that you have very unique gallery at your page and that you don't want someone else to link to the images directly.

A well known way to handle this is to check if the referrer matches your site or is still empty. But is the referrer trustable?

Lighttpd's [mod_secdownload](http://www.lighttpd.net/documentation/secdownload.html) module can generate URLs with an admin-definable timeout. 

!http://www.example.org/gallery/<md5>/<timestamp>/image.jpg

The URLs becomes invalid after about 30 seconds (admin configurable) and if the link is deep-linked from another site, the link would only work for a very short time. 

All you have to do is to generate the links for the images is use a very simple script:

```
#!php
<?php

$secret = "verysecret";
$uri_prefix = "/dl/";

# filename
$f = "/secret-file.txt";

# current timestamp
$t = time();

$t_hex = sprintf("%08x", $t);
$m = md5($secret.$f.$t_hex);

# generate link
printf('<a href="%s%s/%s%s">%s</a>',
       $uri_prefix, $m, $t_hex, $f, $f);
?>
```

and to set up the config on the side of lighttpd:

```
secdownload.secret          = "verysecret"
secdownload.document-root   = "/home/www/servers/download-area/"
secdownload.uri-prefix      = "/gallery/"
```

Since the document root of secured files are outside of the web directory, the files can't be accessed directly. As long as the URL itself is valid (MD5 + timestamp), the file is sent from the secure directory, otherwise the request is denied.

John Leach adds a tweak to change the URLs only every 5 minutes and gives a example in Ruby at http://johnleach.co.uk/words/archives/2006/03/16/213


## Using a PHP to control the sent file

If you need more flexibility and can spare some CPU cycles for a FastCGI app like PHP you can instruct lighttpd from the FastCGI side to send out a static file. 

( Actually this is the way FastCGI Authorizer work, but PHP doesn't allow us to run it as authorizer. )

Since Lighttpd 1.4.4 we support the ``X-LIGHTTPD-send-file`` response header which instructs the lighttpd to ignore the content of the response and replace it with the specified file. As this allows to send any file that the server can read, this feature is disabled by default and should only be enabled in controled environments. You are warned.

```
<?php
header("X-LIGHTTPD-send-file: /path/to/protected/file");
?>
```

and enable the support in the configuration:

```
fastcgi.server = ( ".php" => (( ..., "allow-x-send-file" => "enable" )) )
```

If the option is not enabled, the X-LIGHTTPD-send-file header is ignored. As all headers starting with X-LIGHTTPD this header is filtered out before the final header for the HTTP response is formed. It is not seen by the user.

## Comments

Should this page be called "hot linking" instead of "deep linking"? "Deep linking" is supposed to mean linking to a specific HTML (not image) page on your website instead of the front page, and that can be *good* - see http://www.useit.com/alertbox/20020303.html . -Philip Mak <pmak@aaanime.net>

It appears he is trying to protect a limited set of a particular kind of file (e.g., a photo album) from being deep linked, not the whole site.  -wls, <wls@wwco.com>

Interesting. I'm just learning about lighttpd. I've been doing this sort of thing on apache by creating a random-length (11-17) random alphabetic symlink in php which gets deleted when the user's session dies. The symlink points to the media directory outside the webtree. Thus it only needs to be done once per session.
