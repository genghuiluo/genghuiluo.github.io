---
layout: post
title: play with oracle11g vm
date: 2017-04-14 10:27:41 +0800
categories: oracle
---

http://www.cnblogs.com/mchina/archive/2012/11/27/2782993.html

sqlplus "/ as sysdba"
sqlplus "scott/scott"

startup
shutdown immediate

conn sys@orcl as sysdba


Connect to the database:
sqlplus username/password@database-name

To list all tables owned by the current user, type:
select tablespace_name, table_name from user_tables;

To list all tables in a database:
select tablespace_name, table_name from dba_tables;

To list all tables accessible to the current user, type:
select tablespace_name, table_name from all_tables;

You can find more info about views all_tables, user_tables, and dba_tables in Oracle Documentation. To describe a table, type:
desc <table_name>


http://stackoverflow.com/questions/9862364/how-to-login-to-the-scot-account-after-installing-oracle-11g

I think you have not unlocked your scott user account while installation<Plug>PeepOpenlease follow the steps below to unlock you scott account .

When you started installing oracle ,it asked for global database name and database password that password is used for the sys system sysman dbsnmp account.

SQL> conn user/password;

SQL> conn scott/tiger;
Error message is displayed: the account is locked.

Try to login as "system" - pass

SQL> conn  system/password;
Unlock "scott"

SQL> alter user scott account unlock;
Can change "tiger":

SQL> alter user scott identified by tiger;
SQL> conn scott/tiger; -Success
scott account is locked in 11g due to security thinking,



retrieve the Oracle instance name, you execute the following SQL statement:

SELECT sys_context('USERENV','DB_NAME') AS Instance FROM dual;


Creating a User
CREATE USER books_admin IDENTIFIED BY MyPassword;
GRANT CONNECT TO books_admin;
GRANT CONNECT, RESOURCE, DBA TO books_admin;
GRANT CREATE SESSION GRANT ANY PRIVILEGE TO books_admin;
GRANT UNLIMITED TABLESPACE TO books_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON schema.books TO books_admin;
