# How to setup remote rdiff-backup functionality

On plumbum:

```
export SERVER=xenon

pw useradd ${SERVER}-backup -s /sbin/nologin -c "${SERVER} Backup User"

mkdir -p /home/bup/${DISK}/${SERVER}/.ssh
chown ${SERVER}-backup:${SERVER}-backup /home/bup/${DISK}/${SERVER}/.ssh /home/bup/${DISK}/${SERVER}/.ssh/authorized_keys2 /home/bup/${DISK}/${SERVER}/
chmod 700 /home/bup/${DISK}/${SERVER}/.ssh /home/bup/${DISK}/${SERVER}/
chmod 600 /home/bup/${DISK}/${SERVER}/.ssh/authorized_keys2
```

on plumbum add:

```
export SERVER=potion
pw useradd backup-$SERVER -c "$SERVER Backup User"

mkdir -p /home/bup/$SERVER/.ssh
```

on the client as root:

```
CLIENT=xenon
ssh-keygen -b1024 -C"${CLIENT} Backup Key" -tdsa
cat ~/.ssh/id_dsa.pub
rm ~/.ssh/id_dsa.pub
```

on the server:

```
su -m backup-${SERVER}-backup
cd /home/bup/${SERVER}/.ssh
vi authorized_keys2
```


YOU NEED TO INSTALL gsed for this to work!!!!!!

if you need to backup a complex and huge directory structure do as follows:

```
cd /home/share/Fichiers\ Windows/
mkdir -p /tmp/dot
rsync * /tmp/dot && rdiff-backup --print-statistics -v5 /tmp/dot steve@hadron.ion.lu::/home/bup/disk1/ajf/home-share/Fichiers_Windows/dot-rdiff && rm -rf /tmp/dot
find ./ -type d -maxdepth 1 |cut -f 2 -d / |sed '1d' |sed 's/\ /\\ /g ' |gsed 's/\o047/\\\o047/g ' |sed 's/$/-rdiff/' > dir-escaped.txt
find ./ -type d -maxdepth 1 |cut -f 2 -d / |sed '1d' |sed 's/\ /\\ /g ' |gsed 's/\o047/\\\o047/g ' |sed 's/^/rdiff-backup --print-statistics -v5 /' |sed 's/$/ steve@hadron.ion.lu::\/home\/bup\/disk1\/ajf\/home-share\/Fichiers_Windows\//' > dir-escaped.sh.tmp
lam dir-escaped.sh.tmp dir-escaped.txt > dir-escaped.sh
sh ./dir-escaped.sh && rm dir-escaped.sh.tmp dir-escaped.txt dir-escaped.sh

cd /home/share/Fichiers\ Mac/
mkdir -p /tmp/dot
rsync * /tmp/dot && rdiff-backup --print-statistics -v5 /tmp/dot steve@hadron.ion.lu::/home/bup/disk1/ajf/home-share/Fichiers_Mac/dot-rdiff && rm -rf /tmp/dot
find ./ -type d -maxdepth 1 |cut -f 2 -d / |sed '1d' |sed 's/\ /\\ /g ' |gsed 's/\o047/\\\o047/g ' |sed 's/$/-rdiff/' > dir-escaped.txt
find ./ -type d -maxdepth 1 |cut -f 2 -d / |sed '1d' |sed 's/\ /\\ /g ' |gsed 's/\o047/\\\o047/g ' |sed 's/^/rdiff-backup --print-statistics -v5 /' |sed 's/$/ steve@hadron.ion.lu::\/home\/bup\/disk1\/ajf\/home-share\/Fichiers_Windows\//' > dir-escaped.sh.tmp
lam dir-escaped.sh.tmp dir-escaped.txt > dir-escaped.sh
sh ./dir-escaped.sh && rm dir-escaped.sh.tmp dir-escaped.txt dir-escaped.sh
```


rdiff-web install:

```
www/py-cherrypy 2.1.1 (2.2.0 will not work)
mysql required
databases/py-MySQLdb
```
