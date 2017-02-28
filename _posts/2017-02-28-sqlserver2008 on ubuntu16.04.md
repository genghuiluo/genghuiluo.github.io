---
layout: post
title: sqlserver2008 on ubuntu16.04
date: 2017-02-23 17:19:22 +0800
categories: sqlserver
---
Although [SQLServer on Linux is under development](http://www.microsoft.com/en-us/cloud-platform/sql-server-on-linux), limit to get.

So use VM tools(Generall, VMware or VirtualBox)

### 1. Download what you need

SQLServer2008 Express Edition is free to download.

- [Microsoft® SQL Server® 2008 Express](https://www.microsoft.com/en-US/download/details.aspx?id=1695)
- [Microsoft® SQL Server® 2008 Management Studio Express](https://www.microsoft.com/en-us/download/details.aspx?id=7593)

or

- [Microsoft® SQL Server® 2008 Express with Advanced Services](https://www.microsoft.com/en-US/download/details.aspx?id=1842)
- [VMware workstation pro 12 for linux](http://www.vmware.com/products/workstation/workstation-evaluation.html)

### 2 Set up VM

#### (1) VMware
``` bash
sh VMware-Workstation-Full-12.0.1-3160714.x86_64.bundle

# since 16.04 use GTK3, you'll get the below error
# Gtk-Message: Failed to load module "canberra-gtk-module": libcanberra-gtk-module.so: cannot open shared object file: No such file or directory
https://communities.vmware.com/thread/536112?start=0&tstart=0
echo /usr/lib/vmware/lib/libglibmm-2.4.so.1 | sudo tee -a /etc/ld.so.conf.d/LD_LIBRARY_PATH.conf
sudo ldconfig

# above solution will disable system moniter
http://askubuntu.com/questions/698706/system-monitor-fails-to-launch
You are loading a library specific to VMWare, so I assume that you need to use that program, like I do.
Edit /usr/bin/vmware and add the line
export LD_LIBRARY_PATH=/usr/lib/vmware/lib/libglibmm-2.4.so.1/:$LD_LIBRARY_PATH
anywhere around the line which says set -e.
If you use VMPlayer, do the same for /etc/bin/vmplayer
Remove the file /etc/ld.so.conf.d/LD_LIBRARY_PATH.conf
Execute the command sudo ldconfig
All should work properly at this point.
```

open vmware and create a virtual machine with a OS mirror(e.g. win7 ultimate ghost iso)

wait for vmware installing “vmare tool” on your VM(AUTO FOR WINDOWS)

drag&drop above downloaded exe file into VM(guest).

#### (2) VirtualBox
```
sudo apt install virtualbox
```

open virtualbox and create a VM
```
setting->storage->optical driver->attach an OS mirror
```

start VM

To utilize drag&drop or share folder option, please insert VirtualBox Guest Addition:
```
Device->Insert Guest Addition CD image.
```

if download successfully, image will be mouted on optical driver automatically, then install with proper program(VboxWindowsAdditions-amd64 for wi7 64bit, autorun.sh for most linux)

> if you met network operation failed error, download VBoxGuestAdditions_5.0.24.iso via http://download.virtualbox.org/virtualbox/5.0.24/ , change with your VirtualBox version.
mount it with Device->Other Driver->choose disk image…

Use share folder instead of drag&drop which doesn’t perform well in VirtualBox.
```
Device->Shared folder->New(select a dir on your host, which will auto mount in guest)
```
reboot your VM, and you’ll see the share folder in guest and move downloaded exe file to share folder on host.

### 3 install SQLServer
`SQLEXPRADV_x64_CHS.exe` or `SQLEXPR_x64_CHS.exe+SQLManagementStudio_x64_CHS.exe`
