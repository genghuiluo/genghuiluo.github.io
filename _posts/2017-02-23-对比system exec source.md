---
layout: post
title: 对比system exec source
date: 2017-02-23 17:19:22 +0800
categories: linux
---
#### create a test shell script
``` bash
#!/bin/bash

sleep 100 #system built-in cmd
```
`>./pid.sh`

system是调用shell执行你的命令，system=fork+exec+waitpid,执行完毕之后，回到原先的程序中去。

fork是linux的系统调用，用来创建子进程（child process）。子进程是父进程(parent process)的一个副本，从父进程那里获得一定的资源分配以及继承父进程的环境。子进程与父进程唯一不同的地方在于pid（process id）。
```
# ps -ef
UID        PID  PPID  C STIME TTY          TIME CMD
ghluo    19784 19627  0 22:24 pts/1    00:00:00 bash
ghluo    19878 19784  0 22:27 pts/1    00:00:00 /bin/bash ./pid.sh
ghluo    19879 19878  0 22:27 pts/1    00:00:00 sleep 100

# 进程结构：
bash
    \--pid.sh
            \--sleep
```

#### modify pid.sh to
``` bash
#!/bin/bash
exec sleep 100 #系统调用exec是以新的进程去代替原来的进程，但进程的PID保持不变。
```

```
UID        PID  PPID  C STIME TTY          TIME CMD
ghluo    19784 19627  0 22:24 pts/1    00:00:00 bash
ghluo    20275 19784  0 22:40 pts/1    00:00:00 sleep 100

进程结构：
bash
    \--- pid.sh ---> sleep
```

source命令即点(.)命令。 

在bash下输入man source，找到source命令解释处，可以看到解释”Read and execute commands from filename in the current shell environment and …”。

从中可以知道，source命令是在当前进程中执行指定文件中的各个命令，而不是另起子进程(或替换shell)。（e.g. rc file&profile to set env)

``` bash
# pid.sh
#!/bin/bash
source ./pid_sub.sh

# pid_sub.sh
#!/bin/bash
sleep 100
```

```
UID        PID  PPID  C STIME TTY          TIME CMD
ghluo     4762  4228  0 09:18 pts/0    00:00:00 /bin/bash ./pid.sh

#进程结构：
bash
    \--- pid.sh(pid_sub.sh)
```
