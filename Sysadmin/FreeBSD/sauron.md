# Installing and Configuring Sauron

```
portinstall p5-Net-Netmask p5-Crypt-RC5 p5-IDNA-Punycode p5-Digest-MD5 p5-Digest-SHA1 p5-Digest-HMAC p5-MIME-Base64 p5-Net-DNS p5-Pg p5-DBI p5-DBD-Pg
```

postgress is needed... so if you set up a new pg server read the readme howto

http://sauron.jyu.fi/pub/sauron/sauron-0.7.2.tar.gz
```
untar
./configure
make
make docs
make install
```

```
  1) Build and install the program (SKIP this if you're installing the RPM):
        ./configure
        make
        make docs       (optional)
        make install

  2) Create database for Sauron to use in PostgreSQL
        (use createdb command to create the database, see PostgreSQL
         documentation for more help)

         su - pgsql
         createdb dbsauron

  3) Edit configuration files: config and config-browser
        (these are usually in /usr/local/etc/sauron or /etc/sauron)
        at minimum you need to check paths and setup database
        connection string (DB_CONNECT)

  4) Create tables in the newly created database:
        <change to installation directory (/usr/local/sauron)>
        ./createtables
        ./status                (check that everything worked)

  5) Populate OUI (Ethernet card manufacturer) table (optional):
        ./import-ethers contrib/Ethernet.txt
        ./import-ethers --force contrib/additional-ether-codes.txt
           (NOTE! you may want to download IEEE's public list
            of OUIs from: http://standards.ieee.org/regauth/oui/index.shtml
            and import it as well)
        wget http://standards.ieee.org/regauth/oui/oui.txt
        ./import-ethers oui.txt

  6) Populate global root servers table:
        wget ftp://ftp.rs.internic.net/domain/named.root
        ./import-roots default named.root
          (NOTE! you should download latest version of this file
           from: ftp://ftp.rs.internic.net/domain/ and use it)

  7) Create administrator account:
        ./adduser --superuser              (remember to set superuser flag)

  8) Setup www interface
        You need to make sauron.cgi and browser.cgi available through
        your www server. One way to do this is to make symbolic links
        for sauron.cgi and browser.cgi in your cgi-bin directory.
        Copy images under icons/ directory to sauron/icons/ directory
        under your web server root directory (or just make a symbolic link)

        chown www:www /usr/local/sauron/logs

  9) now you can use the web interface to create a server and zones, or
     you can import existing named/dhcpd configurations using
     import/iport-dhcp utilities. Or you can try out the demo database
     that can be found under test/ directory in source tree.
```
