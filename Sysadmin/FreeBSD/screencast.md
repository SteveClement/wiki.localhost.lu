# Introduction

This outlines the installation of a VNCServer on Unix and the subsequent
recording of such a session

## Install Ports

```
portinstall \
 net/x11vnc \
 net/vnc2swf \
 net/vnc \
 x11-wm/blackbox
```

## Install vncrec

```
 cd ~/work
 wget http://www.sodan.org/~penny/vncrec/vncrec-0.2.tar.gz
 tar xfvz vncrec-0.2.tar.gz
 cd vncrec-0.2
 xmkmf -a
 cd libvncauth; make
 cd ../vncrec; make
 as root: make install
 # /usr/bin/install -c -s  vncrec /usr/X11R6/bin/vncrec
 # So make sure /usr/X11R6/bin is in your $PATH
```

# Start VNCServer

Launch it:
```
 vncserver -geometry 800x600
```

Kill it:
```
 vncserver -kill :1
```


Tweak ~/.vnc/xstartup

don't forget to vncserver -kill :1 when you change xstartup


= Record a session via vncrec =

```
 vncrec -record test.vnc
```


A new window opens asking you the IP address e.g:

 mymachine:1

enter the password

and Voilà you are recording your session now.

to play back:

```
 vncrec -play test.vnc
```


# Record a session via vnc2swf

With vnc2swf we have 2 options:

* Capture an entire screen
* Capture only a particular X-Window (e.g. xterm or mrxvt)


Capturing the entire screen:

```
 vnc2swf -shared -nostatus myfilename.swf :1 > myfilename.html
```

this will create a file called: myfilename.swf and an HTML document called myfilename.html


This will capture EVERYTHING that happens in the 800x600 VNC Server

Once ready press F9 to start recording. (or add -startrecording to record immediately)


# Misc. Notes


 multimedia/istanbul
 Nativ X option: sysutils/xvidcap
 
 optional:
 pyvnc2swf

``` 
 x11vnc -localhost -viewonly -wait 10 defer 10 &
 python ~/pyvnc2swf-$ver/vnc2swf.py -o tutor.swf -N -S 'arecorde -c 2 -f cd -t wav voice.wav' localhost:0
 ffmpeg -i voice.wav -ar 22050 voice.mp3
 python ~/pyvnc2swf-$ver/edit.py -o tutor1.swf -a voice.mp3 tutor.swf
 my tutor1.swf tutor.swf
 rm voice.wav voice.mp3
 rm tutor.html
```

WWW: http://cyberelk.net/tim/rfbproxy/


# Transcoding the Captured Stream

The VNC stream can be played back using vncrec's -play option, but this
doesn't allow cueing to specific locations. So we instead use transcode, a
video-to-video conversion tool and which provides a vncrec import plug-in, to
convert it to a seek-able video format.

The following invocation of transcode uses the Xvid.org codec:

```
$ transcode -x vnc -y xvid -i file.vnc -o file.avi -z -k
```

You may need to use transcodes' --dvd_access_delay switch: this provides a
time-out to wait for vncrec, which can sometimes take a while to start up. I've
generally just used `30' for 30 seconds.

There is one small problem when transcoding on a machine with a different
video depth (number of bits per pixel) from that which was used for recording.
This is possibly because vncrec records the screen capture using the video
mode of the capturing machine. Fortunately Xvnc can be used to set up an X
server with the same depth as the original as follows:

mode of the capturing machine. Fortunately Xvnc can be used to set up an X
server with the same depth as the original as follows:

```
$ Xvnc :1 -once -depth 16 -geometry 1600x1200 &
$ DISPLAY=:1 transcode -i vnc ...
```

Remember to kill the Xvnc server afterwards.

Be warned that the transcoding can take a while, especially when you have big
videos. You can try to reduce this by using a lower frame-rate with transcodes'
-fps switch.

http://www.cs.ubc.ca/~bsd/vncrecording.html

http://linuxgazette.net/102/washko.html