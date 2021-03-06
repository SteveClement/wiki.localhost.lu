Notes:

1.  SugarCRM requires that you increase the default PHP memory limit from
    8Mb to 32Mb in the php.ini file.  You should edit this file and ensure
    that the memory_limit parameter should be set to 32Mb or greater:

```
memory_limit = 32M      ; Maximum amount of memory a script may consume
```

2.  SugarCRM requires the following two parameters to be set in your php.ini.

```
allow_call_time_pass_reference = Off
safe_mode = Off         ; disable "safe mode"
```

    While SugarCRM will work (albeit inefficiently) with
    allow_call_time_pass_reference enabled, safe_mode must be disabled to
    allow the system to work at all.  For more information on why these
    parameters are unnecessary, please see the PHP manual.

2.  In order to get Apache or your preferred web server to recognise
    SugarCRM's location on your disk, you'll need to put the following line
    (or the equivalent) into the web server configuration:

```
Alias /sugarcrm /usr/local/www/sugarcrm
<Directory /usr/local/www/sugarcrm>
        Order allow,deny
        Allow from all
</Directory>
```

3.  Please see the documentation directory (/usr/local/share/doc/sugarcrm)
    for full documentation on how to get the best out of SugarCRM.

4.  Enjoy!