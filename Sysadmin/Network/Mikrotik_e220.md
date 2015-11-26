http://wiki.mikrotik.com/wiki/Option_Globetrotter_HSDPA_USB_Modem

# Huawei E220 HSDPA USB Modem

    * 1 Introduction
    * 2 Hardware
    * 3 Router Configuration for PPP
    * 4 Troubleshooting
    * 5 Additional Resources

# Introduction

This example shows how to get the Huawei E220 HSDPA USB Modem working with Tele2 (Luxemborug Mobile Telephone UMTS/GPRS networks)
Service in your country might have different requirements and strings, but this is just to give you an outline of what is required.

# Hardware

Router Hardware: MikroTik Router with USB port(s) (RB230, any x86 system, or, RB433 when available with USB)

Router Software: RouterOS V3.x (works in v2.9.x as well)

USB Modem: Huawei E220 HSDPA USB Modem H7.2


The USB Modem is recognized in RouterOS as an USB device and listed under the USB resources:

```
[admin@rb433_USB_test] /interface ppp-client> /system resource usb print
 # DEVICE VENDOR                            NAME                            SPEED                           
 0 1:1                                      RB400 OHCI                      12 Mbps                         
 1 1:2    Option N.V.                       Globetrotter HSDPA Modem        12 Mbps                         
[admin@rb433_USB_test] /interface ppp-client>

[admin@MikroTik] > /system resource usb print
 # DEVICE VENDOR                                      NAME                                      SPEED                                     
 0 2:1                                                OHCI Host Controller                      12 Mbps                                   
 1 2:3    HUAWEI Technologies                         HUAWEI Mobile                             12 Mbps                                   
 2 1:1                                                EHCI Host Controller                      480 Mbps                                  
 3 1:3    Syntek                                      USB2.0                                    480 Mbps                                  
 4 2:5    HUAWEI Technologies                         HUAWEI Mobile                             12 Mbps                                   
[admin@MikroTik] > 
```


Make sure the USB ports are set to 9600:

```
[admin@rb433_USB_test] > /port print 
Flags: I - inactive 
 #   NAME                               USED-BY                               BAUD-RATE
 0   serial0                            Serial Console                        auto     
 1   usb1                                                                     9600     
 2   usb2                                                                     9600     
 3   usb3                                                                     9600     
[admin@rb433_USB_test] > 

[edit] Router Configuration for PPP

```

Copy and paste the following text into the router console:

```
/port set usb3 baud-rate=9600

/ppp profile 
add name="ppp-LMT" remote-address=212.93.97.200
add name="ppp-Amigo" remote-address=212.93.97.200

/interface ppp-client 
add name="ppp-lmt" modem-init="AT+CGDCONT=1,\"IP\",\"internet.lmt.lv\"" \
    dial-command="ATDT" phone="*99***1#" profile=ppp-LMT \
    user="" password="" \
    add-default-route=yes use-peer-dns=yes\
    port=usb3 disabled=yes
add name="ppp-amigo" modem-init="AT+CGDCONT=1,\"IP\",\"amigo.lv\"" \
    dial-command="ATDT" phone="*99***1#" profile=ppp-Amigo \
    user="amigo" password="amigo" \
    add-default-route=yes use-peer-dns=yes\
    port=usb3 disabled=yes
```

The first command sets the baud rate of USB port (our modem uses USB3). Next, two profiles are created (because we have two different SIM cards from two providers). Then, ppp-client interfaces are created (adjust your peer-dns and default-route settings according to what you want to do over that interface).

Enable the ppp-lmt interface and watch the logs to see how the connection is being established over the USB modem:

```
00:54:06 async,ppp,info ppp-lmt: initializing... 
00:54:06 async,ppp,info ppp-lmt: reseting link... 
00:54:06 system,info device changed by admin 
00:54:07 async,ppp,info ppp-lmt: initializing modem... 
00:54:07 async,ppp,info ppp-lmt: dialing out... 
00:54:07 async,ppp,info ppp-lmt: authenticated 
00:54:10 system,info dns changed 
00:54:10 async,ppp,info ppp-lmt: connected
```

Check the addresses and routes! In our case we have:

```
[admin@rb433_USB_test] > /ip address print 
Flags: X - disabled, I - invalid, D - dynamic 
 #   ADDRESS            NETWORK         BROADCAST       INTERFACE                      
 0 D 10.5.8.62/24       10.5.8.0        10.5.8.255      ether1                         
 1 D 10.34.252.96/32    212.93.97.200   0.0.0.0         ppp-lmt                        
[admin@rb433_USB_test] > /ip route print 
Flags: X - disabled, A - active, D - dynamic, 
C - connect, S - static, r - rip, b - bgp, o - ospf, m - mme, 
B - blackhole, U - unreachable, P - prohibit 
 #      DST-ADDRESS        PREF-SRC        G GATEWAY                  DISTANCE INTER...
 0 ADS  0.0.0.0/0                          r 212.93.97.200            1        ppp-lmt 
 1 ADC  10.5.8.0/24        10.5.8.62                                  0        ether1  
 2 ADC  212.93.97.200/32   10.34.252.96                               0        ppp-lmt 
[admin@rb433_USB_test] > 
```

You may need to use masquerade to hide your private network when going out through the ppp.
[edit] Troubleshooting

1. If you do not get "authenticated" and "connected", then there is something wrong with your settings. Most likely, the profile or the ppp-client interface settings should be changed to match your provider's requirements.

2. If the USB port is not set to 9600 baud rate, there will be log message when you try to run the ppp client:

```
00:08:50 async,ppp,info ppp-lmt: initializing... 
00:08:50 async,ppp,info ppp-lmt: reseting link... 
00:08:50 async,ppp,info ppp-lmt: reseting link... - could not acquire serial port 
00:08:50 async,ppp,info ppp-lmt: disconnected
```

3. You can check if you can communicate with the USB modem by using the serial-terminal. Make sure the ppp-client is disabled! Start the serial terminal and run some AT commands:

```
[admin@rb433_USB_test] > system serial-terminal usb3

[Ctrl-A is the prefix key]

AT
OK
AT+CSQ
+CSQ: 12,99

OK
```

This must be okay, because the modem responds to your commands. Quit the serial terminal with "Ctrl-A" and "Q":

```
[Q - quit connection]      [B - send break]
[A - send Ctrl-A prefix]   [R - autoconfigure rate]


Welcome back!
[admin@rb433_USB_test] > 
```

4. Turn off PIN request for your SIM card, it makes the life much easier. Do it in a phone if you do not know the correct AT command.
[edit] Additional Resources

Huawei_EVDO WiKi Page with similar setup for a PCMCIA modem

Teltonika HomePage of the USB modem manufacturer
Retrieved from "http://wiki.mikrotik.com/wiki/Option_Globetrotter_HSDPA_USB_Modem"

Category: Hardware
