---
layout: post
title: use MPICH bulid a sample cluster
date: 2017-02-23 17:19:22 +0800
categories: linux
---
### [wiki](http://mpitutorial.com/tutorials/running-an-mpi-cluster-within-a-lan/)

### parallel program interface 

> e.g. [MPI](https://www.mpich.org/) 
MPICH (MPI implementations for FORTRAN, C, and C++)

### Setup Details:
#### (1) all you need to install is mpich:(e.g. ubuntu) – simple..

`sudo apt-get install mpich `

#### (2) launch a bunch of instances

#### (3) edit hosts file on master&slave add all ip into master hosts file
```
geluo@facebook-core-7868:~$ sudo cat /etc/hosts
[sudo] password for geluo:
127.0.0.1 localhost
10.149.255.xxx facebook-core-7868.lvs02.dev.ebayc3.com facebook-core-7868
10.149.255.xxx master
10.14x.211.xxx backup
10.x.248.xxx slave1
10.148.248.xxx slave2
10.148.248.xx6 slave3
10.xxx.248.xx7 slave4
10.147.211.xxx slave5
```
add master ip into slave hosts file.. 

#### (4) add pubkey of master node to each slave
```
geluo@facebook-core-7868:~$ ssh geluo@slave1 'cat /home/geluo/.ssh/authorized_keys'
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDNUNY9bUKLlWno1CMen/1ZJDqKP73eCt...
```

#### (5) have a try with mpirun on master
```
geluo@facebook-core-7868:~$ mpirun -np 7 -host master,backup,slave1,slave2,slave3,slave4,slave5 hostname
facebook-core-7868
facebook-salve-std4-4653
facebook-salve-6665
facebook-salve-std5-8621
facebook-salve-std3-4646
facebook-salve-std2-6641
facebook-salve-std1-763
```

#### (6) share folder between master/slave install NFS server on master

`sudo apt-get install nfs-kernel-server`

export your share foler

```
geluo@facebook-core-7868:~$ cat /etc/exports
/mnt/shared *(rw,sync,no_root_squash,no_subtree_check)
$ exportfs -a
```

install NFS client on slave

```
$ sudo apt-get install nfs-common
$ sudo mount -t nfs master:/mnt/shared  /mnt/shared
geluo@facebook-salve-std1-7635:~$ df -hT
Filesystem Type Size Used Avail Use% Mounted on
udev devtmpfs 5.9G 12K 5.9G 1% /dev
tmpfs tmpfs 1.2G 392K 1.2G 1% /run
/dev/disk/by-label/cloudimg-rootfs ext4 57G 1.5G 53G 3% /
none tmpfs 4.0K 0 4.0K 0% /sys/fs/cgroup
none tmpfs 5.0M 0 5.0M 0% /run/lock
none tmpfs 5.9G 0 5.9G 0% /run/shm
none tmpfs 100M 0 100M 0% /run/user
/dev/vdb vfat 64M 34K 64M 1% /mnt
master:/mnt/shared nfs4 591G 19G 542G 4% /mnt/shared
```
