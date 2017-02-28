---
layout: post
title: teradata notes @clsfd
date: 2017-02-27 11:06:42 +0800
categories: teradata
---
### fastload
``` sql
.BEGIN LOADING clsfd_working.STG_CLSFD_ADJUST_KPI_W ERRORFILES tdlog_tables
.STG_CLSFD_ADJUST_KPI_W_E1, tdlog_tables.STG_CLSFD_ADJUST_KPI_W_E2 CHECKPOINT 0 INDICATORS;
```

> Jeff: Tdlog E1 E2这些fastload自动生成的，如果是数据的原因，有时候会写进去

### fast export
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

### multiload

### TPump(small volume+real time)

### BTEQ

### SQL Assistant

### sys udf

``` sql
syslib.udf_utf8_to16 -- latin to unicode 

case when  syslib.udf_isdecimal(CLSFD_CATEG_REF_ID ) = 1 then CLSFD_CATEG_REF_ID else null end ,
```

### TD bridge
``` sql
/* export from Ares to Mozart 

Download 4 gB file data within 8 minutes with 38K TD Cpu
*/
set query_band = 'dataPath=/user/chewu/ca_ad_counter1/combined.txt;sock_timeout=120;recv_eofresponse=1;childThreadCount=1;hdfsURI=hdfs://ares-nn.vip.ebay.com:8020;sinkClass=HDFSTextFileSink;delimiter=,;' for session;
select bridgeimport.* from parallel_import(
    using  output_cols('
      adid DECIMAL(18,0) ,
      counter_name VARCHAR(50)  ,
      countt DECIMAL(20,0) ,
      site_id DECIMAL(20,0),
      context_id VARCHAR(50)  ,
      event_dt VARCHAR(50)  
    ')
configserver('bridge-gateway-mzt:1025')
configname('mzt_dm_ares') 
) bridgeimport;
```

``` sql
/* import fromTeradata to HDFS

Upload 100GB table in 5 minutes 

*/
set query_band = 'dataPath=/user/chewu/clsfd_ca_box_httpheader/mzarc;sock_timeout=360;recv_eofresponse=1;childThreadCount=1;hdfsURI=hdfs://ares-nn.vip.ebay.com:8020;sinkClass=HDFSTextFileSink;delimiterCharCode=7;' for session;

LOCK ROW FOR ACCESS
SELECT bridgeexport.* FROM parallel_export ( ON
( SELECT * FROM p_clsfd_t.clsfd_ca_box_httpheader     
)
USING configserver('bridge-gateway-mzt:1025')
configname('mzt_dm_ares') --lvs_adm_apollo
) bridgeexport ;
```


- perm
- spool
- temp

> PE=total CPU time/effective CPU time

> TDWM: teradata workload manager
