---
layout: post
title: built-in variables(e.g. $$) in shell
date: 2017-06-23 11:00:39 +0800
categories: linux
---

| var    | desc                                                  |
|--------|-------------------------------------------------------|
| !#     | 上一个命令名                                          |
| !$     | 上一个命令的最后一个参数                              |
| !:n    | 上一个命令的第n个参数                                 |
| $$     | Shell本身的PID（ProcessID）                           |
| $!     | Shell最后运行的后台Process的PID                       |
| $?     | 最后运行的命令的结束代码（返回值）                    |
| $-     | 使用Set命令设定的Flag一览                             |
| $\*     | 所有参数列表。以”$1 $2 … $n”的形式输出所有参数。      |
| $@     | 所有参数列表。以”$1” “$2” … “$n” 的形式输出所有参数。 |
| $#     | 添加到Shell的参数个数                                 |
| $0     | Shell本身的文件名                                     |
| $1~$n | 添加到Shell的各参数值。$1是第1参数，$2是第2参数… |