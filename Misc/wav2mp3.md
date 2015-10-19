# Converting Wav to Mp3

```
#!/bin/sh

cd /raid/monitor

for wavin in `ls *.wav`;do

mp3out=`echo $wavin |cut -f1 -d.`.mp3
echo "lame -b16 --noshort $wavin $mp3out && mv $mp3out /raid/share/mib/audio"

done
```
