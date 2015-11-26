To get the Huawei HSPA Modems going on OpenBSD you have to:

http://www.jensolsson.se/2008/12/setting-up-huawei-e220-as-a-secondary-connection/ (404)


First of all we need to remove the PIN code from the SIM card so we dont have to bother with it.
We connect to the modem with “cu”. My modem serial port is at /dev/cuaU0

First we have to authenticate with the PIN code
```
>AT+CPIN=1234
```

Then we disable the PIN code check:
```
>AT+CLCK=”SC”,0,”1234″
```

We then create a directory for the config files at /etc/ppp/peers.
In there we put 2 files. A config file and a chat file communicating with the modem.
I want it to be flexible in case I switch operator so I call my files threeg and threeg.chat.
Below are the files I got working. I am not entirely sure that they are optimal, but they seem to work well. I have hade a lot of trouble just getting it working. Examples on other sites about the modem in question did not work for me. Maybe because I am running OpenBSD.
Do not forget to change “internet.glocalnet.se” to your providers APN.

/etc/ppp/peers/threeg:
```
/dev/cuaU0
crtscts
921600
defaultroute
noauth
:10.64.64.64
connect 'chat -v -f /etc/ppp/peers/threeg.chat'
```

/etc/ppp/peers/threeg.chat:
```
ABORT "NO CARRIER"
ABORT "NO DIALTONE"
ABORT "ERROR"
ABORT "NO ANSWER"
ABORT "BUSY"
ABORT "Username/Password Incorrect"
TIMEOUT 15
"" "ATZ"
OK "ATE1"
OK "ATQ0V1E1S0=0&C1&D2+FCLASS=0"
OK 'AT+CGDCONT=1,"IP","internet.glocalnet.se"'
OK "ATDT*99***1#"
TIMEOUT 30
CONNECT \d\c
```

Then to start the connection we must create a ppp0 interface. We do that with ifconfig.
We then start the pppd daemon.
```
# ifconfig ppp0 create
pppd file /etc/ppp/peers/threeg
```

# HUAWEI E169 Modem

I decided to get a Huawei E169 with a 3 contract to allow me to have mobile broadband.

The scripts that I use with
```
/usr/sbin/pppd
```

are shown in [1] and are available as text files txt/three and txt/three.chat.

Here are some notes to getting it working with OpenBSD.

Nameservers: 4.2.2.4 and 4.2.2.3

To send text messages directly using AT commands:

Need to get text mode

```
AT+CMGF=1
```

then to send SMS

```
AT+CMGS="+44xxxMobilexxx"

> Type your message!!

Ctrl-Z
```

The > will come up automatically.

[1] thread on marc

[3] http://lars-bamberger.gmxhome.de/linux/E169.html

[4] SMS on a Huawei

three:

```
debug
/dev/cuaU0
921600
# ISP ipcp session
0.0.0.0:10.64.64.64
netmask 255.255.255.255
ipcp-accept-local
ipcp-accept-remote
crtscts
persist
deflate 0
refuse-pap
refuse-chap
noauth
noipdefault
noccp
novj
novjccomp
nopcomp
connect '/usr/sbin/chat -v -f /etc/ppp/peers/three.chat'
```

three.chat:
```
TIMEOUT 120
ABORT "BUSY"
ABORT "ERROR"
ABORT "NO CARRIER"
ABORT "VOICE"
ABORT "NO DIALTONE"
"" ATZ
#OK AT+CPIN=0000
#OK AT+CGDCONT=1,"IP","3internet"
OK ATD*99***1#
CONNECT \c
```
