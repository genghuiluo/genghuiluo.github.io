---
layout: post
title: setup wordpress on own box
date: 2017-02-23 17:19:22 +0800
categories: linux
---
> How to set up a wordpress on a linux box(e.g. ubuntu) ASAP?

1. install LAMP, download binary wordpress to /var/www/html(default)


    ```
    wget http://wordpress.org/latest.tar.gz 
    sudo apt-get install apache2 apache2-doc apache2-utils 
    sudo chown -R www-data:www-data wordpress 
    sudo apt-get install php5 libapache2-mod-php5 php5-mcrypt php5-mysql
    sudo vi /etc/php5/apache2/php.ini # enable extension=msql.so 
    sudo apt-get install mysql-server
    ```

2. login into mysql as root, create wp db&user

    
    ```
    CREATE DATABASE wp_db; 
    CREATE USER wp_user@localhost IDENTIFIED BY 'password'; 
    GRANT ALL PRIVILEGES ON wp_db.* TO wp_user@localhost; 
    FLUSH PRIVILEGES;
    ```

3. enable apache&mysql service


    ```
    sudo service apache2 restart 
    sudo service mysql restart
    ```

> How to migrate wordpress to another host?

1. dump mysql database and back up wordpress folder

    `mysqldump -u wp_user -p wp_db > wp_dump.sql`

2. compress&package wordpress&dump_sql_file to target host, set up LAMP ready

3. import dump sql into mysql on new host


    ```
    #create user&db first
    CREATE DATABASE wp_db; 
    CREATE USER wp_user@localhost IDENTIFIED BY 'password'; 
    GRANT ALL PRIVILEGES ON wp_db.* TO wp_user@localhost; 
    FLUSH PRIVILEGES;
                    
    >mysql -u wp_user -p wp_db < wp_dump.sql
    ```

4. put wordpress under you apache document root folder and try it in your browser.

5. update site url in mysql database


    ```
    UPDATE wp_options SET option_value='http://ecg-analytics-618762.lvs01.eaz.ebayc3.com/analytics-hub' WHERE option_name='home'; 
    UPDATE wp_options SET option_value='http://ecg-analytics-618762.lvs01.eaz.ebayc3.com/analytics-hub' WHERE option_name='siteurl';
    ```

