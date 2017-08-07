---
layout: post
title: drive space report
date: 2017-02-23 17:19:22 +0800
categories: sqlserver
---
For the drive space control report, you may have already identified these system resources and functions, but if not, these might simplify the process:

``` sql
SELECT DISTINCT
    @@SERVERNAME as [server]
    , volume_mount_point as drive
    , cast(total_bytes / 1024.0 / 1024.0 / 1024.0 AS INT) as total_gb
    , cast(available_bytes/ 1024.0 / 1024.0 / 1024.0 AS INT) as free_gb
FROM 
    sys.master_files AS f
    CROSS APPLY sys.dm_os_volume_stats(f.database_id, f.file_id)
ORDER BY
    @@SERVERNAME
    , volume_mount_point
```

| server     | drive | total_gb | free_gb |
|------------|-------|----------|---------|
| HQMRKSQL01 | C:\   | 136      | 76      |
| HQMRKSQL01 | F:\   | 273      | 173     |
| HQMRKSQL01 | G:\   | 1640     | 514     |
| HQMRKSQL01 | H:\   | 1640     | 495     |
| HQMRKSQL01 | J:\   | 499      | 232     |
| HQMRKSQL01 | K:\   | 499      | 303     |

> sys.dm_os_volume_stats missing?

It is available in SQL 2008 R2 with SP1 or later. http://msdn.microsoft.com/en-us/library/hh223223(SQL.105).aspx

And this script will combine drive space and database file-level space information at the drive level：
;

``` sql
WITH CTE_DRIVE_SIZE AS (
    SELECT DISTINCT
        @@SERVERNAME as [server]
        , left(volume_mount_point, 1) as drive
        , cast(total_bytes / 1024.0 / 1024.0 / 1024.0 AS INT) as total_gb
        , cast(available_bytes/ 1024.0 / 1024.0 / 1024.0 AS INT) as free_gb
    FROM 
        sys.master_files AS f
        CROSS APPLY sys.dm_os_volume_stats(f.database_id, f.file_id) -- It is available in SQL 2008 R2 with SP1 or later. http://msdn.microsoft.com/en-us/library/hh223223(SQL.105).aspx
)
, CTE_FILE_SIZE AS (
SELECT
    @@SERVERNAME as [server]
    , DB_NAME(database_id) as db
    , type_desc
    , name as db_file_name
    , physical_name
    , LEFT(physical_name, 1) as drive
    , isnull(nullif(size / 128, 0), 1) as size_mg
    , isnull(nullif(max_size / 128, 0), 1) as max_size_mg
    , case when is_percent_growth = 0 then isnull(nullif(growth / 128, 0), 1) else 0 end AS growth_mb
    , isnull(nullif(size / (128 * 1024), 0), 1) as size_gb
    , isnull(nullif(max_size / (128 * 1024), 0), 1) as max_size_gb
    , case when is_percent_growth = 0 then isnull(nullif(growth / (128 * 1024), 0), 1) else 0 end AS growth_gb
    , case when is_percent_growth = 1 then growth else 0 end AS growth_pctg
FROM 
    sys.master_files
)
SELECT  DISTINCT
    d.server
    , d.drive
    , d.total_gb
    , d.free_gb
    , f.db
    , f.type_desc
    , f.db_file_name
    , f.size_gb
    , f.max_size_gb
    , f.max_size_gb - f.size_gb as available_gb
FROM
    CTE_DRIVE_SIZE d
    JOIN CTE_FILE_SIZE f
    ON d.server = f.server
    AND d.drive = f.drive
ORDER BY
    d.server
    , d.drive
    , f.db
    , f.type_desc desc
```

> Thanks to Sunny Lin
