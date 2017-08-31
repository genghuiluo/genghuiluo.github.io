---
layout: post
title: only SQL to solve max continuous number
date: 2017-05-11 21:32:27 +0800
categories: database
---


MySQL does not provide row_number() like Microsoft SQL Server, Oracle, or PostgreSQL. 

But, you can use session variables to emulate the row_number function(http://www.mysqltutorial.org/mysql-row_number/).

``` sql
mysql> select id from continuous_test;
+----+
| id |
+----+
|  1 |
|  2 |
|  3 |
|  8 |
|  9 |
| 10 |
| 12 |
+----+
7 rows in set (0.00 sec)

SET @row_number = 0; 
SELECT @row_number:=@row_number + 1) AS row_num,
	id,
	id - @row_number AS offset
FROM continuous_test;

+---------+----+--------+
| row_num | id | offset |
+---------+----+--------+
|       1 |  1 |      0 |
|       2 |  2 |      0 |
|       3 |  3 |      0 |
|       4 |  8 |      4 |
|       5 |  9 |      4 |
|       6 | 10 |      4 |
|       7 | 12 |      5 |
+---------+----+--------+


SET @row_number = 0;
 
SELECT GROUP_CONCAT(t.id),
	MAX(t.id),
	COUNT(1)
FROM (SELECT (@row_number:=@row_number + 1) AS row_num,
		id,
		id - @row_number AS offset
	FROM continuous_test) t
GROUP BY t.offset;

+--------------------+-----------+----------+
| GROUP_CONCAT(o.id) | MAX(o.id) | COUNT(1) |
+--------------------+-----------+----------+
| 3,1,2              |         3 |        3 |
| 8,9,10             |        10 |        3 |
| 12                 |        12 |        1 |
+--------------------+-----------+----------+

```

previous case show how to add a seq for each row, we can also add row number for each group

``` sql
# for example, group by customerNumber
SELECT 
    @row_number:=CASE
        WHEN @customer_no = customerNumber THEN @row_number + 1
        ELSE 1
        END AS num,
    @customer_no:=customerNumber as CustomerNumber,
    paymentDate,
    amount
FROM
    payments
ORDER BY  customerNumber;
```
