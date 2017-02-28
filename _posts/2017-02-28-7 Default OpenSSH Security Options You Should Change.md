---
layout: post
title: 7 Default OpenSSH Security Options You Should Change
date: 2017-02-23 17:19:22 +0800
categories: linux
---
### 7 Default OpenSSH Security Options You Should Change in /etc/ssh/sshd_config

#### 1. Disable Root Login (PermitRootLogin)

By default you can ssh to the server as root. It is best not to allow root to login directly to the server. Instead, you should login to the system as your account and then do ‘su -‘ to login as root.

If you have multiple sysadmins in your organization, and if they all login to the server directly as root, you might not know which sysadmin logged in as root. Instead, if you disable login as root, sysadmins are forced to login as their account first, before they can do ‘su -‘, this makes the auditing easier.

Add the following entry to sshd_config to disable root to login to the server directly.
```
$ vi /etc/ssh/sshd_config
PermitRootLogin no
```
#### 2. Allow Only Specific Users or Groups (AllowUsers AllowGroups)

By default anybody who is authenticated successfully are allowed to login. Instead you can restrict which users (or groups) you allow to login to the system.

This is helpful when you have created several user accounts on the system, but want only few of them to login.

This is also helpful when you are using NIS, openLDAP (or some other external system) for authentication. Every user in your company might have account on NIS, OpenLDAP etc. But, on a specific server you want only few of them to login. For example, on production system you want only sysadmins to login.

Add the following entry to the sshd_config file to allow only specific users to login to the system. In the example below only ramesh, john and jason can login to this system. Usernames should be separated by space.
```
$ vi /etc/ssh/sshd_config
AllowUsers ramesh john jason
Add the following entry to the sshd_config file to allow only the users who belong to a specific group to login. In the exampe below only users who belong to sysadmin and dba group can login to the system.

$ vi /etc/ssh/sshd_config
AllowGroups sysadmin dba
```
#### 3. Deny Specific Users or Groups (DenyUsers DenyGroups)

Instead of allowing specific users (or groups), you can also deny specific users or groups.

Add the following entry to the sshd_config file to deny specific users to login to the system. In the example below cvs, apache, jane cannot login to this system. Usernames should be separated by space.
```
$ vi /etc/ssh/sshd_config
DenyUsers cvs apache jane
Add the following entry to the sshd_config file to deny users who belong to a specific group to login. In the exampe below users who belong to developers and qa group cannot login to the system.

$ vi /etc/ssh/sshd_config
DenyGroups developers qa
```

> Note: You can use combination of all the Allow and Deny directivies. It is processed in this order: DenyUsers, AllowUsers, DenyGroups, and finally AllowGroups

#### 4. Change SSHD Port Number (Port)

By default ssh runs on port 22. Most of the attackers will check if a server is open on port 22, and will randomly use brute force to login to the server using several username and password combination.

If you change the port # to something different, others need to know exactly what port to use to login to the server using ssh. The exampe below uses port 222 for ssh.
```
$ vi /etc/ssh/sshd_config
Port 222
```
From your logs (/var/log/secure), if you see lot of invalid logins using ssh for accounts that don’t exist on your system, from the
ip-address that you don’t recognize, it migth be some brute-force attack. Those kind of ssh invalid login will stop, if you change the port number.

Please note that this causes little inconvenience to your team who login to the system, as they need to know both the ip-address and the port number.

#### 5. Change Login Grace Time (LoginGraceTime)

When you ssh to a server, you have 2 minutes to login. If you don’t successfully login within 2 minutes, ssh will disconnect.
2 minutes time to login successfully is too much. You should consider changing it to 30 seconds, or may be 1 minute.

Add the following entry to the sshd_config file to change the login grace time from 2 minutes to 1 minute.
```
$ vi /etc/ssh/sshd_config
LoginGraceTime 1m
``` 
#### 6. Restrict the Interface (IP Address) to Login (ListenAddress)

If you have multiple interfaces on the server that are configured to different ip-address, you might not want everybody to login to the server using all those ip-address.

Let us assume that you have the following 4 interfaces on the server:

- eth0 – 192.168.10.200
- eth1 – 192.168.10.201
- eth2 – 192.168.10.202
- eth3 – 192.168.10.203

By default ssh will listen on all of the above ip-addresses. If you want users to login only using ip-address 200 and 202, do the following in your sshd_config
```
$ vi /etc/ssh/sshd_config
ListenAddress 192.168.10.200
ListenAddress 192.168.10.202
```
#### 7. Disconnect SSH when no activity (ClientAliveInterval)

Once you’ve successfully logged in to the system, you might want to get disconnected when there are no activities after x number of minutes. This is basically idle timeout.

In Bash, you can achieve this using [TMOUT variable](http://www.thegeekstuff.com/2010/05/tmout-exit-bash-shell-when-no-activity/).

In OpenSSH, this can be achieved by combining ClientAliveCountMax and ClientAliveInterval options in sshd_config file.

- ClientAliveCountMax – This indicates the total number of checkalive message sent by the ssh server without getting any response from the ssh client. Default is 3.
- ClientAliveInterval – This indicates the timeout in seconds. After x number of seconds, ssh server will send a message to the client asking for response. Deafult is 0 (server will not send message to client to check.).

If you want ssh client to exit (timeout) automatically after 10 minutes (600 seconds), modify the sshd_config file and set the following two parameters as shown below.
```
$ vi /etc/ssh/sshd_config
ClientAliveInterval 600
ClientAliveCountMax 0
```

### SSH login without password

> Your aim:

You want to use Linux and OpenSSH to automate your tasks. Therefore you need an automatic login from host A / user a to Host B / user b. You don't want to enter any passwords, because you want to call ssh from a within a shell script.

> How to do it?

First log in on A as user a and generate a pair of authentication keys. Do not enter a passphrase:
```
a@A:~> ssh-keygen -t rsa
Generating public/private rsa key pair.
Enter file in which to save the key (/home/a/.ssh/id_rsa): 
Created directory '/home/a/.ssh'.
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/a/.ssh/id_rsa.
Your public key has been saved in /home/a/.ssh/id_rsa.pub.
The key fingerprint is:
3e:4f:05:79:3a:9f:96:7c:3b:ad:e9:58:37:bc:37:e4 a@A
```
Now use ssh to create a directory ~/.ssh as user b on B. (The directory may already exist, which is fine):
```
a@A:~> ssh b@B mkdir -p .ssh
b@B's password: 
```
Finally append a's new public key to b@B:.ssh/authorized_keys and enter b's password one last time:
```
a@A:~> cat .ssh/id_rsa.pub | ssh b@B 'cat >> .ssh/authorized_keys'
b@B's password: 
```
From now on you can log into B as b from A as a without password:
```
a@A:~> ssh b@B
```

A note from one of our readers: Depending on your version of SSH you might also have to do the following changes:

- Put the public key in .ssh/authorized_keys2
- Change the permissions of .ssh to 700
- Change the permissions of .ssh/authorized_keys2 to 640

### 通过ssh传输文件

- scp -rp /path/filename username@remoteIP:/path #将本地文件拷贝到服务器上
- scp -rp username@remoteIP:/path/filename /path #将远程文件从服务器下载到本地
- tar cvzf - /path/ \| ssh username@remoteip "cd /some/path/; cat -> path.tar.gz" #压缩传输
- tar cvzf - /path/ \| ssh username@remoteip "cd /some/path/; tar xvzf -" #压缩传输一个目录并解压

> 这里可以理解为前一个“-” pipe到后一个“-”，“-”代表stdin，后面tar/cat 读取stdin
