---
layout: post
title: manage your disk on linux
date: 2017-04-30 14:58:15 +0800
categories: linux
---

### df / du sample usage

> [私房菜]常见的装置在Linux中的档名：

| 装置                | 装置在Linux内的档名                       |
|---------------------|-------------------------------------------|
| IDE硬盘机           | /dev/hd[a-d]                              |
| SCSI/SATA/U盘硬盘机 | /dev/sd[a-p]                              |
| U盘快闪碟           | /dev/sd[a-p](与SATA相同)                  |
| 软盘机              | /dev/fd[0-1]                              |
| 打印机              | 25针: /dev/lp[0-2] U盘: /dev/usb/lp[0-15] |
| 鼠标                | U盘: /dev/usb/mouse[0-15] PS2: /dev/psaux |
| 当前CDROM/DVDROM    | /dev/cdrom                                |
| 当前的鼠标          | /dev/mouse                                |
| 磁带机              | IDE: /dev/ht0 SCSI: /dev/st0              |

#### df
report file system disk space usage.

Usage: df [options] [file]

如果没有指定file，则显示全部挂载的filesystem(已经格式化的分区）磁盘空间使用状态。
```
> df
Filesystem     1K-blocks      Used Available Use% Mounted on
udev             4028752         4   4028748   1% /dev
tmpfs             807888      1592    806296   1% /run
/dev/sda2      237648544 139105000  86448568  62% /
none                   4         0         4   0% /sys/fs/cgroup
none                5120         0      5120   0% /run/lock
none             4039424    185156   3854268   5% /run/shm
none              102400        36    102364   1% /run/user
/dev/sda1         191551      3440    188112   2% /boot/efi
```
/dev/sda2 是MBR分区表的命名方式，/dev/sda表示总线识别到的第一个SCSI类硬盘，/dev/sda1代表该硬盘的第一个分区
如果指定了file，则只显示file所在filesystem的
```
> df /tmp
Filesystem                                             1K-blocks      Used Available Use% Mounted on
/dev/disk/by-uuid/9f4776f2-400e-4725-a64e-e61e2ddd8020 237648544 139102512  86451056  62% /
```
/dev/disk/by-uuid/xxx同样也是一个分区的名字，只不过不过它是GPT的命名方式

df命令各个选项的含义如下：
- -a：显示所有文件系统的磁盘使用情况，包括0块（block）的文件系统，如/proc文件系统。
- -k：以k字节为单位显示。
- -i：显示inode信息，而不是磁盘块，什么是inode?
- -t：显示各指定类型的文件系统的磁盘空间使用情况。
- -x：列出不是某一指定类型文件系统的磁盘空间使用情况（与t选项相反）。
- -T：显示文件系统类型。
- -h：人类可读的显示（以K/M/G显示大小）

#### du
disk used，统计目录/文件所占磁盘空间的大小

du命令的各个选项含义如下：
- -s：对每个Names参数只给出占用的数据块总数。
- -a：递归地显示指定目录中各文件及子目录中各文件占用的数据块数。若既不指定-s，也不指定-a，则只显示Names中的每一个目录及其中的各子目录所占的磁盘块数。
- -b：以字节为单位列出磁盘空间使用情况（系统默认以k字节为单位）。
- -k：以1024字节为单位列出磁盘空间使用情况。
- -c：最后再加上一个总计（系统默认设置）。
- -l：计算所有的文件大小，对硬链接文件，则计算多次。
- -x：跳过在不同文件系统上的目录不予统计(不同文件系统计方式不同）。

```
#查看当前目录下，一级目录/文件的大小（如果要展开所有目录，请用-a替换-s）
> du -sh * .[!.]*
4.0K    Desktop
2.0G    Documents
11G Downloads
266M    eclipse
7.6M    github
4.0K    Music
383M    Pictures
4.0K    practive~
4.0K    Public
4.0K    Templates
17M test
3.8G    Videos
84G vmware
1.2G    workspace
```

> 加上.[!.]*是为了看到以dot(.)开头的文件或者目录的大小,
因为bash本身无法识别RE（Regular Expression），而使用wildcard， 
这种匹配方式和RE有很多不同，例如asterisk(*)无法匹配dot(.)。

### fdisk demo
fdisk可以划分磁盘分区，仅仅支持MBR分区表不支持GPT(GUID Partition Table)

> parted 可以用来创建GPT分区表

```
$fdisk /dev/hda    //使用/dev/hda作为分区硬盘（第一个IDE介面）
Command (m for help): m  //查看fdisk所有命令
Command action
   a   toggle a bootable flag
   b   edit bsd disklabel
   c   toggle the dos compatibility flag
   d   delete a partition
   l   list known partition types
   m   print this menu
   n   add a new partition
   o   create a new empty DOS partition table
   p   print the partition table
   q   quit without saving changes
   s   create a new empty Sun disklabel
   t   change a partition's system id
   u   change display/entry units
   v   verify the partition table
   w   write table to disk and exit
   x   extra functionality (experts only)
```
fdisk有很多参数，可是经常使用的只有几个。
在Linux分区过程，一般是先通过p参数来显示硬盘分区表信息，然后根据信息确定将来的分区。如下所示：
```
Disk /dev/sda: 4294 MB, 4294967296 bytes
255 heads, 63 sectors/track, 522 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
   Device Boot    Start       End    Blocks   Id  System
/dev/hda1   *        41       522   3871665   83  Linux
/dev/hda2             1        40    321268+  82  Linux swap

Partition table entries are not in disk order
Command (m for help):
```
如果想完全改变硬盘的分区格式，就可以通过d参数一个一个地删除存在的硬盘分区。删除完毕，就可以通过n参数来增加新的分区。当按下“n”后，可以看到如下所示：
```
Command (m for help): n
Command action
   e   extended
   p   primary partition (1-4)
   p
   Partiton number(1-4):1
   First cylinder(1-1023):1
   Last cylinder or + size or +sizeK or + sizeM(1-1023):+258M
```
这里要选择新建的分区类型，是主分区还是扩展分区；并选择p或是e。然后就是设置分区的大小。

要提醒注意的是，如果硬盘上有扩展分区，就只能增加逻辑分区，不能增加扩展分区

在增加分区的时候，其类型都是默认的Linux Native，如果要把其中的某些分区改变为其他类型，例如Linux Swap或FAT32等，可以通过命令t来改变，当按下“t”改变分区类型的时候，系统会提示要改变哪个分区、以及改变为什么类型（如果想知道系统所支持的分区类型，键入l），如下所示：
```
Command (m for help): t
Partition number (1-4): 1
Hex code (type L to list codes): 82
Changed system type of partition 1 to 82 (Linux swap)
```
改变完了分区类型，就可以按下“w”，保存并退出。如果不想保存，那么可以选择“q”直接退出。

### mkfs/mount
分区创建完了需要格式化分区,才能被挂载到某个目录
`$mkfs -t 文件系统 存储设备`

这里的文件系统是要指定的，比如 ext3 ；reiserfs ；ext2 ；fat32 ；msdos 等

设备比如是一个硬盘的分区，软盘，光驱等

挂载有两种方式：
1. 修改分区分文件
    
    ```
    echo ‘/dev/xvdb1 /mnt ext3 defaults 0 0’ >> /etc/fstab
    #（ubuntu 的格式有所区别）
    # 使用“mount -a”命令挂载新分区
    ```

2. 直接使用mount

    `mount 挂载文件 [-t 文件系统 ] [-o 选项] 设备 目录`

    > 注： -t 通过这个参数，我们来指定文件系统的类型，
    一般的情况下不必指定有时也能识加，-t 后面跟 ext3 、ext2 、reiserfs、vfat 、ntfs 等，
    其中 vfat 是fat32和fat16分区文件系统所所用的参数；
    如果忘记了文件系统，也可以在-t 后面加auto;
    -o 这个选项，主要选项有权限、用户、磁盘限额、语言编码等，但语言编码的选项，大多用于vfat和ntfs文件系统；

    > 设备 指存储设备，比如/dev/hda1， /dev/sda1 ，cdrom 等
