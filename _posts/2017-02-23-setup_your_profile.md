---
layout: post
title: setup your profile
date: 2017-02-23 17:19:22 +0800
categories: linux
---
- /etc/profile
- /etc/bashrc
- ~/.profile
- ~/.bash_profile
- ~/.bashrc
- ~/.kshrc

> in RHEL

First of all, the files in the /etc directory are global for all users, but should really avoid changing them if at all possible. 

If need to modify the global settings, you can use /etc/profile.d (this is to prevent your changes from getting wiped out when packages are upgraded).

Now, from an individual user basis, the next question is why are there all these different files (.bashrc, .bash_profile, .profile, etc).

The primary thing to understand is that the rc files are for all shell invocations while the profiles are strictly for interactive shells. 

On top of that, if you are going to be using both ksh and bash, you should use .profile for ksh and .bash_profile for bash. 

Since most configuration directives recognized by ksh are also recognized by bash, some people who use both shells find it easier to just create a symlink between the two.

There is also the matter of .kshrc, which is actually not a file that the korn shell specifically looks for. 

It’s just a practical convention, and many people use it, and then source the file from inside their .profile. Otherwise, ksh will not automatically read it.
