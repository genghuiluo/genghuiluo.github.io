---
layout: post
title: 《收获_不止Oracle》_part1
date: 2017-04-30 15:01:44 +0800
categories: database
---

物理体系

<img src="{{ site.url }}/assets/oracle_study_1.jpg" style="width:80%"/>

1. oracle由database和instance组成
2. instance由一个开辟的内存共享区SGA和一系列后台进程组成,SGA被划分为：
    - shared pool
    - db cache
    - log buffer
3. database由：
    - 数据文件
    - 参数文件
    - 日志文件
    - 控制文件
    - 归档日志文件(最后可能会被转移到新的存储介质，用于备份恢复）
    - 等
4. PGA(program global area)私有不共享的(当前发起用户使用的私有内存空间），用户发起的任何操作都在PGA预处理:
    - 保存用户连接信息
    - 保存用户权限
    - 排序，如果内存足够，在PGA完成，如果放不下，超出的部分就在临时表空间中完成排序

``` sql
SQL> set autotrace on
SP2-0618: Cannot find the Session Identifier.  Check PLUSTRACE role is enabled
SP2-0611: Error enabling STATISTICS report

SQL> @$ORACLE_HOME/sqlplus/admin/plustrce.sql

SQL> grant plustrace to scott;
```

`alter system set <parameter_name>=<value> scope=memory|spfile|both [sid=<sid_name>]` oracle参数配置
- memory,只改边当前实例运行，重启后失效
- spfile,只更改spfile设置，不改变当前实例运行，重启后生效
- both

逻辑体系

<img src="{{ site.url }}/assets/oracle_study_2.jpg" style="width:80%"/>

表空间：
- 系统表空间(system)
- 回滚段表空间(undo)
- 临时表空间
- 用户表空间

block, oracle 最小的逻辑数据单位
extent,oracle 分配空间的最小单位

