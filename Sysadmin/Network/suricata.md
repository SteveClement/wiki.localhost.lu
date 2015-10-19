# suricata/libpcap/tcpdump/snort with PF_RING support

Make sure your Intel Driver has DNA and PF_RING support to enjoy full-speed: [[ixgbe]]

## Install Ubuntu 12.04 deps

```
sudo apt-get install autoconf subversion pkg-config git-core build-essential libpcre++-dev libyaml-dev libnet1-dev gettext libmagic-dev ethtool dkms subversion flex bison libpcre3-dev libpcap-dev libyaml-dev zlib1g-dev libcap-ng-dev libnet1-dev  git-core automake autoconf libtool libdaq-dev libdumbnet-dev
```

# PF_RING
```
cd /usr/src/
sudo svn --force export https://svn.ntop.org/svn/ntop/trunk/PF_RING/ PF_RING_CURRENT_SVN 
sudo chown -R ${USER}:${USER} PF_RING_CURRENT_SVN
sudo mkdir /usr/src/pf_ring-4
sudo chown ${USER}:${USER} /usr/src/pf_ring-4
cp -Rf /usr/src/PF_RING_CURRENT_SVN/kernel/* /usr/src/pf_ring-4/
cd /usr/src/pf_ring-4/

cat << EOF > dkms.conf 
PACKAGE_NAME="pf_ring"
PACKAGE_VERSION="4"
BUILT_MODULE_NAME[0]="pf_ring"
DEST_MODULE_LOCATION[0]="/kernel/net/pf_ring/"
AUTOINSTALL="yes" 
EOF

sudo dkms add -m pf_ring -v 4 
sudo dkms build -m pf_ring -v 4 
sudo dkms install -m pf_ring -v 4 

sudo mkdir -p /opt/PF_RING/{bin,lib,include/linux,sbin}
sudo cp -f /usr/src/PF_RING_CURRENT_SVN/kernel/linux/pf_ring.h /opt/PF_RING/include/linux/ 

cd /usr/src/PF_RING_CURRENT_SVN/userland/lib 
./configure 
sed -i -e 's/INSTDIR   = \${DESTDIR}\/\/usr\/local/INSTDIR   = \${DESTDIR}\/opt\/PF_RING/' Makefile 
make
sudo make install 
echo "options pf_ring transparent_mode=0 min_num_slots=32768 enable_tx_capture=0" > /etc/modprobe.d/pf_ring.conf
sudo modprobe pf_ring
sudo modinfo pf_ring && cat /proc/net/pf_ring/info


# libpcap-1.1.1-ring
cd /usr/src/PF_RING_CURRENT_SVN/userland/libpcap-1.1.1-ring
./configure 
sed -i -e 's/\.\.\/lib\/libpfring\.a/\/opt\/PF_RING\/lib\/libpfring\.a/' Makefile 
sed -i -e 's/\.\.\/lib\/libpfring\.a/\/opt\/PF_RING\/lib\/libpfring\.a/' Makefile.in 
./configure --prefix=/opt/PF_RING && make && sudo make install 


# tcpdump-4.1.1-ring
cd /usr/src/PF_RING_CURRENT_SVN/userland/tcpdump-4.1.1
./configure 
sed -i -e 's/\.\.\/lib\/libpfring\.a/\/opt\/PF_RING\/lib\/libpfring\.a/' Makefile 
sed -i -e 's/\.\.\/lib\/libpfring\.a/\/opt\/PF_RING\/lib\/libpfring\.a/' Makefile.in 
sed -i -e 's/-I \.\.\/libpcap-1\.0\.0-ring/-I \/opt\/PF_RING\/include/' Makefile 
sed -i -e 's/-I \.\.\/libpcap-1\.0\.0-ring/-I \/opt\/PF_RING\/include/' Makefile.in 
sed -i -e 's/-L \.\.\/libpcap-1\.0\.0-ring\/-L /\/opt\/PF_RING\/lib\//' Makefile 
sed -i -e 's/-L \.\.\/libpcap-1\.0\.0-ring\/-L /\/opt\/PF_RING\/lib\//' Makefile.in 
./configure LD_RUN_PATH="/opt/PF_RING/lib:/usr/lib:/usr/local/lib" --prefix=/opt/PF_RING/ --enable-ipv6 && make && sudo make install 


# suricata-head-ring
cd /usr/src/PF_RING_CURRENT_SVN/userland/
git clone git://phalanx.openinfosecfoundation.org/oisf.git oisfnew 
cd oisfnew 
./autogen.sh 
./configure --enable-pfring --with-libpfring-libraries=/opt/PF_RING/lib --with-libpfring-includes=/opt/PF_RING/include --with-libpcap-libraries=/opt/PF_RING/lib --with-libpcap-includes=/opt/PF_RING/include LD_RUN_PATH="/opt/PF_RING/lib:/usr/lib:/usr/local/lib" --prefix=/opt/PF_RING/ 
make
sudo make install
sudo make install-rules

sudo mkdir /etc/suricata 
sudo cp suricata.yaml /etc/suricata/ 
sudo cp classification.config /etc/suricata/ 
sudo cp reference.config /etc/suricata
sudo mv /opt/PF_RING/etc/suricata/rules /etc/suricata/
sudo rm -r /opt/PF_RING/etc
sudo mkdir /var/log/suricata 
sudo touch /etc/suricata/treshold.config

# vi /etc/suricata/suricata.yaml
# Change: 
###max-pending-packets: 1024
###runmode: autofp
##default-log-dir: /opt/PF_RING/var/log/suricata/
##default-rule-path: /opt/PF_RING/etc/suricata/rules
##classification-file: /opt/PF_RING/etc/suricata/classification.config
##reference-config-file: /opt/PF_RING/etc/suricata/reference.config
#vim -- :%s/opt\/PF_RING\//

sudo sed -i -e 's/\/opt\/PF_RING//' /etc/suricata/suricata.yaml 
sudo sed -i -e 's/#max-pending-packets:\ 1024/max-pending-packets:\ 65534/' /etc/suricata/suricata.yaml
sudo sed -i -e 's/#runmode:\ autofp/runmode:\ workers/' /etc/suricata/suricata.yaml

#run suricata
sudo /opt/PF_RING/bin/suricata --pfring-int=eth3 --pfring-cluster-id=99 --pfring-cluster-type=cluster_flow -c /etc/suricata/suricata.yaml
```

