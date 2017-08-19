---
layout: post
title: informatica transformation - joiner
date: 2017-08-19 13:08:13 +0800
categories: etl
---

### 4 Join Types

![]({{ site.url }}/assets/joiner_1.jpg)

![]({{ site.url }}/assets/joiner_2.jpg)

![]({{ site.url }}/assets/joiner_3.jpg)

![]({{ site.url }}/assets/joiner_4.jpg)

Note: The Joiner transformation does not match null values. For example, if both EMP_ID1 and EMP_ID2 contain a row with a null value, the Integration Service does not consider them a match and does not join the two rows. To join rows with null values, replace null input with default values, and then join on the default values.

## How to Tune Performance of Informatica Joiner Transformation? 
Joiner transformation allows you to join two heterogeneous sources in the Informatica mapping. You can use this transformation to perform INNER and OUTER joins between two input streams. 

For performance reasons, I recommend you ONLY use JOINER transformation(compare with db join, I think) if any of the following condition is true, 

1. Data sources are not relational in nature (joining two flat files) 
2. Data sources are heterogeneous in nature (e.g. Flat File and Database) 
3. Data sources are coming from different relational connections 
4. One or more column(s) used in the joining condition(s) of the JOINER is derived in the mapping 

Except the above mentioned conditions, it is better to use database side joins. To know why, please read  

Database performs join faster than Informatica(http://dwbi.org/etl/informatica/155-informatica-join-vs-database-join) 

Although the article in the above link is particular about Oracle database but the conclusion will hold true in case of most of the other databases. 

### Tuning JOINER Transformation 
However, if you have to use the joiner transformation, following are the additional points/actions that you must consider: 

- When joining between two data sources, treat the data source containing less number of records as Master. This is because the Cache size of the Joiner transformation depends on master data (unless sorted input with the same source is used). 
- Ensure that both the master and detail input sources are sorted and both “Sorted Input” and “Master Sort Order” ports are checked and set 
- Consider using cache partitioning for Joiner transformation if you have partition option available under your Informatica license. More details on this topic later 
- Check if the Data and Index cache sizes can be configured. 
 
### Understanding Joiner Cache 

Joiner Transformation needs a space to store the cache for the data and index. This cache can be either memory cache (stored in RAM) or disk cache (stored in hard drive disks) or both depending on various factors which I won’t discuss now. Obviously the memory cache is much faster than the disk cache. So enough system memory should be available to Informatica for faster Join operation. One can actually configure the amount of memory for Joiner data cache and index cache by the following two options under Joiner Transformation Properties: 

1. Joiner Data Cache Size 
2. Joiner Index Cache Size 

If you click on these properties under the “Mapping” tab of the session, you can access “Joiner-Cache Calculator” which is a small tool inbuilt into the PowerCenter Manager for calculating the required amount of cache sizes for the joining operation. You can use the values suggested by this calculator for joiner data and index cache or you can leave them as AUTO. If you do not leave them as Auto and input some values in those boxes, you must ensure that the allocated memory is available while the session executes. Otherwise the session will fail. 

I prefer to leave Joiner Data and Index Cache sizes parameters to Auto and set the maximum values for the auto memory attributes in the session level. To know why, please read on. 

### Partitioning the Joiner cache 

If the session containing the joiner is already partitioned, then one can take the advantage of cache partitioning for the Joiner. As the name suggests, the joiner cache itself gets divided in different partitions in this case. The benefit of this is Informatica accesses the cache in parallel for each partition which is faster than accessing the full cache in serial. 

In order to achieve this cache partition, you need to create a partition point on the Joiner Transformation by choosing the “Add Partition Point” option in Session level under the Mapping::Partitions tab. Then you can edit that partition point to add more than one Hash Auto-key partitions to it. Suppose if you add 4 hash auto key partitions to the Joiner transformation then, by default, Informatica will automatically add 4 Pass-Through partitions in the source qualifier transformations of *both* the master and detail pipelines. 

The benefit of choosing Hash Auto Keys partition in the Joiner transformation is – you need NOT explicitly tell Informatica how to divide the incoming data to individual partitions in Joiner level. You set it to Hash Auto Keys and you forget it, Informatica will take care for the rest. 

However, as soon as you add number of Hash Auto Keys partition to the Joiner level, your source qualifiers also get Pass-Through partitioned. Here you may override the Source Qualifier query and specify individual SQL queries for each partition in the source qualifier transformation level. Supposing your original source side SQL query is like below: 
``` sql
SELECT AccountID, TransactionType, TransactionAmount  
FROM Transactions 
You can override the above query for each partition level like below: 
Partition #1: 
SELECT AccountID, TransactionType, TransactionAmount  
FROM Transactions  
WHERE AccountType = 'SAVINGS' 
Partition #2: 
SELECT AccountID, TransactionType, TransactionAmount  
FROM Transactions  
WHERE AccountType = 'CURRENT' 
Partition #3: 
SELECT AccountID, TransactionType, TransactionAmount  
FROM Transactions  
WHERE AccountType = 'CHECK-IN' 
Partition #4: 
SELECT AccountID, TransactionType, TransactionAmount  
FROM Transactions  
WHERE AccountType = 'DEMAT' 
```
The above method ensures that each of your source qualifier partition is populated with different set of data. 

Alternatively you may also change the partition type in source qualifier level from Pass-Through to “Key range” and specify start and end range of values for each partition. You can also change the partition type to “Database Partitioning” if your source database is Oracle or DB2. 

Another important point to note here is – if you add SORTER transformation before Joiner (which you should always do if your data is not already sorted from source) – then you should also consider creating partition points and adding same number of partitions to the sorter transformation. If the partition type at the sorter level is Hash Auto Key, then you need not add any partition point in the Joiner Transformation level 

Based on whether your joiner data is sorted or not and the cache is partitioned or not, different number of cache(s) will be created by Informatica as shown below: 
 
| | Number of Cache(s) in Disk | Number of Cache(s) in Memory |
| ----- | ----- | ----- |
| Data Sorted | Only one | Equal to number of partitions |
| Data Un-sorted/ Not Partitioned | Only one | Only one |
| Data Un-sorted/ Partitioned | Equal to number of partitions | Equal to number of partitions |

So, this is all about tuning a joiner transformation. 

> http://dwbi.org/etl/informatica/159-tuning-informatica-joiner  
