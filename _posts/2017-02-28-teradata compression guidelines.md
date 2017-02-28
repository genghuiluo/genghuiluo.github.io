---
layout: post
title: teradata compression guidelines
date: 2017-02-28 09:46:30 +0800
categories: teradata
---

> shared by Coffing Publishing @eBay

## What is Compression?
Teradata compression is one of several techniques available for storing data efficiently. Compression will reduce the amount of physical storage capacity required for a given amount of logical data by compressing the repeated values. Teradata uses a loss less compression method. This means that although the data is compacted, there is no loss of information.

## Benefits of Compression

- Teradata compression reduces storage cost by storing more logical data per unit of physical capacity.
- Performance is improved because there is less physical data to retrieve during scan-oriented queries.
- Performance is further enhanced since data remains compressed in memory and the Teradata cache can hold more logical rows.
- The compression algorithm used by Teradata is extremely efficient and the savings in compute resources from reducing disk accesses more than compensates for the CPU used for compression.
- Another way to improve performance is to use the space saved by compression for advanced indexes.

## Types of Compression
Compression in Teradata plays a very important role in saving some space and increasing the performance of SQL Query. In Teradata, COMPRESSION can be implemented in three ways:

- a) Single Value or Multi Value Compression (MVC)
- b) Algorithmic Compression (ALC)
- c) Block – Level Compression (BLC)

### a)      Single Value or Multi Value Compression:
This type of compression is widely used in many Teradata Data Warehouse environments.

This is easy to implement and can save good amount of space.

MVC uses a dictionary to maintain value of data and its corresponding bit pattern. So while saving, Teradata replace the exact value with the bit pattern and save it. Hence, occupying much less space. MVC works at column level and should be defined for each column explicitly for which COMPRESSION is required.

To implement this in Teradata, add COMPRESS in table structure along with the column definition to which you want to compress:

`COMPRESS (‘Value1’,'Value2’,'Value3’),`

The problem with MVC is you should know the values which are expected in the columns. Also, a value may be suitable for compression today may not be suitable tomorrow if the data demography of table has changed with time.

### b)      Algorithmic Compression:
This type of compression uses Algorithm to COMPRESS the data while storing and reverse Algorithm to DECOMPRESS the data while displaying.

There are few Algorithms (UDF’s) available in TERADATA 13.10 and user can also add custom Algorithms and use it while creating a new table. Teradata provides the following embedded services functions for compressing and decompressing data. These functions are stored in the TD_SYSFNLIB system database

To implement this in Teradata, add COMPRESS in table structure along with the column definition to which you want to compress:

`COMPRESS USING ALGO_NAME DECOMPRESS USING REV_ALGO_NAME,`

Using ALC is more resource intensive process. Nowadays we have very high configuration server with very good CPU. We can utilize this strength for ALC and save space. ALC operates at the column level.

### c)       Block – Level Compression:
This type of compression is used to compress data at block level or table level and not at column level. The cold data or the data which is not accessed frequently is idle for compression using BLC.

BLC is very resource intensive process and may take some time for compression and decompression. However the space saving which can be achieved using this method is phenomenal.

We can implement Block Level Compression by adding following statements before loading the table which we need to COMPRESS:
```
–Turn BLC ON
SET QUERY_BAND = ‘BLOCKCOMPRESSION=YES;’ FOR SESSION;
```
The granularity of Teradata compression is the individual field of a row. This is the finest level of granularity possible and is superior for query processing, updates, and concurrency. Field compression offers superior performance when compared to row level or block level compression schemes. Row and block level compression schemes require extraneous work to uncompressed row or block whenever they might potentially contribute to a result set.

## Comparison

|                    | Multi-Value Compression (MVC)                             | Algorithmic Compression (ALC)                                                                 | Block Level Compression (BLC) - (TBBLC)                                                                               |
|--------------------|-----------------------------------------------------------|-----------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------|
| Ease of Use        | Easy to apply to well understood data columns and values. | Easy to apply on column with CREATE TABLE.                                                    | Set once and forget.                                                                                                  |
| Analysis Required  | Need to analyze data for common values.                   | Use Teradata algorithms or user-defined compression algorithms to match unique data patterns. | Need to analyze CPU overhead trade-off. You can turn on for all data on system or you can apply on a per table basis. |
| Flexibility        | Works for a wide variety of data and situations.          | Automatically invoked for values not replaced by MVC.                                         | Automatically combined with other compression mechanisms.                                                             |
| Performance Impact | No or minimal CPU usage                                   | Depends on compression algorithm used.                                                        | Reduced I/O due to compressed data blocks. CPU cycles are used to compress/decompress.                                |
| Applicability      | Replaces common values                                    | Industry data, UNICODE, Latin data                                                            | All Data                                                                                                              |

Advantages of Multi-Value Compression

- You can assign multi-value compression to columns that contain the following types of data.
- Nulls, including nulls for distinct and structured non‑LOB UDTs, ARRAY/VARRAY and Period UDT data types
- Zero’s
- Blanks
- Constants having any of the following data types.
- BYTE (up to 510 bytes)
- BYTEINT
- CHARACTER (up to 510 characters)
- DATE (expressed as COMPRESS (DATE ’yyyy-mm-dd’))
- DECIMAL/NUMERIC
- DOUBLE PRECISION
- FLOAT
- GRAPHIC (up to 510 characters)
- INTEGER
- REAL
- SMALLINT
- VARCHAR
- VARGRAPHIC
- Both non‑temporal and temporal UDT columns
- Distinct and structured UDT columns if the UDT does not contain BLOB or CLOB data.
- You can compress columns that are a component of a secondary index, but MultiLoad operations on a table with a secondary index can take longer if the secondary index column set is compressed.
To avoid this problem, drop any compressed secondary indexes before starting the MultiLoad job and then recreate them afterward.
- Adding Compress to any column will by default COMPRESS NULL’s
- Compress values are CASE SPECIFIC, so Compress ‘RAJ’ will not Compress ‘raj’

Limitations of Multi-Value Compression
- You cannot compress more than 255 distinct values for an individual column.
- You cannot change the COMPRESS attribute for a column after it is defined.
- The workaround is to perform an INSERT … SELECT or MERGE into a new table defined with a revised set of compress values.
- You cannot create a table with more bytes compressed than there is room to store them in the table header.
- You cannot compress values in columns that are any of the following.
    - Primary index columns
    - Identity columns
    - Volatile table columns
    - Derived table columns
    - Structured or internal UDT columns. This includes ARRAY, VARRAY, Period, and Geospatial UDT columns and any structured UDT that contains a BLOB or CLOB data type
    - Row‑level security constraint columns
    - Referenced primary key columns
    - Referencing foreign key columns for standard referential integrity relationships

You can compress values in referencing foreign key columns for Batch and Referential Constraint referential integrity relationships.

## Candidates List for Multi-Value Compression
Below columns shall always be compressed and are good candidates for saving space in the system.

- Codes
- Indicators and flags
- Cre_User and Upd_User
- Any common date that is not part of partition, such as any default value (‘9999-12-31’)
- Count or amount column with largely zero’s
- Quantity columns are often compressed at (0, 1)
- Text columns with a limited set of values: like auction format

References

> Teradata Physical Database Design (Refer to chapter 10 for more details on compression)
By: Tera-Tom Coffing; Leah Nolander (Book 4)
