---
layout: post
title: bash script in parallel
date: 2017-06-29 17:45:10 +0800
categories: linux
---
[转自](http://jerkwin.github.io/2013/12/14/Bash%E8%84%9A%E6%9C%AC%E5%AE%9E%E7%8E%B0%E6%89%B9%E9%87%8F%E4%BD%9C%E4%B8%9A%E5%B9%B6%E8%A1%8C%E5%8C%96/)

> 在Linux下运行作业时, 经常会遇到以下情形: 有大量作业需要运行, 完成每个作业所需要的时间也不是很长. 如果我们以串行方式来运行这些作业, 可能要耗费较长的时间; 若采用并行方式运行则可以大大节约运行时间. 再者, 目前的计算机绝大部分都是多核架构, 要想充分发挥它们的计算能力也需要并行化. 总结网上看到的资料, 利用Bash脚本, 可以采用下面几种方法实现批量作业的并行化. 注意, 下面论述中将不会区分进程和线程, 也不会区分并行和并发.

## 采用GNU的paralle程序
parallel是GNU专门用于并行化的一个程序, 对于简单的批量作业并行化非常合适. 使用parallel不需要编写脚本, 只需在原命令的基础上简单地加上parallel就可以了. 所以, 如果能用paralle并行化你的作业, 请优先使用. [有关paralle的详细说明](https://www.gnu.org/software/parallel/man.html).

## 最简单的并行化方法: &+wait
利用Bash的后台运行&和wait函数, 可实现最简单的批量作业并行化. 如下面的代码, 串行执行大约需要10秒
``` bash
# Language: bash
for((i=1; i<=3; i++)); do {
	sleep 3
	echo "DONE!"
} done

# 改为下面的简单并行代码理想情况下可将运行时间压缩到3秒左右

# Language: bash
for((i=1; i<=3; i++)); do {
	sleep 3
	echo "DONE!"
} & done
wait
```
## 进程数可控的并行化方法(1): 模拟队列
使用Bash脚本同时运行多个进程并无困难, 主要存在的问题是如何控制同时运行的进程数目. 上面的简单并行化方法使用时进程数无法控制, 因而功能有限, 因为大多数时候我们需要运行的作业数远远超过可用处理器数, 这种情况下若大量作业同时在后台运行, 会导致运行速度变慢, 并行效率大大下降. 一种简单的解决方案就是模拟一个限定最大进程数的队列, 以进程PID做为队列元素, 每隔一定时间检查队列, 若队列中有作业完成, 则添加新的作业到队列中. 这种方法还可以避免由于不同作业耗时不同而产生的无用等待. 下面是根据网上的代码改写的一种实现.
``` bash
# Language: bash
Njob=10    # 作业数目
Nproc=5    # 可同时运行的最大作业数

function CMD {        # 测试命令, 随机等待几秒钟
	n=$((RANDOM % 5 + 1))
	echo "Job $1 Ijob $2 sleeping for $n seconds ..."
	sleep $n
	echo "Job $1 Ijob $2 exiting ..."
}
function PushQue {    # 将PID压入队列
	Que="$Que $1"
	Nrun=$(($Nrun+1))
}
function GenQue {     # 更新队列
	OldQue=$Que
	Que=""; Nrun=0
	for PID in $OldQue; do
		if [[ -d /proc/$PID ]]; then
			PushQue $PID
		fi
	done
}
function ChkQue {     # 检查队列
	OldQue=$Que
	for PID in $OldQue; do
		if [[ ! -d /proc/$PID ]] ; then
			GenQue; break
		fi
	done
}

for((i=1; i<=$Njob; i++)); do
	CMD $i &
	PID=$!
	PushQue $PID
	while [[ $Nrun -ge $Nproc ]]; do
		ChkQue
		sleep 1
	done
done
wait
```
一个更简洁的方法是记录PID到数组, 通过检查PID存在与否以确定作业是否运行完毕. 可实现如下
``` bash
# Language: bash
Njob=10    # 作业数目
Nproc=5    # 可同时运行的最大作业数

function CMD {        # 测试命令, 随机等待几秒钟
	n=$((RANDOM % 5 + 1))
	echo "Job $1 Ijob $2 sleeping for $n seconds ..."
	sleep $n
	echo "Job $1 Ijob $2 exiting ..."
}

PID=() # 记录PID到数组, 检查PID是否存在以确定是否运行完毕
for((i=1; i<=Njob; )); do
	for((Ijob=0; Ijob<Nproc; Ijob++)); do
		if [[ $i -gt $Njob ]]; then
			break;
		fi
		if [[ ! "${PID[Ijob]}" ]] || ! kill -0 ${PID[Ijob]} 2> /dev/null; then
			CMD $i $Ijob &
			PID[Ijob]=$!
			i=$((i+1))
		fi
	done
	sleep 1
done
wait
```
## 进程数可控的并行化方法(2): 命名管道
上面的并行化方法也可利用命名管道来实现, 命名管道是Linux下进程间进行通讯的一种方法, 也称为先入先出(fifo, first in first out)文件. 具体方法是创建一个fifo文件, 作为进程池, 里面存放一定数目的”令牌”. 作业运行规则如下: 所有作业排队依次领取令牌; 每个作业运行前从进程池中领取一块令牌, 完成后再归还令牌; 当进程池中没有令牌时, 要运行的作业只能等待. 这样就能保证同时运行的作业数等于令牌数. 前面的模拟队列方法实际就是以PID作为令牌的实现.

据我已查看的资料, 这种方法在网络上讨论最多. 实现也很简洁, 但理解其代码需要的Linux知识较多. 下面是我改写的示例代码及其注释.
``` bash
# Language: bash
Njob=10    # 作业数目
Nproc=5    # 可同时运行的最大作业数

function CMD {        # 测试命令, 随机等待几秒钟
	n=$((RANDOM % 5 + 1))
	echo "Job $1 Ijob $2 sleeping for $n seconds ..."
	sleep $n
	echo "Job $1 Ijob $2 exiting ..."
}

Pfifo="/tmp/$$.fifo"   # 以PID为名, 防止创建命名管道时与已有文件重名，从而失败
mkfifo $Pfifo          # 创建命名管道
exec 6<>$Pfifo         # 以读写方式打开命名管道, 文件标识符fd为6
                       # fd可取除0, 1, 2,5外0-9中的任意数字
rm -f $Pfifo           # 删除文件, 也可不删除, 不影响后面操作

# 在fd6中放置$Nproc个空行作为令牌
for((i=1; i<=$Nproc; i++)); do
	echo
done >&6

for((i=1; i<=$Njob; i++)); do  # 依次提交作业
	read -u6                   # 领取令牌, 即从fd6中读取行, 每次一行
                               # 对管道，读一行便少一行，每次只能读取一行
                               # 所有行读取完毕, 执行挂起, 直到管道再次有可读行
                               # 因此实现了进程数量控制
	{                          # 要批量执行的命令放在大括号内, 后台运行
		CMD $i && {            # 可使用判断子进程成功与否的语句
			echo "Job $i finished"
		} || {
			echo "Job $i error"
		}
		sleep 1     # 暂停1秒，可根据需要适当延长,
                    # 关键点，给系统缓冲时间，达到限制并行进程数量的作用
		echo >&6    # 归还令牌, 即进程结束后，再写入一行，使挂起的循环继续执行
	} &

done

wait                # 等待所有的后台子进程结束
exec 6>&-           # 删除文件标识符
```
注意:
1. exec 6<>$Pfifo 这一句很重要, 若无此语句, 向$Pfifo写入数据时, 程序会被阻塞, 直到有read读出了文件中的数据为止. 而执行了此语句, 就可以在程序运行期间不断向文件写入数据而不会阻塞, 并且数据会被保存下来以供read读出.
2. 当$Pfifo中已经没有数据时, read无法读到数据, 进程会被阻塞在read操作上, 直到有子进程运行结束, 向$Pfifo写入一行.
3. 核心执行部分也可使用如下方式

    ``` bash
    # Language: bash
    for((i=1; i<=$Njob; i++)); do
    	read -u6
    	(CMD $i; sleep 1; echo >&6) &
    done
    # {}和()的区别在shell是否会衍生子进程
    ```

4. 此方法在目前的Cygwin(版本1.7.27)下无法使用, 因其不支持双向命名管道. 有人提到一个解决方案, 使用两个文件描述符来替代单个文件描述符, 但此方法我没有测试成功.

