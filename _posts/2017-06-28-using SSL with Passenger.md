---
layout: post
title: using SSL with Passenger
date: 2017-06-28 11:43:47 +0800
categories: web
---

[What's SSL?](http://info.ssl.com/article.aspx?id=10241)

[Why SSL? The Purpose of using SSL Certificates](https://www.sslshopper.com/why-ssl-the-purpose-of-using-ssl-certificates.html)

[Let's Encrypt](https://letsencrypt.org/) is a non-profit CA run by the Internet Security Research Group (ISRG) to provide automated SSL Certificates. It was launched April 12th, 2016. The CA allows 3-month certificates to be issued using the ACME protocol. They do not issue OV, EV, or Wildcard certificates

[Using SSL with Passenger in Production](https://www.phusionpassenger.com/library/deploy/apache/prod_ssl.html)

We recommend that most people with shell access use the [Certbot](https://certbot.eff.org/) ACME client. It can automate certificate issuance and installation with no downtime. 

``` shell
# https://certbot.eff.org/#centosrhel7-apache
$ sudo yum install python-certbot-apache

$ sudo certbot --apache

## some certbot usages
# view a list of the certificates Certbot
$ sudo certbot certificates
# renew specified domain
$ sudo certbot renew [--cert-name example.com]

# revoke a certificate
$ sudo certbot revoke --cert-path /etc/letsencrypt/live/CERTNAME/cert.pem
# delete a certificate
$ sudo certbot delete --cert-name example.com

# create new certificate
$ sudo certbot --renew-with-new-domains
```
![]({{ site.url }}/assets/ssl_1.jpg)

Certbot can be configured to renew your certificates automatically before they expire. **Since Let's Encrypt certificates last for 90 days**, it's highly advisable to take advantage of this feature. You can test automatic renewal for your certificates by running this command: `certbot renew --dry-run`

If that appears to be working correctly, you can arrange for automatic renewal by adding a cron or systemd job which runs the following: `certbot renew`

we recommend running it *twice per day* (it won't do anything until your certificates are due for renewal or revoked, but running it regularly would give your site a chance of staying online in case a Let's Encrypt-initiated revocation happened for some reason).


A great resource in this regard is the [Mozilla SSL Configuration Generator]() which will provide you with up-to-date web server configurations that either maximize compatibility or security.

for example:
```
    # ssl details
    SSLEngine on
    SSLCertificateFile /etc/letsencrypt/live/xxx/cert.pem
    SSLCertificateKeyFile /etc/letsencrypt/live/xxx/privkey.pem
    SSLCertificateChainFile /etc/letsencrypt/live/xxx/chain.pem
```
[SSL Server Test](https://www.ssllabs.com/ssltest/analyze.html)

### reference:
- [How to Install Let’s Encrypt on Apache2](https://www.upcloud.com/support/install-lets-encrypt-apache/)
- [How To Create an SSL Certificate on Apache for CentOS 7](https://www.digitalocean.com/community/tutorials/how-to-create-an-ssl-certificate-on-apache-for-centos-7)
- [OpenSSL心脏出血漏洞全回顾](http://www.freebuf.com/articles/network/32171.html)
