# DNS Tips

## tar pitting malware

One good way to prevent malware to lookup it zombies and daemons is to use a
blockeddomains

a blackhole DNS for enterprises is always a good thing to have!

## debugging bind9

the -g option is what you are looking for, to quote the man page:

```
 -g
           Run the server in the foreground and force all logging to stderr.
```

# Maintaining DNS

To see how outofdate your named.conf / domainDb relation is:

```
cat named.conf |grep ^zone\  |grep -v //  > chkex
```

clean up chkex

then

```
for a in `cat chkex `; do 
 if [ -e domainDb/${a} ]; then 
  echo -n
 else 
  echo "${a} not ins use"
 fi
done
```


# SSH over DNS with Ozyman

No more dealing with nstx messing up your network interfaces!

1. Download Dan Kaminsky's OzymanDNS
2. Get a domain that you can control the nameserver of subdomains for.
ZoneEdit works very well for this, if you don't want to manage your own DNS.
3. Pick a subdomain you want to assign to the OzymanDNS server. Make sure
it has an A record in DNS somewhere that points to it. I chose
ozyman.example.com, since I own example.com (I don't really, but you get the
idea).
4. In the domain you have control over, Add an NS record for
ozyman.example.com. with data of yourhost.college.edu (replace that with an
actual hostname of the machine running the OzymanDNS server.
5. On the server, start: sudo ./nomde.pl -i 127.0.0.1 ozyman.example.com
6. On the client, run:
      ssh -C -o ProxyCommand="./droute.pl -v sshdns.ozyman.example.com"
localhost
7. Congratulations, you should now have an SSH connection open to the host
that's running OzymanDNS.

2006 Ari Pollak
04p31fe02@sneakemail.com

## DNStunnel.de

Keep in mind: All requests to a certain subdomain are relayed to your host,
which then answers them. And you won't look up ordinary hostnames, I tell you.
Hope you got the idea.
Technical Setup

To delegate all requests to sub.example.com to ns.anothernameserver.com, you
first have to delegate all requests to that server (NS record, line 1) and
then send a so-called GLUE record (that is, glued to the record before because
it's most likely the asking server will need this info as well) with your
server's IP (line 2, A record).

sub.example.com.              IN      NS      ns.anothernameserver.com.
ns.anothernameserver.com.     IN      A       192.0.34.166

If you just have a DynDNS account and no static IP, you'd set up the
delegation using a CNAME record. As mentioned above, CNAME is a canonical name
(speak: an alias). So when a server gets back a CNAME instead of an A record
(IP address) he continues to look up this hostname. That brings us to the
following:

sub.example.com.              IN      NS      ns.extern.example.com.
ns.extern.example.com.        IN      CNAME   foo.bar.dyndns.org.

The Fake Server

The fake server you can set up at your server to tunnel all the traffic
through is a little program called OzymanDNS, written in Perl (Client and
Server together 642 SLOC) by DNS guru Dan Kaminsky. The tool is split in four
files, two of them being a file upload/download tool using DNS. Nice examples,
but rather uninteresting for our approach.

The script nomde.pl is the server. Since the server binds to port 53 UDP on
your server (which is a privileged port) you must be root to start the server.
Also, make sure port 53 UDP is reachable from the outside (consider running
nmap -v -sU host from a remote machine). You will usually want to start it as
follows:

sudo ./nomde.pl -i 0.0.0.0 server.example.com

Here, the server will only listen to DNS requests for all subdomains of
server.example.com. That way, people who don't know that exact address cannot
use the service on your server.
The Client


The OzymanDNS client is just a perl script which encodes and transfers
everything it receives on STDIN to it's destination, via DNS requests. Replys
are written to STDOUT.

So this isn't particularly useful as a standalone program. But it was designed
to be used together with SSH. And with SSH this works great. SSH has a config
option, ProxyCommand, which lets you use OzymanDNS's droute.pl client to
tunnel the SSH traffic. The command to connect to your server would look like
this:

ssh -o ProxyCommand="./droute.pl sshdns.server.example.com" user@localhost

Note two things:

   1. Add a sshdns. in front of the hostname you specified the server to
listen to and
   2. Since your connection will already have been tunneled through DNS (and
thus has come out at your host already) there is no need to login as
user@server.example.com (because that already is localhost)

Once the connection is established (you'll probably have to enter your
password) you have a shell! The connection is a little bit droppy sometimes
and has not got the best latency, but it is still good keeping in mind that
connections to the internet are not allowed at this Cafe/Airport/....
Tunneling

Once you verified that the connection is actually working, you can set up a
tunnel so that you may not only have shell, but complete web acces, can fetch
mails using POP, etc., etc...

For this, I recommend to read my tutorial on How to Tunnel Everything through
SSH.

Don't forget: It may provide great performance increases to use SSH's -C
("compress data") switch!
Communication between the Servers

So, now how might the servers communicate with each other, not being directly
able to establish a connection?, you might ask now.

Well, since all subdomain resolve requests are delegatet (ie., relayed) to
your host, you can include arbitrary data in the hostname which your server
then can interpret and execute/relay.

The bytes you want to send to the server (upstream) will be encoded using
Base32 (if you know what Base64 is, Base32 is just the same except there is no
case sensivitiy, for EXAMPLE.COM ist just the same as example.com). After the
data, there is a unique ID (since some DNS requests may take longer than
others and the UDP protocol has no methods to check this) and either one of
the keywords up or down, indicating whether the traffic's up- or downstream.
Here is what an example request could look like (transferring something to the
server):

ntez375sy2qk7jsg2og3eswo2jujscb3r43as6m6hl2ws
xobm7h2olu4tmaq.lyazbf2e2rdynrd3fldvdy2w3tifi
gy2csrx3cqczxyhnxygor72a7fx47uo.nwqy4oa3v5rx6
6b4aek5krzkdm5btgz6jbiwd57ubnohnknpcuybg7py.6
3026-0.id-32227.up.sshdns.feh.dnstunnel.de

The server's response comes as a DNS TXT record. A TXT record can hold
arbitrary ASCII data and can hold uppercase letters as well as lowercase
letters and numbers (some other characters, as well). So the responses come
Base64 encoded. Such a response might look like the following one:

695-8859.id-39201.down.sshdns.feh.dnstunnel.de.   0       IN      TXT
"AAAAlAgfAAAAgQDKrd3sFmf8aLX6FdU8ThUy3SRWGhotR6EsAavqHgBzH2khqsQHQjEf355jS7cT
G+4a8kAmFVQ4mpEEJeBE6IyDWbAQ9a0rgOKcsaWwJ7GdngGm9jpvReXX7S/2oqAIUFCn0M8="
"MHw9tR0kkDVZB7RCfCOpjfHrir7yuiCbt7FpyX8AAAABBQAAAAAAAAAA"

That is, in rough outlines, how tunneling via DNS works.
Security Issues

There are a few security issues you'll have to think about before letting the
server run permanently:

    * As soon as some people guess which subdomain you use to tunnel DNS they
    * can send arbitrary commands to the server. I haven't reviewed the code
    * for too long, but there might be the possiblity of a bug which could be
    * exploited to gain access to your system. But that ist just a unlikely
    * hypothesis.
    * The software still is very experimental and crashes every now and then
    * (see below for a workaround).
    * Consider that the server puts a high load on your system while actively
    * surfing.

I own a Server but my ISP doesn't allow me to change (the relevant) DNS
settings

Well, that is the reason I created this website. I offer to set up a subdomain
for you which delegates all requests (see above) to your fake nameserver. For
this you just need to set up your own listening server. That means you must
have a machine connected to the internet on which you may become root.

If you want me to set up a delegation of a subdomain to your fake nameserver,
just write me an email to <request AT dnstunnel.de>. You should include your
full name, your server's static IP or DynDNS hostname and the desired
subdomain name (name.dnstunnel.de; I encourage you to keep this secret for
your own security).

Please only send requests for hosts you really own. Please do NOT send
requests for hosts you 0wn.

It may take a day or two until I can process your request and maybe another
day until the DNS information is spread well enough around the net.
Legal Warning

Circumventing the AP's access controls (that includes DNS tunneling) is most
probably considered to be a crime, depending on the country you live in. I am
not responsible for whatever you do with your tunnel. I am just providing two
simple entries in my ISP's DNS server to let a hostname point to your server's
IP.
Helper Script

Here are two little helper scripts that'll allow you to automatically start
OzymanDNS on system boot through initd. This is my /etc/init.d/ozymandns file:

```bash
#!/bin/sh
# Written by Julius Plenz

set -e

case "$1" in
  start)
    echo -n "Starting ozymandns listener..."
    screen -d -m /usr/local/bin/ozymandns-listener
    echo "."
    ;;
  stop)
    echo -n "Stopping ozymandns listener..."
    kill `cat /var/run/ozymandns.pid`
    echo "."
      ;;
  restart)
    /etc/init.d/ozymandns stop
    /etc/init.d/ozymandns start
    ;;
  reload|force-reload)
    echo "cannot do that"
    echo "."
    ;;
  *)
    echo "Usage: /etc/init.d/$NAME {start|stop|restart}"
    exit 1
    ;;
esac

exit 0
```

Of course, you'll have to make the script executable. Then I'd suggest to put two links to automatically start and terminate the server on bootup/shutdown:

```
~# cd /etc/rc0.d/; ln -s ../init.d/ozymandns K15ozymandns
~# cd /etc/rc2.d/; ln -s ../init.d/ozymandns S99ozymandns
```
The program called from the init script (/usr/local/bin/ozymandns-listener) looks like this:

```bash
#!/bin/sh

REPLYIP=0.0.0.0
DNSHOST=name.dnstunnel.de

echo $$ > /var/run/ozymandns.pid

while [[ -e /var/run/ozymandns.pid ]] ; do
    cd /usr/local/bin/
    nomde.pl -i $REPLYIP $DNSHOST >/dev/null 2>&1
done
```
Note: This script again assumes you have installed the nomde.pl server in /usr/local/bin/ as well.

Example Video

I made an example video: DNS Tunneling Example Video (1:30, 20MB)
Documentation

There are a few other documents on the net explaining how DNS tunneling works.
Some of these documents describe how DNS tunneling works with nstx, which is a
different application, but basically also does the same as OzymanDNS.

    * Quick tunneling IP over DNS guide at digitalsec.es
    * NSTX (IP-over-DNS) HOWTO at thomer.com
    * Public Access to TOR via DNS at afs.eecs.harvard.edu
    * PPP over SSH over DNS Howto at ecs.soton.ac.uk
    * Dan Kaminsky's PowerPoint Slides at doxpara.com
    * Counter-measurements against DNS tunneling at daemon.be/maarten

<C2><A9> 2006 Julius Plenz <julius * dnstunnel.de>
$Id: index.html,v 1.1 2006/05/09 21:38:21 feh Exp feh $

http://afs.eecs.harvard.edu/user/goodell/src/ozymandns-0.1-goodell-2.tar.gz

## Ozyman DNS for SSH

[[http://www.doxpara.com|Here]], you will find OzymanDNS. The suite of perl
scripts allows for the transmission of data over DNS, this focuses on SSH over
DNS.


To run the server, you should use a static ip and the you must have the
ability to edit the zone of a domain (or have it done for you).<br>
In the domain's zone, you need to set up an nameserver entry for this to work.

box A 10.0.0.11 ; create box.foo.bar, the nomde host

ozy NS box.foo.bar ; set ozy.foo.bar to the nameserver found at box.foo.bar

ssh A 10.0.0.12 ; create ssh.foo.bar SSH server


Create a user on the nomde machine with sudo abilities for running perl,
without password. Create a key pair for the client, install it to this users
'.ssh/authorized_keys' file.


To use the perl scripts, you will need to build  perl with threads.

On OpenBSD, the process invloves /usr/src since it is still a part of the
system/distrobution. The perl distrobution is found in
'/usr/src/gnu/usr.bin/perl'. You will need to edit the 'Makefile.bsd-wrapper'
file and uncomment the THREADED_PERL line. Once the edit is completed, `cd ..
&& make perl`. When it has compiled, cd to the perl directory and `make test
&& make install`.

On FreeBSD, the process is much easier since perl is in the ports. The newest
version of perl can be found in '/usr/ports/lang/perl5.8'. Make with the
threading by `make -DWITH_THREADS`. After it is compiled, `make test` and
install via `make deinstall && make reinstall`.


Once you have a threaded perl, you will need the required modules for the
scripts. They need to be compiled after threaded perl.

In OpenBSD, you need p5-Net-DNS and p5-LWP-UserAgent-Determined from ports and
MIME/Base32 which must be manually installed.

In FreeBSD, you need p5-Net-DNS from the ports.

we are dumb we dont give the modules to make it a little harder to get it work


Now that you have a static ip, the DNS setup, authentication keys in place,
threaded perl, required modules, and the scripts; (the last four being on both
client and server)  it comes time to implement it.

Due to the domain port (53, udp) being under 1024, you will need to run nomde
under sudo.

% sudo perl nomde.pl -i 127.0.0.1 ozy.foo.bar

Now that the server is running, the client can connect SSH over the DNS tunnel
to the server.

% ssh -C -o ProxyCommand="perl droute.pl sshdns.ozy.foo.bar" box.foo.bar


Sadly, the '-L' argument which should enable multiple subdomains, and thus
servers, does not work. this means the tunnel is limited to 1 SSH server.<br>
With a hack of the nomde script, as per
[http://www.digitalsec.es/stuff/texts/dns-tunnelingv0.2-en.txt this] howto, it
is possible to route the SSH server to other ip addresses. Change line 32 from
having "Localforward" to "Localforward=s".

% sudo perl nomde.pl -L sshdns:10.0.0.12:22 ozy.foo.bar

% ssh -C -o ProxyCommand="perl droute.pl sshdns.ozy.foo.bar" 10.0.0.12

It would be suggested to use a do loop to make sure nomde does not die.
while true
do
sudo perl nomde.pl -L sshdns:10.0.0.12:22 ozy.foo.bar
done



--[[User:EvilMoFo|EvilMoFo]] 05:28, 29 Jun 2005 (PDT)
----
[Dan Kaminsky](http://www.doxpara.com), creator of OzymanDNS

[How-To](http://www.digitalsec.es/stuff/texts/dns-tunnelingv0.2-en.txt) Digital
Security Research

[PPPoSSHoDNS](http://www.ecs.soton.ac.uk/~rtl101/pppsshdns.php), another
How-To, PPP over SSH over DNS

# TOR

##Client Setup Instructions

The following instructions illustrate how to configure a client system to
access Tor using the OzymanDNS proxy running on proxyness.net. The
instructions are designed for *nix systems such as Linux and Mac OS X. While
it is likely that OzymanDNS and this proxy method will work with other
operating systems, specific instructions may vary slightly. Please send all
comments and questions to Geoff Goodell.

Step-1 Download and unpack this slightly-hacked version of OzymanDNS. (It
turns out that we needed to modify OzymanDNS slightly to achieve the desired
behavior: please examine our patch for details. Our package includes the
requisite Perl libraries available from CPAN as well as the requisite SSH
private key that allows access to the Tor client service running on
ns2.proxyness.net.

Step-2 Use OzymanDNS to open an SSH tunnel to ns2.proxyness.net, forwarding
some local port to the Tor client service running on port 9050 of
ns2.proxyness.net. Suppose that the droute.pl OzymanDNS client obtained in
Step 1 and the proxyness.key SSH private key obtained in Step 2 are in your
current working directory. The following command will set up the tunnel,
forwarding port 9050 on your client directly to the Tor client port on
ns2.proxyness.net:

    * ssh -i proxyness.key -o ProxyCommand='./droute.pl
    * sshdns.ozy.proxyness.net' -fCNL 9050:localhost:9050 tor@localhost

If port 9050 is not available on your client, you may forward some other local
port by substituting that port number for the first 9050 in the command above.
However, it is probably wise to use the same SocksPort that Tor normally uses,
since (a) there is little point in running Tor locally and (b) choosing the
same port allows any applications (such as Privoxy) that you previously
configured to use with Tor to continue to function seamlessly. If you choose
this approach, then do not forget to ensure that Tor is not running locally!

Step-3 Now you are ready to use the tunnel endpoint as if it were the SOCKS
proxy provided by the Tor client itself. For example, if your web browser is
configured to use Privoxy as an HTTP proxy and you have already configured
Privoxy according to the instructions for configuring various applications to
use Tor, then you should already be able to browse the web. Similarly, you can
use SSH to connect to arbitrary.host.net by running the following command:

    * ssh -o ProxyCommand='socat STDIO SOCKS4A:localhost:%h:%p,socksport=9050'
    * arbitrary.host.net

REMARKS

1. If you actually have an account on lefkada.eecs.harvard.edu, then you have
the option of skipping Step 3 and logging in directly by using the following
command:

    * ssh -Co ProxyCommand='./droute.pl sshdns.ozy.proxyness.net'
    * ssh.proxyness.net

2. A bug in OzymanDNS occasionally causes the OzymanDNS client to crash. When
this happens, the SSH tunnel established in Step 3 will also crash, along with
any TCP sessions presently traversing the tunnel. To (somewhat) ameliorate
this problem, you may want to wrap a while loop around the command you use in
Step 3.

# Network Key
```
 cat proxyness.key
-----BEGIN RSA PRIVATE KEY-----
MIICWwIBAAKBgQDnAA3XWp4Oq4HYE2B2SvCNY4qOjB0qUVUezykkkhsZNYzyWcYb
RljYFWPLLtDy4e5mjYxVyXdi3U40vUyf0swQfH0tXOGeG4UjYZN7/ZvzEMTbJh37
9Rnx7JoisqJS3cJU0D/a/fUQ2YTP6LTFL0Ne3ErOlcFVwnspWr5JTU41XQIBIwKB
gE8zN/IQcLSSkur/VEXQjP1GsymPH/FAdPSezEcNhaI+PvQBhcA1YEoV9lRKkMhN
dk8L9ZnBasLPiIccVMkVEsMsGwmofx2ZKhCwJAyI2r6xElckyf7alXDTeL6XkgNV
iXmoSOSFwU5Gr/01wTOkMraIWPs5rNBg0pqkbAETHwELAkEA+Wtw5sfg9ODgo8Ed
/99SUb4ZdPfrycNvAEpl3WvFFI9EzFXyJSn30Ketn4Ha4rctA/nP4e0nLqIjVaC4
PP3wWQJBAO0YNZ/8UX0+52a+jsPpSeU77jCDk4MipIOE5kXMrrpiF9kVTlKsn2Vb
1RcUvlhNnXVNd0ucJCQdbaWNOJiLLKUCQHkljpv6rxfa8MSQ//FPNpy7a3NT2Oz4
hl86FDhY6rI29YfR+UVARSrVGdEh0LdDBzxyBeLDpVEqLmtrUixA09MCQQCilEIH
Te68SGQpMjYCrpkSN7lF1pEJdtc1nPWsNJUSF2DPXxEiv4M+MFeazGVD3XNJHy07
KT1al9YoYNZZ+QirAkEAyrdV2KOyZTz8/HfIcFxlt5vbdrNKa33c8aHEU4XXwt1U
btYpTmZ3HruYlwduo44VePh0NxBcbegLggGgeFlFQw==
-----END RSA PRIVATE KEY-----
ozymandns-0.1-goodell-2.tar.gz
```
