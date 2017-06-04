---
layout: post
title: my ubuntu-desktop-manifest
date: 2017-06-04 12:11:03 +0800
categories: linux
---
### create a bootable USB flash drive from terminal with corresponding linux-desktop.iso
> get the device name of your USB with `df -h`
> e.g. /dev/sdb1

```
dd if=/path/to/linux-desktop.iso of=/dev/sdx
# not sdx1 !!
sync
eject /sdx1
```

### shadowsocks-qt5
> across great wall 

[@github](https://github.com/shadowsocks/shadowsocks-qt5)
[installation wiki](https://github.com/shadowsocks/shadowsocks-qt5/wiki/%E5%AE%89%E8%A3%85%E6%8C%87%E5%8D%97)

### chrome on linux 

[http://dl.google.com/linux/chrome/deb/](https://www.google.com/chrome/browser/desktop/index.html)

```
sudo dpkg -i google-chrome-stable_current_amd64.deb

# start chrome with a proxy 
google-chrome-stable --proxy-server="127.0.0.1:1080"

# login in google accout to sync your bookmarks and extensions
```

### 输入法

`im-config # select ibus or `

- ibus (Chinese (Pinyin))
- fcitx [sogou pinyin](http://pinyin.sogou.com/linux/?r=pinyin)

#### ibus
setting --> text entry --> add Chinese (Pinyin)

#### sogou pinyin
    
```
sudo dpkg -i ~/Downloads/sogoupinyin_2.1.0.0082_amd64.deb
sudo apt -f install # dependency
sudo dpkg -i ~/Downloads/sogoupinyin_2.1.0.0082_amd64.deb
!!restart!!
fcitx-config-gtk3 # or fcitx-configtool
# --> add input method --> sougou pinyin
```

sogou & fcitx bug
![]({{ site.url }}/assets/sogou_fcitx_bug.jpg)

### [fish](https://fishshell.com/)

### etc

> ubuntu software

- player: vlc
- downloader: deluge
- game: steam
- screenshot: shutter
- package management: synaptic package manager/GDebi package installer

> others

- [zeal](https://zealdocs.org/)
- [网易云音乐](http://music.163.com/#/download)
- [youtube-dl](https://github.com/rg3/youtube-dl)
- [you-get](https://github.com/soimort/you-get)


## developer

### Java

- jdk (http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)
- [eclipse](http://www.eclipse.org/downloads/eclipse-packages/)
    > ~/.local[/desktop]/eclipse.ini, force using gtk-2(not gtk-3)
- [maven](https://maven.apache.org/)
    > [create a Java project with Maven](http://www.mkyong.com/maven/how-to-create-a-java-project-with-maven/)
env variables

```
# fish style
set -x JAVA_HOME $HOME/jdk1.8.0_65
set -x JRE_HOME {$JAVA_HOME}/jre
set -x CLASSPATH .:{$JAVA_HOME}/lib:{$JRE_HOME}/lib
set -x PATH {$JAVA_HOME}/bin {$JRE_HOME}/bin $PATH
```

### ruby

- rvm # sometimes blocked by great wall, you can install ruby via compiling source code 
- rails
- [awesome vim](https://github.com/genghuiluo/vimrc)

### [nodejs](https://nodejs.org/en/)

### [go](http://golangtc.com/download)

env variables
```
# fish style
set -x GOROOT $HOME/go
set -x GOPATH $HOME/gopackage
set -x PATH {$GOROOT}/bin $PATH
```

### python
> built-in python and python3

[pip](http://idroot.net/tutorials/how-to-install-pip-on-ubuntu-14-04/)


### php

### [R](https://www.r-project.org/)

[Ubuntu packages for R](https://cran.r-project.org/bin/linux/ubuntu/README)

### [Octave](https://www.gnu.org/software/octave/#install)

### hadoop

- [hadoop releases](http://hadoop.apache.org/releases.html)
- [single node 伪分布](http://hadoop.apache.org/docs/r2.7.2/hadoop-project-dist/hadoop-common/SingleCluster.html)

### database

- [mysql](http://wiki.ubuntu.org.cn/MySQL%E5%AE%89%E8%A3%85%E6%8C%87%E5%8D%97)
- [sqlserver](https://docs.microsoft.com/zh-cn/sql/linux/sql-server-linux-setup-ubuntu)
    > mssql-tools : Depends: msodbcsql (>= 13.0.0.0) but it is not going to be installed depend on [Microsoft ODBC Driver for SQL Server](https://msdn.microsoft.com/zh-cn/library/hh568454(v=sql.110).aspx)

### common

- UML: 
    1. [ArgoUMl](http://argouml.tigris.org/)
    2. [UMLet](http://www.umlet.com/)
    3. [draw.io](https://www.draw.io/)
    4. [Umbrello](https://umbrello.kde.org/installation.php)
- online notebook
    1. [Evernote](https://www.evernote.com) no linux client
        - [geeknote](http://geeknote.me/documentation/)
        - [印象笔记](https://app.yinxiang.com/) _微信公众号:我的印象笔记_
    2. [wiznote](http://www.wiz.cn/) linux client
    3. [leanote](https://github.com/leanote/leanote) electron desktop



