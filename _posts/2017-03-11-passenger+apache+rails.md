---
layout: post
title: passenger+apache+rails
date: 2017-03-11 20:04:37 +0800
categories: web
---

aliyun ECS centos7

https://www.digitalocean.com/community/tutorials/how-to-setup-a-rails-4-app-with-apache-and-passenger-on-centos-6

``` shell
gem install passenger 
passenger-install-apache2-module  

# /etc/httpd/conf.d/passenger.conf
LoadModule passenger_module /xxx/.rvm/gems/ruby-2.4.0/gems/passenger-5.1.2/buildout/apache2/mod_passenger.so
<IfModule mod_passenger.c>
    PassengerRoot /xxx/.rvm/gems/ruby-2.4.0/gems/passenger-5.1.2
    PassengerDefaultRuby /xxx/.rvm/gems/ruby-2.4.0/wrappers/ruby
</IfModule>

service httpd restart 
```

Virtual Host
``` apache
RackEnv development

<VirtualHost *:80> 
    ServerName www.yourhost.com 
    
    # !!! Be sure to point DocumentRoot to 'public'! 
    DocumentRoot /var/www/html/helloapp/public 
    
    <Directory /var/www/html/helloapp/public> 
        # This relaxes Apache security settings. 
        AllowOverride all 
        # MultiViews must be turned off. 
        Options -MultiViews 
    </Directory> 
</VirtualHost>
```


