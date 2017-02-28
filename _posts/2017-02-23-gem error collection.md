---
layout: post
title: gem error collection
date: 2017-02-23 17:19:22 +0800
categories: ruby
---
> can’t require installed gems with this kind of error msg “`require’: no such file xxxx”

### 1. use –user-install option to install gem into your home dir in case you don’t have root permission
``` bash
gem install xxx --user-install

#add below to your corresponding profile/rc file e.g. .bashrc/.kshrc/.profile
if which ruby >/dev/null && which gem >/dev/null; then
    PATH="$(ruby -rubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi
```

### 2. if you are using ruby >=1.9, directly add “require ‘xxx'” at head.

> since ruby1.9, ‘require “rubygems”‘ happens automatically
        
### if you are using ruby<1.9, add “require ‘rubygems'” at top of head

> what does “require ‘rubygems’ do?
        
- When RubyGems is required, Kernel#require is replaced with our own which is capable of loading gems on demand.
- When you call require ‘x’, this is what happens:
- If the file can be loaded from the existing Ruby loadpath, it is.
- Otherwise, installed gems are searched for a file that matches. If it’s found in gem ‘y’, that gem is activated (added to the loadpath).
- The normal require functionality of returning false if that file has already been loaded is preserved.

