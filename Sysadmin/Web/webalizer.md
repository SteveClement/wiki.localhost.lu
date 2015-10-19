# The Webalizer

[The Webalizer](http://www.webalizer.org/)

# quick FreeBSD Install

```
cd /usr/ports/www/webalizer/
make
cd work/webalizer-2.01-10/
patch -p1 < ~steve/work/plumbum-ion-sysadmin/trunk/patches/webalizer-search.patch
cd ../../
rm work/.build_done.webalizer-2.1.10_5._usr_local
make install clean
```

# Configuring webalizer

either:

 copy /etc/webalizer.conf.sample to somewhere else. See "sane things for
 your conf file" below on what to put in it. You'll need to do this before
 anything will work properly.

 For a site that we manage, the webalizer.conf should live in its
 repository.

 I edited Hostname too. Maybe you wan't to config it more. (woody)

 To run webalizer, change directory to where your webalizer.conf is
 and do:

```
webalizer [filename]
```

 on the prompt, this will process one log file.

 If you want to process several files, this seems to be difficult. You *could*
 do something like this:

```
find /dir/to/logs -name transfer.log -exec webalizer {} \;
```

 but, unfortunately, unless you feed webalizer information in chronological
 order, it looks like it'll throw the data that arrives too late into
 /dev/kingdom/come. Sometimes.

 Note that if you have a cloud of webservers, an https side logged in a
 different file, or anything else that will give logfiles that overlap in
 time, webalizer appears to be unable to do what you want.
 See Richersounds for utility to get around this problem.

 For multiple sites on the same box, put the conf
 file in ~apache/conf as webalizer.www.somewhere.org.conf
 and run using "webalizer -c ~apache/conf/webalizer.www.somewhere.org.conf"
 (use the -c option to tell it where the conf file is)

 add a corresponding line to httpd.conf like the wusage alias, so that
 stats are visible to people who should be allowed to look at them.
 see paper (www.lambiek.net for an example)


# How to Ignore, Hide and Group in Webalizer


 From webalizer.conf:

```
# The Hide*, Group* and Ignore* and Include* keywords allow you to
# change the way Sites, URL's, Referrers, User Agents and Usernames
# are manipulated.  The Ignore* keywords will cause The Webalizer to
# completely ignore records as if they didn't exist (and thus not
# counted in the main site totals).  The Hide* keywords will prevent
# things from being displayed in the 'Top' tables, but will still be
# counted in the main totals.  The Group* keywords allow grouping
# similar objects as if they were one.  Grouped records are displayed
# in the 'Top' tables and can optionally be displayed in BOLD and/or
# shaded. Groups cannot be hidden, and are not counted in the main
# totals. The Group* options do not, by default, hide all the items
# that it matches.  If you want to hide the records that match (so just
# the grouping record is displayed), follow with an identical Hide*
# keyword with the same value.  (see example below)  In addition,
# Group* keywords may have an optional label which will be displayed
# instead of the keywords value.  The label should be seperated from
# the value by at least one 'white-space' character, such as a space
# or tab.
#
# The value can have either a leading or trailing '*' wildcard
# character.  If no wildcard is found, a match can occur anywhere
# in the string. Given a string "www.yourmama.com", the values "your",
# "*mama.com" and "www.your*" will all match.
```

 So for instance to ignore BigBrother stats you do in the webalizer.conf file:

```
IgnoreSite      glass.thebunker.net
```

 to ignore hits to your stats directory on the server:

```
IgnoreURL       /_stats
```


# Sane Defaults

 You'll probably want DNS reverse lookups on - set DNSCache and DNSChildren
 to sensible values. If you do this, note that you CANNOT EASILY FEED
 webalizer DATA ON A PIPE - you need to give it filenames, or it gives up
 at EOF when it can't go back to the beginning.

 You'll almost certainly want "Incremental yes", so that sequential processing
 of rotated logs will work; FoldSeqErr yes is probably a good idea, so minor
 timing errors (which seem to happen with Apache) don't cause records to
 be lost. If you do that, MAKE SURE that you're feeding log files to
 webalizer in the right order, or presumably very weird things can happen.

 You'll probably want GroupURL /images/* Images (if your files are laid out
 that way) so you can see how much bandwidth your lovely pretty design is
 costing you.

 MangleAgents 5 is good, too.

 I edited Hostname too. Maybe you wan't to config it more. (woody)


```
cd /usr/ports/www/webalizer/
make
cd work/webalizer-2.01-10/
patch -p1 < ~steve/work/plumbum-ion-sysadmin/patches/webalizer-search.patch
patch -p1 < ~steve/work/plumbum-ion-sysadmin/patches/webalizer-search-patch_ports.diff
patch -p1 < ~steve/work/plumbum-ion-sysadmin/patches/webalizer-search-patch_ports_with-GeoIP.diff
cd ../../
rm work/.build_done.webalizer._usr_local
make install clean
```

# Installing webalizer
Use at least version 2.01-10. Previous versions have security problems.

# Dependenies
ftp://ftp.mrunix.net/pub/webalizer/webalizer-2.01-10-src.tgz | ->http://prdownloads.sourceforge.net/libpng/libpng-1.2.2.tar.gz |       | |       -> http://www.gzip.org/zlib/zlib-1.1.4.tar.gz | ->http://www.boutell.com/gd/http/gd-1.8.4.tar.gz

 . |
 ->http://www.ijg.org/files/jpegsrc.v6b.tar.gz

# Installing libpng
If needed install zlib and then copy scripts/makefile.freebsd to the main libpng tree and do make test ; rootdo make install You might need to create the directories rootdo mkdir /usr/local/include ; rootdo mkdir /usr/local/man/man3 if make install fails...

