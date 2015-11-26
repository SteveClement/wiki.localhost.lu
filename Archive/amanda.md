First you need to install amanda.
---------------------------------

./configure  --with-user=amanda --with-group=amanda --prefix=/home/amanda --with-config=tobermory-daily --with-amandahosts --with-mmap

make
rootdo make install


Amanda and Tape changers
------------------------

In the ~amanda/etc/amanda/<config>/amanda.conf change the following variables to the appropriate values:

runtapes 6              # number of tapes to be used in a single run of amdump
tpchanger "chg-chio"   # the tape-changer glue script
tapedev "/dev/nrsa0"    # the no-rewind tape device to be used
rawtapedev "/dev/null"  # the raw device to be used (ftape only)
#changerfile "/home/amanda/profero-daily/changer"
#changerfile "/home/amanda/profero-daily/changer-status"
#changerfile "/home/amanda/etc/amanda/profero-daily/changer.conf"
changerdev "/dev/ch0"

The older tapedev parameter is ignored if a tpchanger program is
specified, unless the changer program itself reads tapedev from
amanda.conf.  chg-multi doesn't, as it reads all its configuration
arguments from its own configuration file, specified as changerfile.

If the tpchanger program does not begin with a '/', then amanda will expect
it to reside in libexecdir, and possibly have the version suffix appended
depending on how amanda was configured.

The tape changer program has to be patched because it looks for a picker and HP
changers dont report one, so, apply the patch included. (amanda-chg-chio.patch)
chg-chio lives in ~amanda/libexec/


Labelling Amanda Tapes
----------------------

To label an Amanda tape you have to do:

 su -m amanda -c "~amanda/sbin/amlabel tobermory_daily tobermory_daily1"

Where tobermory_daily is the configuration name and tobermory_daily1 a
unique label conforming to the scheme you defined for labelling.  If
the name of the tape doesnt match the given pattern it gives you the
following message:

amlabel: label tobermory1 doesn't match labelstr "^tobermory_daily[0-9][0-9]*$"

labelstr, which is a variable, can be changed in:

~amanda/etc/amanda/<config>/amanda.conf

We start to count from 1 NOT from 0.

Sidenote:

Tape-changer users can use amlabel with the slot option which will label a tape
in a given slot.
su -m amanda -c "~amanda/sbin/amlabel tobermory_daily tobermory_daily1 slot 1"
The first slot is 1 not 0.

also, on tobermorey you can now simply su to amanda as we've given her a shell. this would not be the case on
client boxes.

Timeouts
--------

If you get an error in the Amanda report like this:

  antre-back / lev 0 FAILED [Request to antre-back timed out.]

(note that it is level 0 - for other levels different explanations may
apply), then probably what has happened is the size estimate has timed
out. Locate the configuration file
(~amanda/etc/amanda/<config>/amanda.conf) and alter the "etimeout"
parameter. e.g.:

etimeout 6000           # number of seconds per filesystem for estimates.

[Is there a CVS repository for Amanda configs?]
