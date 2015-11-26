```
cat /usr/local/etc/ports.conf ; pkg info |grep portconf
echo "editors/vim: WITHOUT_X11" >> /usr/local/etc/ports.conf
echo "devel/t1lib: WITHOUT_X11" >> /usr/local/etc/ports.conf
echo "graphics/php5-gd: WITHOUT_X11" >> /usr/local/etc/ports.conf
echo "x11-toolkits/pango: WITHOUT_X11" >> /usr/local/etc/ports.conf
echo "databases/rrdtool: WITHOUT_DEJAVU" >> /usr/local/etc/ports.conf

pkg info |grep xorg-lib
pkg delete pango\* t1lib-\* php5-gd-\* pecl-pdflib-\* xorg-\* imake-\* gtk-\* vim-\* xterm-\* ;  portinstall editors/vim devel/t1lib print/pecl-pdflib graphics/php5-gd x11-toolkits/pango

```

# Pango Blockers

```
munin-master-2.0.7
nfdump-1.6.6_2
nfsen-1.3.5_3
rrdtool-1.4.7_2 (remove DejaVu fonts)
```

```
pkg delete xorg-\* imake-\* gtk-\* xterm-\*
for a in `pkg info |grep X |awk '{ print $1 }' `; do  pkg delete $a; done

pkg delete \
printproto-\* \
renderproto-\* \
bigreqsproto-\* \
inputproto-\* \
kbproto-\* \
xcb-proto-\* \
xtrans-\* \
libxcb-\* \
expect-\* \
libwmf-\* \
tk-\* \
cairo-\* \
xf86-\* \
xf86driproto-\* \
xkeyboard-\* \
encodings-\* \
xbacklight-\* \
appres-\* \
bdftopcf-\* \
beforelight-\* \
bitmap-\* \
bitstream-vera-\* \
dmxproto-\* \
editres-\* \
evieext-\* \
fontconfig-\* \
fslsfonts-\* \
fstobdf-\* \
glproto-\* \
iceauth-\* \
libGL-\* \
libGLU-\* \
libICE-\* \
libSM-\* \
libX11-\* \
libXScrnSaver-\* \
libXTrap-\* \
libXau-\* \
libXaw-\* \
libXcomposite-\* \
libXcursor-\* \
libXdamage-\* \
libXdmcp-\* \
libXevie-\* \
libXext-\* \
libXfixes-\* \
libXfont-\* \
libXfontcache-\* \
libXft-\* \
libXi-\* \
libXinerama-\* \
libXmu-\* \
libXp-\* \
libXpm-\* \
libXprintAppUtil-\* \
libXprintUtil-\* \
libXrandr-\* \
libXrender-\* \
libXres-\* \
libXt-\* \
libXtst-\* \
libXv-\* \
libXvMC-\* \
libXxf86dga-\* \
libXxf86misc-\* \
libXxf86vm-\* \
libdmx-\* \
libksba-\* \
liboldX-\* \
libxkbfile-\* \
libxkbui-\* \
listres-\* \
mkfontdir-\* \
mkfontscale-\* \
oclock-\* \
scripts-\* \
sessreg-\* \
setxkbmap-\* \
showfont-\* \
smproxy-\* \
trapproto-\* \
twm-\* \
viewres-\* \
x11perf-\* \
xauth-\* \
xbiff-\* \
xbitmaps-\* \
xcalc-\* \
xclipboard-\* \
xclock-\* \
xcmiscproto-\* \
xcmsdb-\* \
xconsole-\* \
xcursorgen-\* \
xdbedizzy-\* \
xditview-\* \
xdm-\* \
xdpyinfo-\* \
xdriinfo-\* \
xedit-\* \
xev-\* \
xextproto-\* \
xeyes-\* \
xf86bigfontproto-\* \
xf86dga-\* \
xf86dgaproto-\* \
xf86miscproto-\* \
xf86vidmodeproto-\* \
xfd-\* \
xfindproxy-\* \
xfontsel-\* \
xfs-\* \
xfsinfo-\* \
xfwp-\* \
xgamma-\* \
xgc-\* \
xhost-\* \
xineramaproto-\* \
xinit-\* \
xkbcomp-\* \
xkbevd-\* \
xkbprint-\* \
xkbutils-\* \
xkill-\* \
xload-\* \
xlogo-\* \
xlsfonts-\* \
xmag-\* \
xman-\* \
xmessage-\* \
xmh-\* \
xmodmap-\* \
xmore-\* \
xphelloworld-\* \
xplsprinters-\* \
xpr-\* \
xprehashprinterlist-\* \
xprop-\* \
xproto-\* \
xproxymanagementprotocol-\* \
xrandr-\* \
xrdb-\* \
xrefresh-\* \
xrx-\* \
xset-\* \
xsetmode-\* \
xsetpointer-\* \
xsetroot-\* \
xsm-\* \
xstdcmap-\* \
xtrans-\* \
xtrap-\* \
xvidtune-\* \
xvinfo-\* \
xwd-\* \
xwininfo-\* \
xwud-\* \
xlsatoms-\* \
xlsclients-\* \
ico-\* \
libFS-\* \
libX11-\* \
libxcb-\* \
luit-\* \
mkcomposecache-\* \
rgb-\* \
rstart-\* \
dirmngr-\* \
gnupg-\* \
fonttosfnt-\* \
libfontenc-\* \
makedepend-\* \
compositeproto-\* \
inputproto-\* \
renderproto-\* \
bigreqsproto-\* \
damageproto-\* \
fixesproto-\* \
fontcacheproto-\* \
fontsproto-\* \
kbproto-\* \
printproto-\* \
randrproto-\* \
resourceproto-\* \
recordproto-\* \
scrnsaverproto-\* \
videoproto-\* \
font-\*
```


# Temp

```
pkg delete libX11-1.6.2,1 libX\* libGL\* freeglut\* libxcb\* xorg-macros\* xf86\* xproto-\* xtrans-\* libICE\* libSM\* makedepend\* libxslt-1.1.28_1 libxml2-2.8.0_3 textproc/xmlto textproc/libxslt textproc/py-libxml2 xcb-proto-\* xcmiscproto-\* xextproto-\* kbproto-1.0.6 damageproto-1.2.1 dri2proto-2.8 bigreqsproto-1.1.2 fixesproto-5.0 fontconfig-2.11.0_1 freetype2-2.5.3 glproto-1.4.17 inputproto-2.3 libgd-2.1.0_1,1 analog-6.0_9,1 mrtg-2.17.4_4,1 fwanalog-0.6.9_5 x11-fonts/fontconfig libdrm-2.4.17_1 randrproto-1.4.0 renderproto-0.11.1
```