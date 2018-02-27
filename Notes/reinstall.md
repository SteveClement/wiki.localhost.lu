# reInstall any system

## FreeBSD

See [FreeBSD Install](https://github.com/SteveClement/sysadmin/tree/master/tools/install)

## OpenBSD

See [OpenBSD Desktop](../Sysadmin/OpenBSD/Desktop.md)

## Ubuntu

To be completed

## OSX

### AppStore Apps

* [pwSafe](https://itunes.apple.com/us/app/pwsafe-password-safe-compatible/id520993579)
* [Gemini 2](https://itunes.apple.com/us/app/id1090488118)
* [RegExRx](https://itunes.apple.com/us/app/regexrx/id498370702)
* [Keka](https://itunes.apple.com/lu/app/keka/id470158793) cmd + , -> Extraction -> Move to trash
* [Kaleidoscope](https://itunes.apple.com/us/app/kaleidoscope/id587512244)
* [Evernote](https://itunes.apple.com/us/app/evernote-stay-organized/id406056744)
* [Xcode](https://itunes.apple.com/us/app/xcode/id497799835) -> xcode-select --install

### Drag to applications folder Apps

* [Google Chrome](https://www.google.com/chrome/)
* [GPG Suite](https://gpgtools.org/)
* [iTerm2](https://iterm2.com/downloads/stable/latest)
* [ShifIt](https://github.com/fikovnik/ShiftIt/releases)
* [Synergy](http://synergy-project.org/)
* [Firefox](https://getfirefox.com)
* [Thunderbird](https://www.mozilla.org/en-US/thunderbird/)
* [Xquartz](http://xquartz.macosforge.org/)
* [MacTex](http://tug.org/cgi-bin/mactex-download/MacTeX.pkg)
* [Little Snitch](https://www.obdev.at/products/littlesnitch/index.html)
* [Virtualbox & Extension Pack](https://www.virtualbox.org/wiki/Downloads)
* [LibreOffice](https://www.libreoffice.org/download)
* [Sublime Text 3](https://www.sublimetext.com/3)
* [CleanMyMac 3](http://macpaw.com/cleanmymac)
* [0xed](http://www.suavetech.com/cgi-bin/download.cgi?0xED.tar.bz2)
* [Google Drive](https://www.google.com/drive/download/)
* [SpamSieve](https://c-command.com/spamsieve/)
* [TorBrowser](https://www.torproject.org/projects/torbrowser.html.en#downloads)
* [VLC](https://www.videolan.org/vlc/download-macosx.html)
* [Adobe CC](https://creative.adobe.com/products/download/creative-cloud)
* [SDFormatter](https://www.sdcard.org/downloads/formatter_4/eula_mac/index.html)
* [Steam](https://steamcdn-a.akamaihd.net/client/installer/steam.dmg)
* [Viber Desktop](https://download.cdn.viber.com/desktop/mac/Viber.dmg)
* [Whatsapp](https://web.whatsapp.com/desktop/mac/files/WhatsApp.dmg)
* [Line](https://line.me/download)
* [Spotify](https://www.spotify.com/lu-de/download/mac/)

#### Archived
* [Jdisk Report](http://www.jgoodies.com/downloads/jdiskreport/)
* [Karabiner-Elements](https://github.com/tekezo/Karabiner-Elements)
* [Owncloud](https://owncloud.org/install/#install-clients)
* [Dropbox](https://www.dropbox.com/downloading)
* [Dia](http://dia-installer.de/download/macosx.html.en)
* [Gimp](https://www.gimp.org/downloads/)
* [f.lux](https://justgetflux.com/dlmac.html)
* [mBlock](http://www.mblock.cc/)
* [Arduino](https://www.arduino.cc/en/Main/Software)
* [Ardublock](http://blog.ardublock.com/engetting-started-ardublockzhardublock/)
* [Tunnelblick](https://tunnelblick.net/downloads.html)

### Shell install things

#### zsh

```
chsh -s /bin/zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
cp bin/virtualenvwrapper.sh /usr/local/bin/
pip3 install virtualenvwrapper nodeenv
```

#### Fonts

```
mkdir ~/Desktop/code/ && cd ~/Desktop/code
git clone git@github.com:powerline/fonts.git
cd fonts
./install.sh
```

#### Sublime

```

```

#### msmtp

http://www.futurile.net/resources/msmtp-a-simple-mail-transfer-agent/#queuing-outgoing-email
https://wiki.archlinux.org/index.php/Msmtp#Using_msmtp_offline

#### Xcode

https://draculatheme.com/xcode/

#### Terminals

Font used: Meslo LG L DZ for Powerline
#### iTerm2

https://draculatheme.com/iterm/

git@github.com:mbadolato/iTerm2-Color-Schemes.git

#### Terminal.app

https://draculatheme.com/terminal/

#### Apple Mail

##### SpamSieve

SpamSieve stores its training data in the folder:

```
/Users/<username>/Library/Application Support/SpamSieve/
```

and it stores its preferences in the file:

```
/Users/<username>/Library/Preferences/com.c-command.SpamSieve.plist
```

You should back up both of these. (See the How can I open the Library folder? section for how to access them.)

Moving or Copying SpamSieve to Another Mac

To transfer SpamSieve’s data to another machine, first quit both copies of SpamSieve. Then copy the folder and the preferences file to the corresponding locations on the other machine.

Your SpamSieve license will be transferred when you copy the preferences file. You can also transfer it manually, by looking up your order information.

When copying your SpamSieve setup to a Mac that didn’t previously have SpamSieve installed, you’ll need to put the SpamSieve application file in the Applications folder and do the setup in your mail program, but you can skip the initial training process because of the files that you copied above.

If you are copying the training data because you want to use SpamSieve on both Macs (rather than just moving it from one to the other), please see the SpamSieve and Multiple Macs section.

Restoring From a Backup

Restore the SpamSieve folder and the com.c-command.SpamSieve.plist file that are mentioned above.
Go to the SpamSieve Web site and click the Download button.
Complete the installation steps in the Installing SpamSieve and Using SpamSieve sections, except that you can skip the initial training.

##### Filters

#### pygame in virtualenv

```
brew install sdl sdl_image sdl_mixer sdl_ttf portmidi smpeg pyenv-virtualenv pyenv-virtualenvwrapper python3
pip3 install --upgrade pip setuptools wheel virtaulenv virtualenvwrapper
mkvirtualenv -p python3 ~/.virtualenvs/pygame
source ~/.virtualenvs/pygame/bin/activate
pip3 install hg+http://bitbucket.org/pygame/pygame
```

#### pgzero

Main install [README.md](https://github.com/CoderDojoLu/pgzero-examples/blob/master/README.md)

#### [Homebrew](http://brew.sh/)

##### Install

```
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
``` 

###### [brew Cask](https://github.com/caskroom/homebrew-cask)

```
brew install caskroom/cask/brew-cask
```

##### brew packages

```
brew install \
baobab \
contacts \
csshx \
dialog \
dos2unix \
elinks \
enscript \
exiftool \
ffmpeg \
findutils \
gnu-tar \
htop-osx \
hunspell \
imagemagick \
imapfilter \
irssi \
khard \
khal \
libav \
lynx \
mercurial \
msmtp \
mu \
muttils \
neovim \
ngrep \
node \
nodeenv \
offlineimap \
p7zip \
python3 \
rbenv \
redis \
rmate \
ssh-copy-id \
terminal-notifier \
tmux \
unrar \
urlview \
vdirsyncer \
w3m \
wemux \
wget \
youtube-dl \
z \
zsh \
zsh-syntax-highlighting

brew install --with-override-system-vi --with-python3  vim
brew install --with-libotr bitlbee
brew install --with-python3 notmuch
brew install --with-pygtk nmap # Adds zenmap

```

#### Printing with lpr

First, add LPD Printer. Second check what the device name is.

~/bin/mylpr
```bash
#!/bin/bash
ENSCRIPT="--no-header --margins=36:36:36:36 --font=Courier11 --word-wrap --media=A4"
export ENSCRIPT
/usr/local/bin/enscript -p - $1 | /usr/bin/lpr -P printer_office_lan_LPD
```

#### mutt

```
pip3 install git+https://github.com/honza/mutt-notmuch-py.git
brew tap neomutt/homebrew-neomutt
brew install --with-gpgme --with-libidn --with-notmuch-patch --with-s-lang neomutt
sudo -u steve /usr/bin/security -v add-internet-password -a steve@localhost.lu -s mail.mbox.lu /Users/steve/Library/Keychains/login.keychain
sudo -u steve /usr/bin/security -v add-internet-password -a steve.clement@securitymadein.lu -s mail.mbox.lu /Users/steve/Library/Keychains/login.keychain
sudo -u steve /usr/bin/security -v add-internet-password -a steve.clement@x.circl.lu -s mail.mbox.lu /Users/steve/Library/Keychains/login.keychain
sudo -u steve /usr/bin/security -v add-internet-password -a steve@ion.lu -s mail.mbox.lu /Users/steve/Library/Keychains/login.keychain
```

#### vdirsyncer et al.

brew install vdirsyncer khal khard

```bash
ln -s ~/truecrypt1/dotfiles/.config/vdirsyncer .vdirsyncer
vdirsyncer discover steve_calendar
vdirsyncer discover steve_contacts
vdirsyncer sync
```




To make sure gpg works add a symlink to gpg from gpg2

```
ln -s /usr/local/bin/gpg2  /usr/local/bin/gpg
```

* [Install mutt](../Sysadmin/OSX/mutt.md)
* [Old Docs](../Sysadmin/OSX/Tips.md)
* [More Docs](../InfoSec/GeneralProtection.md)
* [Python Setup](../Devel/python.md)

### Finder Tweaks

* cmd , -> General, Sidebar, Advanced
* List view -> View -> Show View Options -> Calculate all sizes etc -> Use as Defaults

## Webapps

### Slack Dracula

https://draculatheme.com/slack/

### Ruby Gems

```
# gem install i2cssh <- Broken
gem install tmuxinator
```
