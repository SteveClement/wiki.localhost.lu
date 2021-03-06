# Building from Source

I frequently need to recompile stuff under Ubuntu.

My **favorite** ./configure line so far is:

```
 ./configure  --datadir=/usr --prefix=/usr --localstatedir=/var --sysconfdir=/etc
```

If you get:

```
 warning: macro `AM_GCONF_SOURCE_2' not found in library
```

all you need to do is:

```
 sudo apt-get install libgconf2-dev
```

Thanks to:

[Milinda Pathirage](http://mpathirage.com/fixing-macro-am_gconf_source_2-not-found-in-library-in-ubuntu/)

# Adding **add-apt-repository**

```
sudo apt-get install software-properties-common
```

# Clean install

## Some of my essential Packages

```
vim git-core
virtualbox virtualbox-guest-additions-iso 
ipython3-notebook ipython-notebook htop vim mercurial git ntpdate python3-pip geany geany-plugin-lua geany-plugin-prettyprinter geany-plugin-latex geany-plugin-spellcheck python-imaging rrdtool curl wget lynx zip unzip unrar-free nmap gnupg rsync rdiff-backup smartmontools tmux build-essential ca-certificates molly-guard sshfs chromium-browser vlc python-dev python-numpy munin-node python3-dev python3-numpy
```

## Additionals

firefox extensions

# Ignoring packages

To bar/ignore a package on apt, the tzdata package for example:

```
echo tzdata hold | sudo dpkg --set-selections
```

To "unhold" do:

```
echo tzdata install | sudo dpkg --set-selections
```

# Removing Kernels

Over time an awful lot of kernels gather in Debian or Ubuntu.

To remove these obsolete kernels do:

```
uname -a
dpkg -l |grep linux-
sudo apt-get remove --purge EXACT-OLD-KERNEL-NAME
sudo update-grub
```

:warning: Be careful not to remove the currently installed kernel!

# Remove broken packages

## Display them
```
sudo dpkg -l | grep "^iU"
```

## Remove them
```
sudo apt-get -f install
sudo apt-get remove --purge $(sudo dpkg -l | grep "^iU" | awk '{print $2}' | tr '\n' ' ')
```

# Remove residual packages (rc)

## Display them
```
sudo dpkg -l | grep "^rc"
```

## Remove them
```
sudo apt-get remove --purge $(sudo dpkg -l | grep "^rc" | awk '{print $2}' | tr '\n' ' ')
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

# sublime

## For Sublime-Text-2

```
sudo add-apt-repository ppa:webupd8team/sublime-text-2
sudo apt-get update
sudo apt-get install sublime-text
```

## For Sublime-Text-3

```
sudo add-apt-repository ppa:webupd8team/sublime-text-3
sudo apt-get update
sudo apt-get install sublime-text-installer
Source: https://gist.github.com/dantoncancella/4977978
```

# git
## Upgrade to more recent git

```
sudo apt-get remove git
sudo add-apt-repository ppa:git-core/ppa
sudo apt-get update
sudo apt-get install git
git --version
```
