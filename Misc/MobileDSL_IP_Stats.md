In a 45 minute time frame you get 27 unique IP addresses when constantly cycling the connection

```
 steve@steve-laptop:~/Desktop/MobDSL$ cat index.html* |cut -f 1 -d "<" |grep -v Date |sort |uniq -c
     * 1 Remote IP: 212.66.64.104
     * 2 Remote IP: 212.66.64.11
     * 1 Remote IP: 212.66.64.158
     * 1 Remote IP: 212.66.64.180
     * 1 Remote IP: 212.66.64.28
     * 1 Remote IP: 212.66.65.107
     * 1 Remote IP: 212.66.65.173
     * 1 Remote IP: 212.66.65.250
     * 1 Remote IP: 212.66.65.44
     * 1 Remote IP: 212.66.65.91
     * 3 Remote IP: 212.66.66.41
     * 2 Remote IP: 212.66.67.77
     * 1 Remote IP: 212.66.80.13
     * 1 Remote IP: 212.66.80.87
     * 1 Remote IP: 212.66.81.109
     * 1 Remote IP: 212.66.81.182
     * 1 Remote IP: 212.66.81.37
     * 1 Remote IP: 212.66.82.136
     * 1 Remote IP: 212.66.83.20
     * 1 Remote IP: 212.66.83.204
     * 1 Remote IP: 212.66.83.93
     * 1 Remote IP: 212.66.84.204
     * 1 Remote IP: 212.66.85.165
     * 1 Remote IP: 212.66.86.111
     * 5 Remote IP: 212.66.86.212
     * 1 Remote IP: 212.66.86.252
     * 1 Remote IP: 212.66.87.129
```
