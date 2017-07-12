---
layout: post
title: Get start with python
date: 2017-06-28 14:19:05 +0800
categories: python
---
### installation

> python2 is not compatible with python3 .

most of linux distributions includle python defaultly.
``` shell
$ python -V
Python 2.7.6
$ python3 -V
Python 3.4.0
```

personally, l like to add a alias to use python3 as default.
``` shell
alias python='python3'
```

pip, python package manager. *like gem for ruby, npm for nodejs, maven for java*
``` shell
$ sudo apt-get -y install python-pip
```

ipython, python interactive terminal, like irb for ruby.
``` shell
$ pip install ipython
```

wiki：[python3 doc](https://docs.python.org/3/)

### python basic

branch
``` python
if condition1:
    exec1
elif condition2:
    exec2
else:
    exec3
```

loop
``` python
for var in list/tuple:
    exec

while condition:
    exec
```
collection

- list:有序集合[1,2,3]，索引下边从[0]开始（类似于array），添加append()、删除pop()、添加到指定位置insert(pos,val)
- tuple: 元祖(1,2,3)（和list非常类似，但是一旦初始化就不可修改)
- dicti：字典{‘a’:1,’b’:2}（类似于Java的map或是ruby的hash），key-value pair，key不可变
- set: 一组key的集合，没有重复的key，s = set([1, 2, 3])，可以看成数学意义上的无序和无重复元素的集合

> 和list比较，dict有以下几个特点：查找和插入的速度极快，不会随着key的增加而变慢；需要占用大量的内存，内存浪费多。
而list相反：查找和插入的时间随着元素的增加而增加；占用空间小，浪费内存很少。

function
``` python
def my_func(x):
    //do something
```
