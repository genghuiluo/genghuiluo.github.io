---
layout: post
title: multihread data consistentcy
date: 2017-02-23 17:19:22 +0800
categories: ruby
---
> doc detail @ [Thread](http://ruby-doc.org/core-2.2.0/Thread.html) & [Mutex](http://ruby-doc.org/core-2.2.0/Mutex.html)

Let’s start with a basic simple.

``` ruby
#sample1
cnt1=cnt2=0
diff=0

counter=Thread.new do
    loop do
        cnt1+=1
        cnt2+=1
    end
end

spy=Thread.new do
    loop do
        diff+=(cnt1-cnt2).abs
    end
end

sleep 1 
counter.exit
spy.exit

puts "count1: #{cnt1}"
puts "count2: #{cnt2}"
puts "diff: #{diff}"
```

I create two threads counter and spy here. First thread keep adding 1 for two variables and second one record the diffrence between cnt1 and cnt2.

> Idealy

1. thread1 add 1 to cnt1
2. thread2 read cnt2 while thread1 write cnt2
3. thread2 capture the diff

the result of sample1:
```
count1: 18514976
count2: 18514976
diff: 0
```
oops…, if you run this code on a single core machine, maybe get what you want to see here.The gap between two varialbes’increment is so tiny that thread2 can’t capture it.So let’s enlarge the gap by using a counter array.

``` ruby
#sample2
cnt=[]
diff=0

 1000.times do
     cnt<<0
 end

 counter=Thread.new do
     loop do
         cnt.map!{|c| c+1}
     end
 end

 spy=Thread.new do
     loop do
         diff+=(cnt.first-cnt.last).abs
     end
 end

 sleep 1
 counter.exit
 spy.exit

 puts "count1: #{cnt.first}"
 puts "count2: #{cnt.last}"
 puts "diff: #{diff}"
```

No big change here. Just for thread1, we need to add 1 to 1000 instead of 2 variables in each loop this time.
```
count1: 8318
count2: 8317
diff: 5753627
```
This time thread2 capture the inconsistence.

> How to permit data inconsistence while using multi-thread?

basic idea is that thread lock the resource when access it, so other resoure can’t access the same resource until the previous thread release lock.
We can use Mutex to do this.

``` ruby
 cnt=[]
 diff=0
 mutex=Mutex.new

 1000.times do
     cnt<<0
 end

 counter=Thread.new do
     loop do
         mutex.synchronize do
             cnt.map!{|c| c+1}
         end
     end
 end

 spy=Thread.new do
     loop do
         mutex.synchronize do
             diff+=(cnt.first-cnt.last).abs
         end
     end
 end

 sleep 1
 mutex.lock

 puts "count1: #{cnt.first}"
 puts "count2: #{cnt.last}"
 puts "diff: #{diff}"
```

The block between mutex.synchronize do and end called access shared resource. When thread1 is writing cnt[], thread2 can’t read it at sametime since it’s locked.
```
count1: 15411
count2: 15411
diff: 0
```
> how to check each thread’s acual cpu usage on a multi-core machine?

Please assign a large number to sleep to let the process run longer.And utlize linux built-in ps.

``` bash
> ps -ef|grep ruby|grep -v 'grep'
ghluo    11656  8350 99 03:44 pts/18   00:00:41 ruby multi_thread.rb
> ps -p 11656 -L -o pid,tid,psr,pcpu
  PID   TID PSR %CPU
11656 11656   2  0.0
11656 11657   1  0.0
11656 11658   0 98.8
11656 11659   3  4.9
# psr is assigned cpu id
# single thread ruby program will have two threads(one is the main process, another one should be ruby interpreter i think),similarly double thread program should have 4 threads(main+interpreter+2).
```
