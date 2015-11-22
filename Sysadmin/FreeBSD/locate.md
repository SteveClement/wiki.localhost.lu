# Securely Configuring 'locate' under FreeBSD (and other *NIX)

If you want one global 'locate database' for the root user simply calling 'locate.updatedb' will reveal all your files to any users who have access to that database. Which may be a security risk in your environment.

c.f the warning:

```
aggli ~ # /usr/libexec/locate.updatedb
>>> WARNING
>>> Executing updatedb as root.  This WILL reveal all filenames
>>> on your machine to all login users, which is a security risk.
```


To solve this you need a per user database and a tighten DB for the root user.

From the man file we know that:

```
/etc/locate.rc
```

is the main config file and that we have the environment variable LOCATE_CONFIG to point to this file.

Vanilla Contents:

```
#
# /etc/locate.rc -  command script for updatedb(8)
#
# $FreeBSD: src/usr.bin/locate/locate/locate.rc,v 1.10.8.1 2009/04/15 03:14:26 kensmith Exp $

#
# All commented values are the defaults
#
# temp directory
#TMPDIR="/tmp"

# the actual database
#FCODES="/var/db/locate.database"

# directories to be put in the database
#SEARCHPATHS="/"

# directories unwanted in output
#PRUNEPATHS="/tmp /usr/tmp /var/tmp /var/db/portsnap"

# filesystems allowed. Beware: a non-listed filesystem will be pruned
# and if the SEARCHPATHS starts in such a filesystem locate will build
# an empty database.
#
# be careful if you add 'nfs'
#FILESYSTEMS="ufs ext2fs"
```

From the man page we know that the environment variable LOCATE_PATH sets the Database Path.

So adding the following in you login script (main bashrc is using bash)

```
export LOCATE_PATH="$HOME/db/locate.database"
```

of course db must exist in your home dir.

Amend /etc/locate.rc so that the option "FCODES" looks like this:

```
FCODES="$HOME/db/"
```

locate.updatedb creates the file with umask permission, which means the World can read your Database file.
For added security chmod 600 $HOME/db/locate.database

You could do the following too:

Step 1: Copy and modify database update program I first copied the original program to a new directory, with this command:
```
 cp /usr/libexec/locate.updatedb ~/bin/llocate.updatedb
```

Make a few changes to the location of the new database directory, changed the pruned paths, and added vfat to my available filesystems, so that lines 52 to 54 now looked like this:

```
 ${FCODES:=$HOME/Library/llocate.database}  # the database

 ${SEARCHPATHS:="$HOME"}  # directories to be put in the database

 ${PRUNEPATHS:="$HOME/tmp $HOME/Library "}  # unwanted directories
```

Step 2: set up crontab your slocate db to update every hour at the 25 minute mark:
```
 25 * * * *        $HOME/bin/llocate.updatedb
```

(crontab -l is your friend when testing)

Step 3: Create the alias Finally, I set up the alias to get the command to work automatically by adding the following command to my $HOME/.bashrc file:
```
 alias llocate='locate -d $HOME/Library/llocate.database'
```

You should now be able to easily "llocate" your own files!