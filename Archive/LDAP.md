# Installing OpenLDAP

## Introdution

This describer how to build an shared Address book with OpenLDAP with the
Schemas used by Mozilla Thunderbird and maybe other Mozilla Products.


### Installing OpenLDAP on FreeBSD

 portinstall net/openldap23-server

 Make sure you select BDB backend and if needed the replication/slurpd daemon.


Choose a password for your rootdn and make sure it's encrypted:

 beekini ldap # slappasswd -s mysuperdup3g7pass
 {SSHA}Saf3jUFsxS0yxf7JaK1vDEkEkmknbE7Y


Configure your slapd.conf to reflect your environment.
Example slapd.conf is included in the directory.


Then you have to tweak some schema files where the diffs are included.

 core.schema.diff cosine.schema.diff nis.schema.diff


Then you have to ldapadd the init diff:

 ldapadd -x -D "cn=Manager,dc=ion,dc=lu" -W -f init.ldif

 This has to be tailored to the client and add any sub address books



For the web-interface you need:

 portinstall lang/php5 php5-ldap php5-xml

phpldapadmin:

 portinstall phpldapadmin php5-session

 php5-session required for phpldapadmin



ldap.conf:
       The ldap.conf configuration file is used to set system-wide defaults to
       be applied when running ldap clients.

      
To enable SSL:

 mkdir /usr/local/etc/openldap/certs
 chmod 700 /usr/local/etc/openldap/certs
 chown ldap:ldap /usr/local/etc/openldap/certs
 cd /usr/local/etc/openldap/certs
"
 openssl req -new -x509 -nodes -keyout openldap-server.key -out openldap-server.crt
 openssl genrsa -des3 -out openldap-ca-server.key 1024
 openssl rsa -in openldap-ca-server.key -out openldap-ca-server.key
 openssl req -new -x509 -days 3650 -key openldap-ca-server.key -out openldap-ca-server.crt
"
 chmod 600 *.crt *.key
 chown ldap:ldap *.crt *.key

slapd.conf:

 TLSCACertificateFile /usr/local/etc/openldap/certs/openldap-ca-server.crt
 TLSCertificateFile /usr/local/etc/openldap/certs/openldap-server.crt
 TLSCertificateKeyFile /usr/local/etc/openldap/certs/openldap-server.key


ldap.conf on clients:

TLS_REQCERT allow

##TLS_CACERT /etc/ssl/certs/cacert.pem
TLS_CACERT /usr/local/etc/openldap/certs/openldap-server.pem
TLS_REQCERT demand
----

rc.conf:

 slapd_enable="YES"
 slapd_flags='-h "ldap://0.0.0.0/ ldaps://0.0.0.0/"'
 slapd_sockets="/var/run/openldap/ldapi"

slapd_flags:

If you need a Unix socket add the following to the ldap_flags to create /var/run/openldap/

 ldapi://%2fvar%2frun%2fopenldap%2fldapi/

ldap.conf:
 HOST myserver.com
 PORT 636


Replication server:

To have an OpenLDAP replicated environment some changes needed to be made and
slurpd has to be run on the Master server to slurp to it's slaves.


on the master add:

replica uri=ldap://malium.ion.lu:389
        binddn="cn=Replicator,dc=ion,dc=lu"
        bindmethod=simple credentials=secret
replogfile /var/db/openldap-slurp/replica/slurpd.replog

on the slave:

updatedn "cn=Replicator,dc=ion,dc=lu"
updateref "ldap://malium.ion.lu:389"

Note that you need to have the very same schemas etc..

stop the ldap master server and slapcat export the data and slapadd it on the
slave


ldapadd -x -D "cn=Replicator,dc=ion,dc=lu" -W -f init.ldif
ldapadd -x -D "cn=Replicator,dc=ion,dc=lu" -W -f import.ldif

start the slapd slurpd on the master

# Working and Understanding OpenLDAP

## tips

If OpenLDAP won't Start-up and hangs:

Can't ctrl-c do: (ctrl-z kill -9 pid)

Yes, normal kill wouldn't work.

Do a backup of openldap-data

Figure out the lib version of db

```
# ldd /usr/local/libexec/slapd
/usr/local/libexec/slapd:
        libldap_r-2.2.so.7 => /usr/local/lib/libldap_r-2.2.so.7 (0x28136000)
        liblber-2.2.so.7 => /usr/local/lib/liblber-2.2.so.7 (0x28167000)
        libdb-4.2.so.2 => /usr/local/lib/libdb-4.2.so.2 (0x28173000)
        libcrypto.so.3 => /usr/lib/libcrypto.so.3 (0x28235000)
        libssl.so.3 => /usr/lib/libssl.so.3 (0x2832c000)
        libfetch.so.3 => /usr/lib/libfetch.so.3 (0x2835b000)
        libcom_err.so.2 => /usr/lib/libcom_err.so.2 (0x28368000)
        libcrypt.so.2 => /usr/lib/libcrypt.so.2 (0x2836a000)
        libwrap.so.3 => /usr/lib/libwrap.so.3 (0x28383000)
        libc_r.so.4 => /usr/lib/libc_r.so.4 (0x2838b000)
```

we use v4.2 (libdb-4.2.so.2)

