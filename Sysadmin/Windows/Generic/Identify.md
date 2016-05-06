# Check Motherboard Model Number on Microsoft Windows

Src: http://www.howtogeek.com/208420/how-to-check-your-motherboard-model-number-on-your-windows-pc/

On a cmd prompt type the following.

```
wmic baseboard get product,Manufacturer,version,serialnumber
```
