---
layout: post
title: start Docker on win10
date: 2017-07-21 11:13:29 +0800
categories: docker
---

[docker CE(community edtion)](https://store.docker.com/editions/community/docker-ce-desktop-windows)

[follow by steps](https://docs.docker.com/docker-for-windows/install/#install-docker-for-windows)

*two key factors*
1. [enable Hyper-V in windows feature](https://docs.docker.com/docker-for-windows/troubleshoot/#hyper-v)
2. [enable intel virtual technology in BIOS](https://docs.docker.com/docker-for-windows/troubleshoot/#virtualization-must-be-enabled)

Get Started...

<img src="{{ site.url }}/assets/docker_win10_1.jpg" style="width:100%" />
> [what's alpine?](https://docs.docker.com/samples/alpine/)
<img src="{{ site.url }}/assets/docker_win10_2.jpg" style="width:40%" />

[Containers: Running instances of an Image](http://odewahn.github.io/docker-jumpstart/containers.html)

> For interactive processes (like a shell), you must use -i -t together in order to allocate a tty for the container process.

``` bash
PS C:\Users\chinacscs> docker run -it ubuntu:latest /bin/bash
Unable to find image 'ubuntu:latest' locally
latest: Pulling from library/ubuntu
75c416ea735c: Pull complete
c6ff40b6d658: Pull complete
a7050fc1f338: Pull complete
f0ffb5cf6ba9: Pull complete
be232718519c: Pull complete
Digest: sha256:a0ee7647e24c8494f1cf6b94f1a3cd127f423268293c25d924fbe18fd82db5a4
Status: Downloaded newer image for ubuntu:latest
root@0e9cba9b9e1f:/# bash --version
bash --version
GNU bash, version 4.3.48(1)-release (x86_64-pc-linux-gnu)
Copyright (C) 2013 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>

This is free software; you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
root@0e9cba9b9e1f:/# ll
ll
rwxr-xr-x   1 root root 4096 Jun 20 23:18 var/
```

Copying files from host to Docker container

<img src="{{ site.url }}/assets/docker_win10_3.jpg" style="width:80%" />

### connect to oracle instance inside docker
`docker run -it --shm-size 2g -m 4g --memory-swap 8g --expose 1521 -p 1521:1521 --hostname oracle genghuiluo/rhel7:oracle_11g_r2 /bin/bash`

```
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=EXTPROC1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=oracle)(PORT=1521)))
```

enable docker in Cygwin
```
ln /cygdrive/c/Program\ Files/Docker/Docker/resources/bin/docker.exe /usr/bin/docker
```