## Snort

```
sudo apt-get install libdaq-dev libdumbnet-dev
cd /usr/src/PF_RING_CURRENT_SVN/userland/snort
wget http://www.snort.org/downloads/1862 -O snort-2.9.3.1.tar.gz
wget http://www.snort.org/assets/178/pfring-daq-module-0.1.tar.gz
tar xfvz snort-2.9.3.1.tar.gz
cd snort-2.9.3.1
./configure --with-libpfring-libraries=/opt/PF_RING/lib --with-libpfring-includes=/opt/PF_RING/include --with-libpcap-libraries=/opt/PF_RING/lib --with-libpcap-includes=/opt/PF_RING/include LD_RUN_PATH="/opt/PF_RING/lib:/usr/lib:/usr/local/lib" --prefix=/opt/PF_RING/ 
make
sudo make install
cd /usr/src/PF_RING_CURRENT_SVN/userland/snort/pfring-daq-module
ln -s /usr/src/PF_RING_CURRENT_SVN /root/PF_RING
autoreconf -ivf
./configure --with-libpfring-libraries=/opt/PF_RING/lib --with-libpfring-includes=/opt/PF_RING/include LD_RUN_PATH="/opt/PF_RING/lib:/usr/lib:/usr/local/lib" --prefix=/opt/PF_RING
make
sudo make install 
```
