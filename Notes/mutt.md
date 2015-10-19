## Deleting Duplicates with mutt

Open Folder you want to "treat".

Type: o
Then: t
Finally: D
Pattern: ~=
Expunge: $

You did: Sort by thread, delete based on Pattern ~= ,expunge mail.

## Basic .muttrc

```
## This is a basic muttrc to work with GPG you NEED to change: 0x blabla,
## thats my keys id put yours instead.

set pgp_decode_command="gpg %?p?--passphrase-fd 0? --no-verbose --batch --output - %f"
set pgp_verify_command="gpg --no-verbose --batch --output - --verify %s %f"
set pgp_decrypt_command="gpg --passphrase-fd 0 --no-verbose --batch --output - %f"
set pgp_sign_command="gpg --no-verbose --batch --output - --passphrase-fd 0 --armor --detach-sign --textmode %?a?-u %a? %f"
set pgp_clearsign_command="gpg --no-verbose --batch --output - --passphrase-fd 0 --armor --textmode --clearsign %?a?-u %a? %f"
set pgp_encrypt_only_command="pgpewrap gpg --batch --quiet --no-verbose --output - --encrypt --textmode --armor --always-trust --encrypt-to 0x1B220AB8 -- -r %r -- %f"
set pgp_encrypt_sign_command="pgpewrap gpg --passphrase-fd 0 --batch --quiet --no-verbose --textmode --output - --encrypt --sign %?a?-u %a? --armor --always-trust --encrypt-to 0x1B220AB8 -- -r %r -- %f"
set pgp_import_command="gpg --no-verbose --import -v %f"
set pgp_export_command="gpg --no-verbose --export --armor %r"
set pgp_verify_key_command="gpg --no-verbose --batch --fingerprint --check-sigs %r"
set pgp_list_pubring_command="gpg --no-verbose --batch --with-colons --list-keys %r" 
set pgp_list_secring_command="gpg --no-verbose --batch --with-colons --list-secret-keys %r" 
set pgp_autosign=yes
set pgp_auto_detect=yes
set pgp_sign_as=0x1B220AB8
set pgp_replyencrypt=yes
set pgp_timeout=1800
set pgp_good_sign="^gpg: Good signature from"
set spoolfile=imap://linion.ion.lu/INBOX
set folder=imap://linion.ion.lu
set imap_user="steve@ion.lu"
set certificate_file=~/.mutt/certs

## The set cert_file will enable the: accept certificate in mutt,
## spoolfile/folder options make it easier to use mutt w/ imap.
```
