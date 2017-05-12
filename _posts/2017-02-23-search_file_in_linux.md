---
layout: post
title: compare different ways of searching file in linux
date: 2017-02-23 17:19:22 +0800
categories: linux
---

### 1) whereis filename

character: quick, fuzzy search

e.g.  
```
> whereis mysql
mysql: /usr/bin/mysql /usr/lib/mysql /etc/mysql /usr/include/mysql /usr/share/mysql /usr/share/man/man1/mysql.1.gz
```

### 2) find / -name filename

character: accurate, cost resource

e.g. `find / -name php.ini`

> find details:

most common usage: `find / -name my* -print`

search with timestamp:
1. file was accessed in 3 minutes: `find /usr -amin 3 –print`
2. file was modified in 5 days:`find /usr -ctime 5 -print`
3. file was owned by jacky and file name start with `j`(case-sensitive):`find /doc -user jacky -name 'j*' –print`
4. filename start with `ja` or `ma`: `find /doc \( -name 'ja*' -o- -name 'ma*' \) –print`
5. delete file whose filename end with `bak`: `find /doc -name '*bak' -exec rm {} \;`

### 3) locate filename 
character: the fastest, recommended

> rely on a database, so you might require to update it when your use locate

### 4) slocate

slocate提供了一种安全的方法为系统的文件建立索引,同时用户可以通过slocate快速搜索到系统中的文件.它使用了与locate类似的增量 编码方法来压缩它的数据库，极大提高了它的搜索速度，它同时包含了文件的许可权和所有关系，使得用户看不到他们无权访问的文件

slocate提供两个功能：

1. 创建文件索引数据库。它会定时或者手工刷新索引数据库。
2. 在数据库中搜索指定文件。存在索引数据库，因此它的检索速度非常快，能够满足对所有文件系统快速检索文件的需要。

slocate的常用参数：

- -u    从根目录开始建立索引数据库（会花费一定时间，依赖于用户系统性能和需建立索引的文件数量）
- -U dir    从指定的目录dir建立索引数据库
- -e dirlist    排除指定的目录列表，以逗号分隔
- -f filesystemlist 排除指定的文件系统列表，以逗号分隔
　　

示例：
```　　
slocate -e /usr,/etc -u       #从根目录创建索引,但排除/usr,/etc目录
slocate mysql
```

#### more
分页显示一个文件或任何输出结果.其实more不是用来寻找文件的，但是一般人却十有八九是在找文件时把它派上用场。例子：
```
> ls /etc |more
> more /etc/X11/XF86Config
```

#### less(这个命令目前只在 Linux 系统可以使用，其他 UNIX 家族尚无)
less与more相似，它的优点就是可以随时回头，最简单的用【PgUp】键就可以向上翻。
```
shell>ls /etc |less
shell>less /etc/X11/XF86Config
```


