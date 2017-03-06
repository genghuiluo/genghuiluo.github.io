---
layout: post
title: sqlite3 sample usage
date: 2017-03-06 18:44:57 +0800
categories: database
---
[SQLite](https://www.sqlite.org/) is a software library that implements a *self-contained, serverless, zero-configuration, transactiona* SQL database engine
```
> sqlite3
SQLite version 3.11.0 2016-02-15 17:29:24
Enter ".help" for usage hints.
Connected to a transient in-memory database.
Use ".open FILENAME" to reopen on a persistent database.
sqlite> .help
.backup ?DB? FILE      Backup DB (default "main") to FILE
...
```

## common cmd usage

### 1. bakcup&restore
```
sqlite> create table test_table (id integer,name string);
sqlite> .backup './test.db'
sqlite> .exit

> ll
-rw-r--r-- 1 ghluo ghluo 2.0K 6月  23 21:41 test.db

sqlite> .restore './test.db'  /* or .open './test.db' */
sqlite> .tables /* show tables */
test_table
sqlite> .schema test_table /* desc table */
```

### 2. dump ddl
```
sqlite> .output './test.ddl'  /* can use it to redirect query output,too */
sqlite> .dump test_%
sqlite> .exit

> cat test.ddl 
PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE test_table (id integer,name string);
COMMIT;
```

### 3. attach specified database (main/temp are reserved for the primary database)
```
sqlite> attach database './test.db' as mydb;
sqlite> .databases
seq  name             file                                                      
---  ---------------  ----------------------------------------------------------
0    main                                                                       
2    mydb             /home/ghluo/project/test/sqlite/./test.db
```

### 4. index
```
/* can only create on <main> db */
sqlite> .open ./test.db
sqlite> .database
seq  name             file                                                      
---  ---------------  ----------------------------------------------------------
0    main             /home/ghluo/project/test/sqlite/./test.db                 
sqlite> create index test_index on test_table(id);
sqlite> .indices test_table
test_index
sqlite> .schema test_%
CREATE TABLE test_table (id integer,name string);
CREATE INDEX test_index on test_table(id);
```

### 5. import a file
```
sqlite> select * from test_table;
sqlite> .separator ","
sqlite> .import raw.csv test_table
sqlite> select * from test_table;
1,abc
2,mark
3,eric
```

### 6. format output
```
sqlite> .header on
sqlite> .mode column
sqlite> .width 10
sqlite> select * from test_table;
id          name      
----------  ----------
1           abc       
2           mark      
3           eric 
```
> format output configuration can be written into ~/.sqliterc, which will automatically load when you try `sqlite3`
