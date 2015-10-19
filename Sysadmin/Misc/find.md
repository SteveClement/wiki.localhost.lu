# Some useful find things

## List 0 byte Files

replace ls -l with rm to delete
```
find . -size 0 -type f -exec ls -l {} \;
```

## Lists files older than n*24h

### 5*24h

```
#### Variable BUP_AGE can be one of the following too:
##export BUP_AGE="-cmin n" # File's status was last changed n minutes ago.
##export BUP_AGE="-ctime n" # File's status was __last changed__ n*24 hours ago.
##export BUP_AGE="-empty"  #File is empty and is either a regular file or a directory.
export BUP_AGE="-atime +5" # Means: File was last accessed n*24 hours ago. Where n=5
find . $BUP_AGE -type f -exec ls -l {} \;
```
