---
layout: post
title: Get median of non-sorted numbers
date: 2017-06-27 20:52:57 +0800
categories: database
---

### 1) Currently, the best answer in my mind..

```
mysql> select * from median_test;
+------+
| id   |
+------+
|    1 |
|    3 |
|    5 |
|    6 |
|    8 |
|    9 |
|   10 |
|   16 |
|   20 |
+------+
9 rows in set (0.00 sec)

mysql> select t1.id from median_test t1, median_test t2 group by t1.id having abs(sum(sign(t2.id-t1.id)))<=1;
+------+
| id   |
+------+
|    8 |
+------+
1 row in set (0.00 sec)
```

### 2）use ROW_NUMBER(), may not work for some databases, e.g. MYSQL

``` sql
select id from (
    select id,
        row_number() over(order by id asc) as rn1,
        row_number() over(order by id desc) as rn2
    from median_test) t
where abs(rn1 - rn2) <= 1;

```
