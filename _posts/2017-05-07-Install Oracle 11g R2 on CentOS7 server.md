---
layout: post
title: Install Oracle 11g R2 on CentOS7 server
date: 2017-05-07 22:48:34 +0800
categories: oracle
---



http://www.cnblogs.com/mophee/archive/2013/06/01/3107137.html

ADD SWAP:
https://www.digitalocean.com/community/tutorials/how-to-add-swap-on-centos-7

INCREASE SIZE OF TMPFS FILE SYSTEM:
https://ihazem.wordpress.com/2011/03/08/increase-size-of-tmpfs-file-system/




```
[oracle@aliyun database]$ ./runInstaller -silent -responseFile ~/db_install.rsp

[oracle@aliyun ~]$ grep Error /data/db/oraInventory/logs/installActions2017-05-07_10-21-27PM.log
INFO: Error Message:PRVF-7543 : OS Kernel parameter "semmni" does not have proper value on node "aliyun" [Expected = "128" ; Found = "0"].
INFO: Error Message:PRVF-7532 : Package "libaio-0.3.105 (i386)" is missing on node "aliyun"
INFO: Error Message:PRVF-7532 : Package "glibc-2.3.4-2.41 (i686)" is missing on node "aliyun"
INFO: Error Message:PRVF-7532 : Package "compat-libstdc++-33-3.2.3 (i386)" is missing on node "aliyun"
INFO: Error Message:PRVF-7532 : Package "libaio-devel-0.3.105 (i386)" is missing on node "aliyun"
INFO: Error Message:PRVF-7532 : Package "libgcc-3.4.6 (i386)" is missing on node "aliyun"
INFO: Error Message:PRVF-7532 : Package "libstdc++-3.4.6 (i386)" is missing on node "aliyun"
INFO: Error Message:PRVF-7532 : Package "unixODBC-2.2.11 (i386)" is missing on node "aliyun"
INFO: Error Message:PRVF-7532 : Package "unixODBC-devel-2.2.11 (i386)" is missing on node "aliyun"

[oracle@aliyun database]$ ./runInstaller -silent -ignorePrereq -responseFile ~/db_install.rsp
```
