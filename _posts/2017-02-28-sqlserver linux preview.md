---
layout: post
title: sqlserver linux preview
date: 2017-02-23 17:19:22 +0800
categories: sqlserver
---
[Install SQL Server on Ubuntu](https://docs.microsoft.com/zh-cn/sql/linux/sql-server-linux-setup-ubuntu)

> mssql-tools : Depends: msodbcsql (>= 13.0.0.0) but it is not going to be installed
depend on [Microsoft ODBC Driver for SQL Server] https://msdn.microsoft.com/zh-cn/library/hh568454(v=sql.110).aspx

[Install SQL Server tools on Linux](https://docs.microsoft.com/zh-cn/sql/linux/sql-server-linux-setup-tools#ubuntu)

login as SA: `sqlcmd -S localhost -U SA -P 'Your Password'`

![]({{ site.url }}/assets/sqlserver_1.jpg)

dbcc checkdb

![]({{ site.url }}/assets/sqlserver_2.jpg)

dbcc sqlperf(logspace)

![]({{ site.url }}/assets/sqlserver_3.jpg)

dbcc opentran

![]({{ site.url }}/assets/sqlserver_4.jpg)

sysfiles

![]({{ site.url }}/assets/sqlserver_5.jpg)

if you install ms sql on your PC, next time when you try to login into as SA,
```
Sqlcmd: Error: Microsoft ODBC Driver 13 for SQL Server : Login timeout expired.
Sqlcmd: Error: Microsoft ODBC Driver 13 for SQL Server : TCP Provider: Error code 0x2749.
Sqlcmd: Error: Microsoft ODBC Driver 13 for SQL Server : A network-related or instance-specific error has occurred while establishing a connection to SQL Server. Server is not found or not accessible. Check if instance name is correct and if SQL Server is configured to allow remote connections. For more information see SQL Server Books Online..
```
SQL service is not running.
```
systemctl status mssql-server
● mssql-server.service - Microsoft(R) SQL Server(R) Database Engine
    Loaded: loaded (/lib/systemd/system/mssql-server.service; disabled; vendor pr
    Active: inactive (dead)
```
Manually, start service with `sudo systemctl start mssql-server`

Or configure this service auto-start
