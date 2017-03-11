---
layout: post
title: passenger+nginx+rails
date: 2017-03-11 19:37:24 +0800
categories: web
---

AWS EC2 box

## Installing Passenger + Nginx
https://www.phusionpassenger.com/library/install/nginx/install/oss/trusty/

``` shell
# Install our PGP key and add HTTPS support for APT
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
sudo apt-get install -y apt-transport-https ca-certificates

# Add our APT repository
sudo sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger xenial main > /etc/apt/sources.list.d/passenger.list'
sudo apt-get update

# Install Passenger + Nginx
sudo apt-get install -y nginx-extras passenger
```

/etc/nginx/nginx.conf

uncomment `# include /etc/nginx/passenger.conf;`

restart `sudo service nginx restart`

chech passenger installation

``` shell
sudo /usr/bin/passenger-config validate-install

sudo /usr/sbin/passenger-memory-stats
```

## Deploy Rails App
https://www.phusionpassenger.com/library/config/nginx/intro.html
https://www.phusionpassenger.com/library/config/nginx/reference/#setting_correct_passenger_ruby_value

``` shell
rails new demo --skip-test-unit

sudo apt install nodejs

# add secret for production
# why .env not work
```

modify /etc/nginx/nginx.conf

``` nginx
http {
    xxxx
    server_names_hash_bucket_size 128;

    # Passenger
    server {
        server_name ec2-35-166-48-64.us-west-2.compute.amazonaws.com;
        root /home/ubuntu/test/demo/public;
        passenger_enabled on;
        passenger_ruby /home/ubuntu/.rvm/gems/ruby-2.4.0/wrappers/ruby;
        passenger_sticky_sessions on;
    }
    xxx
}
```

access_log /var/log/nginx/access.log;
error_log /var/log/nginx/error.log;

