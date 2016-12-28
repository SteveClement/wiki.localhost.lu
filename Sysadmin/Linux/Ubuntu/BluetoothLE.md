You need a Bluetooth 4.0 adapter with LE (http://en.wikipedia.org/wiki/Bluetooth_low_energy)

# Install dependencies

```
 sudo apt-get install libusb-dev libdbus-1-dev libglib2.0-dev libudev-dev libical-dev libreadline-dev
```

# Grab tar ball and install

```
 mkdir bluez
 cd bluez
 wget http://www.kernel.org/pub/linux/bluetooth/bluez-5.43.tar.gz
 tar xfvz bluez-5.43.tar.gz
 cd bluez-5.43
 LDFLAGS=-lrt ./configure --disable-systemd --datadir=/usr --prefix=/usr --localstatedir=/var --sysconfdir=/etc
 make
 sudo make install
```

```
hciconfig

sudo hciconfig hciO up
sudo hciconfig hci0 leadv 3
sudo hciconfig hci0 noscan
sudo hcitool -i hci0 cmd 0x08 0x0008 1E 02 01 1A 1A FF 4C 00 02 15 E2 0A 39 F4 73 F5 4B C4 A1 2F 17 D1 AD 07 A9 61 00 00 00 00 C8 00
```

# Bluez iBeacon

https://github.com/carsonmcdonald/bluez-ibeacon