run: db_recover-4.2

all should work again now

Getting all e-mail addys from LDAP:

slapcat |grep \@ |cut -f2 -d" "|sort |uniq -i > /tmp/spam2.txt

Backing up ldap:

/usr/local/sbin/slapcat -l /tmp/ldap.ldif && tar cfvpj /home/bup/ldap-`date +%Y%m%d`.tbz /tmp/ldap.ldif && rm /tmp/ldap.ldif

Restoring the db:

structuralObjectClass: mozillaAbPersonObsolete
entryUUID: 2044f28a-96d7-1028-9e1a-acdb94e6af3c
creatorsName: cn=Manager,dc=ion,dc=lu
createTimestamp: 20040909180924Z
entryCSN: 20040909180924Z#000001#00#000000
modifiersName: cn=Manager,dc=ion,dc=lu
modifyTimestamp: 20040909180924Z

all of this is overhead you have to remove it in order to function 100%

cat ldap.ldif \
|grep -v -e structuralObjectClass: -e entryUUID: -e creatorsName: -e createTimestamp: -e entryCSN: -e modifiersName: -e modifyTi
mestamp:

In case all hell breaks lose and you have no ldif anymore:

db_dump-4.2 -p id2entry.bdb  |grep cn= |sed 'G;G' > one
cn=Lara Breuer,ou=contacts,dc=ion,dc=lu\ 'cn=lara breuer,ou=contacts,dc=ion,dc=lu
givenName\ Lara\ lara\ sn\ Breuer\ breuer\ cn\ \0bLara Breuer\ \0blara breuer\ mail\ \14lara.breuer@quest.lu\ \14lara.breuer@que
st.lu\ o\ \05Quest\ \05quest\  $bd1 b20-8cf9-102b-8870-ff835b4beae6\ \10\bd\10\0b \8c\f9\10+\88p\ff\83[K\ea\e6\ REPLACED\0f2 705
02130652Z\ \ \08entryCSN\  2 70502130652Z#  01# #   \ \ \0dmodifiersName\ \17cn=Manager,dc=ion,dc=lu\ \17cn=manager,dc=ion,dc=lu
\ \0fmodifyTimestamp\ \0f2 70502130652Z\ \ \


 cat  one \
 |sed 's/^...........//' \
 |sed 's/^=/cn=/' \
 |sed 's/^1f//' \
 |sed 's/\00/ /g' \
 |gsed 's/\\ \\0bobjectClass\\ \\05\\03top\\ \\06person\\ \\14organizationalPerson\\ //' \
 |gsed 's/\\0dinetOrgPerson\\ \\17mozillaAbPersonObsolete\\ \\ \\09/\n/' \
 |sed -e 's/\\01//g' -e 's/\\04//g' -e 's/\\06//g' -e 's/\\02//g' \
 |sed 's/\\15structuralObjectClass\\ \\17mozillaAbPersonObsolete\\ \\17mozillaAbPersonObsolete\\ \\09entryUUID\\ / /' \
 |gsed 's/\\0ccreatorsName\\ \\17cn=Manager,dc=ion,dc=lu\\ \\17cn=manager,dc=ion,dc=lu\\ \\0fcreateTimestamp\\ /\n/' \
 |gsed 's/,ou=contacts,dc=ion,dc=lu\\/\n/' \
 |gsed 's/mail\\ \\/\nMail: /' \
 |gsed 's/#  01# #   \\ \\ \\0dmodifiersName\\ \\17cn=Manager,dc=ion,dc=lu\\ //' \
 |gsed 's/\\17cn=manager,dc=ion,dc=lu\\ \\0fmodifyTimestamp\\ \\0f2/\n/' \
 |gsed 's/\\ \\0ftelephoneNumber\\ \\/\n/' \
 |gsed 's/\\ \\18facsimileTelephoneNumber\\ \\/\nFax: /' \
 |grep -v ,ou=contacts,dc=ion,dc=lu \
 |gsed 's/\\0dpostalAddress\\ \\/\nAddress: /' \
 |gsed 's/\\ \\0bdescription\\/\nDescription: /' \
 |gsed 's/\\c3\\a9/e/g' \
 |gsed 's/ sn\\ /\n/g' \
 |gsed 's/\\ \\ \\08entryCSN\\  2/\n/g' \
 |gsed 's/\\ mobile\\ \\/\nMobile: /g'


 ldap test:

 ldapsearch -x -b '' -s base '(objectclass=*)' namingContexts
 ldapsearch -x -b 'ou=contacts,dc=ion,dc=lu' -s base '(objectclass=*)'
 ldapsearch -x -b 'dc=ion,dc=lu' '(objectclass=*)'

 on a remote host:

 ldapsearch -H ldap://localhost -W -x -b 'ou=contacts,dc=ion,dc=lu' -s base '(objectclass=*)'


 ldap deltions:

 similar to ldapadd

you need a file with only the dn of the entry in it:

delete.ldif:

cn=Ronald4 Weber,ou=contacts,dc=ion,dc=lu

ldapdelete -x -D "cn=Manager,dc=ion,dc=lu" -W -f delete.ldif

would delete the cn entry Ronald4 Weber



slapd.conf tweaks:

access to *
by * read

tls=yes
