# Mounting a raw (dd) disk image on macOS

## To mount a raw disk in OSX first attach the raw image without mounting it

```
hdiutil attach -imagekey diskimage-class=CRawDiskImage -nomount filename
```


