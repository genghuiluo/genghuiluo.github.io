---
layout: post
title: Install Oracle 11g R2 on CentOS7 server (not desktop)
date: 2017-05-12 12:53:40 +0800
categories: oracle
---

[Oracle 11g R2 Installation Guide](https://docs.oracle.com/cd/E11882_01/install.112/e47689/toc.htm)

#### 1) Hardware requirement:
- at least 1GB RAM
    suggested swap size: if 1~2GB RAM, swap size = 1.5xRAM_size; if 2~16GB RAM, swap size = RAMZ_size; if >16GB RAM, swap size = 16GB
- at least 1GB /tmp
- root permission
- etc...

Add swap: https://www.digitalocean.com/community/tutorials/how-to-add-swap-on-centos-7

Increase size of TMPFS file system: https://ihazem.wordpress.com/2011/03/08/increase-size-of-tmpfs-file-system/

#### 2) Software dependency:

``` shell
sudo yum install -y binutils compat-libstdc++-33 elfutils-libelf elfutils-libelf-devel gcc gcc-c++ glibc glibc-common glibc-devel libaio libaio-devel libgcc libstdc++ libstdc++-devel make numactl sysstat libXp unixODBC unixODBC-devel

```
**pdksh** (not in most yum repository), my sharing [download @yun.baidu.com]()

#### 3) user & group

``` shell
# create group
groupadd oinstall
groupadd dba
groupadd oper

# create oracle user
useradd -g oinstall -G dba,oper oracle; #default group: oinstall，available groups: dba/oper
passwd oracle # set password
```

#### 4) modify kernel parameter

`sudo vi /etc/sysctl.conf`, append below, then `sysctl -p` to enable change 

```
fs.file-max = 6815744
fs.aio_max_nr=1048576
kernel.shmall = 2097152
kernel.shmmax = 2147483648
kernel.shmmni = 4096
kernel.sem = 250 32000 100 128
net.ipv4.ip_local_port_range = 9000 65500
net.core.rmem_default = 262144
net.core.rmem_max = 4194304
net.core.wmem_default = 262144
net.core.wmem_max = 1048576
```

#### 5) modify system resource limit

`sudo vi /etc/security/limits.conf`, append below

```
oracle soft nproc 2047
oracle hard nproc 16384
oracle soft nofile 1024
oracle hard nofile 65536
oracle soft stack 10240
```

#### 6) upload linux.x64_11gR2_database_xxx.zip and create folder for installtation

``` shell
# Install 
mkdir /opt/oracle
chown oracle:oinstall /opt/oracle
chmod 755 /opt/oracle
# Inventory
mkdir /opt/oraInventory
chown oracle:oinstall /opt/oraInventory
chmod 755 /opt/oraInventory
# unzip & make it r+w+x by user 'oralce'  
chmod -R 700 /home/oralce/database
chown -R oracle:oinstall /home/oracle/database
```

#### 7) set up environment variable

``` shell
# e.g. /home/oracle/.bash_profile
ORACLE_BASE=/opt/oracle;
ORACLE_HOME=$ORACLE_BASE/11g;
ORACLE_SID=orcl; # instance name 
LD_LIBRARY_PATH=$ORACLE_HOME/lib;
PATH=$PATH:$ORACLE_HOME/bin:$HOME/bin;
export ORACLE_BASE ORACLE_HOME ORACLE_SID LD_LIBRARY_PATH PATH;
```

#### 8) install with `runInstaller`

Since it's on server editon of linux( no X window ), so I need to use `slient mode` with **responsive file**.

You can use `/home/oracle/database/response/db_install.rsp` as a example.

``` shell
# first time, don't add -ignorePrereq option
[oracle@aliyun database]$ ./runInstaller -silent -responseFile ~/db_install.rsp

# check Error in log
[oracle@aliyun ~]$ grep Error /data/db/oraInventory/logs/installActions2017-05-07_10-21-27PM.log
INFO: Error Message:PRVF-7532 : Package "libaio-0.3.105 (i386)" is missing on node "aliyun"
INFO: Error Message:PRVF-7532 : Package "glibc-2.3.4-2.41 (i686)" is missing on node "aliyun"
INFO: Error Message:PRVF-7532 : Package "compat-libstdc++-33-3.2.3 (i386)" is missing on node "aliyun"
INFO: Error Message:PRVF-7532 : Package "libaio-devel-0.3.105 (i386)" is missing on node "aliyun"
INFO: Error Message:PRVF-7532 : Package "libgcc-3.4.6 (i386)" is missing on node "aliyun"
INFO: Error Message:PRVF-7532 : Package "libstdc++-3.4.6 (i386)" is missing on node "aliyun"
INFO: Error Message:PRVF-7532 : Package "unixODBC-2.2.11 (i386)" is missing on node "aliyun"
INFO: Error Message:PRVF-7532 : Package "unixODBC-devel-2.2.11 (i386)" is missing on node "aliyun"

# ensure your result is similiar to mine, then you can add -ignorePrereq option and re-run again
# Why this error message exists?
# 32 bit packages on CentOS are based on i686 architecture, while oracle require i386. But it's OK..
# 由于CentOS的32bit程序包都是i686的，而oracle要求i386，所以此处会失败

[oracle@aliyun database]$ ./runInstaller -silent -ignorePrereq -responseFile ~/db_install.rsp
```

> ref: http://www.cnblogs.com/mophee/archive/2013/06/01/3107137.html
