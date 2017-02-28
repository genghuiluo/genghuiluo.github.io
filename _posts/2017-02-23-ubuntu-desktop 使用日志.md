---
layout: post
title: ubuntu-desktop 使用日志
date: 2017-02-23 17:19:22 +0800
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


