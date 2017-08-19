---
layout: post
title: informatica general transformations
date: 2017-08-19 13:07:55 +0800
categories: etl
---
### Source Qualifier

- Source Qualifier有下列用途(DB Relational Source)： A. 连接同源的数据集； B. 过滤源数据； C. 指定连接条件（等连，非等连，like）和类型（内连，外连）； D. 指定排序栏位（当Mapping 中用到Aggregator 或者Joiner 时，排序可以改进 性能）； E. Distinct； F. Override Select；
- Source Qualifier 执行从数据库数据类型到Powercenter 数据类型间的转换；
- 当一个Mapping 中有多个Source Qualifier 连到多个Target 时可用Target Load Order 指定装载顺序；
- 在Source Qualifier 中的多个地方可以使用参数或变量，传入SQL 语句用的是*字符串格式*，所以大部分时候都需要用引号；
- Source Qualifier 只为连出的Port 产生SQL 语句，需要注意的是，Override SQL 是和 连出线的Port 顺序相关的，而且，其它属性如Join，Filter，Sorted Ports，Distinct 会失效；
- 这些属性都可以在Session 属性中被Override(覆盖)。
- 一切检索的内容都是以SQL Query 最高优先级，如果没有sql query 就找 User Join Define 和filter,如果有SQL Query 那么SQ 拉出的端口必须与SQL Query 的Select 个数一样多, sql query 多表时,select 到的field 的table 的Source 是一 定需带上的,当需要多个schema 作为源的话,则一定需要sql querry
- Pre SQL 和Post SQL 在seesion 执行前或者结束时会触发。比如可以把session 执行 的时间写入到某些地方，获取执行电脑的ip 地址等用处.

### Update Strategy

- Powercenter 的更新策略包括两个方面： 
    - A. 在Mapping 中：用Update Strategy Transformation 标识行为Insert，Update， Delete 或者Reject
    - B. 在Session 中：配置Treat source row as 属性（Insert，Update，Delete 或 者Data driven），配置Target 的属性（Insert，Update as Upadte(只是更新) \| as Insert(把更新视为新增) \| else Insert(先更新,更新不到则新增) ，Delete (Truncate target table option)
- 在Update Strategy Expression 中可以输入常量（DD_INSERT， DD_UPDATE， DD_DELETE， DD_REJECT）或者数字值 （0，1，2，3），其它数字值被解析为0，可以用IIF 或者DECODE 函数构建逻辑表达式来区别每一行的更新策略；
- Forward Rejected Rows：勾选时被Rejected 的行会存入对应Target 配置的Reject文件中去，不选时，可能会写入Session Log中去，根椐当前Transformation 的Tracing Level 的属性来决定；如果在会话属性中配置了出错行日志属性，则不会生成Reject 文件；

### Expression

- 用来执行单行计算，在计算表达式中（丰富的函数库），可以使用输入端口，输入/输出端口，可以使用 函数以及非连接的Lookup，也可以使用变量端口；
- 数据来源只能一个（单行计算）

### Lookup

> lookup is the most complicate transformation in my mind, [view more]({{ site.url }}/etl/2017/05/22/informatica_transformation_-_dynamic_lookup.html)

