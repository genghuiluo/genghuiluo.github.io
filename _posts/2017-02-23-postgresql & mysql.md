---
layout: post
title: postgresql & mysql
date: 2017-02-23 17:19:22 +0800
categories: database
---
[转载知乎](http://www.zhihu.com/question/20010554/answer/62628256)

## PostgreSQL 与 MySQL 相比，优势何在?

### Pg没有MySQL的各种坑

MySQL 的各种 text 字段有不同的限制, 要手动区分 small text, middle text, large text... Pg 没有这个限制, text 能支持各种大小.

按照 SQL 标准, 做 null 判断不能用 = null, 只能用 is null

```
the result of any arithmetic comparison with NULL is also NULL
```

但 pg 可以设置 transform_null_equals 把 = null 翻译成 is null 避免踩坑

不少人应该遇到过 MySQL 里需要 utf8mb4 才能显示 emoji 的坑, Pg 就没这个坑.

*MySQL 的事务隔离级别 repeatable read 并不能阻止常见的并发更新, 得加锁才可以, 但悲观锁会影响性能, 手动实现乐观锁又复杂. 而 Pg 的列里有隐藏的乐观锁 version 字段, 默认的 repeatable read 级别就能保证并发更新的正确性, 并且又有乐观锁的性能. 附带一个各数据库对隔离级别的行为差异比较调查: http://www.cs.umb.edu/~poneil/iso.pdf*

> Really? 行锁防止别的事务修改或删除，GAP锁防止别的事务新增，行锁和GAP锁结合形成的的Next-Key锁共同解决了RR级别在写数据时的幻读问题(Innodb)

MySQL 不支持多个表从同一个序列中取 id, 而 Pg 可以.

MySQL 不支持 OVER 子句, 而 Pg 支持. OVER 子句能简单的解决 "每组取 top 5" 的这类问题.

几乎任何数据库的子查询 (subquery) 性能都比 MySQL 好.

[更多的坑](http://blog.ionelmc.ro/2014/12/28/terrible-choices-mysql/)

不少人踩完坑了, 以为换个数据库还得踩一次, 所以很抗拒, 事实上不是!!!

### Pg 不仅仅是 SQL 数据库

它可以存储 array 和 json, 可以在 array 和 json 上建索引, 甚至还能用表达式索引. 为了实现文档数据库的功能, 设计了 jsonb 的存储结构. 有人会说为什么不用 Mongodb 的 BSON 呢? Pg 的开发团队曾经考虑过, 但是他们看到 BSON 把 ["a", "b", "c"] 存成 {0: "a", 1: "b", 2: "c"} 的时候就决定要重新做一个 jsonb 了... 现在 jsonb 的性能已经优于 BSON.

现在往前端偏移的开发环境里, 用 Pg + PostgREST 直接生成后端 API 是非常快速高效的办法:
[begriffs/postgrest · GitHub](https://github.com/begriffs/postgrest)
postgREST 的性能非常强悍, 一个原因就是 Pg 可以直接组织返回 json 的结果.

它支持服务器端脚本: TCL, Python, R, Perl, Ruby, MRuby ... 自带 map-reduce 了.

它有地理信息处理扩展 (GIS 扩展不仅限于真实世界, 游戏里的地形什么的也可以), 可以用 Pg 搭寻路服务器和地图服务器:
[PostGIS — Spatial and Geographic Objects for PostgreSQL](http://postgis.net/)

它自带全文搜索功能 (不用费劲再装一个 elasticsearch 咯):
[Full text search in milliseconds with PostgreSQL](https://blog.lateral.io/2015/05/full-text-search-in-milliseconds-with-postgresql/) 不过一些语言相关的支持还不太完善, 有个 bamboo 插件用调教过的 mecab 做中文分词, 如果要求比较高, 还是自己分了词再存到 tsvector 比较好.

它支持 trigram 索引.
trigram 索引可以帮助改进全文搜索的结果: [PostgreSQL: Documentation: 9.3: pg_trgm](https://www.postgresql.org/docs/9.3/static/pgtrgm.html)
trigram 还可以实现高效的正则搜索 (原理参考 https://swtch.com/~rsc/regexp/regexp4.html )

MySQL 处理树状回复的设计会很复杂, 而且需要写很多代码, 而 Pg 可以高效处理树结构:

- [Scaling Threaded Comments on Django at Disqus](http://cramer.io/2010/05/30/scaling-threaded-comments-on-django-at-disqus)
- [Trees In The Database - Advanced data structures(VPN)](http://www.slideshare.net/quipo/trees-in-the-database-advanced-data-structures)

它可以高效处理图结构, 轻松实现 "朋友的朋友的朋友" 这种功能:
http://www.slideshare.net/quipo/rdbms-in-the-social-networks-age

它可以把 70 种外部数据源 (包括 Mysql, Oracle, CSV, hadoop ...) 当成自己数据库中的表来查询:
[Foreign data wrappers](https://wiki.postgresql.org/wiki/FDW?nocache=1)

心动不如行动
[Converting MySQL to PostgreSQL](https://en.wikibooks.org/wiki/Converting_MySQL_to_PostgreSQL)

===========================================================

楼上的回答问题很多，这两个数据库我都使用过，谈谈我的看法，这个答案有很大一部分来自于刘鑫的博客（找半天没找到地址，请读者自行google）。

1. PostgreSQL 的稳定性极强， Innodb 等引擎在崩溃、断电之类的灾难场景下抗打击能力有了长足进步，然而很多 MySQL 用户都遇到过Server级的数据库丢失的场景——mysql系统库是MyISAM的，相比之下，PG数据库这方面要好一些。
2. 任何系统都有它的性能极限，在高并发读写，负载逼近极限下，PG的性能指标仍可以维持双曲线甚至对数曲线，到顶峰之后不再下降，而 MySQL 明显出现一个波峰后下滑（5.5版本之后，在企业级版本中有个插件可以改善很多，不过需要付费）。
3. PG 多年来在 GIS 领域处于优势地位，因为它有丰富的几何类型，实际上不止几何类型，PG有大量字典、数组、bitmap 等数据类型，相比之下mysql就差很多，instagram就是因为PG的空间数据库扩展POSTGIS远远强于MYSQL的my spatial而采用PGSQL的。
4. PG 的“无锁定”特性非常突出，甚至包括 vacuum 这样的整理数据空间的操作，这个和PGSQL的MVCC实现有关系。
5. PG 的可以使用函数和条件索引，这使得PG数据库的调优非常灵活，mysql就没有这个功能，条件索引在web应用中很重要。
6. PG有极其强悍的 SQL 编程能力（9.x 图灵完备，支持递归！），有非常丰富的统计函数和统计语法支持，比如分析函数（ORACLE的叫法，PG里叫window函数），还可以用多种语言来写存储过程，对于R的支持也很好。这一点上MYSQL就差的很远，很多分析功能都不支持，腾讯内部数据存储主要是MYSQL，但是数据分析主要是HADOOP+PGSQL（听李元佳说过，但是没有验证过）。
7. PG 的有多种集群架构可以选择，plproxy 可以支持语句级的镜像或分片，slony 可以进行字段级的同步设置，standby 可以构建WAL文件级或流式的读写分离集群，同步频率和集群策略调整方便，操作非常简单。
8. 一般关系型数据库的字符串有限定长度8k左右，无限长 TEXT 类型的功能受限，只能作为外部大数据访问。而 PG 的 TEXT 类型可以直接访问，SQL语法内置正则表达式，可以索引，还可以全文检索，或使用xml xpath。用PG的话，文档数据库都可以省了。
9. 对于WEB应用来说，复制的特性很重要，mysql到现在也是异步复制，pgsql可以做到同步，异步，半同步复制。还有mysql的同步是基于binlog复制，类似oracle golden gate,是基于stream的复制，做到同步很困难，这种方式更加适合异地复制，pgsql的复制基于wal，可以做到同步复制。同时，pgsql还提供stream复制。
10. pgsql对于numa架构的支持比mysql强一些，比MYSQL对于读的性能更好一些，pgsql提交可以完全异步，而mysql的内存表不够实用（因为表锁的原因）

最后说一下我感觉 PG 不如 MySQL 的地方。

1. MySQL有一些实用的运维支持，如 slow-query.log ，这个pg肯定可以定制出来，但是如果可以配置使用就更好了。
2. 是mysql的innodb引擎，可以充分优化利用系统所有内存，超大内存下PG对内存使用的不那么充分，
3. MySQL的复制可以用多级从库，但是在9.2之前，PGSQL不能用从库带从库。
4. 从测试结果上看，mysql 5.5的性能提升很大，单机性能强于pgsql，5.6应该会强更多.
5. 对于web应用来说,mysql 5.6 的内置MC API功能很好用，PGSQL差一些。

> 另外一些：
pgsql和mysql都是背后有商业公司，而且都不是一个公司。大部分开发者，都是拿工资的。
说mysql的执行速度比pgsql快很多是不对的，速度接近，而且很多时候取决于你的配置。
对于存储过程，函数，视图之类的功能，现在两个数据库都可以支持了。
另外多线程架构和多进程架构之间没有绝对的好坏，oracle在unix上是多进程架构，在windows上是多线程架构。
很多pg应用也是24/7的应用，比如skype. 最近几个版本VACUUM基本不影响PGSQL 运行，8.0之后的PGSQL不需要cygwin就可以在windows上运行。
至于说对于事务的支持，mysql和pgsql都没有问题。


