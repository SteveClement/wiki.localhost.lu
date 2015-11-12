# flv streaming

High performance flv-streaming with lighttpd is possible since lighttpd 1.4.11.

With lighty you can easily handle 10000 parallel downloads of your movies including protection against hot-linking with mod_secdownload. This is basicly all you need to build the free video.google.com for yourself.

Just add this you your lighttpd.conf and restart the server:

server.modules = ( ..., "mod_flv_streaming", ... )

flv-streaming.extensions = ( ".flv" )

Players

mod_flv_streaming expects you to fetch the flv-file with a GET parameter if you want to do a seek into the file.

GET /movie.flv?start=23 HTTP/1.1
Host: ...

    * Fabian Topfstedt has done this for us. Get his player and place it in the webfolder. To use the player you have include this piece of HTML:

```
        <object
          classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
          codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,19,0"
          width="336"
          height="297">
          <param name="movie" value="scrubber.swf?file=/movie.flv" />
          <param name="quality" value="high" />
          <embed src="scrubber.swf?file=/movie.flv"
            quality="high"
            pluginspage="http://www.macromedia.com/go/getflashplayer"
           type="application/x-shockwave-flash"
            width="336"
            height="297"></embed>
        </object>
```

    * for the RMP you can use a simple rewrite to get it working with mod_flv_streaming

```
      url.rewrite = ( 
        "^/name-of-php-script.php\?file=(.+)&position=0$" => "/$1",
        "^/name-of-php-script.php\?file=(.+)&position=([0-9]+)$" => "/$1?start=$2",
      )
```

encoding flash movies

As example I took a video from Ryan Wiebers page about Saber-Effects.

The .mov file was converted into a .flv with the help of ffmpeg and indexed with flvtool2.

```
$ wget http://ryanw.michaelfrisk.com/ryan-w/clips/kid_fight.mov
$ ffmpeg -i kid_fight.mov kid_fight.flv
$ flvtool2 -U kid_fight.flv
```
