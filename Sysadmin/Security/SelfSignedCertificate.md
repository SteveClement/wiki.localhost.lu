# How to create a Certificate yourself

```
Step one - create the key and request:

export FQDN=wiki.localhost.lu
export CERT_DIR=.

  openssl req -new > $CERT_DIR/$FQDN.csr

Step two - remove the passphrase from the key (optional):

  openssl rsa -in privkey.pem -out $CERT_DIR/$FQDN.key

Step three - convert request into signed cert:

   openssl x509 -in $CERT_DIR/$FQDN.csr -out $CERT_DIR/$FQDN.crt -req -signkey $CERT_DIR/$FQDN.key -days 3650


If you create a cert please enter CORRECT VALUES, and for the common name it HAS to be the hostname you are going to connect to otherwise there are warning messages in the clients.

steve@xenon:~$   openssl req -new > new.cert.csr
Generating a 1024 bit RSA private key
.........................++++++
............++++++
writing new private key to 'privkey.pem'
Enter PEM pass phrase:
Verifying - Enter PEM pass phrase:
phrase is too short, needs to be at least 4 chars
Enter PEM pass phrase:
Verifying - Enter PEM pass phrase:
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:LU
State or Province Name (full name) [Some-State]:Luxembourg
Locality Name (eg, city) []:Luxembourg
Organization Name (eg, company) [Internet Widgits Pty Ltd]:ION Network Solutions
Organizational Unit Name (eg, section) []:
Common Name (eg, YOUR name) []:alebion.ion.lu
Email Address []:webmaster@ion.lu

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
An optional company name []:
steve@xenon:~$   openssl rsa -in privkey.pem -out new.cert.key
Enter pass phrase for privkey.pem:
writing RSA key
steve@xenon:~$    openssl x509 -in new.cert.csr -out new.cert.cert -req -signkey new.cert.key -days 365
Signature ok
subject=/C=LU/ST=Luxembourg/L=Luxembourg/O=ION Network Solutions/CN=alebion.ion.lu/emailAddress=webmaster@ion.lu
Getting Private key



How do I create a client certificate?
=====================================

Step one - create a CA certificate/key pair, as above.

Step two - sign the client request with the CA key:

  openssl x509 -req -in client.cert.csr -out client.cert.cert -signkey my.CA.key -CA my.CA.cert -CAkey my.CA.key -CAcreateserial -days 365

Step three - issue the file 'client.cert.cert' to the requester.

The Apache-SSL directives that you need to validate against this cert are:

  SSLCACertificateFile /path/to/certs/my.CA.cert
  SSLVerifyClient 2



Ports will help too:
====================

cd /usr/ports/www/apache13-modssl
+---------------------------------------------------------------------+
| Before you install the package you now should prepare the SSL       |
| certificate system by running the 'make certificate' command.       |
| For different situations the following variants are provided:       |
|                                                                     |
| % make certificate TYPE=dummy    (dummy self-signed Snake Oil cert) |
| % make certificate TYPE=test     (test cert signed by Snake Oil CA) |
| % make certificate TYPE=custom   (custom cert signed by own CA)     |
| % make certificate TYPE=existing (existing cert)                    |
|        CRT=/path/to/your.crt [KEY=/path/to/your.key]                |
|                                                                     |
| Use TYPE=dummy    when you're a  vendor package maintainer,         |
| the TYPE=test     when you're an admin but want to do tests only,   |
| the TYPE=custom   when you're an admin willing to run a real server |
| and TYPE=existing when you're an admin who upgrades a server.       |
| (The default is TYPE=test)                                          |
|                                                                     |
| Additionally add ALGO=RSA (default) or ALGO=DSA to select           |
| the signature algorithm used for the generated certificate.         |
|                                                                     |
| Use 'make certificate VIEW=1' to display the generated data.        |
|                                                                     |
| Thanks for using Apache & mod_ssl.       Ralf S. Engelschall        |
|                                          rse@engelschall.com        |
|                                          www.engelschall.com        |
+---------------------------------------------------------------------+
<=== src
===>  Creating Dummy Certificate for Server (SnakeOil)
      [use 'make certificate' to create a real one]
```
