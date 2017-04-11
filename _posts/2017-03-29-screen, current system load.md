---
layout: post
title: screen, current system load
date: 2017-04-09 16:06:51 +0800
categories: linux
---

In my [.screenrc file](https://github.com/genghuiluo/legacy/blob/master/.screenrc), I use `%l` in caption string.


```
# bottom title display
caption always "%{= kw} %H | %{kc}%?%-w%?%{kY}%n*%f %t%?(%u)%?%{= kc}%?%+w%? %=|%{kW} %l %{kw}| %{kc}%{-b}%D, %m/%d/%Y |%{kW}%{+b}%c:%s %{wk}"
```

![]({{ site.url }}/assets/screen_caption.jpg)


due to https://www.gnu.org/software/screen/manual/screen.html#String-Escapes

%l, current load of system

[The three numbers stand for average cpu load during the last minute, 5 minutes and 15 minutes where 0 means 0% load and 1.0 means 100% load.](http://stackoverflow.com/questions/18439129/system-loads-in-gnu-screens-hardstatus-line)

which is same as `uptime` or `top`, [Understanding Linux CPU Load](http://blog.scoutapp.com/articles/2009/07/31/understanding-load-averages)

