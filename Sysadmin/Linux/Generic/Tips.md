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

[Source](https://wiki.gnupg.org/AgentForwarding)

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

If you can modify the remote ssh server settings you should put the following into `/etc/ssh/sshd_config`

```
StreamLocalBindUnlink yes
```
