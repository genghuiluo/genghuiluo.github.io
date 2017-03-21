---
layout: post
title: count(*),count(1),count(id)
date: 2017-03-21 10:15:22 +0800
categories: sql
---

``` mysql
mysql> create table cnt_test (id  tinyint);
Query OK, 0 rows affected (0.04 sec)

mysql> insert cnt_test values (1),(2),(NULL),(4);
Query OK, 4 rows affected (0.00 sec)
Records: 4  Duplicates: 0  Warnings: 0

mysql> select * from cnt_test;
+------+
| id   |
+------+
|    1 |
|    2 |
| NULL |
|    4 |
+------+
4 rows in set (0.00 sec)

mysql> select count(*) from cnt_test;
+----------+
| count(*) |
+----------+
|        4 |
+----------+
1 row in set (0.00 sec)

mysql> select count(id) from cnt_test;
+-----------+
| count(id) |
+-----------+
|         3 |
+-----------+
1 row in set (0.00 sec)

mysql> select count(1) from cnt_test;
+----------+
| count(1) |
+----------+
|        4 |
+----------+
1 row in set (0.00 sec)
```
