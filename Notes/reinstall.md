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
* [Slack](https://itunes.apple.com/us/app/slack/id803453959)
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
* [Karabiner-Elements](https://github.com/tekezo/Karabiner-Elements)
* [Sublime Text 3](https://www.sublimetext.com/3)
* [CleanMyMac 3](http://macpaw.com/cleanmymac)
* [Geany](https://www.geany.org/Download/Releases)
* [Gimp](https://www.gimp.org/downloads/)
* [0xed](http://www.suavetech.com/cgi-bin/download.cgi?0xED.tar.bz2)
* [Viber Desktop](https://download.cdn.viber.com/desktop/mac/Viber.dmg)
* [Whatsapp](https://web.whatsapp.com/desktop/mac/files/WhatsApp.dmg)
* [f.lux](https://justgetflux.com/dlmac.html)
* [Google Drive](https://www.google.com/drive/download/)
* [mBlock](http://www.mblock.cc/)
* [Arduino](https://www.arduino.cc/en/Main/Software)
* [Ardublock](http://blog.ardublock.com/engetting-started-ardublockzhardublock/)
* [SpamSieve](https://c-command.com/spamsieve/)
* [Steam](https://steamcdn-a.akamaihd.net/client/installer/steam.dmg)
* [TorBrowser](https://www.torproject.org/projects/torbrowser.html.en#downloads)
* [Tunnelblick](https://tunnelblick.net/downloads.html)
* [VLC](https://www.videolan.org/vlc/download-macosx.html)
* [Adobe CC](https://creative.adobe.com/products/download/creative-cloud)
* [SDFormatter](https://www.sdcard.org/downloads/formatter_4/eula_mac/index.html)
* [Dia](http://dia-installer.de/download/macosx.html.en)
* [Dropbox](https://www.dropbox.com/downloading)
* [Owncloud](https://owncloud.org/install/#install-clients)

### Shell install things

#### Fonts

```
mkdir ~/Desktop/code/ && cd ~/Desktop/code
git clone git@github.com:powerline/fonts.git
cd fonts
./install.sh
```

#### pygame in virtualenv

```
brew install sdl sdl_image sdl_mixer sdl_ttf portmidi smpeg pyenv-virtualenv pyenv-virtualenvwrapper python3
pip3 install --upgrade pip setuptools wheel
mkdir ~/.virtualenvs
virtualenv -p python3 ~/.virtualenvs/pygame
source ~/.virtualenvs/pygame/bin/acitvate
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
brew install wget htop-osx tmux irssi zsh rbenv nmap csshx exiftool dos2unix findutils gnu-tar hunspell lynx ngrep p7zip mercurial ssh-copy-id imagemagick unrar redis rmate zsh-syntax-highlighting python3 terminal-notifier
```

* [Install mutt](../Sysadmin/OSX/mutt.md)
* [Old Docs](../Sysadmin/OSX/Tips.md)
* [More Docs](../InfoSec/GeneralProtection.md)
* [Python Setup](../Devel/python.md)

### Finder Tweaks

* cmd , -> General, Sidebar, Advanced
* List view -> View -> Show View Options -> Calculate all sizes etc -> Use as Defaults

