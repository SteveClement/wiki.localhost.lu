# Certificate fingerprint

## How to get the fingerprint and other info for an SSL site certificate

```
openssl x509 -fingerprint < <certificate file>
```

```
openssl x509 -sha1 -fingerprint < <certificate file>
```

```
openssl x509 -fingerprint < groups.aldigital.co.uk.cert
```

# To get lots of information about a cert, but not including the fingerprint

```
openssl s_client -connect <host:port>
```

e.g.
```
openssl s_client -connect beta.richersounds.co.uk:443
```