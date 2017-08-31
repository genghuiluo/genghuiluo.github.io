---
layout: post
title: oracle IDE in vim
date: 2017-05-22 14:55:47 +0800
categories: database
---

[Vorax, an Oracle IDE for Geeks](https://github.com/talek/vorax4), I spent a good amount of time to set up this Vim plugin on my desktop.

My Environment:
- ubuntu desktop 16.04 LTS
- $SHELL: fish
- vim: [awesome vim](https://github.com/genghuiluo/vimrc)

### 1) clone vorax4 into awesome vim

```
cd ~/.vim_runtime
git clone git@github.com:talek/vorax4.git sources_non_forked/vorax4
```

### 2) vorax4 rely on ruby 1.9.3 or 2.0.0 (are both not maintained by community any more)

Since ubuntu system ruby (`sudo apt install ruby`), general version is 2.2 or 2.3

I use rvm to manage different versions of ruby.

While rvm bascily support bash/zsh, to utilize it in fish, I need a utility [oh-my-fish](https://github.com/oh-my-fish/oh-my-fish).

With omf(oh-my-fish), install [rvm plugin](https://github.com/oh-my-fish/plugin-rvm) `omf install rvm`

Use ruby 1.9.3 as default,
```
rvm install 1.9.3
rvm use --default 1.9.3

# check if works
ruby -v
```

### 3) recompile vim with ruby1.9.3

```
sudo apt install mercurial

# get vim source http://www.vim.org/mercurial.php
hg clone https://bitbucket.org/vim-mirror/vim

# configure & compile
cd vim
./configure --with-features=HUGE \
    --enable-pythoninterp=yes \
    --with-python-config-dir=/usr/lib/python2.7/config/ \
    --enable-multibyte=yes \
    --enable-cscope=yes \
    --enable-rubyinterp=yes \
    --with-ruby-command=<your ruby path, '$which ruby'> \
    --enable-gui=gnome2 \
    --with-x \
    --enable-fontset
make
sudo make install
```
### 4) install gem dependencies

On it's wiki, `gem install vorax` to solve gem dependencies, [vorax](https://rubygems.org/gems/vorax) is a dummy gem which contains 4 gems.
Since one of 4 gems, sdsykes-ferret was not maintained by owner anymore. So ...
```
# nokogiri require ruby >= 2.1, so you need to specify a history version
gem install nokogiri -v 1.6.8 --no-rdoc --no-ri
gem install childprocess --no-rdoc --no-ri
gem install rubytree --no-rdoc --no-ri
gem install ferret --no-rdoc --no-ri # instead of sdsykes-ferret
```

### 5) have a try

> ensure that you have oralce client installed (include sqlplus)

**If you install 64bit sqlplus, `sqlplus64`, you need to modify source ruby code of vorax plugin**
In my case, `.vim_runtime/sources_non_forked/vorax4/vorax/ruby/lib/vorax/sqlplus.rb`, change sqlplus to sqlplus64
``` ruby
 def initialize(bin_file = "sqlplus64")                                                                                                                                                   
       @bin_file = bin_file
```

open vim, connect to a oracle instance `:VORAXConnect scott/tiger@db`

open database explorer, `<Leader>ve`
	
> what' my <Leader>? it's "\" by default, you can check with `:echo mapleader`, it's "," in my case

execute statementss, `<Leader>e`

open SQL Scratch `<Leader>ss`

output window, https://github.com/talek/vorax4/wiki/The-Output-Window

![]({{ site.url }}/assets/vim_1.jpg)






