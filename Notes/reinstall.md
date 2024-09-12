# reInstall any system

## FreeBSD

See [FreeBSD Install](https://github.com/SteveClement/sysadmin/tree/master/tools/install) :warning: out of date

## OpenBSD

See [OpenBSD Desktop](../Sysadmin/OpenBSD/Desktop.md)

## Debian

See [Debian Desktop](../Sysadmin/Linux/Debian/Desktop.md)

## New tools

* https://mosh.org/#getting
* http://spacevim.org/quick-start-guide/
* brew tap caskroom/fonts
* brew cask install font-hack-nerd-font
* https://gist.github.com/BretFisher/78a90d4e39e79d5f3c9769d4002f67a7
* http://betterthanack.com/
* https://github.com/axiros/terminal_markdown_viewer
* https://gist.github.com/BretFisher/6f688dde0122399efdca5a9d26100437

## macOS

See [macOS Desktop](../Sysadmin/macOS/Desktop.md)

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

#### Usb-Serial

Download and install the PL2303 Driver

http://www.prolific.com.tw/US/ShowProduct.aspx?p_id=229&pcid=41

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

#### Printing with lpr

First, add LPD Printer. Second check what the device name is.

~/bin/mylpr
```bash
#!/bin/bash
ENSCRIPT="--no-header --margins=36:36:36:36 --font=Courier11 --word-wrap --media=A4"
export ENSCRIPT
/usr/local/bin/enscript -p - $1 | /usr/bin/lpr -P printer_office_lan_LPD
```

* [Old Docs](../Sysadmin/OSX/Tips.md)
* [More Docs](../InfoSec/GeneralProtection.md)
* [Python Setup](../Devel/python.md)

### Ruby Gems

```
# gem install i2cssh <- Broken
gem install tmuxinator
```
