# Golden Cheetah

From http://goldencheetah.org/

GoldenCheetah is a software package that:

 * Downloads ride data directly from the CycleOps PowerTap and the SRM PowerControl.
 * Imports ride data downloaded with other programs, including TrainingPeaks WKO+ and the manufacturers' software for the Ergomo, Garmin, Polar, PowerTap, and SRM devices.
 * Provides a rich set of analysis tools, including a critical power graph, BikeScore calculation, histogram analysis, a best interval finder, and a pedal force versus pedal velocity chart, to name just a few.
 * Is available for Linux, Mac OS X, and Windows. (The Windows version does not yet support direct downloads from the SRM PowerControl.)
 * Is released under an Open Source license.

We believe that cyclists should be able to download their power data to the computer of their choice, analyze it in whatever way they see fit, and share their methods of analysis with others.

# Compiling on Mac OS X 10.6

Install qt4-mac via ports:
```
 sudo port install qt4-mac
```

Follow the Dev Guide: http://goldencheetah.org/developers-guide.html


# Installation on Ubuntu 10.04
## Binary

## From Source

http://goldencheetah.org/developers-guide.html
```
sudo apt-get install git-core libqt4-dev libboost-dev libqt4-sql-sqlite
```

:warning: Missing -lqwt not a cadidate: libqwt5-qt3-dev

## liboauth

Is needed for (future?) Twitter integration.


Install libftdi from source:
```
http://www.ftdichip.com/Drivers/D2XX.htm
wget http://www.ftdichip.com/Drivers/D2XX/Linux/libftd2xx0.4.16.tar.gz
(OR 64bit wget http://www.ftdichip.com/Drivers/D2XX/Linux/libftd2xx0.4.16_x86_64.tar.gz)

tar xfvz libftd2xx0.4.16_x86_64.tar.gz
cd libftd2xx0.4.16_x86_64
sudo cp libftd2xx.so.0.4.16 /usr/local/lib
cd /usr/local/lib
sudo ln -s libftd2xx.so.0.4.16 libftd2xx.so
cd /usr/lib
sudo ln -s /usr/local/lib/libftd2xx.so.0.4.16 libftd2xx.so
sudo mv ftd2xx.h /usr/local/include/
sudo mv WinTypes.h /usr/local/include/
```

If needed install libsrm and 
```
git clone git://github.com/rclasen/srmio.git
cd srmio
make
sudo make install
```


# My Devices
 * Garmin Edge 705
 * Garmin Forerunner 110

# My Future Devices
 * Quarq CinQo SRAM 130