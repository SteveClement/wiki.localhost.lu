# Essentials

https://gist.github.com/devnoname120/4767a0aa18879217170fd0c68809fc24

Rearrange topbar: https://github.com/Mortennn/Dozer
Alt Video Player, with keep afloat: IINA
Alacritty conf: https://gist.github.com/sts10/df620672662fe4c6f03ac296a02b8e72
dmenu clone: https://keminglabs.com/finda/
Better Display: https://github.com/waydabber/BetterDisplay

Alacritty doesn't create the config file for you, but it looks for one in the following locations:

    $XDG_CONFIG_HOME/alacritty/alacritty.toml
    $XDG_CONFIG_HOME/alacritty.toml
    $HOME/.config/alacritty/alacritty.toml
    $HOME/.alacritty.toml

## reinstall macOS base OS

[Official notes](https://support.apple.com/en-us/102655)

- Shut down your Mac

When the system shuts down, follow these steps:

1. Wait 25 seconds for the system to fully shut down.
2. Press and hold down the power button to power on the system.
   * It is important that the system be fully powered off before this step,
     and that you press and hold down the button once, not multiple times.
     This is required to put the machine into the right mode.
   * Once you see `loading Options`, you can release the power button.

- Reinstall macOS from Recovery

Eventually go into `Options` and format your disk if necessary.

## Keyboard repeat rate

The below is way too fastt. Try 13 or 14,  key repeat is ok at 30ms


```
defaults write -g InitialKeyRepeat -int 10 # normal minimum is 15 (225 ms)
defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)
```

The restart your computer.



* ~~Truecrypt~~ [TrueCrypt forks](https://pure-privacy.org/projects/)
* [Homebrew](http://brew.sh/)
 * ``` ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"``` ([Mac Ports](https://www.macports.org/))
 * [brew Cask](https://github.com/caskroom/homebrew-cask)
  * brew install caskroom/cask/brew-cask
 * Cask packages
  * brew cask install iterm2 google-chrome mactex texshop firefox thunderbird xquartz little-snitch gpgtools kaleidoscope keka virtualbox libreoffice macupdate-desktop evernote osxfuse 0xed shiftit adafruit-arduino viber sdformatter
 * Homebrew packages
  * brew install wget htop-osx tmux irssi zsh rbenv nmap csshx exiftool dos2unix findutils gnu-tar hunspell lynx ngrep p7zip mercurial ssh-copy-id imagemagick unrar redis rmate termimal-notifier
  * chsh -s /bin/zsh
  * sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  * ext2fuse/ext4fuse now in a tap (homebrew/fuse/ext2fuse_ext4fuse)
  * brew install --with-libotr bitlbee
  * brew tap neomutt/homebrew-neomutt
  * brew install --with-s-lang --with-sidebar-patch --with-notmuch-patch --with-gpgme --with-libidn --HEAD neomutt
  * brew install urlview contacts offlineimap notmuch msmtp imapfilter findutils dialog elinks mu muttils
 * gem install tmuxinator
 * Potentially casked
  * 1password
  * 4k-youtube-to-mp3
  * a-better-finder-rename
  * ableton-live-suite
  * adobe-cc*
  * audacity
  * [Firefox](https://getfirefox.com)
  * [Thunderbird](https://getthunderbird.com)
  * [Solarized iTerm2](http://ethanschoonover.com/solarized)
  * [Xquartz](http://xquartz.macosforge.org/)
  * [MacTex](https://tug.org/mactex/)
  * [TexShop](http://pages.uoregon.edu/koch/texshop/installing.html)
  * [Little Snitch](https://www.obdev.at/products/littlesnitch/index.html)
  * [GPGTools](https://gpgtools.org)
  * [ShiftIt](https://github.com/fikovnik/ShiftIt/releases)
  * [iTerm2](https://www.iterm2.com/)
  * [Keka](http://www.kekaosx.com/en/)
  * [Google Chrome](https://www.google.com/chrome/)
  * [Kaleidoscope](http://www.kaleidoscopeapp.com/)
  * [Virtualbox](https://virtualbox.org)
  * [LibreOffice](https://www.libreoffice.org/download)
  * [MacUpdate](http://www.macupdate.com/desktop)
  * [Karabiner](https://pqrs.org/osx/karabiner/)
   * [dasKeyboard mapping](https://github.com/pauloconnor/das_keyboard)
 * Fonts
  * [Source Code Pro](https://github.com/adobe-fonts/source-code-pro/releases/tag/1.017R)
  * [Inconsolata-Dz](https://github.com/powerline/fonts/tree/master/InconsolataDz)
  * git clone git@github.com:powerline/fonts.git
  * cd fonts
  * ./install.sh
 * [Synergy](http://synergy-project.org/)
 * [Xcode](https://itunes.apple.com/en/app/xcode/id497799835?mt=12)
 * [Spellchecker.lu](https://spellchecker.lu)
 * ~~FlashPlayer~~
 * [OSX mutt](mutt.md)
 * [RegExRX](https://itunes.apple.com/us/app/regexrx/id498370702?mt=12)
 * [PasswordGorilla](https://github.com/zdia/gorilla/wiki) or [pwSafe](http://pwsafe.info/mac/)
 * ~~AppFresh~~
 * [Sublime Text 3](https://www.sublimetext.com/3)
  * [Package Control](https://packagecontrol.io/installation#st3)
  * ColorPicker
  * Solarized (braver)
  * LatexTools
  * Language French
  * GitGutter
  * MarkdownEditing
  * LiveReload
  * WordCount

## CLI

### Enabling OS X Screen Sharing from the Command Line

#### Enables Screen Sharing and Remote Management

```
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -access -off -restart -agent -privs -all -allowAccessFor -allUsers
```

#### Enables only Screen Sharing
```
sudo defaults write /var/db/launchd.db/com.apple.launchd/overrides.plist com.apple.screensharing -dict Disabled -bool false
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.screensharing.plist
```

## Development

 * brew install android-sdk go jq phantomjs python3 mercurial 

### python virtualenv

Various possibilities, make sure virtualenvwrapper works.
Default virtualenv folder: ~/.virtualenvs

 * mkdir ~/.virtualenvs

### pygame

 * brew install sdl sdl_image sdl_mixer sdl_ttf portmidi smpeg pyenv-virtualenv pyenv-virtualenvwrapper
 * virtualenv -p python3 ~/.virtualenvs/pygame
 * source ~/.virtualenvs/pygame/bin/acitvate
 * pip3 install hg+http://bitbucket.org/pygame/pygame
 
### cocos2d-python
 * virtualenv -p python3 ~/.virtualenvs/cocos2d
 * pip install cocos2d

#### Fixing packages

```
export PKG_S="sdl sdl_image sdl_mixer sdl_ttf smpeg portmidi"
for PKG in `echo ${PKG_S}`; do
   brew rm ${PKG}
   brew rm $(join <(brew leaves) <(brew deps ${PKG}))
done 
```

## Hiding your Desktop

To hide the Desktop on OSX 10.10, 10.11, 10.12 open a Terminal and type the following

```
defaults write com.apple.finder CreateDesktop false
killall Finder
```

To make it visible again just flip **false** to **true**

```
defaults write com.apple.finder CreateDesktop true
killall Finder
```

## Showing hidden files in Finder

### Enabling in Terminal
```
defaults write com.apple.finder AppleShowAllFiles YES
killall Finder
```


### Disabling in Terminal
```
defaults write com.apple.finder AppleShowAllFiles NO
killall Finder
```

# Potentially obsolete
## Mac Ports

  * port install pidgin pidgin-otr
  * brew install pidgin

## Tier 2
 * [tftpserver](http://ww2.unime.it/flr/tftpserver)
  * brew cask install tftpserver

# Apple Mail

## Rebuild the index

```
rm ~/Library/Mail/V4/MailData/Envelope\ Index
rm ~/Library/Mail/V4/MailData/Envelope\ Index-shm
rm ~/Library/Mail/V4/MailData/Envelope\ Index-wal
```
