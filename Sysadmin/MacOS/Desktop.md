# Preparing the system

## bootstrap

To bootstrap the machine you first need to:

- Login iCloud and the AppStore
- Enable remote access
- ssh into the machine remotely
- Install brew:

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

- clone the `truecrypt1` and `NONAME` folder into your homedir
- run `prep.sh`

- Login to Visual Code


### Investigate configs

#### Keka

cmd - , -> Extraction -> Always to folder, Move to bin, Show content in finder, 

### WebApps

- [regexr](https://regexr.com/)


### AppStore Apps

    * [Gemini 2](https://itunes.apple.com/us/app/id1090488118)
    * [Kaleidoscope](https://itunes.apple.com/us/app/kaleidoscope/id587512244)
    * [Xcode](https://itunes.apple.com/us/app/xcode/id497799835)

#### lessfilter

```
pip3 install pygments
```

#### mutt et al.

```
mkdir ~/.signatures # ln -s your sigs.
pip3 install git+https://github.com/honza/mutt-notmuch-py.git
brew tap neomutt/homebrew-neomutt
brew install --with-gpgme --with-libidn --with-notmuch-patch --with-s-lang neomutt
sudo -u steve /usr/bin/security -v add-internet-password -a steve@localhost.lu -s mail.mbox.lu /Users/steve/Library/Keychains/login.keychain
sudo -u steve /usr/bin/security -v add-internet-password -a steve.clement@lhc.lu -s mail.mbox.lu /Users/steve/Library/Keychains/login.keychain
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

### Finder Tweaks

* cmd , -> General, Sidebar, Advanced
* List view -> View -> Show View Options -> Calculate all sizes etc -> Use as Defaults

KeyRepeat -> Tips.md

* [Install mutt](mutt.md)

