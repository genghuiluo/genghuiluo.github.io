---
layout: post
title: sqlite3 sample usage
date: 2017-05-12 10:53:53 +0800
categories: database
---
[SQLite](https://www.sqlite.org/) is a software library that implements a *self-contained, serverless, zero-configuration, transactiona* SQL database engine
``` sql
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
``` sql
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
``` sql
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
``` sql
sqlite> attach database './test.db' as mydb;
sqlite> .databases
seq  name             file                                                      
---  ---------------  ----------------------------------------------------------
0    main                                                                       
2    mydb             /home/ghluo/project/test/sqlite/./test.db
```

### 4. index
``` sql
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
``` sql
sqlite> select * from test_table;
sqlite> .separator ","
sqlite> .import raw.csv test_table
sqlite> select * from test_table;
1,abc
2,mark
3,eric
```

### 6. format output
``` sql
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
> format output configuration can be written into [~/.sqliterc](https://github.com/genghuiluo/legacy/blob/master/.sqliterc), which will automatically load when you try `sqlite3`

### 7. create trigger
syntax:
``` sql
CREATE [TEMP | TEMPORARY] TRIGGER trigger-name
[BEFORE | AFTER] database-event ON [database-name .]table-name
trigger-action

trigger-action is further defined as: 

[FOR EACH ROW | FOR EACH STATEMENT] [WHEN expression]
BEGIN
trigger-step; [trigger-step;] *
END
```
parameter:

| Name | Description |
|---------------|----------------|
| trigger-name                    | The name of the trigger. A trigger  must be distinct from the name of any other trigger for the same table. The name cannot be schema-qualified — the trigger inherits the schema of its table.       |
| BEFORE AFTERINSTEAD OF          | Determines whether the function is called before, after, or instead of the event. A constraint trigger can only be specified as AFTER.                                                                |
| database-event                  | One of the INSERT, UPDATE, DELETE that will fire the trigger.                                                                                                                                         |
| table-name                      | The name of the table or view the trigger is for.                                                                                                                                                     |
| FOR EACH ROW FOR EACH STATEMENT | Specifies whether the trigger procedure should be fired once for every row affected by the trigger event, or just once per SQL statement. If neither is specified, FOR EACH STATEMENT is the default. |
| expression                      | A Boolean expression that determines whether the trigger function will actually be executed.                                                                                                          |
| trigger-step                    | Action for the trigger, it is the sql statement.                                                                                                                                                      |

sample
``` sql
CREATE TRIGGER aft_insert AFTER INSERT ON emp_details  
BEGIN  
INSERT INTO emp_log(emp_id,salary,edittime)  
    VALUES(NEW.employee_id,NEW.salary,current_date);  
END;
```

### more in [SQL as understood by SQLite](https://www.sqlite.org/lang.html)

