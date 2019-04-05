Making remote satellite work with mbox.lu

Add the following to /etc/postfix/main.cf:

```
sudo postconf -e 'relayhost = mail.mbox.lu:587'
echo "smtp_sasl_auth_enable = yes
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
smtp_sasl_security_options = noanonymous
smtp_tls_security_level = may" | sudo tee -a /etc/postfix/main.cf
```

Create /etc/postfix/sasl_passwd

```
echo "mail.mbox.lu:587 steve@example.com:MySuper Secure Passw0rd" |sudo tee /etc/postfix/sasl_passwd
sudo postmap hash:/etc/postfix/sasl_passwd
sudo chown root:root /etc/postfix/sasl_passwd /etc/postfix/sasl_passwd.db
sudo chmod 0600 /etc/postfix/sasl_passwd /etc/postfix/sasl_passwd.db
sudo service postfix restart
```

Done :)

Debug:

```
vi /etc/master.cf
```

Add -v to the end of "smtp unix" line:

```
smtp      unix  -       -       -       -       -       smtp -v
```
