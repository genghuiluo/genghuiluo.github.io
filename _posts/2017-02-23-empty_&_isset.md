---
layout: post
title: empty & isset
date: 2017-02-23 17:19:22 +0800
categories: php
---
*顾名思义，empty() 判断一个变量是否为“空”，isset() 判断一个变量是否已经设置。*

> 当一个变量值等于0时，empty()也会成立（True），因而会发生一些意外。empty() 和 isset() 虽然都是变量处理函数，它们都用来判断变量是否已经配置，它们却是有一定的区别：empty还会检测变量是否为空、为零。当一个变量值为0，empty() 认为这个变量同等于空，即相当于没有设置。
比如检测 $id 变量，当 $id=0 时，用empty() 和 isset() 来检测变量 $id 是否已经配置，两都将返回不同的值 empty() 认为没有配置，isset() 能够取得 $id 的值：

``` php
$id=0;
empty($id)?print "It's empty":print "It's $id";
//结果：It's empty .
!isset($id)?print "It's empty":print "It's $id";
//结果：It's 0 
```

这意味着，我们在使用变量处理函数时，当该变量可能出现0的值，使用 empty() 要小心，这个时候用 isset 取代它更明智一些。

当一个php页面的 URL 尾部参数出现 id=0 时（比如：test.php?id=0），试比较：
``` php
if(empty($id)) $id=1; //若 id=0 ，id 也会为1
if(!isset($id)) $id=1; //若 id=0 ，id 不会为1
```
