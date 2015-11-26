```
apt-get install linux-headers-$(uname -r) build-essential rpm capiutils

wget http://opensuse.fltronic.de/rpms/10_2/src/fcpci-0.1-0.src.rpm

rpm2cpio fcpci-0.1-0.src.rpm | cpio -i
tar xzvf fcpci-suse93-3.11-07.tar.gz
cd fritz
patch -p1 < ../fritz-tools.diff
./install
```