---
layout: post
title: informatica PowerCenter architecture
date: 2017-08-19 13:08:37 +0800
categories: etl
---

> Informatica PowerCenter is client-server architecture(官方的说法是SOA(Service Oriented Architecture, 面向服务架构),包含以下几个部分：

### Server:

- Informatica Domain: 管理所有的node和service，lisence协议限定只有一个domain，domain的元数据（domain configuration database）存放在RDBMS中（例如Oracle）。
- Node: 在一个domain下的一台物理机器的逻辑表示。node有两种：gateway node和worker node。所有的gateway node都必须有domian元数据库schema的connection，只有一个master gateway node，剩下的gateway node全部是backup gateway node，master gateway node执行service manager，管理所有Node上的service。除了gateway node剩下的就是worker，worker可以执行application service。
- Service Manager: 所有节点上都有一个service manager进程，统一被master gateway node调度。管理所有的application services，安全验证和授权，domain和node的配置，日志管理（log agent存在于所有有service执行的node上+log manager只存在与master gateway node,集中所有的log）。
- Informatcia Administrator: web应用来管理配置informatica所有的domain，nodes，services，repositories，直接在浏览器中访问。
- Integration Service: 从PWC repository （保存了所有mapping/workflow的元数据）获取workflow的元数据，执行DTM进程(IS可以跨多个nodes，支持grid)。
- Repository Service: 管理连接PWC repository

> 以上两种都属于application service，informatica有以下几种application service： 
    
- PWC Repository Service 
- PWC Integration Service 
- PWC Web Service 
- Hub Model Repository Service 
- Data Integration Service 
- Analyst Service 

所有节点都可以执行任意种类的application service

### Client:

- Designer：编辑source/target/mapping…
- Workflow Manager：编辑session/workflow…
- Workflow Monitor：控制检测session/workflow的运行
- Repository Manager(ps:只有它支持多个object导出xml)：管理PWC Repository，编 辑folder，user，group，权限分配

![]({{ site.url }}/assets/informatica_arthitecture.png)

杜绍森的training:

<img src="{{ site.url }}/assets/informatica_arthitecture_1.jpg" style="width:80%"/>

<img src="{{ site.url }}/assets/informatica_arthitecture_2.jpg" style="width:80%"/>

<img src="{{ site.url }}/assets/informatica_arthitecture_3.jpg" style="width:80%"/>

<img src="{{ site.url }}/assets/informatica_arthitecture_4.jpg" style="width:80%"/>

<img src="{{ site.url }}/assets/informatica_arthitecture_5.jpg" style="width:80%"/>
