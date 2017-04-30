---
layout: post
title: 《高性能MySQL》_chapter2_基准测试
date: 2017-04-30 15:02:28 +0800
categories: mysql
---

sysbench, a great MySQL benchmark testing tool

[MySQL 101: Monitor Disk I/O with pt-diskstats](https://www.percona.com/blog/2014/09/04/mysql-101-monitor-disk-io-with-pt-diskstats/)

基于MySQL默认配置的测试没有什么意义，因为默认配置是基于消耗很少的极小应用的

有时候需要使用不同的方法测试不同的指标。
- *吞吐量*: 单位时间内的事务处理数，常用测试单位(TPS,每秒事务数)
- 响应时间/延迟: 通常可以使用百分比响应时间
- 并发性: _同时工作中_的线程数/连接数


自动化基准测试，可以是一个Makefile文件或者一组脚本(shell/PHP/Perl...)

收集数据: https://github.com/genghuiluo/legacy/blob/master/mysql/collect_sample.sh

抽取数据: https://github.com/genghuiluo/legacy/blob/master/mysql/analyze_sample.sh
``` shell
$./analyze_sample.sh 5-sec-status-2017-04-11_05-status
#ts date time load QPS
1491901265 2017-04-11 17:01:05 0.04 0.00
1491901270 2017-04-11 17:01:10 0.04 1.80
1491901275 2017-04-11 17:01:15 0.03 2.40
1491901280 2017-04-11 17:01:20 0.11 1.80
1491901285 2017-04-11 17:01:25 0.10 1.80
1491901290 2017-04-11 17:01:30 0.09 1.20
1491901295 2017-04-11 17:01:35 0.09 1.80
1491901300 2017-04-11 17:01:40 0.08 2.00
1491901305 2017-04-11 17:01:45 0.07 1.60
1491901310 2017-04-11 17:01:50 0.07 1.80
1491901315 2017-04-11 17:01:55 0.06 2.80
1491901320 2017-04-11 17:02:00 0.06 1.20
```

绘图:(gnuplot / R）
``` shell
$gnuplot
...
gnuplot> plot "mysql/qps-per-5-sec" using 5 w lines title "QPS"
```
![]({{ site.url }}/assets/gnuplot_mysql.jpg)

已有的集成式测试工具：
1. [ab](http://httpd.apache.org/docs/2.4/programs/ab.html), Apache HTTP 服务器基准测试工具（每秒可以处理多少请求）
	
	```
	$ab -n 100 -c 10 https://genghuiluo.cn/
    This is ApacheBench, Version 2.3 <$Revision: 1430300 $>
    Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
    Licensed to The Apache Software Foundation, http://www.apache.org/
    
    Benchmarking genghuiluo.cn (be patient).....done
    
    
    Server Software:        Apache/2.4.6
    Server Hostname:        genghuiluo.cn
    Server Port:            443
    SSL/TLS Protocol:       TLSv1.2,ECDHE-RSA-AES256-GCM-SHA384,2048,256
    
    Document Path:          /
    Document Length:        3258 bytes
    
    Concurrency Level:      10
    Time taken for tests:   1.678 seconds
    Complete requests:      100
    Failed requests:        0
    Write errors:           0
    Total transferred:      413900 bytes
    HTML transferred:       325800 bytes
    Requests per second:    59.58 [#/sec] (mean)
    Time per request:       167.845 [ms] (mean)
    Time per request:       16.785 [ms] (mean, across all concurrent requests)
    Transfer rate:          240.82 [Kbytes/sec] received
    
    Connection Times (ms)
                  min  mean[+/-sd] median   max
    Connect:        9   82  33.4     88     155
    Processing:    10   84  38.1     80     159
    Waiting:        4   56  31.1     56     148
    Total:         52  166  50.5    147     283
    
    Percentage of the requests served within a certain time (ms)
      50%    147
      66%    160
      75%    164
      80%    228
      90%    261
      95%    267
      98%    283
      99%    283
     100%    283 (longest request)
    ```
    
    > The apache benchmark tool is very basic, and while it will give you a solid idea of some performance, it is a bad idea to only depend on it if you plan to have your site exposed to serious stress in production.
    
    Having said that, here's the most common and simplest parameters:
    
    -c: ("Concurrency"). Indicates how many clients (people/users) will be hitting the site at the same time. While ab runs, there will be -c clients hitting the site. This is what actually decides the amount of stress your site will suffer during the benchmark.
    
    -n: Indicates how many requests are going to be made. This just decides the length of the benchmark. A high -n value with a -c value that your server can support is a good idea to ensure that things don't break under sustained stress: it's not the same to support stress for 5 seconds than for 5 hours.
    
    -k: This does the "KeepAlive" funcionality browsers do by nature. You don't need to pass a value for -k as it it "boolean" (meaning: it indicates that you desire for your test to use the Keep Alive header from HTTP and sustain the connection). Since browsers do this and you're likely to want to simulate the stress and flow that your site will have from browsers, it is recommended you do a benchmark with this.

2. http_load,https://acme.com/software/http_load/
    ``` shell
    $cat url.txt
    http://highscalability.com/blog/2007/7/16/blog-mysql-performance-blog-everything-about-mysql-performan.html
    http://highscalability.com/blog/2007/7/16/paper-the-clustered-storage-revolution.html
    http://highscalability.com/blog/2007/7/16/paper-mysql-scale-out-by-application-partitioning.html

    $http_load -parallel 1 -seconds 10 url.txt 
    5 fetches, 1 max parallel, 225743 bytes, in 10 seconds
    45148.6 mean bytes/connection
    0.5 fetches/sec, 22574.3 bytes/sec
    msecs/connect: 252.637 mean, 306.62 max, 214.668 min
    msecs/first-response: 530.725 mean, 652.146 max, 424.044 min
    HTTP response codes:
      code 200 -- 5
    ```
3. JMeter

单组件式测试工具:
1. [mysqlslap](https://dev.mysql.com/doc/refman/5.7/en/mysqlslap.html),模拟服务器负载,并输出计时信息
    ```
    mysql> create schema mysqlslap; -- CREATE SCHEMA is a synonym for CREATE DATABASE
    
    # this sample create and query SQL statements, with 50 clients querying and 200 selects for each
    $mysqlslap --delimiter=";"\
    --create="CREATE TABLE a (b int);INSERT INTO a VALUES (23)"\
    --query="SELECT * FROM a" --concurrency=50 --iterations=200

    Benchmark
        Average number of seconds to run all queries: 0.010 seconds
        Minimum number of seconds to run all queries: 0.002 seconds
        Maximum number of seconds to run all queries: 0.022 seconds
        Number of clients running queries: 50
        Average number of queries per client: 0
    ```
2. [MySQL Benchmark Suite (sql-bench)](https://dev.mysql.com/doc/refman/5.5/en/mysql-benchmarks.html), 包含了大量预定义的测试，用于比较不同存储引擎或者不同配置的性能测试
    > [Measuring Peformance(Benchmarking)](https://dev.mysql.com/doc/refman/5.7/en/optimize-benchmarking.html)   
3. [Super Smack(abandoned)](https://github.com/tmountain/Super-Smack), 用于MySQL和PG
4. [Database Test Suite](http://osdldbt.sourceforge.net/)
5. [Percona's TPCC-MySQL Tool](https://github.com/Percona-Lab/tpcc-mysql)
6. [sysbench](https://github.com/akopytov/sysbench)
    > 多线程系统压测工具，（文件I/O,操作系统调度器,内存分配,传输速度,POSIX线程,数据库服务器...),支持Lua脚本语言

MySQL内置的BENCHMARK(),可以测试某些特定操作的执行速度,参数可以是需要执行的次数和表达式
``` sql
-- md5() faster than sha1()
-- 表达式必须使用user defined variable,否则因为系统缓存命中而影响结果
mysql> set @input:='hello mark';
Query OK, 0 rows affected (0.00 sec)

mysql> select benchmark(1000000,md5(@input));
+--------------------------------+
| benchmark(1000000,md5(@input)) |
+--------------------------------+
|                              0 |
+--------------------------------+
1 row in set (0.23 sec)

mysql> select benchmark(1000000,sha1(@input));
+---------------------------------+
| benchmark(1000000,sha1(@input)) |
+---------------------------------+
|                               0 |
+---------------------------------+
1 row in set (0.25 sec)
```
> 虽然benchmark()很方便，但是不适合用于真正的基准测试


