---
layout: post
title: open source ETL tool - kettle
date: 2017-07-12 10:52:48 +0800
categories: ETL
---


kettle is a open source ETL tool which coded by Java, (support Windows & Unix/Linux)

Currently kettle was acquired by [Pentaho and named as PDI(pentaho data intergration)](http://community.pentaho.com/projects/data-integration/), there are both **community(free)** and **enterprise version**.

To install kettle, [http://wiki.pentaho.com/display/EAI/01.+Installing+Kettle](http://wiki.pentaho.com/display/EAI/01.+Installing+Kettle)

### kettle's components

`data-integration` directory hierarchy looks like:

<img src="{{ site.url }}/assets/kettle_1.jpg" style="width:40%"/>

I have highlighted 4 main components of kettle in the screenshot above, there are two executable files (.bat / .sh, run on Windows / Unix-like) for each one.

- [spoon, the GUI client of kettle](http://wiki.pentaho.com/display/EAI/Spoon+User+Guide)
- [pan, a program that can execute transformations designed in Spoon when stored as a XML(KTR file) or in a repository](http://wiki.pentaho.com/display/EAI/Pan+User+Documentation)
- [kitchen, a program that can execute jobs designed by Spoon in XML(KJB file) or in a database repository](http://wiki.pentaho.com/display/EAI/Kitchen+User+Documentation)
- [carte,  a simple web server that allows you to execute transformations and jobs remotely](http://wiki.pentaho.com/display/EAI/Carte+User+Documentation)

#### 1) Spoon

After you run `./spoon.sh`,

<img src="{{ site.url }}/assets/kettle_2.jpg" style="width:100%"/>

the first thing you should do, **create a repository**, kettle currently support 3 kinds of repository:

1. pentaho repository( enterprise cloud )
2. database repository
3. file repository ( .ktr & .kjb )

My suggestion is database repo, you can find [details for any kind of repository here.](https://help.pentaho.com/Documentation/7.0/0L0/0Y0/040)

After you create a repo, connect in Spoon by admin/admin (default password: admin).

<img src="{{ site.url }}/assets/kettle_3.jpg" style="width:50%"/>

To open a transformation/job from repo, 'Tools' -> 'Repository' -> 'Explore...' ( Ctrl + E )

<img src="{{ site.url }}/assets/kettle_5.jpg" style="width:50%"/>

#### 2) Pan

- Run a transformation from file
	``` shell
	# This example runs a transformation from file on a windows platform:
	pan.bat /file:"D:\Transformations\Customer Dimension.ktr" /level:Basic
	
	# This example runs a transformation from file on a Linux box:
	pan.sh -file="/PRD/Customer Dimension.ktr" -level=Minimal
	```
- Run a transformation from Repository
	``` shell
	# This example runs a transformation from the repository on a windows platform: (Enter on a single line without returns...)
	pan.bat /rep:"Production Repository"
            /trans:"update Customer Dimension"
            /dir:/Dimensions/
            /user:matt
            /pass:somepassword123
            /level:Basic
	```

#### 3) Kitchen

- Run a job from file
	``` shell
	# This example runs a job from file on a windows platform: 
	kitchen.bat /file:D:\Jobs\updateWarehouse.kjb /level:Basic
	
	# This example runs a job from file on a Linux box:
	kitchen.sh -file=/PRD/updateWarehouse.kjb -level=Minimal
	```
- Run a job from Repository
	``` shell
	# This example runs a job from the repository on a windows platform:
	kitchen.bat
	                    /rep:"Production Repository"
	                    /job:"Update dimensions"
	                    /dir:/Dimensions
	                    /user:matt
	                    /pass:somepassword123
	                    /level:Basic
	```
	
#### 4) Carte

enable carte on your remote host:
``` shell
carte.sh 127.0.0.1 8081
```

add new slave server in Spoon:

<img src="{{ site.url }}/assets/kettle_6.jpg" style="width:80%"/>

run options: select the slave sever that you create

<img src="{{ site.url }}/assets/kettle_7.jpg" style="width:50%"/>

view execution result  @ <your_ip>:<your_port> (e.g. http://127.0.0.1:8081)

> Go in deeper, [Execute Scheduled Jobs on a Remote Carte Server](https://help.pentaho.com/Documentation/5.2/0P0/0U0/050/050)

### Questions I met

#### 1) How add jdbc driver of different databases into kettle?

Use MySQL as an example, if you try to add a MySQL database connection without a mysql jdbc driver, you will meet this kind of error message:
```
Error connecting to database [Local MySQL DB] : org.pentaho.di.core.exception.KettleDatabaseException: Error occured while trying to connect to the database
Exception while loading class org.gjt.mm.mysql.Driver
```

Solution: 
1. Download the [Latest MySQL JDBC Driver](https://dev.mysql.com/downloads/connector/j/)
2. Unzip the zip file (in my case it was mysql-connector-java-5.1.31.zip)
3. copy the .jar file (mysql-connector-java-5.1.31-bin.jar) and paste it in your Lib folder( data-integration/lib )
4. Restart Pentaho (Data Integration) and re-test the MySQL Connection.

#### 2) tables in a database repo created by kettle
kettle will create several tables in your specified database for a database repository,

<img src="{{ site.url }}/assets/kettle_4.jpg" style="width:30%"/>

#### 3) share repository meta data between different clients

just copy `$HOME/.kettle/repositories.xml` to different host's same location

> Notice: you may need to change the ip in `<server></server>`.

#### 4) DB Procedure Call Error

1. Can't find procedure with 'Find it...' button
    You can just type the procedure name. It's a kettle's bug as we all know.
2. [PLS-00222: no function with name 'PROC_XXX' exists in this scope](http://forums.pentaho.com/showthread.php?56746-Db-Procedure-Call-Error&s=6aa5d0c9f9f14f3b2faf90e0fb6eb76e)

    The mistake i had done was i had left **the Result name populated** thus the component presumed the call was for a function. 
    Once i had removed the value from this field the procedure worked.

    <img src="{{ site.url }}/assets/kettle_8.jpg" style="width:40%"/>

#### 5) table output contain preserved word, insert failed
e.g. insert into an Oracle table
<img src="{{ site.url }}/assets/kettle_9.jpg" style="width:100%"/>
you need to configure the oracle connection like this: 
<img src="{{ site.url }}/assets/kettle_10.jpg" style="width:50%"/>


> currently, I am planing to create a ETL automation tool with kettle, feel free to star [this repo on github](https://github.com/genghuiluo/trans-builder).