1. Lookup 根椐输入值从数据库或者平面文件中查找数据； 
2. Lookup 分为连接型和非连接型的： 
    - 连接型的可以传送多个返回值给其它的Transformation，非连接型的只能有一个返回端口，在表达式中用Lookup 函数（:LKP()）来调用； 
    - 连接型的可以利用到默认值，当没有匹配记录时，非连接型的总是返回空； 
    - Lookup可以配置成使用CACHE，*对平面文件这项必选*，Informatica Server 在条件栏位上建立索引CACHE，在其它栏位上建立数据CACHE，如果分配的CACHE空间不够就存放在CACHE 文件中； 
    - CACHE 文件可以是临时的，也可以是固定化的； 
    - 当Lookup 配置成动态时，对应的表是Target，如果输入行连接栏位在CACHE 中没有找到匹配记录，就在CACHE 中插入一行，如果找到了就更新CACHE或者不更新CACHE，取决于比较栏位是否匹配，给标志栏位NewLookupRow 赋值0（Unchange），1（Insert）， 2（Update）；
    - Lookup的端口除了I，O 之外，还有L 和R； 
    - 多匹配行处理策略：返回第一行，返回最一行，报错； 
    - 在数据库Lookup 使用CACHE 的前提下可以使用Override SQL，下面情形下适于使用 Override SQL： 
        - A. 增加一个Where 子句； 
        - B. 指定不同于默认SQL 的Order By 子句，在带有Order By 子句的Override SQL 后加上–,目的是屏蔽掉系统自动产生的Order By 子句；(PowerCenter 服务器是默认是按lookup 的栏位来Order By 的,如果你在 Override 里面想要覆盖它的Order By 方式，一定必须在结尾输入’–‘注释符来覆盖,否则lookup会失败,而且在新的Order by 里面要有LookUp Condition 包含的栏位，而且顺序需要一致) 
        - C. Lookup 表名或者栏位中包含保留字或者栏位名中含/时，用引号将保留字引起来； (如果look up 栏位里面包含了db 的保留字，那么需要在pm 目录下建立一个含 有那些保留字的reswords.txt 的文件，pm 会在保留字周围放置一些引用，来解 决和服务器冲突的问题.) 
        - D. 需要在Lookup 查询中使用参数或者变量时； 
        - E. 其它情况，比如从一个连接中返回结果或者要对返回作函数处理后的结果作为 CACHE； 
    - 关于Lookup的条件匹配： 
        - A. 条件两边的端口必须匹配； 
        - B. 输入端口允许在条件中出现多次； 
        - C. 多个条件间的关系是AND； 
        - D. 相等条件可以匹配空值(NULL=NULL)； 
        - E. 如果条件中有等于和不等于，将所有等于放在前面； 
    - 如果允许，可以在Lookup 表的连接条件栏位上建立索引，以改进性能； 
    - LookUp 一定要有输入port,SQL Overrid 不能覆盖condition 的作用 
    - Dynamic LookUp 一般用于查找目标表是否已经有Source 传过来的记录,然后根据更新标志(flag)做处理.也就是把目标表的所有数据先用文件作为缓存存放起来,然后Source传过来的记录与缓存文件的数据比较并且由属性(insert else update,update else insert)决定是否更新缓存文件. 
    - 理解Associated Port 的意义；关联端口,当Dynamic Look Up Cache 时,PM 如何把in port的资料和cache 里面的资料来对比和关联，然后产生新的cache 和NewLookUpRow就是需要用Associated Port来关联in port端口的资料或者Sequrence了。Condition 相关的Fields端口会被自动关联.只有有连线出去的port 的比较才有意义.也就是说如果没有连线出去，两个值尽管不相等，NewLookUpRow 还是为0.而且Null=Null 
    - Ignore in Comparison 可以不去比较的栏位(但是至少要有一个,要不Look Up 会失败),如果适当使用可以提高性能。 忽略比较,当这个值之外所有比较值都相同则不更新Cache,,NewLookUpRow=0 当其它比较值还有不相同时则更新Cache. NewLookUpRow=,1 or 2 15. Output Old Value On Update:当更新的时候不会更新新值到Cache,全部以Cache 里面的值输出

### Aggregator

