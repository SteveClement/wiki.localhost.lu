# Piwik

[Piwik](https://piwik.org/)

```
POST-INSTALL CONFIGURATION FOR Piwik
=====================================
1) Create a user and a empty database for Piwik to store all
   its tables in (or choose an existing database).

2) Add the following to your Apache configuration, and
   restart the server:

   ### Add the AcceptPathInfo directive only for Apache 2.0.30 or later.
   Alias /piwik /usr/local/www/piwik/
   AcceptPathInfo On
   <Directory /usr/local/www/piwik>
      AllowOverride None
      Options Indexes FollowSymLinks
      Order Allow,Deny
      Allow from all
   </Directory>

3) Visit your Piwik site with a browser (i.e.,
   http://your.server.com/piwik/), and you should
   be taken to the setup script, which will lead
   you through setting up Piwik.

For more information, see the INSTALL DOCUMENTATION:

  http://piwik.org/docs/installation/
```
