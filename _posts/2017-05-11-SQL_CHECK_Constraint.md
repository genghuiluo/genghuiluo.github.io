---
layout: post
title: SQL CHECK Constraint
date: 2017-05-11 21:32:19 +0800
categories: magic_sql
---

> https://www.w3schools.com/sql/sql_check.asp

The CHECK constraint is used to limit the value range that can be placed in a column.

If you define a CHECK constraint on a single column it allows only certain values for this column.

If you define a CHECK constraint on a table it can limit the values in certain columns based on values in other columns in the row.

## SQL CHECK on CREATE TABLE

MySQL:
``` sql
CREATE TABLE Persons (
    ID int NOT NULL,
    LastName varchar(255) NOT NULL,
    FirstName varchar(255),
    Age int,
    CHECK (Age>=18)
);
```

SQL Server / Oracle / MS Access:
``` sql
CREATE TABLE Persons (
    ID int NOT NULL,
    LastName varchar(255) NOT NULL,
    FirstName varchar(255),
    Age int CHECK (Age>=18)
);
```

To allow naming of a CHECK constraint, and for defining a CHECK constraint on multiple columns:

MySQL / SQL Server / Oracle / MS Access:
``` sql
CREATE TABLE Persons (
    ID int NOT NULL,
    LastName varchar(255) NOT NULL,
    FirstName varchar(255),
    Age int,
    City varchar(255),
    CONSTRAINT CHK_Person CHECK (Age>=18 AND City='Sandnes')
);
```

## SQL CHECK on ALTER TABLE

MySQL / SQL Server / Oracle / MS Access:
``` sql
ALTER TABLE Persons
ADD CHECK (Age>=18);

ALTER TABLE Persons
ADD CONSTRAINT CHK_PersonAge CHECK (Age>=18 AND City='Sandnes');
```

## DROP a CHECK Constraint

SQL Server / Oracle / MS Access:
``` sql
ALTER TABLE Persons
DROP CONSTRAINT CHK_PersonAge;
```

MySQL:
``` sql
ALTER TABLE Persons
DROP CHECK CHK_PersonAge;
```
