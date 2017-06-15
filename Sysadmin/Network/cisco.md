Disable USB modules:

https://www.cisco.com/c/en/us/td/docs/solutions/GGSG-Engineering/15_1_4M/USB_Disable.html

hw-module usb disable

SSH RSA User Authentication on a CISCO 2960

$ fold -b -w 72 /home/steve/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAgEAu4IivdlQyBsel3pcByFwSFltD43PnP/QQ2Xh
cG2dLAaYJSGbjNsHuSjLXJAaFqR0q09aSumQUuGysPKSocKQ6MST+MW96N1MomfqO6/Pixz0
fA/V8uZKfWtqK4iIF/sZBhsvcXqET13PVQTJF/Pnhg33GWd9/7n91AdK3Ce1xuRosvQYzftS
E3D7/QHcp4a5/Fk+Xo1Wg8xOsvPxLHtl2WVIRDx/+nm2x2YNakI3asTAElHS0gi20/e14P0g
vMtOsfol1H1QQeU1ShQb4c5Q2koNcWnn18JiRctcocIbYh785TeR5iLTALKo2yEl8JO8J5/S
epmouKMWyEI7wp7OEW6HmgDPEHHYWn3jjtIhDkBcMhctVD+Pvswj+18agaRF4P28pBoGgZCE
qND/d7KH4nlGkkFIVxlJeCawD0CstEFdzjOTMUFoq/YF7uahyvBX/MlZDGbCGmXwJyMQWg5O
+P58JbX21+RMaI8Je3AFoJBaj4JTquG08SOr1/E8/0VOAyHBUGg1vwE4MlQ+brS6PcP48fay
K7Ql3nkGOegwUaFfKiZ7jGXvsR80QbHXpB15/ANcO58HrwYAQVVqxqcazGeKdE7CAApUfJSz
XxW2ryOSWXoGptDRHfyyhYWRzrvlHlOdDiEl/eH0zzsv0gtxvv8OIdl7q1PH2MtdNKdZEkk=
 Steve Clement

Copy from: ssh-rsa skdlkdf;lsdk
Until the end of the keystring (you HAVE TO omit the Key Comment else you get: %SSH: Failed to decode the Key Value)


(config) #ip ssh pubkey-chain
(conf-ssh-pubkey) #username steve
(conf-ssh-pubkey-user)#key-string
(conf-ssh-pubkey-data)#ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAgEAu4IivdlQyBsel3pcByFwSFltD43PnP/QQ2Xh
(conf-ssh-pubkey-data)#cG2dLAaYJSGbjNsHuSjLXJAaFqR0q09aSumQUuGysPKSocKQ6MST+MW96N1MomfqO6/Pixz0
(conf-ssh-pubkey-data)#fA/V8uZKfWtqK4iIF/sZBhsvcXqET13PVQTJF/Pnhg33GWd9/7n91AdK3Ce1xuRosvQYzftS
(conf-ssh-pubkey-data)#E3D7/QHcp4a5/Fk+Xo1Wg8xOsvPxLHtl2WVIRDx/+nm2x2YNakI3asTAElHS0gi20/e14P0g
(conf-ssh-pubkey-data)#vMtOsfol1H1QQeU1ShQb4c5Q2koNcWnn18JiRctcocIbYh785TeR5iLTALKo2yEl8JO8J5/S
(conf-ssh-pubkey-data)#epmouKMWyEI7wp7OEW6HmgDPEHHYWn3jjtIhDkBcMhctVD+Pvswj+18agaRF4P28pBoGgZCE
(conf-ssh-pubkey-data)#qND/d7KH4nlGkkFIVxlJeCawD0CstEFdzjOTMUFoq/YF7uahyvBX/MlZDGbCGmXwJyMQWg5O
(conf-ssh-pubkey-data)#+P58JbX21+RMaI8Je3AFoJBaj4JTquG08SOr1/E8/0VOAyHBUGg1vwE4MlQ+brS6PcP48fay
(conf-ssh-pubkey-data)#exit
(conf-ssh-pubkey-user)#exit
(conf-ssh-pubkey)#exit
wr


To disable telnet

conf t
line vty 0 15
transport input none

To disable web services

conf t
(config)#no ip http server
(config)#no ip http secure-server


DNS

Setting Up DNS
Beginning in privileged EXEC mode, follow these steps to set up your switch to use the DNS:

 
 Command
 Purpose
 Step 1
 configure terminal
 Enter global configuration mode.
 Step 2
 ip domain-name name
 Define a default domain name that the software uses to complete unqualified hostnames (names without a dotted-decimal domain name).
 Do not include the initial period that separates an unqualified name from the domain name.
 At boot-up time, no domain name is configured; however, if the switch configuration comes from a BOOTP or Dynamic Host Configuration Protocol (DHCP) server, then the default domain name might be set by the BOOTP or DHCP server (if the servers were configured with this information).
 Step 3
 ip name-server server-address1 [ server-address2... server-address6 ]
 Specify the address of one or more name servers to use for name and address resolution.
 You can specify up to six name servers. Separate each server address with a space. The first server specified is the primary server. The switch sends DNS queries to the primary server first. If that query fails, the backup servers are queried.
 Step 4
 ip domain-lookup
 (Optional) Enable DNS-based hostname-to-address translation on your switch. This feature is enabled by default.
 If your network devices require connectivity with devices in networks for which you do not control name assignment, you can dynamically assign device names that uniquely identify your devices by using the global Internet naming scheme (DNS).
 Step 5
 end
 Return to privileged EXEC mode.
 Step 6
 show running-config
 Verify your entries.
 Step 7
 copy running-config startup-config
 (Optional) Save your entries in the configuration file.

 Trunk vs Access

 https://www.cisco.com/c/en/us/td/docs/switches/datacenter/nexus5000/sw/configuration/guide/cli/CLIConfigurationGuide/AccessTrunk.html

 IP Multicast routing:

 https://www.cisco.com/c/en/us/td/docs/ios/12_2/ip/configuration/guide/fipr_c/1cfmulti.html

 
NTP

conf t
ntp server pool.ntp.org version 2
ntp peer pool.ntp.org version 2
clock timezone CET 2

