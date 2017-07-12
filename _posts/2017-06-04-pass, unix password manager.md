---
layout: post
title: pass, Lunix password manager
date: 2017-06-04 16:38:27 +0800
categories: linux
---

pass usage: https://www.passwordstore.org/

> **Very Important!!**: pass use gpg2, some use `gpg --gen-key` by defauly. 
You will meet this error message `gpg: [stdin]: encryption failed: No public key` when initailiziing pass with `pass init`, 
to solve this, https://unix.stackexchange.com/questions/226944/pass-and-gpg-no-public-key

```
gpg2 --list-keys
gpg2 --list-secret-keys
gpg2 --export-secret-keys
gpg2 --import <key file>
gpg2 --edit-key <gpg-id>   # trust , 5 , save

pass init
pass git init
pass git remote add origin <git@xxx>
pass git push origin master
pass git clone git@xxxx ~/.password-store

pass insert xxx/xxx
pass insert -m xxx/xxx
pass [ls]
pass xxx/xxx
pass -c xxx/xxxx
```
> ref: https://help.github.com/articles/generating-a-new-gpg-key/
