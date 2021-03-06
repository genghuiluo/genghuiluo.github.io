---
layout: post
title: linux filesystem inode
date: 2017-02-23 17:19:22 +0800
categories: linux
---
### what's inode in linux?

> 文件储存在硬盘上，硬盘的最小存储单位叫做"扇区"（Sector）。
每个扇区储存512字节（相当于0.5KB）。
操作系统读取硬盘的时候，不会一个个扇区地读取，这样效率太低，而是一次性连续读取多个扇区，即一次性读取一个"块"（block）。
这种由多个扇区组成的"块"，是文件存取的最小单位。
"块"的大小，最常见的是4KB，即连续八个sector组成一个block。
文件数据都储存在"块"中，那么很显然，我们还必须找到一个地方储存文件的元信息，比如文件的创建者、文件的创建日期、文件的大小等等。
这种储存文件元信息的区域就叫做inode。

<img src="{{ site.url }}/assets/inode_0.JPG" style="width:300px;height:450px;">

inode包含文件的元信息，具体来说有以下内容: 

* 文件的字节数 
* 文件拥有者的User ID 
* 文件的Group ID 
* 文件的读、写、执行权限 
* 文件的时间戳，共有三个：ctime指inode上一次变动的时间，mtime指文件内容上一次变动的时间，atime指文件上一次打开的时间。 
* 链接数，即有多少文件名指向这个inode 
* 文件数据block的位置 

可以用stat命令，查看某个文件的inode信息： 总之，除了文件名以外的所有文件信息，都存在inode之中。

![]({{ site.url }}/assets/inode_1.png)

inode也会消耗硬盘空间，所以硬盘格式化的时候，操作系统自动将硬盘分成两个区域。一个是数据区，存放文件数据；另一个是inode区（inode table），存放inode所包含的信息。
每个inode节点的大小，一般是128字节或256字节。inode节点的总数，在格式化时就给定，一般是每1KB或每2KB就设置一个inode。

> 假定在一块1GB的硬盘中，每个inode节点的大小为128字节，每1KB就设置一个inode，那么inode table的大小就会达到128MB，占整块硬盘的12.8%。 

查看每个硬盘分区的inode总数和已经使用的数量，可以使用df命令。 

![]({{ site.url }}/assets/inode_2.png)

每个inode都有一个号码，操作系统用inode号码来识别不同的文件。 这里值得重复一遍，Unix/Linux系统内部不使用文件名，而使用inode号码来识别文件。
对于系统来说，文件名只是inode号码便于识别的别称或者绰号。 

表面上，用户通过文件名，打开文件。实际上，系统内部这个过程分成三步：

    1. 系统找到这个文件名对应的inode号码；
    2. 通过inode号码，获取inode信息；
    3. 根据inode信息，找到文件数据所在的block，读出数据。 
    
使用ls -i命令，可以看到文件名对应的inode号码：

![]({{ site.url }}/assets/inode_3.png)

### inode 与 link

#### hard link
一般情况下，文件名和inode号码是"一一对应"关系，每个inode号码对应一个文件名。
但是，Unix/Linux系统允许，多个文件名指向同一个inode号码。 这意味着，可以用不同的文件名访问同样的内容；对文件内容进行修改，会影响到所有文件名；但是，删除一个文件名，不影响另一个文件名的访问。
这种情况就被称为"硬链接"（hard link）。 

    `ln命令可以创建硬链接： ln 源文件 目标文件`
    
![]({{ site.url }}/assets/inode_4.png)

源文件与目标文件的inode号码相同，都指向同一个inode。
inode信息中有一项叫做"链接数"，记录指向该inode的文件名总数，这时就会增加1。
反过来，删除一个文件名，就会使得inode节点中的"链接数"减1。

> 当这个值减到0，表明没有文件名指向这个inode，系统就会回收这个inode号码，以及其所对应block区域。(删除文件的机理）

> 这里顺便说一下目录文件的"链接数"。创建目录时，默认会生成两个目录项："."和".."。
前者的inode号码就是当前目录的inode号码，等同于当前目录的"硬链接"；后者的inode号码就是当前目录的父目录的inode号码，等同于父目录的"硬链接"。

> 所以，任何一个目录的"硬链接"总数 = 2（本身"."和父目录指向ta）+ 它的子目录总数（含隐藏目录）。 

#### symbalic link
除了硬链接以外，还有一种特殊情况。

> 文件A和文件B的inode号码虽然不一样，但是文件A的内容是文件B的路径。
读取文件A时，系统会自动将访问者导向文件B。因此，无论打开哪一个文件，最终读取的都是文件B。 
这意味着，文件A依赖于文件B而存在，如果删除了文件B，打开文件A就会报错："No such file or directory"。
这是软链接与硬链接最大的不同：文件A指向文件B的文件名，而不是文件B的inode号码，文件B的inode"链接数"不会因此发生变化。
也意味着A和B可以是完全不同文件系统。 

    `ln -s命令可以创建软链接。 ln -s 源文文件或目录 目标文件或目录`

![]({{ site.url }}/assets/inode_5.png)

### inode的特殊作用 
由于inode号码与文件名分离，这种机制导致了一些Unix/Linux系统特有的现象。 

1. 有时，文件名包含特殊字符，无法正常删除。这时，直接删除inode节点，就能起到删除文件的作用。 
2. 移动文件或重命名文件，只是改变文件名，不影响inode号码。 
3. 打开一个文件以后，系统就以inode号码来识别这个文件，不再考虑文件名。因此，通常来说，系统无法从inode号码得知文件名。
    > 第3点使得软件更新变得简单，可以在不关闭软件的情况下进行更新，不需要重启。
    > 因为系统通过inode号码，识别运行中的文件，不通过文件名。更新的时候，新版文件以同样的文件名，生成一个新的inode，不会影响到运行中的文件。
    > 等到下一次运行这个软件的时候，文件名就自动指向新版文件，旧版文件的inode则被回收。
