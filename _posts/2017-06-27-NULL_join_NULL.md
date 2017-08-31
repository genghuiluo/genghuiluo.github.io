---
layout: post
title: NULL join NULL
date: 2017-06-27 19:12:45 +0800
categories: database
---

> NULL <> NULL ( NULL means unknow ） 

MySQL

``` sql
mysql> select * from cnt_test;
+------+
| id   |
+------+
|    1 |
|    2 |
| NULL |
|    4 |
+------+

mysql> select * from join_null_test;
+------+
| id   |
+------+
|    1 |
| NULL |
+------+
2 rows in set (0.00 sec)


mysql> select * from cnt_test inner join join_null_test on cnt_test.id = join_null_test.id;
+------+------+
| id   | id   |
+------+------+
|    1 |    1 |
+------+------+
1 row in set (0.01 sec)

```

SQL Server

``` sql
use test
go

select * from test1;
select * from test2;

select * from test1 inner join test2 on test1.id = test2.id;
```

![]({{ site.url }}/assets/null_join_null_1.jpg)
