---
layout: post
title: start with PL/SQL 101
date: 2017-07-27 16:47:49 +0800
categories: oracle
---

### %TYPE, %ROWTYPE
``` sql
-- %TYPE is used to declare a field with the same type as 
-- that of a specified table's column: 
 
 DECLARE
    v_EmpName  emp.ename%TYPE;
BEGIN
    SELECT ename INTO v_EmpName FROM emp WHERE ROWNUM = 1;
    DBMS_OUTPUT.PUT_LINE('Name = ' || v_EmpName);
END;
            
-- %ROWTYPE is used to declare a record with the same types as 
-- found in the specified database table, view or cursor: 
              
DECLARE
    v_emp emp%ROWTYPE;
BEGIN
    v_emp.empno := 10;
    v_emp.ename := 'XXXXXXX';
END;
```

### SQL%ROWCOUNT
> To find out how many rows are affected by DML statements, you can check the value of SQL%ROWCOUNT

### [Defining TABLE Types](https://docs.oracle.com/cd/A57673_01/DOC/server/doc/PLS23/ch4.htm)
To create PL/SQL tables, you take two steps. First, you define a TABLE type, then declare PL/SQL tables of that type. You can define TABLE types in the declarative part of any block, subprogram, or package using the syntax
``` sql
TYPE table_type_name IS TABLE OF datatype [NOT NULL]
   INDEX BY BINARY_INTEGER;
```
where table_type_name is a type specifier used in subsequent declarations of PL/SQL tables.

*The INDEX BY clause must specify datatype BINARY_INTEGER*, if the element type is a record type, every field in the record must have a scalar datatype such as CHAR, DATE, or NUMBER.

> PLS_INTEGER and BINARY_INTEGER Data Types
- The PL/SQL data types PLS_INTEGER and BINARY_INTEGER are identical. For simplicity, this document uses PLS_INTEGER to mean both PLS_INTEGER and BINARY_INTEGER.
- The PLS_INTEGER data type stores signed integers in the range -2,147,483,648 through 2,147,483,647, represented in 32 bits.
- The PLS_INTEGER data type has these advantages over the NUMBER data type and NUMBER subtypes:
- PLS_INTEGER values require less storage.
- PLS_INTEGER operations use hardware arithmetic, so they are faster than NUMBER operations, which use library arithmetic.
*For efficiency, use PLS_INTEGER values for all calculations in its range*

### BULK COLLECT
[I can use BULK COLLECT as follows:](http://www.oracle.com/technetwork/issue-archive/2008/08-mar/o28plsql-095155.html)
``` sql
PROCEDURE process_all_rows
IS
    TYPE employees_aat 
    IS TABLE OF employees%ROWTYPE
    INDEX BY PLS_INTEGER;
    l_employees employees_aat;
BEGIN
    SELECT *
    BULK COLLECT INTO l_employees
    FROM employees;
                                 
    FOR indx IN 1 .. l_employees.COUNT 
    LOOP
        analyze_compensation 
        (l_employees(indx));
    END LOOP;
END process_all_rows;
```

### [Retrieving the Error Code and Error Message: SQLCODE and SQLERRM](https://docs.oracle.com/cd/B19306_01/appdev.102/b14261/errors.htm#CJAJBAJG)
In an exception handler, you can use the built-in functions SQLCODE and SQLERRM to find out which error occurred and to get the associated error message.
``` sql
-- Example 10-11 Displaying SQLCODE and SQLERRM

CREATE TABLE errors (code NUMBER, message VARCHAR2(64), happened TIMESTAMP);
DECLARE
    name employees.last_name%TYPE;
    v_code NUMBER;
    v_errm VARCHAR2(64);
BEGIN
    SELECT last_name INTO name FROM employees WHERE employee_id = -1;
EXCEPTION
    WHEN OTHERS THEN
        v_code := SQLCODE;
        v_errm := SUBSTR(SQLERRM, 1 , 64);
    DBMS_OUTPUT.PUT_LINE('Error code ' || v_code || ': ' || v_errm);
    -- Normally we would call another procedure, declared with PRAGMA
    -- AUTONOMOUS_TRANSACTION, to insert information about errors.
    INSERT INTO errors VALUES (v_code, v_errm, SYSTIMESTAMP);
END;
```

### DUAL
The DUAL table is a special one-row, one-column table present by default in Oracle and other database installations. In Oracle, the table has a single VARCHAR2(1) column called DUMMY that has a value of 'X'. It is suitable for use in selecting a pseudo column such as SYSDATE or USER.

Oracle's SQL syntax requires the FROM clause but some queries don't require any tables - DUAL can be readily used in these cases.
``` sql
SELECT 1+1 from dual;
```

### [spool](https://docs.oracle.com/cd/E12825_01/epm.111/esb_techref/frameset.htm?maxl_commands_spool.htm)

### DDL没有特殊需求最好不要加双引号:
``` sql
CREATE SEQUENCE  "inv_suitbility_dm"."SEQ_ETL_JOB_BATCH"  MINVALUE 1 MAXVALUE 9999999;
-- this ddl will generate under a lowercase schema name "inv_suitbility_dm"

CREATE SEQUENCE  inv_suitbility_dm.SEQ_ETL_JOB_BATCH  MINVALUE 1 MAXVALUE 9999999;
```

### NUM TO INTERVAL
``` sql
-- https://docs.oracle.com/cd/B19306_01/server.102/b14200/functions104.htm
SELECT SYSDATE - NUMTOYMINTERVAL('1','YEAR') FROM DUAL;
-- https://docs.oracle.com/cd/B19306_01/server.102/b14200/functions103.htm
SELECT SYSDATE - NUMTODSINTERVAL('1','DAY') FROM DUAL;
```

### [TRUNC (date)](https://docs.oracle.com/cd/B19306_01/server.102/b14200/functions201.htm) & [TRUNC (number)](https://docs.oracle.com/cd/B19306_01/server.102/b14200/functions200.htm)

### [GREATEST](https://docs.oracle.com/cd/B19306_01/server.102/b14200/functions060.htm) & [LEAST](https://docs.oracle.com/cd/B19306_01/server.102/b14200/functions075.htm)

[more dba SQL ...](https://github.com/genghuiluo/legacy/blob/master/oracle_dba_scripts.sql)
> v\_$ views are the actual views, v$views are public synonyms of those views. query the dba\_objects tables to see this.

### [DIRECTORY]

``` sql
CREATE [OR REPLACE] DIRECTORY directory AS 'pathname';

GRANT READ[,WRITE] ON DIRECTORY directory TO username;

SELECT directory_path FROM dba_directories WHERE directory_name =upper('invdir');
```

### 同义词 

```
CREATE SYNONYM  fn_drop_if_exist FOR sp_drop_if_exist;
```