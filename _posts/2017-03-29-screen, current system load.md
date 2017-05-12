---
layout: post
title: config your screen, .screenrc
date: 2017-05-12 13:54:20 +0800
categories: linux
---

[screen](https://www.gnu.org/software/screen/manual/screen.html) is a multi-windown manager in terminal. 

> There is similar tool [tumx(Terminal MUltipleXer)](http://tmux.github.io/),
https://unix.stackexchange.com/questions/7453/how-to-split-the-terminal-into-more-than-one-view


This is my [.screenrc file](https://github.com/genghuiluo/legacy/blob/master/.screenrc), FYI.


[understand hardstatus/capiton](http://www.kilobitspersecond.com/2014/02/10/understanding-gnu-screens-hardstatus-strings/)

``` shell
# bottom title display
caption always "%{= kw} %H | %{kc}%?%-w%?%{kY}%n*%f %t%?(%u)%?%{= kc}%?%+w%? %=|%{kW} %l %{kw}| %{kc}%{-b}%D, %m/%d/%Y |%{kW}%{+b}%c:%s %{wk}"
```
In my [.screenrc file](https://github.com/genghuiluo/legacy/blob/master/.screenrc), I use `%l` in caption string which looks like below:

![]({{ site.url }}/assets/screen_caption.jpg)

> due to https://www.gnu.org/software/screen/manual/screen.html#String-Escapes, %l, current load of system

[The three numbers stand for average cpu load during the last minute, 5 minutes and 15 minutes where 0 means 0% load and 1.0 means 100% load.](http://stackoverflow.com/questions/18439129/system-loads-in-gnu-screens-hardstatus-line), which is same as `uptime` or `top`, [Understanding Linux CPU Load](http://blog.scoutapp.com/articles/2009/07/31/understanding-load-averages)

