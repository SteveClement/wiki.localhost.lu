<<TableOfContents>>

# Protecting your Valuables on modern *nix systems in 2017

As a modern-day Sysadmin Pirate (or Ninja) you have a few artefacts you don't want to loose or leave lying around plain-text on your Disk or take to con.

Mine are:

 * SSH-Keys
 * GnuPG Keys
 * Certificates (for Web Sites and VPN)
 * Password Stores (Chrom*, Mozilla*, PWSafe, mutt, Wireless etc...)
 * CryptoDisks
 * Configuration Files

## Encrypt Home

A good step towards better security is to enable the encryption on your home folder.
One smallish down-side is performance. As soon as you encrypt on-the-fly it has an impact on your CPU.
There are efforts of having CPU assisted encryption but that seems not to be a high priority for most chip-makers. (But Intel is really working on it and perhaps YOU could write  a nice CUDA hack to make it even more performant)

Under Ubuntu this can be done easily during install and the decryption key will be your Password. So better think of a strong 12 character password for your Security! (example: Sbtoas12cpfyS! <- can you find out how this was created?)
Update: "I really think this is a better password! "
I got used to it now and most of my passwords are entire phrases. I do not event count anymore how long it is. I only make sure at least some special characters are in there if it's pretty sensitive. I still use throw-away common passwords among low impact sites/services.

Under MacOSX this can be achieved in the SystemPreference -> Security -> FileVault
Also here you need to have a strong Login Password here because it unlocks your keychain as well as your encrypted home (or Disk).

 * One drawback is the public ssh key not being available anymore for remote logins if the encrypted store is not mounted. A work around would be to change the Value: *AuthorizedKeysFile* in your *sshd_config* file
 * Another downside is performance if you have Virtual Machines or other Disk IO Intesive tasks and this is platform independent. This might become less crucial in the future once Hardware crypto is used more thoroughly. A workaround is to put your VM on an external Drive. In my experience USB 2.0 is not performant enough but with USB 3.0 more or less widely available this is an interesting alternative.

## Locate your valuables

If you use Ubuntu your key store and WPA connection secrets are to be protected.

Under OSX *Keychain Access Status* needs to be displayed in the *Menu Bar* to easily lock the keychain.

Open *Keychain Access* and go to *Preferences*, Tick:

 * Show Status in Menu Bar

Once you have that layer of protection in place think of other directories you want to encrypt:

```
 ~/.ssh
 ~/.gnupg
 ~/.purple (pidgin passwords, stored plain text in accounts.xml)
 ~/.mozilla/firefox/${your_profile}/key3.db
 ~/.mozilla/firefox/${your_profile}/signons*
 ~/.mozilla/firefox/${your_profile}/cookies* (for the paranoid)
 ~/.mozilla/firefox/${your_profile}/formhistory.sqlite (for the ones who know why)
 ~/.thunderbird/${your_profile}/key3.db
 ~/.thunderbird/${your_profile}/signons*
 ~/.thunderbird/${your_profile}/cookies* (for the very paranoid)
 ~/.mutt
 ~/.gconf
 ~/keepassx.kdb
 ~/.config/chromium/Default (DO NOT USE CHROMIUM TO SAVE PASSWORDS, YOU CANNOT SET A MASTER PASSWORD YET AS OF 2011)
 ~/.vimrc
 ~/.signature-*
 ~/Library/Application\ Support/Adium\ 2.0
 ~/Delibar
 ~/Library/Preferences/com.twitter.twitter-mac.plist
 ~/Library/StickiesDatabase
 ~/.shsh
 ~/.msmtprc
```

Other things you might want to sync:

```
 ~/Music/iTunes
 ~/Desktop
 ~/truecrypt1
 ~/Library/GoldenCheetah
```

This is what in General my Digital Life looks like. (have fun profiling me)


## Define worst case scenario

If this get's stolen and eventually decrypted, would I be boned?

## Set master passwords where possible

:warning: Bare in mind that setting a Master Password on your Firefox and Thunderbird is essential.

Yes I do save my Passwords from Various web sites on my Laptop. Everyone has more than 30 different logins and it is either the same password everywhere or different passwords stored in Mozilla's Password Safe.


### Remembering Passwords

