---
layout: post
title: hanoi with recursion
date: 2017-02-23 17:19:22 +0800
categories: algorithm
---
### 三柱汉诺塔问题  question of three pegs hanoi

有A,B,C三个柱子，n表示A柱上的盘子个数，输出将A柱上所有的盘子移到C柱上的步骤
分治法的思路，将母任务分成类似的子任务：

- (1) 将A柱的前n-1个盘子，借助C柱移到B柱
- (2) 将A柱最下面的盘子移到C柱
- (3) 将B柱的n-1个盘子，借助A柱移到C柱

``` ruby
#ruby code
def move(n,a,b,c)
        if n==1
                puts "# #{a}-->#{c}"
        else
                move(n-1,a,c,b)
                puts "# #{a}-->#{c}"
                move(n-1,b,a,c)
        end
end

move(3,'A','B','C')

# A-->C
# A-->B
# C-->B
# A-->C
# B-->A
# B-->C
# A-->C
```

### 四柱汉诺塔问题 question of four pegs hanoi
有A,B,C,D三个柱子，n表示A柱上的盘子个数，输出将A柱上所有的盘子移到D柱上的最少步骤

四柱演变为最优解问题

Frame算法（1941）

- (1) 将A柱的前n-k个盘子，通过C柱和D柱移动到B柱
- (2) 将A柱剩余的k个盘子，通过C柱移动到D柱（三柱汉诺塔算法）
- (3) 将B柱的n-k个盘子 ，通过A柱和C柱，移动到D柱

``` ruby
#ruby code
def ThreePegsHanoi(n,a,b,c)
        step=[]
        if n==1
                step+=["# #{a}-->#{c}"]
        else
                step+=ThreePegsHanoi(n-1,a,c,b)
                step+=["# #{a}-->#{c}"]
                step+=ThreePegsHanoi(n-1,b,a,c)
        end
        return step
end

def FourPegsHanoi(n,a,b,c,d)
        step=[]
        if n==1
                step+=["# #{a}-->#{d}"]
        else
                minstep=[]
                (1..n).each do |k|
                        step+=FourPegsHanoi(n-k,a,c,d,b)
                        step+=ThreePegsHanoi(k,a,c,d)
                        step+=FourPegsHanoi(n-k,b,a,c,d)
                        if minstep.length>step.length or minstep.length==0
                                minstep=step
                        end
                        step=[]
                end
                step=minstep
        end
        return step
end
puts FourPegsHanoi(10,'A','B','C','D')

# A-->D
# A-->B
# A-->C
# B-->C
......
# C-->D
# B-->D
```