- Aggregator 可用于聚合统计，和SQL语句不同的是，可以针对不同的计算指定不同的条件，并可输出非Group By 的栏位；
- 用于Group By 的端口可以是输入的， 输入输出的，输出的或者变量端口，用到的输出及变量端口中不能含有统计函数；
- 统计端口可以包含统计函数（共有15 个），可以进行两层嵌套，但要求所有的统计端口都进行嵌套；
- 对于那些即非Group By 又非统计的端口，返回最后一次收到的那一行；
- Sorted Input 属性表示输入的数据已经按Group By端口的要求排好了顺序，这样能提高性能，输入部分数据就能有部分结果，源和目标的组件能同时工作，在没有选这个属性的情况下，需要等到所有数据输入完成才能开始有统计结果；注意：当选择Sorted Input 属性，但是输入数据未排序时。Session 将failed。当aggregate expression 包含嵌套aggregate functions 或者采用incremental aggregation 或者Treat source rows as 是data driven 时，不能用Sorted Input属性。
- 在上面属性未选的情况下，需要用到索引CACHE和数据CACHE

### Filter

- Filter 用来过滤数据，被过滤掉的数据不会写入Session Log，也不会写入Reject File；
- 将Filter 尽可能地靠近Source 可以提升性能；
- Filter 只能接受来自单个Transformation 的数据流；
- Filter 只有一种输入/输出端口，默认值无效；
- 只有Filter Condition 评估为真（或者非零数值）的记录才能通过；
- 如果有可能，用Source Qualifier 代替Filter 可以取得更好的性能。
     
### Joiner

> joiner is a complicate transformation, [view more]({{ site.url }}/etl/2017/05/22/informatica_transformation_-_joiner.html)

1. Joiner 可以用来连接两个相关的不同来源的数据集； 
2. 至少需要指定一个匹配端口； 
3. 对两个来源有如下限制： 
    - A. 两个数据源要求是来自两个Pipeline 或者一个Pipeline 的两个分支； 
    - B. 任何一个Pipeline 中都不能含有Update Stragegy； 
    - C. Sequence 不能直接连到Joiner； 
4. Joiner 的主要属性如下： 
    - A. 比较时大小写敏感； 
    - B. 缓存目录，数据缓存的大小，索引缓存的大小（lkp的索引cache是jnr的两倍）； 
    - C. 连接类型（Normal，Master Outer，Detail Outer，Full Outer）； 
    - D. 输入已排序：输入数据已按连接端口的顺序排好序，这可以减少磁盘输入及输出，提高了Joiner 的性能； 
5. 指定非重复值少的表作为Master 表可以提升性能，默认情况下，第一个加入的数据源是Detail； 
6. 只支持相等连接，当使用多个连接端口时，连接的顺序对性能有影响； 
7. 连接端口如果含有NULL 值，连接不会成功； 
8. Joiner一次只能连接两个数据源，如果有多个数据源要进行连接，使用多个Joiner； 
9. Joiner可以连接来自同一个Source的数据流（自连），有两个方法：如果Joiner 选择了Sorted Input属性，可以用一个Source Instance来实现，否则就需要Source的两个Instance； 
10. Joiner 的Index Cache（连接端口）以及Data Cache（其它端口）是针对Master 表建立的； 
11. 在不同的配置条件下，Joiner有不同的阻塞策略，这样可以用更少的Cache，对性能有不同的影响； 
12. 在有可能的情况下，尽可能在数据库完成连接处理；

### Normalizer
        
> normalizer is a complicate transformation, [view more]()

1. 在关系型数据库处理中，Normalizer 用来从一行变成多行； 
2. Generated Key，自动产生不能删除的端口，命名为GK_XXX，由这个端口产生一个序列号值，在需要时可以作为主键，运行成功后会在知识库中保存下一个值，可以在Mapping 中看到下一个值，可以修改这个值； 
3. Generated Column ID，自动产生不能删除的端口，命名为GCID\_， 这个端口产生一个序号指名当前输出来自多个输入中的哪一个； 
4. Reset和Restart 属性：会话结束时重置GK 值到上次的值或者到1；

### Router

