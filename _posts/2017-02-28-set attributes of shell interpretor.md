---
layout: post
title: set attributes of shell interpretor
date: 2017-02-23 17:19:22 +0800
categories: linux
---
### set命令是shell解释器的一个内置命令，用来设置shell解释器的属性，从而能够控制shell解释器的一些行为

> 这里以bash为例，不同的shell，格式略有区别

`set` 不带选项执行set命令时，会输出当前shell的所有变量，输出格式就和shell脚本里面的变量赋值的格式一样： name=value

```
# - 开启
set [-abefhkmnptuvxBCEHPT] [-o option-name] [arg ...]
# + 关闭
set [+abefhkmnptuvxBCEHPT] [+o option-name] [arg ...]
```

set通过选项来开关shell的不同特性，每个特性都对应一个选项。每个特性都有两种配置方式：

- 通过 `set -e` 和 `set +e` 这种形式，即直接指定选项。
- 通过 `set -o errexit` 和 `set +o errexit` 这种形式，即通过-o这个选项来指定选项名。

执行`set -o`会输出当前的set选项配置情况
```
> set -o
allexport       off
braceexpand     on
emacs           on
errexit         off
errtrace        off
functrace       off
hashall         on
histexpand      on
history         on
ignoreeof       off
interactive-comments    on
keyword         off
monitor         on
noclobber       off
noexec          off
noglob          off
nolog           off
notify          off
nounset         off
onecmd          off
physical        off
pipefail        off
posix           off
privileged      off
verbose         off
vi              off
xtrace          off
```
执行`set +o`也是输出当前的set选项的配置情况，只不过输出形式是一系列的set命令。这种输出形式一般用于重建当前的set配置项时使用
```
> set +o
set +o allexport
set -o braceexpand
set -o emacs
...
```

### common options detail

1. -e or -o errexit
    - 设置了这个选项后，当一个命令执行失败时，shell会立即退出。
2. -n or -o noexec
    - 设置了这个选项后，shell读取命令，但是不会执行它们。这个选项可以用来检查shell脚本是否存在语法错误。
3. -u or -o unset
    - 设置了这个选项之后，当shell要扩展一个还未设置过值的变量时，shell必须输出信息到stderr，然后立即退出。但是交互式shell不应该退出。
4. -x or -o xtrace
    - 设置了这个选项之后，对于每一条要执行的命令，shell在扩展了命令之后（参数扩展）、执行命令之前，输出trace到stderr
