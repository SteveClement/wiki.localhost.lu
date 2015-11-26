```
mkdir /var/db/ports/lighttpd
cat << EOF > /var/db/ports/lighttpd/options
_OPTIONS_READ=lighttpd-1.4.25
WITH_BZIP2=true
WITHOUT_CML=true
WITHOUT_FAM=true
WITHOUT_GDBM=true
WITH_IPV6=true
WITH_MAGNET=true
WITHOUT_MEMCACHE=true
WITH_MYSQL=true
WITHOUT_OPENLDAP=true
WITH_OPENSSL=true
WITHOUT_VALGRIND=true
WITH_WEBDAV=true
EOF

mkdir /var/db/ports/php5
cat << EOF > /var/db/ports/php5/options
_OPTIONS_READ=php5-5.2.11_1
WITH_CLI=true
WITH_CGI=true
WITHOUT_APACHE=true
WITHOUT_DEBUG=true
WITH_SUHOSIN=true
WITHOUT_MULTIBYTE=true
WITH_IPV6=true
WITHOUT_MAILHEAD=true
WITHOUT_REDIRECT=true
WITHOUT_DISCARD=true
WITH_FASTCGI=true
WITH_PATHINFO=true
EOF

mkdir /var/db/ports/sqlite3
cat << EOF > /var/db/ports/sqlite3/options
_OPTIONS_READ=sqlite3-3.6.19
WITHOUT_DEBUG=true
WITHOUT_FTS3=true
WITHOUT_RAMTABLE=true
WITHOUT_TCLWRAPPER=true
WITH_METADATA=true
WITH_THREADSAFE=true
EOF

mkdir /var/db/ports/e2fsprogs
cat << EOF > /var/db/ports/e2fsprogs/options
_OPTIONS_READ=e2fsprogs-libuuid-1.41.9
WITH_NLS=true
EOF

echo "lighttpd_enable=\"YES\"" >> /etc/rc.conf

touch /var/log/lighttpd.access.log
touch /var/log/lighttpd.error.log
chown www /var/log/lighttpd.access.log  /var/log/lighttpd.error.log
mkdir /var/run/lighttpd
chown www:nogroup /var/run/lighttpd

portinstall www/lighttpd lang/php5
```

## Config File

Hash in the mod_fastcgi and fastcgi.server examples:

```
server.modules = (
                   "mod_fastcgi",
                 )


fastcgi.server             = ( ".php" =>
                               ( "localhost" =>
                                 (
                                   "socket" => "/var/run/lighttpd/php-fastcgi.socket",
                                   "bin-path" => "/usr/local/bin/php-cgi"
                                 )
                               )
                            )

ssl.engine = "enable"
ssl.pemfile = "/usr/local/www/certs/star.alebion.net.pem"
ssl.ca-file = "/path/to/CA.crt"
```


# Create Self-Signed Cert

```
cd /usr/local/www
mkdir certs
chmod 700 certs && chown www:nogroup certs && cd certs
openssl req -new -x509 \
  -keyout star.alebion.net.pem -out star.alebion.net.pem \
  -days 3650 -nodes
chown www:nogroup star.alebion.net.pem
chmod 600 star.alebion.net.pem
```

# php.ini

Copy the recommended php.ini

```
 cp -p /usr/local/etc/php.ini-recommended /usr/local/etc/php.ini
```

And change

```
cgi.fix_pathinfo = 1
```


# Advanced

Advanced useage of some tuneables.

```
fastcgi.server = ( ".php" => ((
                     "bin-path" => "/path/to/php-cgi",
                     "socket" => "/tmp/php.socket",
                     "max-procs" => 2,
                     "bin-environment" => (
                       "PHP_FCGI_CHILDREN" => "16",
                       "PHP_FCGI_MAX_REQUESTS" => "10000"
                     ),
                     "bin-copy-environment" => (
                       "PATH", "SHELL", "USER"
                     ),
                     "broken-scriptfilename" => "enable"
                 )))
```