- Router 和Filter 很相似，Router 可以用一或多个Filter 来取代，不同的是用Router 来生成多个组时输入数据只需处理一次，所以效率更高；
- Router 由一个输入组，一到多个用户定义的输出组和一个默认组组成，每一个用户定 义的输出组含一个测试条件，满足条件的输入数据会进入相应的用户定义组，不满足所 有用户定义条件的数据会进入默认组；
- 输入组和输出组的端口类型和名称相同；
- Powercenter 根椐连接的用户定义输出组的顺序来进行评估，如果默认组没有连接，则 不评估那些没有连接的用户定义输出组；
- 如果某一行符合多个输出组的评估条件，则出现在多个组的输出数据流中；
- 可以将一个输出组的端口连到多个Transformation 或者Target 上，但不能将多个输出 组的端口连到一个Transformation 或者Target 上；

### Sequence

- Sequence 用来产生序列号用以作为主键栏位，可以重用；
- 只有两个输出端口：Nextval 和Currval；
- 通过配置Start Value，End Value，Current Value 和 Cycle 属性，可以让产生的Nextval 在一个指定的范围内循环；
- 可以将Nextval 端口连到多个Target 上，这时是阻塞式的产生序列号的，可以保证多个Target得到不同的序列号，如果想要得到相同的序列号，可以将Nextval 端口连到 Target 之前的一个共有的Transformation上；
- 如果只连出Currval，得到的是一个常量，并且一次阻塞只能获得一个值，所以为性能考量，一般都不连出这个端口，如果Nextval 同时有连出，这时Currval = Nextval + Increment By； 6. 在没有配置Cycle 属性时，如果序列号达到了End Value，会话会失败；
- 不重用的Sequence 有Reset 属性，启用以后，在每个会话结束时会将Current Value 置为会话开始时的值，这个值是它产生的第一个值；
- 当Sequence 配置成重用时，应该给Number of Cached Values 一个大于零的缓存值， 这个值是主要为保证不出现重复数据而设置的.比如当设置为100,那么一个线程在从1 开始在跑,则另外一个线程会从101 开始.每次跑完都要补足100 整数.

### Sorter

- Sorter 用来排序数据，可以指定多个排序端口，每个端口可以指定升降序，字符串比较时可以忽略大小写，还可以用Distinct 选项来消除重复(所有端口,包括没有指定排序的端口)；
- 排序时会用到输入数据两倍大小或者更大的空间，默认的排序Cache是8M，可选的排序Cache 范围是1M 到4G，排序Cache不够时，服务器会将数据临时存储在排序目录，如果指定的排序Cache 无法满足，会话会失败，可以用文档中提到公式计算Cache(?)；
- 当配置使用 Distinct 属性时，所有的端口都会用于排序；
- 默认情况下，NULL 大于任何值，可以配置NULL 值小于任何值；

### Union

- Union 可以将多个数据流合并成一个数据流，功能类似于SQL 中的UNION ALL；
- Union 可以有多个输入组，只有一个输出组，输入组和输出组有一一对应的端口；
- Ports 页不可编辑，只能编辑Groups 和 Group Tabs 页；

### Rank

- Rank 可以用来返回根椐某个端口排序的最大或者最小的N条记录，并且可以指定分组； 可以用于得到去除的重复资料(比如5 条相同数据，只取了一条，那么另外四条可以由 这个加上Sqerence 组合得到其它四条.).
- Rank 中可以使用分组，但并不能使用分组函数(?)，可以指定多个分组端口，但用于排序的Rank 端口不可用于分组；
- Rank 端口有五种属性：I（输入），O（输出），V（变量），R（排序），G（分组）， 至少需要有一个输入端口和一个输出端口，排序端口有且只有一个，而且必须输出，排序端口和变量端口不能用于分组；
- 输入端口的数据只能来自一个Transformation；
- 有一个默认的Rankindex 端口，表示输出行在排序中的位置；
- 如果是字符排序，可以选择大小敏感或者大小写不敏感；
- Top X 中的X 数量表示前几条数据(Rankindex 的值就是顺序)，当Rankindex 一样时, 取其中部分,比如Top1,有两条记录的Rankindex 为1，则取其中一条.其受cache限制， 可按需调cache.
