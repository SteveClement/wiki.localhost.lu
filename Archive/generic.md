# Very generic unix tips

## Generate random alpha/numeric string

```
 openssl rand 13 |xxd -ps
```

**openssl** will generate 13 bytes of stuff then **xxd** will dump it into a human readable form