# Installing jpeg
unpack ./configure make rootdo make install

# Installing gd
Unpack it.

Edit the Makefile and add:

-I../jpeg-6b/

at the INCLUDEDIRS variable

make

rootdo make install

# webalizer
If reverse DNS lookups are required (which they usually will), include --enable-dns.

```
./configure --enable-dns --with-png=../libpng-1.2.2 --with-gd=../gd-1.8.4
```
(i had to add --with-png-inc=/usr/local/include at some point - woody) (i had to tell it my gd path, even though it was /usr/local/lib, which

 . seems obvious - tim)

make rootdo make install

# Configuring webalizer
either:

copy /etc/webalizer.conf.sample to somewhere else. See "sane things for your conf file" below on what to put in it. You'll need to do this before anything will work properly.

For a site that we manage, the webalizer.conf should live in its repository.

I edited Hostname too. Maybe you wan't to config it more. (woody)

To run webalizer, change directory to where your webalizer.conf is and do:

webalizer [filename]

on the prompt, this will process one log file.

If you want to process several files, this seems to be difficult. You *could* do something like this:

find /dir/to/logs -name transfer.log -exec webalizer {} \;

but, unfortunately, unless you feed webalizer information in chronological order, it looks like it'll throw the data that arrives too late into /dev/kingdom/come. Sometimes.

Note that if you have a cloud of webservers, an https side logged in a different file, or anything else that will give logfiles that overlap in time, webalizer appears to be unable to do what you want. See Richersounds for utility to get around this problem.

For multiple sites on the same box, put the conf file in ~apache/conf as webalizer.www.somewhere.org.conf and run using "webalizer -c ~apache/conf/webalizer.www.somewhere.org.conf" (use the -c option to tell it where the conf file is)

add a corresponding line to httpd.conf like the wusage alias, so that stats are visible to people who should be allowed to look at them. see paper (www.lambiek.net for an example)

# How to Ignore, Hide and Group in Webalizer
From webalizer.conf:

```
# The Hide*, Group* and Ignore* and Include* keywords allow you to # change the way Sites, URL's, Referrers, User Agents and Usernames # are manipulated.  The Ignore* keywords will cause The Webalizer to # completely ignore records as if they didn't exist (and thus not # counted in the main site totals).  The Hide* keywords will prevent # things from being displayed in the 'Top' tables, but will still be # counted in the main totals.  The Group* keywords allow grouping # similar objects as if they were one.  Grouped records are displayed # in the 'Top' tables and can optionally be displayed in BOLD and/or # shaded. Groups cannot be hidden, and are not counted in the main # totals. The Group* options do not, by default, hide all the items # that it matches.  If you want to hide the records that match (so just # the grouping record is displayed), follow with an identical Hide* # keyword with the same value.  (see example below)  In addition, # Group* keywords may have an optional label which will be displayed # instead of the keywords value.  The label should be seperated from # the value by at least one 'white-space' character, such as a space # or tab. # # The value can have either a leading or trailing '*' wildcard # character.  If no wildcard is found, a match can occur anywhere # in the string. Given a string "www.yourmama.com", the values "your", # "*mama.com" and "www.your*" will all match.

So for instance to ignore BigBrother stats you do in the webalizer.conf file:

IgnoreSite      glass.thebunker.net

to ignore hits to your stats directory on the server:

IgnoreURL       /_stats
```

## Sane Defaults

```
You'll probably want DNS reverse lookups on - set DNSCache and DNSChildren to sensible values. If you do this, note that you CANNOT EASILY FEED webalizer DATA ON A PIPE - you need to give it filenames, or it gives up at EOF when it can't go back to the beginning.

You'll almost certainly want "Incremental yes", so that sequential processing of rotated logs will work; FoldSeqErr yes is probably a good idea, so minor timing errors (which seem to happen with Apache) don't cause records to be lost. If you do that, MAKE SURE that you're feeding log files to webalizer in the right order, or presumably very weird things can happen.

You'll probably want GroupURL /images/* Images (if your files are laid out that way) so you can see how much bandwidth your lovely pretty design is costing you.

MangleAgents 5 is good, too.

I edited Hostname too. Maybe you wan't to config it more. (woody)

Patching file lang/webalizer_lang.english.orig using Plan A...
Reversed (or previously applied) patch detected!  Assume -R? [y]

Patching file linklist.c.orig using Plan A...
Reversed (or previously applied) patch detected!  Assume -R? [y]

Patching file linklist.h.orig using Plan A...
Reversed (or previously applied) patch detected!  Assume -R? [y]

Patching file output.c.orig using Plan A...
Reversed (or previously applied) patch detected!  Assume -R? [y]

Patching file sample.conf.orig using Plan A...
Reversed (or previously applied) patch detected!  Assume -R? [y]

Patching file webalizer.c.orig using Plan A...
Reversed (or previously applied) patch detected!  Assume -R? [y]

Patching file webalizer.h.orig using Plan A...
Reversed (or previously applied) patch detected!  Assume -R? [y]

Patching file webalizer_lang.h using Plan A...
Reversed (or previously applied) patch detected!  Assume -R? [y]

one webalizer-2.01-10 # find . |grep rej
./lang/webalizer_lang.english.orig.rej
./linklist.c.orig.rej
./linklist.h.orig.rej
./output.c.orig.rej
./preserve.c.orig.rej
./sample.conf.orig.rej
./webalizer.c.orig.rej
./webalizer.h.orig.rej
./webalizer_lang.h.rej
```