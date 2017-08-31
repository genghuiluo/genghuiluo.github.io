---
layout: post
title: find teradata table usage from querylog
date: 2017-02-28 09:50:32 +0800
categories: database
---

> shared by Jeff @clsfd

A self-service for developers to check a Teradata table usage via query log.
Hope it helps downstream analysis, and enable robust cut over changes by notifying all downstream users.

``` sql
-- find all table query usage in previous 180 days for table p_clsfd_t.CLSFD_ECN_METRICS
-- replace the logdate range, database/tablenames
-- the result contains
-- # queryid, procid, logdate as identifies a unique sql statement in Teradata query log
-- # appid, names Teradata SQL client type like Bteq, JDBC tools like Alation, or Tableau
-- # username, account execute the sql, i.e., potential downstream users
-- # scriptname, sql script name, while only applies to query run via standard ETL process flow in VDM/production process (target_table_load.ksh )
create volatile table test_qry
as
(select
a.queryid, a.logdate, a.procid , tablename as tablename,
appid, username, starttime,
queryband,
case when queryband is not null then Getquerybandvalue(queryband, 0, 'scriptname') end as scriptname,
errorcode
from
         (select queryid, logdate, procid, objecttablename  as tablename
         From dw_monitor_views.DBQLOBJTBL_HST
         where objectdatabasename = 'p_clsfd_t' and
         objecttablename in (
         'CLSFD_ECN_METRICS'
          )
         and objecttype = 'tab'
         and logdate>= date -180
         ) test
JOIN
         DW_Monitor_ViewsX.QryLog_Hist a
on
         test.queryid = a.queryid and test.logdate = a.logdate and test.procid = a.procid
where a.logdate >= date - 180
) with data
primary index(queryid, procid, logdate) on commit preserve rows;

-- find batch scripts , PET or Production Bteq
-- script name segment in query band is not empty, implies the query run through standard target_table_load_handler.ksh in batch mode
select
         username, scriptname , max(logdate), min(logdate), SUM(1)qry_cnts, COUNT(distinct logdate) qry_days
From test_qry
where coalesce(trim(scriptname), '')<> ''
Group by 1,2 ;

-- find tableau users
-- appid tells user access client type. special attention to tableau reports as they usually involve more changes
select
         username, appid, max(logdate), min(logdate), SUM(1)qry_cnts, COUNT(distinct logdate) qry_days
From test_qry
where appid like '%Tab%'
Group by 1 ,2 ;

-- find power users by access frequency and times.
-- the access pattern, i.e. client + user name , with stable query count and high
select
         username, appid, max(logdate), min(logdate), SUM(1) qry_cnts, COUNT(distinct logdate) qry_days
From test_qry
Group by 1,2 ;

-- get a user query text for reference
select top 100 qlog.username, qlog.logdate, qlog.appid, qlog.querytext
From  test_qry qry
join DW_Monitor_ViewsX.QryLog_Hist  qlog
on qry.queryid  = qlog.queryid
and qry.procid = qlog.procid
and qry.logdate = qlog.logdate
where qry.username= 'XIAOXHUANG'    and qry.appid = 'TABPROTOSRV'
order by qlog.logdate desc
```
