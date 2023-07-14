# Install build tools, debian helpers and fakeroot
```
apt-get install build-essential debhelper fakeroot
```

# source code should reside in /usr/src
```
cd /usr/src
```

# Download PHP source
```
apt-get source php5
```

# Install all packages required to build PHP5
```
apt-get build-dep php5
cd php5-5.2.3
```

How a package is compiled is set within the files contained in the debian directory of a package. 
Rules for configuring the compile process can be found in **debian/rules**. 

In this file there is a line that reads:
```
--with-gd=shared,/usr --enable-gd-native-ttf \.
```

This links to the Ubuntu distributed version of LibGD as a shared library. It is part of the autoconf script that customises the compilation of PHP. I replaced this line with:

```
 --with-gd=shared --enable-gd-native-ttf \. 
```

This causes the compilation process to use the bundled version of GD and make a shared library.
Once the package has been reconfigured it can be compiled and installed by:

```
    # build the php5-* packages
    dpkg-buildpackage -rfakeroot
    cd ..
    # Install the new php5-gd package
    dpkg -i php5-gd_5.2.3-1ubuntu6.3_i386.deb
```
