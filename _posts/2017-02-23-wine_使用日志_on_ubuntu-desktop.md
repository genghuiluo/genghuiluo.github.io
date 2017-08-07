---
layout: post
title: wine 使用日志 on ubuntu-desktop
date: 2017-02-23 17:19:22 +0800
categories: linux
---

> Most linux player use wine to run windows application, especially games(Blizzard..) 
wine is a windows sandbox(actually not monitor, it can hurt your original linux system in fact) which can run on a POSIX OS, 
also NOT virtual box(vmware/virtual box/parallel desktop)

### install wine

- [follow offical guide](https://wiki.winehq.org/Wine_User%27s_Guide) 
- [there is a ubuntu wiki, too](https://wiki.winehq.org/Ubuntuk)

```
sudo dpkg --add-architecture i386 
# which let your 64bit OS run 32bit app(i386,x86),in fact, most of windowns application can't work normally on wine in 64bin.
```

### wine basic
```
#if wine is ready
>wine --verison

##download windows app, e.g.battle.net
>wine Battle.net-Setup.exe
#at first run，～/.wine folder contain enviroment config
#your can also create different env folder. e.g. 32bit
>WINEPREFIX="$HOME/.wine_prefix32" WINEARCH=win32 wine wineboot
#switch env config with variable $WINEPREFIX
>WINEPREFIX="foler, default is ～/.wine“ wine xxx.exe
```
[wine @ubuntu中文wiki](http://wiki.ubuntu.org.cn/Wine%E7%AE%80%E6%98%8E%E6%95%99%E7%A8%8B)

### failed to run hearthstone

wine sounds easy to use，but actually not, :( oops... 
![]({{ site.url }}/assets/wine_hearthstone.png)
I really did some google search here.

1. [《how to install hearthstone on wine》](http://sysads.co.uk/2014/04/install-hearthstone-heroes-warcraft-ubuntu-wine/)，which exist a winetricks wininet bug，[meanwhile @github someone raise this issue](https://github.com/Winetricks/winetricks/issues/600)，try fix, but not work.
2. [same Q&A On stackexchange, not work](http://gaming.stackexchange.com/questions/236160/battle-net-launcher-on-wine-linux-windows-secondary-logon-service-error)
3. [Blizzar european forum，someone raise this error code, too](https://eu.battle.net/forums/en/hearthstone/topic/12618236237)

### bugs of Evernote windows client

- sync issue for 印象笔记
- stack label sync bug

### remove wine
try clean up all, there is a sample on ubuntu:
```
#if lower than ubuntu 16.04, use apt-get instead of apt
>sudo apt --purge remove wine
>sudo apt --purge remove wine-devel
>sudo apt --purge remove winetricks
>sudo add-apt-repository --remove ppa:wine/wine-builds
>sudo apt update
>sudo apt autoclean
>sudo apt clean
>sudo apt autoremove
>rm -rf $HOME/.wine
>rm -f $HOME/.config/menus/applications-merged/wine*
>rm -rf $HOME/.local/share/applications/wine
>rm -f $HOME/.local/share/desktop-directories/wine*
```
