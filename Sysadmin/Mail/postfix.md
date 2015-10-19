Making remote satellite work with mbox.lu

Add the following to main.cf:

```
smtp_sasl_auth_enable = yes
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
smtp_sasl_security_options = noanonymous
smtp_tls_security_level = may
```

Create /etc/postfix/sasl_passwd

```
echo "mail.mbox.lu:587 steve@example.com:MySuper Secure Passw0rd" >> /etc/postfix/sasl_passwd
postmap hash:/etc/postfix/sasl_passwd
```

Done :)

Debug:

```
vi /etc/master.cf
```

Add the: smtp unix line add -v to the end:

```
smtp      unix  -       -       -       -       -       smtp -v
```