# VirtualHost's

```
simple-vhost.server-root = "/var/www/servers/"
simple-vhost.default-host = "example.org"
simple-vhost.document-root = "pages"

$HTTP["host"] == "news.example.org" {
  server.document-root = "/var/www/servers/news2.example.org/pages/"
  }
```

change documentroot

from:

to:


# https redirect

un-hash mod_redirect and add the following lines:

```
$SERVER["socket"] == ":80" {
  $HTTP["host"] =~ "(.*)" {
    url.redirect = ( "^/(.*)" => "https://%1/$1" )
  }
}
```


NOTES:

4. Zertifikat erstellen mit Berechtigungen

openssl req -new -nodes -x509 -keyout /etc/lighttpd/ssl/lighttpd.pem -out
/etc/lighttpd/ssl/lighttpd.pem -days 365
chown lighty:lighty /etc/lighttpd/ssl/lighttpd.pem
chmod 600 /etc/lighttpd/ssl/lighttpd.pem

4.1 Prozedur zur Erstellung des Zertifikats

```
Country Name (2 letter code) [AU]:DE
State or Province Name (full name) [Some-State]:$deinbundesland
Locality Name (eg, city) []:$deinestadt
Organization Name (eg, company) [Internet Widgits Pty
Ltd]:$deinebezeichnung(firma etc)
Organizational Unit Name (eg, section) []:$gruppenname
Common Name (eg, YOUR name) []:mail.meinedomain.tld
Email Address []:$mailadmin@mainedomain.tld
```

5. Passwort f<C3><BC>r Downloadverzeichnis erstellen

```
htpasswd -cmd /var/lighttpd/etc/lighttpd/password/download.pwd $username
htpasswd -cmd /var/lighttpd/etc/lighttpd/password/admin.pwd $admin
```

Sample config:

