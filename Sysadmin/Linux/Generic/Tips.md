### Docker ACL

```
sudo setfacl --modify user:<Username>:rw /var/run/docker.sock
```

### X11 or Wayland


If you want to know whether you are running a Wayland or Xorg desktop the following come in handy.

```
echo $XDG_SESSION_TYPE
x11
```

```
$ loginctl
SESSION  UID USER  SEAT  TTY
    186 1000 steve       pts/1
    501 1000 steve seat0 tty1
    505 1000 steve seat0

3 sessions listed.

$ loginctl show-session 505 -p Type
Type=x11
```

# Removing ipv6 functions

edit **/etc/modprobe.d/blacklist**
add:
```
blacklist ipv6
```

### Rotate Framebuffer Console (fbcon)

You can rotate your virtual framebuffers using fbcon. 0 through 3 to represent the various rotations:

0 - Normal rotation
1 - Rotate clockwise
2 - Rotate upside down
3 - Rotate counter-clockwise
These can be set from the command line by putting a value into the correct system file. Rotate the current framebuffer:

```
echo 3 | sudo tee /sys/class/graphics/fbcon/rotate
```

Rotate all virtual framebuffers:

```
echo 3 | sudo tee /sys/class/graphics/fbcon/rotate_all
```



### chroot to fix OS

```
cd /
mount -t ext3 /dev/sda1 /mnt
mount -t proc proc /mnt/proc
mount -t sysfs sys /mnt/sys
mount -o bind /dev /mnt/dev
mount -o bind /dev/pts /mnt/dev/pts
chroot /mnt
# magick
```

# postfix redirect

```
myhostname = myhost.local
alias_maps = hash:/etc/aliases
alias_database = hash:/etc/aliases
mydestination = myhost.local, myhost, localhost.local, localhost
relayhost = [172.16.100.118]
mynetworks = 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128
mailbox_command = procmail -a "$EXTENSION"
mailbox_size_limit = 0
recipient_delimiter = +
inet_interfaces = loopback-only
inet_protocols = all
masquerade_domains = myhost.local example.com
masquerade_classes = envelope_sender, envelope_recipient, header_sender, header_recipient
```

# Forwarding gpg-agent

## Purpose

Forwarding `gpg-agent` is practical if you want to sign the code with gpg on a remote machine you are doing development on.
It can be tricky to get working but is worth the effort to maintain code integrity.

[Source 1 - wiki.gnupg.org](https://wiki.gnupg.org/AgentForwarding)

## How to

```
# On the local machine run:
gpgconf --list-dir agent-extra-socket
# On the remote machine run:
gpgconf --list-dir agent-socket
```

To your ~/.ssh/config you shall add:

```
# Name of the remote machine
Host gpgtunnel_example
HostName server.domain 
RemoteForward <socket_on_remote_box>  <extra_socket_on_local_box>
```

If you can modify the remote ssh server settings you should put the following into `/etc/ssh/sshd_config.d/gnupg.conf`

```
StreamLocalBindUnlink yes
```

Reload sshd:

```
sudo systemctl restart ssh
# OR
/etc/init.d/ssh restart
```

## Testing

To test on the remote server you can do the following:

```
echo "This text is signed with my forwarded gpg key" |gpg --sign --clear-sign
-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

This text is signed with my forwarded gpg key
-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEP02M9gj5T4goFSyxaaIPUJvkrukFAmbN1mkACgkQaaIPUJvk
rul6/RAAt5GSiePXq17oCOCSikwoDlSIF+K8zlnxplCy6tpJV8oE/73ABApqIwxA
yDS99RglDNgCKT/V/f24OtsfGdfMHvrYtET9v1mCASWZzdfTdnMGO0l85KLe/5RV
+IpQe0e1rnp54DF3H3tbFM/u7MKup4tYhLo9kioLmlehRItiy7KMCqhXR4n6Pwj4
N3OR1E/v4+pfa9Genfxh9jvlJywsopZmBit9iqqnmEokUOm/PulvWLuGiaAJH93L
pP3PvIDKwV0PRK4S6deyplr65ePPNcsVnqesiyjNzvruDYZOxv9ANdRj6TW5auME
jW6YpXnG7AtK4Yjm3tb5ZgSDnbP/rCXEkwCoC2FtIaIG1C0LnotQz1t3g54YpBth
GrPXAF51yFoxTmv+X7WzpcV0wq5OT+u8DSCkwjQ+ZiPEIkc0uz/EsltvnRsAaMWZ
yO+WwPPlVe62w5z+UWYJP+I3zQDjfd4+PlkHYmHNMmQhZERZsPb5dm9wJnnFx32n
/9to3Z8odLQ26vjWo8hTu3sdsJkrcTIQRuA9WPEvd/MPKgmY5htIs/Gvu15966mT
Uy/HxpfnHdLxcOqvcYs7PwFJuoaQLMJ4D+tDAJTh5NjtvTg9yl+G2wDonCAGcg7V
WqSDk58P7D9taGOsyWRBhFdoZAD/zxXrQD77+whhk0ZoOpaoQPU=
=C5CN
-----END PGP SIGNATURE-----
```

If your output is similar to the above, it works.

If it fails, you will get the following:

```
echo "This text is signed with my forwarded gpg key" |gpg --sign --clear-sign
gpg: no default secret key: No secret key
gpg: [stdin]: clear-sign failed: No secret key
```

The forwarding has failed and you need to verify if you have made any mistakes during setup.
