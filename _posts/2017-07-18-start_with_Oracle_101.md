---
layout: post
title: start with Oracle 101
date: 2017-07-18 11:40:17 +0800
categories: database
---

## server

[How to setup a oracle instance on CentOS/RHEL?](http://genghuiluo.cn/oracle/2017/05/22/Install-Oracle-11g-R2-on-CentOS7-server.html)


## client

[Oracle Instant Client on Ubuntu](https://help.ubuntu.com/community/Oracle%20Instant%20Client)

1. Download the Oracle Instantclient RPM files from http://www.oracle.com/technetwork/database/features/instant-client/index-097480.html. Everyone needs either "Basic" or "Basic lite", and most users will want "SQL\*Plus" and the "SDK". [Instant Client Downloads for Linux x86-64](http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html)
2. Convert these .rpm files into .deb packages and install using "alien" ("sudo apt-get install alien" if you don't have it).
3. For example, for version 12.1.0.2.0-1 for Linux x86_64 (64-bit):
	``` shell
	alien -i oracle-instantclient12.1-basic-12.1.0.2.0-1.x86_64.rpm
	alien -i oracle-instantclient12.1-sqlplus-12.1.0.2.0-1.x86_64.rpm
	alien -i oracle-instantclient12.1-devel-12.1.0.2.0-1.x86_64.rpm
	```
4. Test your Instantclient install by using "sqlplus" or "sqlplus64" to connect to your database:
	``` shell
	sqlplus username/password@//dbhost:1521/SID
	```

### Oracle SQL Developer

<img src="{{ site.url }}/assets/sqldeveloper_1.jpg" style="width:50%" />

[Use tnsnames.ora in Oracle SQL Developer](http://stackoverflow.com/questions/2019230/use-tnsnames-ora-in-oracle-sql-developer)

[Oracle TNS names not showing when adding new connection to SQL Developer](http://stackoverflow.com/questions/425029/oracle-tns-names-not-showing-when-adding-new-connection-to-sql-developer/425104#425104)

Hit F5 to run the query. That is "run script" in this client. F9 or ctrl-enter get me to the query results grid view. (PL/SQL Developer(windows); F5--excution plan; F8--excute) 

To connect a non-oracle database, add third-party jdbc driver: (Tools -> Preferences)
<img src="{{ site.url }}/assets/sqldeveloper_2.jpg" style="width:50%" />

[More detail about this tool]()

## connection

- [Connecting to Oracle Database](https://docs.oracle.com/cd/B28359_01/win.111/b28375/featConnecting.htm)
- [Local Naming Parameters (tnsnames.ora)](https://docs.oracle.com/cd/B28359_01/network.111/b28317/tnsnames.htm)


## Unlock scott account after installing Oracle 11g
> I think you have not unlocked your scott user account while installation, follow the steps below to unlock you scott account.
http://stackoverflow.com/questions/9862364/how-to-login-to-the-scot-account-after-installing-oracle-11g)

When you started installing oracle ,it asked for global database name and database password that password is used for the `sys system sysman dbsnmp` account.
``` sql
SQL> conn user/password;

SQL> conn scott/tiger;
Error message is displayed: the account is locked.

Try to login as "system" - pass

SQL> conn  system/password;
Unlock "scott"

SQL> alter user scott account unlock;
Can change "tiger":

SQL> alter user scott identified by tiger;
SQL> conn scott/tiger; 
# Success
# scott account is locked in 11g due to security thinking,
```

## sqlplus(sqlplus64), Get Started

``` sql
-- get user env info
SELECT 
    sys_context('USERENV','INSTANCE_NAME') AS instance_nm, 
    sys_context('USERENV','DB_NAME') AS db_nm,
    sys_context('USERENV','SESSION_USER') AS session_user,
    sys_context('USERENV','SID') AS session_id
FROM DUAL;
-- more about sys_context() in http://docs.oracle.com/cd/B19306_01/server.102/b14200/functions165.htm

-- get oracle server version info 
SELECT * FROM v$version;

-- get connection detail
SELECT * FROM v$session_connect_info WHERE sid = sys_context('USERENV','SID');

-- list all schemas/users
SELECT * FROM DBA_USERS;

-- list all tables owned by current login
SELECT * FROM USER_TABLES;
-- list all tables in database
SELECT * FROM DBA_TABLES;

-- describe a table
DESC USER_TABLES;
```
[more about dba sqls](https://github.com/genghuiluo/legacy/blob/master/oracle_dba_scripts.sql)

### DBMS_METADATA
Sequences are not dependent on tables, therefore you need to use 
`select dbms_metadata.get_ddl('SEQUENCE', 'SEQ_NAME') from dual;` to retrieve its ddl.

### Creating a User:
``` sql
CREATE USER books_admin IDENTIFIED BY MyPassword;
GRANT CONNECT TO books_admin;
-- GRANT CONNECT, RESOURCE, DBA TO books_admin;
GRANT CREATE SESSION GRANT ANY PRIVILEGE TO books_admin;
GRANT UNLIMITED TABLESPACE TO books_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON schema.books TO books_admin;
```