```
cat > /etc/lighttpd/lighttpd.conf << "EOF"
server.username = "lighty"
server.groupname = "lighty"
server.document-root = "/var/www/domain/htdocs/"
server.chroot = "/var/lighttpd"
server.pid-file = "/var/run/lighttpd.pid"
server.errorlog = "/var/log/lighttpd/error.log"
accesslog.filename = "/var/log/lighttpd/access.log"
server.stat-cache-engine = "simple"
server.event-handler = "linux-sysepoll"
server.name = "www.meinedomain.de"
server.max-fds = 2048
evasive.max-conns-per-ip = 10
# connection ist bei dieser Config gedrosselt, daher beibehalten, anpassen
# oder rausschmeissen
connection.kbytes-per-second = 128
server.follow-symlink = "enable"
server.dir-listing = "disable"
server.max-keep-alive-idle = 10
compress.cache-dir = "/tmp/"
compress.filetype = ("text/plain", "text/html")
server.modules = (
  "mod_access",
  "mod_status",
  "mod_cgi",
  "mod_alias",
  "mod_auth",
  "mod_evasive",
  "mod_fastcgi",
  "mod_compress",
  "mod_accesslog"
)
server.indexfiles = (
  "index.xhtml",
  "index.html",
  "index.htm",
  "index.php",
)
mimetype.assign = (
 ".pdf"     => "application/pdf",
 ".sig"     => "application/pgp-signature",
 ".spl"     => "application/futuresplash",
 ".class"   => "application/octet-stream",
 ".ps"      => "application/postscript",
 ".torrent" => "application/x-bittorrent",
 ".dvi"     => "application/x-dvi",
 ".pac"     => "application/x-ns-proxy-autoconfig",
 ".swf"     => "application/x-shockwave-flash",
 ".tgz"     => "application/x-tgz",
 ".mp3"     => "audio/mpeg",
 ".m3u"     => "audio/x-mpegurl",
 ".wma"     => "audio/x-ms-wma",
 ".wax"     => "audio/x-ms-wax",
 ".ogg"     => "application/ogg",
 ".wav"     => "audio/x-wav",
 ".xbm"     => "image/x-xbitmap",
 ".xpm"     => "image/x-xpixmap",
 ".xwd"     => "image/x-xwindowdump",
 ".asc"     => "text/plain",
 ".c"       => "text/plain",
 ".h"       => "text/plain",
 ".cc"      => "text/plain",
 ".cpp"     => "text/plain",
 ".hh"      => "text/plain",
 ".hpp"     => "text/plain",
 ".conf"    => "text/plain",
 ".log"     => "text/plain",
 ".text"    => "text/plain",
 ".txt"     => "text/plain",
 ".diff"    => "text/plain",
 ".patch"   => "text/plain",
 ".ebuild"  => "text/plain",
 ".eclass"  => "text/plain",
 ".rtf"     => "application/rtf",
 ".bmp"     => "image/bmp",
 ".tif"     => "image/tiff",
 ".tiff"    => "image/tiff",
 ".ico"     => "image/x-icon",
 ".mpeg"    => "video/mpeg",
 ".mpg"     => "video/mpeg",
 ".mov"     => "video/quicktime",
 ".qt"      => "video/quicktime",
 ".avi"     => "video/x-msvideo",
 ".asf"     => "video/x-ms-asf",
 ".asx"     => "video/x-ms-asf",
 ".wmv"     => "video/x-ms-wmv",
 ".tbz"     => "application/x-bzip-compressed-tar",
 ".tar.bz2" => "application/x-bzip-compressed-tar",
 ".tar.gz"  => "application/x-tgz",
 ".bz2"     => "application/x-bzip",
 ".gz"      => "application/x-gzip",
 ".tar"     => "application/x-tar",
 ".zip"     => "application/zip",
 ".jpeg"    => "image/jpeg",
 ".jpg"     => "image/jpeg",
 ".png"     => "image/png",
 ".gif"     => "image/gif",
 ".xhtml"   => "text/html",
 ".html"    => "text/html",
 ".htm"     => "text/html",
 ".dtd"     => "text/xml",
 ".xml"     => "text/xml",
 ".css"     => "text/css",
 ".js"      => "text/javascript",
 ".deb"     => "application/x-deb",
 ".php"     => "application/x-httpd-php",
 ""         => "text/plain",
)
static-file.exclude-extensions = (
 ".pl",
 ".cgi",
 ".fcgi",
 ".php",
)
url.access-deny = (
 "~",
 ".ini",
 ".inc",
 ".cfg",
 ".tpl",
 ".bak",
 ".dist",
 ".orig",
 ".htaccess",
 ".htpasswd",
 ".example",
 ".sample",
 ".lang",
)
cgi.assign = (
 ".pl"  => "/usr/bin/perl",
 ".cgi" => "/usr/bin/perl"
)
fastcgi.server = ( ".php" =>
 ( "localhost" =>
 (
 "socket" => "/tmp/php-fastcgi.socket",
 "bin-path" => "/usr/bin/php5-cgi"
        )
  )
)
auth.backend = "htpasswd"
auth.backend.htpasswd.userfile = "/etc/lighttpd/password/download.pwd"
auth.require = ("/download/" => (
  "method"  => "basic",
  "realm"   => "admin",
  "require" => "valid-user"
))
$SERVER["socket"] == ":443" {
ssl.engine = "enable"
ssl.pemfile = "/etc/lighttpd/ssl/lighttpd.pem"
$HTTP["host"] == "admin.meinedomain.de:443" {
server.document-root = "/var/www/wartung/htdocs/"
accesslog.filename = "/var/log/lighttpd/wartung.log"
status.status-url = "/server-status"
status.config-url = "/server-config"
auth.backend = "htpasswd"
auth.backend.htpasswd.userfile = "/etc/lighttpd/password/admin.pwd"
auth.require = ("/" => (
   "method"  => "basic",
   "realm"   => "admin",
   "require" => "valid-user"
))
     }
}
EOF
```
