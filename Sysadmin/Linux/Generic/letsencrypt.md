# Letsencrypt with elasticsearch

```
sudo apt install certbot
sudo certbot certonly --standalone -d my.example.org
sudo mkdir /etc/elasticsearch/ssl
sudo cp -pr /etc/letsencrypt/archive/my.example.org /etc/elasticsearch/ssl/
sudo chmod 750 /etc/elasticsearch/ssl/my.example.org
sudo chmod 640 /etc/elasticsearch/ssl/my.example.org/*
sudo chown -R root:elasticsearch /etc/elasticsearch/ssl/my.example.org
sudo mkdir /etc/kibana/ssl
sudo cp -pr /etc/letsencrypt/archive/my.example.org /etc/kibana/ssl/
sudo chmod 750 /etc/kibana/ssl/my.example.org
sudo chmod 640 /etc/kibana/ssl/my.example.org/*
sudo chown -R root:kibana /etc/kibana/ssl/my.example.org

cd /etc/kibana/ssl/my.example.org
sudo openssl pkcs12 -export -in fullchain1.pem -inkey privkey1.pem -out cert.p12
cd /etc/elasticsearch/ssl/my.example.org
sudo openssl pkcs12 -export -in fullchain1.pem -inkey privkey1.pem -out cert.p12
# Either password protect or empty
bin/elasticsearch-keystore add xpack.security.http.ssl.keystore.secure_password
bin/elasticsearch-keystore add xpack.security.http.ssl.truststore.secure_password
bin/elasticsearch-keystore add xpack.security.transport.ssl.keystore.secure_password
bin/elasticsearch-keystore add xpack.security.transport.ssl.truststore.secure_password
sudo apt install openjdk-17-jre-headless
# Enable security features
xpack.security.enabled: true

xpack.security.http.ssl:
  enabled: true
  certificate: certs/fullchain.pem <!--- Lets Encrypt
  key: certs/privkey.pem

# Enable encryption and mutual authentication between cluster nodes
xpack.security.transport.ssl:
  enabled: true
  verification_mode: certificate
  keystore.path: certs/transport.p12 <!- Self Signed
  truststore.path: certs/transport.p12
```
