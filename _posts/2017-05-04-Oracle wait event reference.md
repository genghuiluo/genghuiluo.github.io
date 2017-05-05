---
layout: post
title: Oracle wait event reference
date: 2017-05-04 14:20:57 +0800
categories: oracle
---

``` sql
SELECT *
FROM V$EVENT_NAME;
```
[Descriptions of Wait Events](https://docs.oracle.com/cd/B28359_01/server.111/b28320/waitevents003.htm#BGGIBDJI)

``` sql
-- https://github.com/genghuiluo/legacy/blob/master/oracle_dba_scripts/wait_event.sql
SELECT
    s.sid,
    s.serial#,
    sql.sql_text,
    sql.sql_fulltext,
    sw.event AS wait_event
FROM v$session s
JOIN v$sql sql ON s.sql_address = sql.address
JOIN v$session_wait sw ON s.sid = sw.sid;
```

general wait events:

1. [SQL\*Net message from client](http://www.dba-oracle.com/t_sql_net_message_from_client.htm)
	> Generally SQL*Net message from client means Oracle is just waiting on  some work to do.  The SQL*Net message from client means that you have a session connected and Oracle is waiting for a command so it can do something.
2. [SQL\*Net Message to Client](http://www.dba-oracle.com/m_sql_net_message_to_client.htm)
	> The SQL*Net message to client  may indicate a network-related issue that causes clients too long to get data from the database server.  Thus, it can be a TCP issue, but it is not limited to that.
3. [ENQ: KO - FAST OBJECT CHECKPOINT](http://www.dba-oracle.com/t_enq_ko_fast_object_checkpoint.htm)
	> When you run full table scan (or a parallel query full-table scan), you will see direct path reads wait event.  But in the beginning you will also see the enq:  ko - fast object checkpoint wait event. This will checkpoint any blocks that belong to the object you are doing direct path read so that latest change goes into the datafile.
4. [direct path write temp]
5. [free buffer waits](http://www.dba-oracle.com/m_free_buffer_waits.htm)
	``` sql
	-- SGA memory allocation
	select * from v$sgainfo
	```




