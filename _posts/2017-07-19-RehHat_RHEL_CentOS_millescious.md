---
layout: post
title: RehHat RHEL CentOS millescious
date: 2017-07-19 16:45:23 +0800
categories: linux
---
## config yum source repo (e.g. 163)

1. Use 163 repository as example, backup origin repo fisrt

    ```
    $mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
    ```

2. Dwnload source repo file from 163 mirror site, move to /etc

    ```
    $wget http://mirrors.163.com/.help/CentOS7-Base-163.repo $mv CentOS7-Base-163.repo /etc/yum.repos.d
    ```

3. upate yum with your new repo file

    ```
    $yum clean all $yum makecache  163 centos mirror wiki
    ```

> What's yum? Yellow dog Updater, Modified. Software package management tool base on rpm IN Fedora, RedHat and CentOS

*虚拟机安装问题：在virtual box中安装完镜像文件后，要更新yum源，否则无法安装virtualbox additions*

## add sudoer

> Error msg "xxx is not in thesudoers file". 
This incident will be reported when you try to use sudo. 
You need to modify /etc/sudoers to assign sudo permission to xxx. 

```
#switch to root
su -  

cd /etc
#add write permission to sudoers file
chmod u+w sudoers 
vi sudoers 
#add "xxxALL=(ALL) ALL"(xxx is your username) 

chmod u-v sudoers 
#revoke write permission 

su xxx 
#switch to your accout, now you can use sudo.
```

sudo是linux系统中，非root权限的用户提升自己权限来执行某些特性命令的方式，它使普通用户在不知道root的密码的情况下，也可以暂时的获得root权限。

一般，普通用户在执行特殊命令是，只需要在特殊命令（如 yum）前面加上sudo，并输入自己的用户密码就可以了，在之后的5分钟内，再次使用特殊命令时，就无需再次输入用户密码。

同时，sudo提供了强大的日志管理，其中(/var/log/sudo.log or auth.log...)详细的记录了每个用户都干了什么。

sudo用户的管理是在文件：/etc/sudoers中存放的。也就是说，如果想把某个用户加入到sudo用户群里面，就需要自行配置这个文件，在读写这个文件时，需要root的权限。


## rhel7 with docker

[minial rhel7 image on docker hub](https://hub.docker.com/r/richxsl/rhel7)

- pull & run this image, change to [alibaba yum repo](https://github.com/genghuiluo/legacy/blob/master/centos/Centos-7.repo) (**change $releasever to specified version, e.g 7, if met 404 ERROR**)
- `yum makecache`
- copy [mkimage-yum.sh](https://github.com/genghuiluo/legacy/blob/master/centos/mkimage-yum.sh) to image, `./mkimage-yum.sh rhel7_docker` to generate a image named rhel7_docker.tar.gz
- `docker import rhel7_docker.tar.gz` & `docker tag <image_id> your_username/repo:tag`
- `docker run -it your_username/repo:tag /bin/bash`

