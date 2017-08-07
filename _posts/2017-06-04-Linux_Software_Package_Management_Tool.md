---
layout: post
title: Linux Software Package Management Tool
date: 2017-06-04 17:04:04 +0800
categories: linux
---
### apt-get (Ubuntu)

> you can replace 'apt-get' with 'apt' since Ubuntu16.04(LST)

- apt-cache search package 搜索包
- apt-cache show package 获取包的相关信息，如说明、大小、版本等
- sudo apt-get install package 安装包
- sudo apt-get install package - - reinstall 重新安装包
- sudo apt-get -f install 修复安装"-f = ——fix-missing"
- sudo apt-get remove package 删除包
- sudo apt-get remove package - - purge 删除包，包括删除配置文件等
- sudo apt-get update 更新源
- sudo apt-get upgrade 更新已安装的包
- sudo apt-get dist-upgrade 升级系统
- sudo apt-get dselect-upgrade 使用 dselect 升级
- apt-cache depends package 了解使用依赖
- apt-cache rdepends package 是查看该包被哪些包依赖
- sudo apt-get build-dep package 安装相关的编译环境
- apt-get source package 下载该包的源代码
- sudo apt-get clean && sudo apt-get autoclean 清理无用的包
- sudo apt-get check 检查是否有损坏的依赖

### dpkg (Debian & Ubuntu)

...


### yum

> yum（全称为 Yellow dog Updater, Modified）是一个在Fedora和RedHat以及SUSE中的Shell前端软件包管理器。

> 基於RPM包管理，能够从指定的服务器自动下载RPM包并且安装，可以自动处理依赖性关系，并且一次安装所有依赖的软体包，无须繁琐地一次次下载、安装

```
# yum的命令形式一般是如下：
yum [options] [command] [package ...]

# 其中的[options]是可选的，选项包括-h（帮助），-y（当安装过程提示选择全部为"yes"），-q（不显示安装的过程）等等。
# [command]为所要进行的操作，[package ...]是操作的对象。

```

概括了部分常用的命令包括：

- 自动搜索最快镜像插件：   yum install yum-fastestmirror
- 安装yum图形窗口插件：    yum install yumex
- 查看可能批量安装的列表： yum grouplist

1. 安装

    ```
    yum install 全部安装
    yum install package1 安装指定的安装包package1
    yum groupinsall group1 安装程序组group1
    ```

2. 更新和升级

    ```
    yum update 全部更新
    yum update package1 更新指定程序包package1
    yum check-update 检查可更新的程序
    yum upgrade package1 升级指定程序包package1
    yum groupupdate group1 升级程序组group1
    ```

3. 查找和显示

    ```
    yum info package1 显示安装包信息package1
    yum list 显示所有已经安装和可以安装的程序包
    yum list package1 显示指定程序包安装情况package1
    yum groupinfo group1 显示程序组group1信息yum search string 根据关键字string查找安装包
    ```

4. 删除程序
    
    ```
    yum remove|erase package1 删除程序包package1
    yum groupremove group1 删除程序组group1
    yum deplist package1 查看程序package1依赖情况
    ```

5. 清除缓存

    ```
    yum clean packages 清除缓存目录下的软件包
    yum clean headers 清除缓存目录下的 headers
    yum clean oldheaders 清除缓存目录下旧的 headers
    yum clean, yum clean all (= yum clean packages; yum clean oldheaders) 清除缓存目录下的软件包及旧的headers
    ```

### rpm (redhat package manager)
