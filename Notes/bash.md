# bash tips

http://www.caliban.org/bash/index.shtml

## $CDPATH

```
cd /home
export CDPATH="/usr/src:~/work/"
cd linux
pwd
/usr/src/linux
```

## $RANDOM

```
echo $RANDOM
randomnumber
```

## $IFS

This is because the for loop is using $IFS to determine what the field
separators are. By default $IFS is set to the space character, which is
why you are getting the above results. IFS needs to be set to the
end-of-line character for your for loop to work.

Try something like this :

```
ORIGIFS=$IFS
IFS=`echo -en "\n\b"`

# insert for loop here

IFS=$ORIGIFS
```
