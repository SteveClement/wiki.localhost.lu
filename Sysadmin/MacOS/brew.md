# OSX brew

## Create dsniff formula

```
brew create http://monkey.org/~dugsong/dsniff/dsniff-2.3.tar.gz
```

## Add dependencies

* libnet
* libnids
* cmake
* gcc

```
brew edit dsniff
```

```
brew install -vd dsniff
```

this will Bomb out and you need to manually add this to the configure script:

```
./configure --disable-debug --disable-dependency-tracking --prefix=/usr/local/Cellar/dsniff/2.3 --with-libnet=/usr/local/Cellar/libnet/1.1/ --with-libnids=/usr/local/Cellar/libnids/1.24/
```

Still figuring out how to properly do it.

Then add it to repo once ready:

```
git add .
git commit -m "Added a formula for dsniff"
gem install json github
github fork
git push SteveClement mastergitx
```

File ticke New Formula:

https://github.com/mxcl/homebrew/issues


https://github.com/mxcl/homebrew/wiki/
