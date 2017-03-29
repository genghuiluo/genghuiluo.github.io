---
layout: post
title: using SSL with Passenger
date: 2017-03-29 22:18:22 +0800
categories: web
---

https://www.phusionpassenger.com/library/deploy/apache/prod_ssl.html

We recommend that most people with shell access use the Certbot ACME client. It can automate certificate issuance and installation with no downtime. 

https://certbot.eff.org/#centosrhel7-apache

![]({{ site.url }}/assets/ssl_1.jpg)

```
    # ssl details
    SSLEngine on
    SSLCertificateFile /etc/letsencrypt/live/xxx/cert.pem
    SSLCertificateKeyFile /etc/letsencrypt/live/xxx/privkey.pem
    SSLCertificateChainFile /etc/letsencrypt/live/xxx/chain.pem
```

[How to Install Let’s Encrypt on Apache2](https://www.upcloud.com/support/install-lets-encrypt-apache/)

[How To Create an SSL Certificate on Apache for CentOS 7](https://www.digitalocean.com/community/tutorials/how-to-create-an-ssl-certificate-on-apache-for-centos-7)
