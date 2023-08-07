# upgrade debian distro

Edit the file /etc/apt/sources.list using a text editor and replace each instance of bullseye with bookworm. Next find the update line, replace keyword bullseye-updates with bookworm-updates. Finally, search the security line, replace keyword bullseye-security with bookworm-security.

```
# backup
sudo apt update
sudo apt upgrade --without-new-pkgs
sudo apt full-upgrade
```

# update default editor

```
sudo update-alternatives --config editor
# non-interactive
sudo update-alternatives --set editor /usr/bin/nvim
```
and/or

```
select-editor
```

# grub2 splashimages
```
sudo apt install grub2-splashimages
sudo update-grub
sudo vi /etc/default/grub
#GRUB_BACKGROUND="/usr/share/images/grub/Plasma-lamp.tga"
```

# Etch GPG Key
```
> B5D0C804ADB11277 is the new signing key for the Etch release which is
> unfortunately not in the debian keyring package yet.

> If you want to fix it take the following steps:

> * As a user
> $ gpg --keyserver pgpkeys.pca.dfn.de --recv-keys B5D0C804ADB11277
> $ gpg --export -a B5D0C804ADB11277 > /tmp/etch

> * As root
> # apt-key add /tmp/etch
> # apt-get update

> For further information or if you encounter any problems take a look
> at "man apt-key" and http://wiki.debian.org/SecureApt (and maybe
> http://blog.madduck.net/debian/2006.01.08-apt-updates too).
```

# Installing vim
```
apt-get install vim
```
## installing gnome latest
```
sudo apt install xorg gnome (or xfce4 xfce4-goodies)
```

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
neovim git
virtualbox virtualbox-guest-additions-iso 
ipython3-notebook ipython-notebook htop vim mercurial git ntpdate python3-pip geany geany-plugin-lua geany-plugin-prettyprinter geany-plugin-latex geany-plugin-spellcheck python-imaging rrdtool curl wget lynx zip unzip unrar-free nmap gnupg rsync rdiff-backup smartmontools tmux build-essential ca-certificates molly-guard sshfs chromium-browser vlc python-dev python-numpy munin-node python3-dev python3-numpy
```

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

Over time an awful lot of kernels gathe in Debian or Ubuntu.

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

# sublime

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
