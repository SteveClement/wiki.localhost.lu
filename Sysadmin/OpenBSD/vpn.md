This is the Linux Connection details for a Unifi VPN Gateway.

Let us translate this into OpenBSD.

```
$ nmcli connection show |grep vpn                           
Office                           5ae55be7-e27a-4882-a4f9-5cdfbf94df40  vpn       --              
$ nmcli connection edit 5ae55be7-e27a-4882-a4f9-5cdfbf94df40

===| nmcli interactive connection editor |===

Editing existing 'vpn' connection: '5ae55be7-e27a-4882-a4f9-5cdfbf94df40'

Type 'help' or '?' for available commands.
Type 'print' to show all the connection properties.
Type 'describe [<setting>.<prop>]' for detailed property description.

You may edit the following settings: connection, vpn, match, ipv4, ipv6, tc, proxy
nmcli> print
===============================================================================
                      Connection profile details (Office)
===============================================================================
connection.id:                          Office
connection.uuid:                        5ae55be7-e27a-4882-a4f9-5cdfbf94df40
connection.stable-id:                   --
connection.type:                        vpn
connection.interface-name:              --
connection.autoconnect:                 no
connection.autoconnect-priority:        0
connection.autoconnect-retries:         -1 (default)
connection.multi-connect:               0 (default)
connection.auth-retries:                -1
connection.timestamp:                   1573270729
connection.read-only:                   no
connection.permissions:                 user:localUser
connection.zone:                        --
connection.master:                      --
connection.slave-type:                  --
connection.autoconnect-slaves:          -1 (default)
connection.secondaries:                 --
connection.gateway-ping-timeout:        0
connection.metered:                     unknown
connection.lldp:                        default
connection.mdns:                        -1 (default)
connection.llmnr:                       -1 (default)
-------------------------------------------------------------------------------
ipv4.method:                            auto
ipv4.dns:                               192.178.0.118
ipv4.dns-search:                        office.lan
ipv4.dns-options:                       ""
ipv4.dns-priority:                      0
ipv4.addresses:                         --
ipv4.gateway:                           --
ipv4.routes:                            { ip = 192.178.0.0/24 }
ipv4.route-metric:                      -1
ipv4.route-table:                       0 (unspec)
ipv4.ignore-auto-routes:                no
ipv4.ignore-auto-dns:                   yes
ipv4.dhcp-client-id:                    --
ipv4.dhcp-timeout:                      0 (default)
ipv4.dhcp-send-hostname:                yes
ipv4.dhcp-hostname:                     --
ipv4.dhcp-fqdn:                         --
ipv4.never-default:                     yes
ipv4.may-fail:                          yes
ipv4.dad-timeout:                       -1 (default)
-------------------------------------------------------------------------------
ipv6.method:                            ignore
ipv6.dns:                               --
ipv6.dns-search:                        --
ipv6.dns-options:                       ""
ipv6.dns-priority:                      0
ipv6.addresses:                         --
ipv6.gateway:                           --
ipv6.routes:                            --
ipv6.route-metric:                      -1
ipv6.route-table:                       0 (unspec)
ipv6.ignore-auto-routes:                no
ipv6.ignore-auto-dns:                   no
ipv6.never-default:                     no
ipv6.may-fail:                          yes
ipv6.ip6-privacy:                       0 (disabled)
ipv6.addr-gen-mode:                     stable-privacy
ipv6.dhcp-duid:                         --
ipv6.dhcp-send-hostname:                yes
ipv6.dhcp-hostname:                     --
ipv6.token:                             --
-------------------------------------------------------------------------------
vpn.service-type:                       org.freedesktop.NetworkManager.l2tp
vpn.user-name:                          --
vpn.data:                               gateway = yourGateway.example.com, ipsec-enabled = yes, ipsec-esp = 3des-sha1, ipsec-ike = 3des-sha1-modp1024, ipsec-psk = SomeGoodOlIPSecPSK, mru = 1400, mtu = 1400, password-flags = 1, refuse-chap = yes, refuse-eap = yes, refuse-mschap = yes, refuse-pap = yes, user = VPNUserName
vpn.secrets:                            <hidden>
vpn.persistent:                         no
vpn.timeout:                            0
-------------------------------------------------------------------------------
proxy.method:                           none
proxy.browser-only:                     no
proxy.pac-url:                          --
proxy.pac-script:                       --
-------------------------------------------------------------------------------
nmcli> 
```
