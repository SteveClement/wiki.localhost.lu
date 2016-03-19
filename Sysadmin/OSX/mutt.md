# Efficient mutt on OSX

Make sure you add this tap:

```
brew tap SteveClement/devel
brew install --with-sidebar-patch --with-trash-patch --with-s-lang --with-pgp-combined-crypt-hook-patch mutt-patched
brew install urlview contacts offlineimap msmtp imapfilter findutils dialog elinks
brew install --with-python --with-python3 notmuch
```


## ~/.urlview

```
COMMAND open %s
```

## muttrc.account

```
set imap_pass="`security find-internet-password -a steve@localhost.lu -g -r imap -s mail.mbox.lu 2>&1 >/dev/null | cut -d\" -f2`"
set postponed=”imaps://imap.gmail.com/[Gmail]/Drafts”
```

## muttrc.globals
```
set query_command = "contacts -Sf '%eTOKEN%n' '%s' | sed -e 's/TOKEN/\t/g'"
auto_view text/html
```

## offlineimap

For offlineimap use make sure ~/.mail exists and the security command knows your credentials ;)

[1] http://oif.eafarris.com/blog/hooking-os-xs-address-book-to-mutt

[2] http://www.verboom.net/blog/index.html?single=20110518.0

[3] http://linsec.ca/Using_mutt_on_OS_X

[4] http://cheat.errtheblog.com

[5] ﻿﻿﻿http://jstorimer.com/shells/2010/01/19/using-mutt-with-gmail-on-osx.html
