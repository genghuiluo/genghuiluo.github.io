---
layout: post
title: ubuntu-desktop My Usage Log
date: 2017-04-22 13:14:20 +0800
categories: linux
---
## ubuntu(>=15.10) 笔记本键盘背光bug

> 硬件：Dell Inspiron/XPS, Tinkpad…  
描述：开机或者从休眠状态返回时，笔记本背光自动开启，BIOS设置keyword lightness off，无效  
  
可能的原因：Dell/lenovo 的hardware module不匹配新版本的linux kernel  
解决方法：编辑 `/etc/dbus-1/system.d/org.freedesktop.UPower.conf`
  
修改：

```
    <allow send_destination="org.freedesktop.UPower"
               send_interface="org.freedesktop.UPower.KbdBacklight"/>
```

为

```
    <deny send_destination="org.freedesktop.UPower"
               send_interface="org.freedesktop.UPower.KbdBacklight"/>
```
                              
重启

reference：https://askubuntu.com/questions/700069/keyboard-backlight-turns-on-after-lock-screen-display-on

## ubuntu(15.10) 更新后无法播放声音bug

1. [Failed] 打开system setting —— sounds
    发现output只有HDMI/DisplayPort，没有识别notebook的speaker
2. [Failed] 安装PulseAudio Volume Control program
       
    ```
    $ sudo apt-get install pavucontrol
    $ pavucontrol
    #可以发现output device中仍然无法找到speaker
    ```

3. [Failed] 重新安装 alsa 和 pulse audio
    
    ``` 
    $sudo apt-get remove --purge alsa-base pulseaudio
    $sudo apt-get install alsa-base pulseaudio
    
    #重启alsa
    $sudo alsa force-reload
    #尝试播放声音依然没有反应
    ```

4. [Success] 修改 alsa-base.conf

    ```
    #强制结束掉所有在运行的pulseaudio的进程
    $killall pulseaudio(或者$pulseaudio -k)
    #编辑alsa-base的配置文件
    $sudo vi /etc/modprobe.d/alsa-base.conf
    # 在最后一行加上： options snd-hda-intel model=generic
    # Reboot，声音恢复，speaker在pavucontrol的output device里重新出现。
    ```              

[ubuntu support Q&A](https://help.ubuntu.com/community/SoundTroubleshootingProcedure)

## ubuntu(16.04) 使用Dell D3100 拓展坞 多屏显示

Dell D3100 use a USB3.0 to connect with your PC.
So you need to down load a driver of [DisplayLink](http://www.displaylink.com/products/universal-docking-stations) via http://www.displaylink.com/downloads/ubuntu

> right-click, then save as

[How to install DisplayLink software on Ubuntu?](http://support.displaylink.com/knowledgebase/articles/684649-how-to-install-displaylink-software-on-ubuntu)

## ubuntu(16.04) “The system is running in low-graphics mode” error? 
<img src="{{ site.url }}/assets/ubuntu-desktop_1.png" style="width:500px">

The error happend after I installed not “official” Mesa PPA([Stable Mesa PPA Offers Latest Drivers on Ubuntu](http://www.omgubuntu.co.uk/2016/12/stable-mesa-drivers-ubuntu-ppa) to solve Octave's crash bug.

To fix these use the PPA Purge tool to downgrade back to the Ubuntu archive’s older.

[AskUbuntu](http://askubuntu.com/questions/307/how-can-ppas-be-removed)

Use the `--remove` flag, similar to how the PPA was added:
`sudo add-apt-repository --remove ppa:whatever/ppa`

As a safer alternative, you can install ppa-purge:
`sudo apt-get install ppa-purge`

And then remove the PPA, downgrading gracefully packages it provided to packages provided by official repositories:
`sudo ppa-purge ppa_name`

Note that this will uninstall packages provided by the PPA, but not those provided by the official repositories. If you want to remove them, you should tell it to apt:
`sudo apt-get purge package_name`

You can also remove PPAs by deleting the .list files from /etc/apt/sources.list.d directory.

Last but not least, you can also disable or remove PPAs from the "Software Sources" section in Ubuntu Settings with a few clicks of your mouse (no terminal needed).

## display hardware temperature

[Psensor – A Graphical Hardware Temperature Monitoring Tool for Linux](http://www.tecmint.com/psensor-monitors-hardware-temperature-in-linux/)

## single mini-DP port + MST = multi screen display
> You don't need multi mini-DP ports or a dock.
> If you have daisy-chaining Dell U2415 monitors on Intel HD Graphics, 
> ubuntu 14.10/15.04+ appears to be supporting MST for Intel graphics out of the box.

[(Dell KB) configure MST](http://www.dell.com/support/article/us/en/19/SLN295251/how-to-configure-u2415-monitor-daisy-chaining-on-intel-hd-graphics?lang=EN)

<img src="{{ site.rul }}/assets/MST_1.jpg" style="width:40%">
<img src="{{ site.rul }}/assets/MST_2.jpg" style="width:40%">

## utilize CISCO AnyConnect without Clien

```                                                                                                      
$ sudo apt install openconnect network-manager-openconnect network-manager-openconnect-gnome               

# by terminal                                                                                            
$ openconnect -v -u xxx https://xxx.xxx.xxx.xxx                                                          
``` 

by gnome desktop, 
1. System -> Network -> Create VPN connection -> select 'Cisco AnyConnect Compatible VPN(openconnect)',  
2. Enter Getway (ip or domain)                                                                           
	> ip don't allow any protocol(e.g. https://), this will cause 'Invalid Host Entry' Error          
3. Keep others by default, Save, connect the VPN connection that you just created. 
