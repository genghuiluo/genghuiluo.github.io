---
layout: post
title: use fish as your default shell
date: 2017-02-23 17:19:22 +0800
categories: linux
---
[fish @github](https://github.com/fish-shell/fish-shell/) 

> cool shell style like zsh, in my opinion

[how to install? follow instruction easily](https://fishshell.com/)

### cool features which I prefer:

1. auto suggestion, completion and stytax highlighting
    
    ```
    > ls -
    # click Tab
    ~> ls -
    --all  -a                                                        (Show hidden)  --ignore-backups  -B        (Ignore files ending with ~)  --width  -w  (Assume screen width)
    --almost-all  -A                                  (Show hidden except . and ..)  --inode  -i                (Print inode number of files)  -1        (List one file per line)
    --author                                                        (Print author)  --lcontext                    (Display security context)  -C              (List by columns)
    --blocksize                                                    (Set block size)  --literal  -N                    (Print raw entry names)  -c        (Show and sort by ctime)
    …and 15 more rows

    # arrow right complete to end
    > ls| -la

    # alt + arrow right complete one word
    # update completions via parsing man pages
    > fish_update_completions
    ```

2. web base config

    ```
    > fish_config
    # will open a tab in your default browser and you can config your color theme/promot etc...
    ```

### questions which maybe bother you

1. fish read your previous environmnet variable in profile(e.g. .profile), you can move them into specified shell rc file like .bashrc
2. fish config file is ~/.config/fish/config.fish, you can create it if it doesn't exist.

usually, we would like to do:
 
- add alias: alias xxx='ls -la'
- set environment variable: set -x variable value
- add PATH: set PATH /usr/local/sbin XXX $PATH
