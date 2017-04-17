---
layout: post
title: ubuntu utilize CISCO AnyConnect without Client
date: 2017-04-14 23:19:30 +0800
categories: linux
---

```
sudo apt install openconnect network-manager-openconnect network-manager-openconnect-gnome


# by terminal
$ openconnect -v -u xxx https://xxx.xxx.xxx.xxx

```

by gnome,
1. System -> Network -> Create VPN connection -> select 'Cisco AnyConnect Compatible VPN(openconnect)',
2. Enter Getway (ip or domain)
    > ip don't allow any protocol(e.g. https://), this will cause 'Invalid Host Entry' Error
3. Keep others by default, Save, connect the VPN connection that you just created.
