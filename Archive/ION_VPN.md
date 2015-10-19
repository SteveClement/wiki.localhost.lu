This will connect 2 Networks together via OpenVPN.

become root:

```
CLIENT="ion"
LUSER="steve"
portinstall openvpn
cd /usr/local/etc/ && mkdir -p openvpn/bin openvpn/certs && cd openvpn/certs

openvpn --genkey --secret shared.key.$CLIENT && chmod 600 shared.key.$CLIENT

cp /home/$LUSER/work/plumbum-ion-sysadmin/trunk/configs/common/openvpn/bin/ion-* /usr/local/etc/openvpn/bin/ && chmod 750 /usr/local/etc/openvpn/bin/*

cp /home/$LUSER/work/plumbum-ion-sysadmin/trunk/configs/common/openvpn/openvpn-CLIENT.conf /usr/local/etc/openvpn/openvpn-$CLIENT.conf

echo "/usr/local/sbin/openvpn --daemon --config /usr/local/etc/openvpn/openvpn.conf" >> /etc/rc.local
echo openvpn_enable=\"YES\" >> /etc/rc.conf
```

On the server:

copy the shared.key.$CLIENT to Your VPN Server. And begin the server side config.
```
chmod 600 /usr/local/etc/openvpn/certs/*
cd /usr/local/etc/openvpn
cp /home/$LUSER/work/plumbum-ion-sysadmin/trunk/configs/common/openvpn/openvpn-SERVER.conf openvpn-$CLIENT.conf
cp /home/$LUSER/work/plumbum-ion-sysadmin/trunk/configs/common/openvpn/bin/CLIENT-* bin/ && chmod 750 bin/CLIENT-* && cd bin/ && mv CLIENT-up.sh $CLIENT-up.sh && mv CLIENT-down.sh $CLIENT-down.sh
```

PKI:

```
cp -rvp /usr/local/share/doc/openvpn /usr/local/etc/openvpn/doc
cp -rvp /usr/local/share/doc/openvpn/easy-rsa /usr/local/etc/openvpn/
cd /usr/local/etc/openvpn/easy-rsa
. ./vars
./clean-all
./build-ca

./build-key-server server

./build-key client1

./build-dh
```
