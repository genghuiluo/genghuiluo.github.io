---
layout: post
title: teradata notes @clsfd
date: 2017-03-04 18:31:27 +0800
categories: teradata
---
## fastload
``` sql
.BEGIN LOADING clsfd_working.STG_CLSFD_ADJUST_KPI_W ERRORFILES tdlog_tables
.STG_CLSFD_ADJUST_KPI_W_E1, tdlog_tables.STG_CLSFD_ADJUST_KPI_W_E2 CHECKPOINT 0 INDICATORS;
```

> Jeff: Tdlog E1 E2这些fastload自动生成的，如果是数据的原因，有时候会写进去

## fast export
``` sql
LOGON mydbs/myid, mypwd
CREATE TABLE Employer_Location (EmpNo INTEGER, Location CHAR(5));
INSERT INTO Employer_Location VALUES(1, 'LA');
INSERT INTO Employer_Location VALUES(2, 'NYC');
INSERT INTO Employer_Location VALUES(3, 'ATL');
.SET TITLEDASHES OFF
.EXPORT REPORT FILE=myfile1.exp
SELECT EmpNo (TITLE ''), Location (TITLE '') FROM Employer_Location;
.EXPORT RESET
.SET TITLEDASHES ON
.EXPORT REPORT FILE=myfile2.exp
SELECT EmpNo, Location FROM Employer_Location;
.EXPORT RESET
.LOGOFF
.EXIT
```

## multiload

## TPump(small volume+real time)

## BTEQ

## SQL Assistant (TDSA setup)
![]({{ site.url }}/assets/teradata_notes_clsfd_tdsa_1.png)

![]({{ site.url }}/assets/teradata_notes_clsfd_tdsa_2.png)

![]({{ site.url }}/assets/teradata_notes_clsfd_tdsa_3.png)

![]({{ site.url }}/assets/teradata_notes_clsfd_tdsa_4.png)


### sys udf

``` sql
syslib.udf_utf8_to16 -- latin to unicode 

case when  syslib.udf_isdecimal(CLSFD_CATEG_REF_ID ) = 1 then CLSFD_CATEG_REF_ID else null end ,
```

## TD bridge
[set query_band](http://www.info.teradata.com/htmlpubs/DB_TTU_14_00/index.html#page/SQL_Reference/B035_1144_111A/End_Logging-Syntax.027.143.html) to utlize ["bridge @ebay"]({{ site.url }}/teradata/2017/03/04/teradata-hadoop-bridge-intro.html).


- perm
- spool
- temp

> PE=total CPU time/effective CPU time

> TDWM: teradata workload manager
