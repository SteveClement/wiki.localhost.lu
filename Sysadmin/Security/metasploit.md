# Metasploit

[Metasploit](https://www.metasploit.com/)

## Install
```
 sudo apt-get install ruby ri rubygems subversion ruby-dev libpcap-dev postgresql-8.4 libpq-dev libreadline-dev libssl-dev libpq5 
 sudo apt-get build-dep ruby
 sudo gem install pg
```


```
sudo mkdir -p /opt/metasploit3
cd /tmp
wget http://updates.metasploit.com/data/releases/framework-3.5.0.tar.bz2
cd /opt/metasploit3
sudo tar xf /tmp/framework-3.5.0.tar.bz2 
sudo chown root:root -R /opt/metasploit3/msf3
sudo ln -sf /opt/metasploit3/msf3/msf* /usr/local/bin/
sudo svn update /opt/metasploit3/msf3/
```


## To enable raw socket modules
```
 sudo su -
 cd /opt/metasploit3/msf3/external/pcaprub/
 ruby extconf.rb
 make && make install
```


## To enable WiFi modules
```
sudo su -
cd  /opt/metasploit3/msf3/external/ruby-lorcon2/
svn co http://802.11ninja.net/svn/lorcon/trunk lorcon2
cd lorcon2
./configure --prefix=/usr && make && make install
cd ..
ruby extconf.rb
make && make install
```

## Crontab for msf updates
```
sudo crontab -e -u root # enter the line below
1 * * * * /usr/bin/svn update  /opt/metasploit3/msf3/ >> /var/log/msfupdate.log 2>&1
```

Postgres support:

```
sudo -s
su postgres
createuser msf_user -P
```

No superuser, create db or new roles
```
Enter password for new role: 
Enter it again: 
Shall the new role be a superuser? (y/n) n
Shall the new role be allowed to create databases? (y/n) n
Shall the new role be allowed to create more new roles? (y/n) n
```

## Creating a database
```
createdb --owner=msf_user msf_database
```


## Configure Metasploit (creates tables)
```
/opt/metasploit3/msf3/msfconsole
msf> db_driver postgresql
msf> db_connect msf_user:[password]@127.0.0.1:5432/msf_database
msf> db_hosts
```

## Enable the database on startup
```
$ cat > ~/.msf3/msfconsole.rc
db_driver postgresql
db_connect msf_user:[password]@127.0.0.1:5432/msf_database
db_workspace -a MyProject
^D
```

[Metasploit Wiki](https://github.com/rapid7/metasploit-framework/wiki)