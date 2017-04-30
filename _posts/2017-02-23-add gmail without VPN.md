---
layout: post
title: add gmail without VPN
date: 2017-04-28 16:45:26 +0800
categories: notes
---
**no vpn required**
> google考虑到双重验证阻碍了app的使用，所以如下：

```
What if an app stops workingNow that you have 2-Step Verification, 
you may have trouble accessing your account from some apps, such as:
“Mail” on iPhone, iPad, or Mac;

Chat clients (e.g., Adium).
To get your apps working again, you’ll need something called an application-specific password. 
Don’t worry—we’ll generate one for you, and you won’t need to remember it.
```

## On Your Mobile Mail App
> e.g. Smartisan M1
#### 1) access https://security.google.com/settings/security/apppasswords

#### 2) login your google account and generate an app password

<img src="{{ site.url }}/assets/add_gmail_1.jpg" style="width:50%;"/>

#### 3) you will get a 16 digital code

<img src="{{ site.url }}/assets/add_gmail_2.jpg" style="width:50%;"/>

#### 4) use the 16 digital code as password when you configure your mail app on you smart phone

<img src="{{ site.url }}/assets/add_gmail_3.jpg" style="width:50%;"/>

> Thanks to 自在才 @ http://bbs.smartisan.com/forum.php?mod=viewthread&tid=65676&highlight=gmail

## On Your Desktop
> e.g. ThunderBird on Linux

1. generate a app password exactly same as what we do on your mobile.
2. ‘File' -> 'New' -> 'Exsiting Mail Account'
3. **important**: change 'Authentication method' to 'Normal password' (which is 'OAuth2' by default)
