# cuckoo install

## OSX

### requirements

- pip
- HomeBrew
- wireshark-chmodbpf
- tcpdump
- ssdeep
- volatility
- virtualbox
- libmagic
- dnspython
- virtualenv
- mongodb
- tesseract

### hombrew deps

```
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install ssdeep libmagic wireshark-chmodbpf mongodb

```


### Host preparation

#### Enable forwarding and prepare firewall

```
sudo sysctl net.inet.ip.forwarding=1
echo "nat on en1 from vboxnet0:network to any -> (en1)" > ./pfrule
echo "pass inet proto icmp all" >> ./pfrule
echo "pass in on vboxnet0 proto udp from any to any port domain keep state" >> ./pfrule
echo "pass quick on en1 proto udp from any to any port domain keep state" >> ./pfrule
sudo pfctl -e
sudo pfctl -f ./pfrule
```

```

git clone https://github.com/volatilityfoundation/volatility.git
cd volatility
python setup.py build
python setup.py install
env "CFLAGS=-I/usr/local/include -L/usr/local/lib" pip install pycrypto
pip install distorm3
```


### Install virtualbox

### Install cuckoo