You have a few options here

 * A cross-platform Password Manager like [PasswordGorilla](http://github.com/zdia/gorilla/wiki)
 * A [password card](http://www.passwordcard.org/en)

I would recommend a cross between the two. Make sure you have your Password card, once in use, always in a safe place, e.g: your wallet or your knickers.


## Choose your Encryption Tool(s)

 * TrueCrypt but be aware of the [Security implications](http://en.wikipedia.org/wiki/TrueCrypt#Security_concerns)

For the subsequent encryption I chose TrueCrypt.
Some purist will yell traitor BUT I need something that works under Linux, Windows and Mac. TrueCrypt can cope with all of them even if not the most secure.

After FAT32 Formatting a 2Gig USB Disk you can do entire Disk encryption on that Drive and depending on how Paranoia you are you might want to investigate what a Hidden Partition is.

:warning: vFAT/FAT32 was a BAD choice(tm) - So I moved to an ext3/4 Filesystem with MacFuse under OSX (permission et al.)

Also there are Evil Maids that try to get to your Pass-phrase:

 * [Evil Maid goes after TrueCrypt](http://theinvisiblethings.blogspot.com/2009/10/evil-maid-goes-after-truecrypt.html)


## ext3/4 on MacOS X

Download [fuse-ext2](http://sourceforge.net/projects/fuse-ext2/)
Also make sure you have [MacFUSE](https://code.google.com/p/macfuse/) otherwise fuse-ext2 wont work.

Alternatively you can use **MacPorts**:

```
 sudo port install ext2fuse
```

or brew:

```
brew install ext2fuse
```

Once this is done, you can mount your Linux formatted TrueCrypt Disk but read-only by default only.

You need to add the "rw+" option in /System/Library/Filesystems/fuse-ext2.fs/fuse-ext2.util
Find the OPTIONS variable and make it look like:

OPTIONS="auto_xattr,defer_permissions,rw+"

```
 vi /System/Library/Filesystems/fuse-ext2.fs/fuse-ext2.util
```

Permissions need to be fixed under MacOSX OR a UserGroup needs to be added.

## Move and Link Valuables

```
 steve@steve-laptop:~$ mv .purple /media/truecrypt1/dotfiles/
 steve@steve-laptop:~$ ln -s /media/truecrypt1/dotfiles/.purple .purple
```

Repeat the above step for: .ssh .gnupg keepassx.kdb


## Securing the Bird and the Fox

For Firefox et al. simply go into the directory and do a move and link for the relevant files.

## Thunderbird Data

```
 steve@steve-laptop:~/.thunderbird/ys0kerhi.default$ mkdir /media/truecrypt1/dotfiles/.thunderbird
 steve@steve-laptop:~/.thunderbird/ys0kerhi.default$ mv -vi cookies.sqlite cert8.db signons* key3.db /media/truecrypt1/dotfiles/.thunderbird
 `cookies.sqlite' -> `/media/truecrypt1/dotfiles/.thunderbird/cookies.sqlite'
 removed `cookies.sqlite'
 `cert8.db' -> `/media/truecrypt1/dotfiles/.thunderbird/cert8.db'
 removed `cert8.db'
 `signons3.txt' -> `/media/truecrypt1/dotfiles/.thunderbird/signons3.txt'
 removed `signons3.txt'
 `signons.sqlite' -> `/media/truecrypt1/dotfiles/.thunderbird/signons.sqlite'
 removed `signons.sqlite'
 `signons.txt' -> `/media/truecrypt1/dotfiles/.thunderbird/signons.txt'
 removed `signons.txt'
 `key3.db' -> `/media/truecrypt1/dotfiles/.thunderbird/key3.db'
 removed `key3.db'
 steve@steve-laptop:~/.thunderbird/ys0kerhi.default$ ln -s /media/truecrypt1/dotfiles/.thunderbird/cookies.sqlite cookies.sqlite
 steve@steve-laptop:~/.thunderbird/ys0kerhi.default$ ln -s /media/truecrypt1/dotfiles/.thunderbird/cert8.db cert8.db
 steve@steve-laptop:~/.thunderbird/ys0kerhi.default$ ln -s /media/truecrypt1/dotfiles/.thunderbird/key3.db key3.db
 steve@steve-laptop:~/.thunderbird/ys0kerhi.default$ ln -s /media/truecrypt1/dotfiles/.thunderbird/signons.sqlite signons.sqlite
 steve@steve-laptop:~/.thunderbird/ys0kerhi.default$ ln -s /media/truecrypt1/dotfiles/.thunderbird/signons.txt signons.txt
 steve@steve-laptop:~/.thunderbird/ys0kerhi.default$ ln -s /media/truecrypt1/dotfiles/.thunderbird/signons3.txt signons3.txt
```

Alternatively:

```
You could consider your address book and your configuration (prefs.js/pgprules.xml) to be transferred to the USB Stick.

 1. Might contain sensitive data
 2. If you have more machines

Files -  abook.mab history.mab pgprules.xml prefs.js
```

## Firefox Data

```
 steve@steve-laptop:~/.mozilla/firefox/hvh835zl.default$ mkdir /media/truecrypt1/dotfiles/.firefox
 steve@steve-laptop:~/.mozilla/firefox/hvh835zl.default$ mv -vi cookies.sqlite cert8.db signons* key3.db formhistory.sqlite /media/truecrypt1/dotfiles/.firefox/
 `cookies.sqlite' -> `/media/truecrypt1/dotfiles/.firefox/cookies.sqlite'
 removed `cookies.sqlite'
 `cert8.db' -> `/media/truecrypt1/dotfiles/.firefox/cert8.db'
 removed `cert8.db'
 `signons3.txt' -> `/media/truecrypt1/dotfiles/.firefox/signons3.txt'
 removed `signons3.txt'
 `signons.sqlite' -> `/media/truecrypt1/dotfiles/.firefox/signons.sqlite'
 removed `signons.sqlite'
 `key3.db' -> `/media/truecrypt1/dotfiles/.firefox/key3.db'
 removed `key3.db'
 `formhistory.sqlite' -> `/media/truecrypt1/dotfiles/.firefox/formhistory.sqlite'
 removed `formhistory.sqlite'
 steve@steve-laptop:~/.mozilla/firefox/hvh835zl.default$ ln -s /media/truecrypt1/dotfiles/.firefox/cookies.sqlite cookies.sqlite
 steve@steve-laptop:~/.mozilla/firefox/hvh835zl.default$ ln -s /media/truecrypt1/dotfiles/.firefox/cert8.db cert8.db
 steve@steve-laptop:~/.mozilla/firefox/hvh835zl.default$ ln -s /media/truecrypt1/dotfiles/.firefox/key3.db key3.db
 steve@steve-laptop:~/.mozilla/firefox/hvh835zl.default$ ln -s /media/truecrypt1/dotfiles/.firefox/signons.sqlite signons.sqlite
 steve@steve-laptop:~/.mozilla/firefox/hvh835zl.default$ ln -s /media/truecrypt1/dotfiles/.firefox/signons3.txt signons3.txt
 steve@steve-laptop:~/.mozilla/firefox/hvh835zl.default$ ln -s /media/truecrypt1/dotfiles/.firefox/formhistory.sqlite formhistory.sqlite
```

## Backups

As I chose a full disk encryption on my USB Drive it is a bit tricky to do any serious backups that do not take gigabytes of Data.
So to back this thing up I simply grab a raw copy of the umounted disk:

```
 # dd if=/dev/sdb of=myCryptedUSB.raw
```

This will dump my 2Gig Drive thus giving me a 1 to 1 copy of the drive.

This is not satisfactory because:

 * It takes too much time
 * It takes too much space

Solution -> get a smaller USB Stick (<512Mb)

**OR**

Create a smaller Partition and just dump that:

```
 # dd if=/dev/sdb1 of=myCryptedUSB.raw
```

Where sdb1 is my 128Mb vfat partition.


## In the mean time https is your friend

The EFF has a neat Firefox extension that does a best effort to redirect you automagically to Secured sites

 * http://www.eff.org/https-everywhere

Moxie has also a new interesting take on securing communications in a clearly flawed SLL world where trust is essentially gone. (http://www.google.com/search?client=safari&rls=en&q=comodo+hacks)

 * https://github.com/moxie0/Convergence

Support the EFF and donate either your time by contributing to their projects or if you can spare some Dollars make a donation.
Or get a Mohawk at Defcon!

## Last Words

Avoid Chromium because you cannot securely store your passwords. (yet)

Avoid Launching your Apps without the Mounted crypto drive, it will eventually bite you.

## References

* http://kb.mozillazine.org/Key3.db
* https://help.ubuntu.com/community/EncryptedPrivateDirectory


## Copy paste

### Clean ONLY if new install

 * Should be transferred into a nice .sh Script

```
rm -r ~/.ssh ~/.gnupg ~/.purple ~/.config/chromium/Default/Web\ Data

### OSX Compatibility
ln -s ~/Library/Thunderbird/Profiles ~/.thunderbird
ln -s ~/Library/Application\ Support/Firefox/Profiles ~/.firefox

cd ~/.thunderbird/*.default
rm cookies.sqlite cert8.db signons* key3.db prefs.js virtualFolders.dat history.mab

cd ~/.firefox/*.default
rm cookies.sqlite cert8.db signons* key3.db formhistory.sqlite

rm ~/Library/StickiesDatabase
```


```
ln -s /Volumes/NO\ NAME/truecrypt1 ~/truecrypt1
ln -s ~/truecrypt1/dotfiles/.ssh ~/.ssh
ln -s ~/truecrypt1/dotfiles/.gnupg ~/.gnupg
ln -s ~/truecrypt1/dotfiles/.purple ~/.purple
ln -s ~/truecrypt1/dotfiles/.bash_history ~/.bash_history
ln -s ~/truecrypt1/dotfiles/.bash_profile ~/.bash_profile
ln -s ~/truecrypt1/dotfiles/.bashrc ~/.bashrc
ln -s ~/truecrypt1/dotfiles/.gitconfig ~/.gitconfig
ln -s ~/truecrypt1/dotfiles/.gitignore ~/.gitignore
ln -s ~/truecrypt1/dotfiles/.gitignore_global ~/.gitignore_global
ln -s ~/truecrypt1/dotfiles/.imapfilter ~/.imapfilter
ln -s ~/truecrypt1/dotfiles/.mutt ~/.mutt
ln -s ~/truecrypt1/dotfiles/.msmtprc ~/.msmtprc
ln -s ~/truecrypt1/dotfiles/.offlineimaprc ~/.offlineimaprc
ln -s ~/truecrypt1/dotfiles/.procmailrc ~/.procmailrc
ln -s ~/truecrypt1/dotfiles/.screenrc ~/.screenrc
ln -s ~/truecrypt1/dotfiles/.shsh ~/.shsh
ln -s ~/truecrypt1/dotfiles/.tmux.conf ~/.tmux.conf
ln -s ~/truecrypt1/dotfiles/.urlview ~/.urlview
ln -s ~/truecrypt1/dotfiles/.vim ~/.vim
ln -s ~/truecrypt1/dotfiles/.vimrc ~/.vimrc
ln -s ~/truecrypt1/dotfiles/.bitlbee .bitlbee
ln -s ~/truecrypt1/dotfiles/.irssi .irssi
ln -s ~/truecrypt1/dotfiles/.config .config
ln -s ~/truecrypt1/dotfiles .dotfiles
ln -s ~/truecrypt1/dotfiles/.notmuch-config .notmuch-config
ln -s ~/truecrypt1/dotfiles/.tmuxinator .tmuxinator
ln -s ~/truecrypt1/dotfiles/.zshrc .zshrc
ln -s ~/truecrypt1/dotfiles/.zshrc-e .zshrc-e
ln -s Library/Audio Audio
ln -s /Volumes/MobileTerra/GoogleDrive GoogleDrive
ln -s /Volumes/MobileTerra/GoogleDrive Google\ Drive
ln -s /Volumes/MobileTerra/GoogleDrive/VM  VirtualBox\ VMs
ln -s GoogleDrive/virtualenvs virtualenvs
ln -s ~/truecrypt1/dotfiles dotfiles
# :warning: Broken! ln -s ~/truecrypt1/dotfiles/.chromium/Web\ Data ~/.config/chromium/Default/Web\ Data
ln -s ~/truecrypt1/StickiesDatabase ~/Library/StickiesDatabase

cd ~/.thunderbird/*.default
ln -s ~/truecrypt1/dotfiles/.thunderbird/cookies.sqlite cookies.sqlite
ln -s ~/truecrypt1/dotfiles/.thunderbird/cert8.db cert8.db
ln -s ~/truecrypt1/dotfiles/.thunderbird/key3.db key3.db
ln -s ~/truecrypt1/dotfiles/.thunderbird/signons.sqlite signons.sqlite
ln -s ~/truecrypt1/dotfiles/.thunderbird/signons.txt signons.txt
ln -s ~/truecrypt1/dotfiles/.thunderbird/signons3.txt signons3.txt

cd ~/.firefox/*.default
rm prefs.js
ln -s ~/truecrypt1/dotfiles/.firefox/cookies.sqlite cookies.sqlite
ln -s ~/truecrypt1/dotfiles/.firefox/cert8.db cert8.db
ln -s ~/truecrypt1/dotfiles/.firefox/key3.db key3.db
ln -s ~/truecrypt1/dotfiles/.firefox/signons.sqlite signons.sqlite
ln -s ~/truecrypt1/dotfiles/.firefox/signons3.txt signons3.txt
ln -s ~/truecrypt1/dotfiles/.firefox/formhistory.sqlite formhistory.sqlite
ln -s ~/truecrypt1/dotfiles/.firefox/prefs.js prefs.js
NoScriptSTS.db
cert_override.txt
```

# For your Unified Setup pleasures, Thunderbird abook

```
ln -s ~/truecrypt1/dotfiles/.thunderbird/abook.mab abook.mab
ln -s ~/truecrypt1/dotfiles/.thunderbird/abook-1.mab abook-1.mab
ln -s ~/truecrypt1/dotfiles/.thunderbird/abook-2.mab abook-2.mab
ln -s ~/truecrypt1/dotfiles/.thunderbird/abook-3.mab abook-3.mab
ln -s ~/truecrypt1/dotfiles/.thunderbird/abook-4.mab abook-4.mab
ln -s ~/truecrypt1/dotfiles/.thunderbird/history.mab history.mab
ln -s ~/truecrypt1/dotfiles/.thunderbird/prefs.js prefs.js
ln -s ~/truecrypt1/dotfiles/.thunderbird/virtualFolders.dat virtualFolders.dat
```

