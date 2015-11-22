```
mkdir ~steve/.ssh
chown steve:steve .ssh
chmod 700 .ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAIEAj13bK4xuULpQ4DYSZktCoxkfP9WU2J6CTq5EWwK9kNxn19SvCoOw+akvc6HQx96W6XATPdi4MeZGNE9THYNt16MaDFJRploryTRP5Zq+GCPWEloSwDOStxug+pTuIOiY0F9veG2Cy5cIACfW3eQvxcrwrEWzSqRgidB5Ct8Moqs= Steve's RSA ssh2 key
ssh-rsa AAAAB3NzaC1yc2EAAAAFAP+HMr8AAACBAN1oP8ftZmwH1ZSvmtGEGTwMsTqcNLP8jQpkzX1QhknKucX8TN+kT3hcpZ0z9e/kq05gaP3iP1gVDI3eV8ta7dUeaNfE5RGqebmobod+VIpmiKcXGcCAyoDc8fntPt8mBXAItdKb+gq8479YPkVCTNh6PqM5T0LB3J75+0RIpWxr cardno:000100000652" > .ssh/authorized_keys2
chown steve:steve .ssh/authorized_keys2
chmod 600 .ssh/authorized_keys2
cd ; mkdir -p work ; cd work ; svn co svn+ssh://plumbum.ion.lu/home/svn/plumbum-ion-sysadmin
```

become root:

```
cat ~steve/.ssh/authorized_keys >> ~root/.ssh/authorized_keys
chmod 600 ~root/.ssh/authorized_keys
cp /home/steve/work/plumbum-ion-sysadmin/trunk/tools/root* /usr/local/bin
chown root:adm /usr/local/bin/root*
chmod 770 /usr/local/bin/root*

cd /etc/init.d
cp -pi ssh ssh-localhost
cp -pi /etc/default/ssh /etc/default/ssh-localhost
cd ../ssh
mkdir /var/run/sshd-localhost
cp -pi sshd_config sshd_config.localhost
```

copy authorized_keys2
copy root*

edit ssh_config
```
   ForwardAgent yes
```

edit sshd_config*

sshd_config
```
PermitRootLogin no
PasswordAuthentication no
UsePAM no
```

sshd_config_localhost
```
Port 222
ListenAddress ::1
ListenAddress 127.0.0.1
PermitRootLogin yes
PasswordAuthentication no
UsePAM no
PidFile /var/run/sshd-localhost.pid
```


edit: **/etc/default/ssh-localhost**

```
SSHD_OPTS="-f /etc/ssh/sshd_config.localhost"
```