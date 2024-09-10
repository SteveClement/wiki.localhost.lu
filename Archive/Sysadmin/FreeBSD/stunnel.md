# stunnel install via ports

```
cd /usr/ports/security/stunnel
make install clean

cd /var/run
mkdir -p stunnel
chown stunnel:stunnel stunnel
chmod 0622 stunnel
```

## /usr/local/etc/stunnel/stunnel.conf

```
; create local jail
chroot = /var/run/stunnel

; set own UID and GID
setuid = stunnel
setgid = stunnel

; some debugging stuff useful for troubleshooting
;;;; debug = 7
output = /var/log/stunnel.log

client = yes
;;;;foreground = yes    ; good for debugging
foreground = no     ; good for normal operation
pid = /stunnel.pid  ; root directory is the local jail

; localhost listening on port 12345
[ssl]
accept = 443
connect = localhost:80
```


## rc.conf

```
stunnel_enable="YES"
stunnel_pid_file="/var/run/stunnel/stunnel.pid"
```