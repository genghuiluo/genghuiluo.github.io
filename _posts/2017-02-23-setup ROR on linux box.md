---
layout: post
title: setup ROR on linux box
date: 2017-02-23 17:19:22 +0800
categories: ruby
---
### 1. install ruby
对于初学者，建议通过编译源码来安装ruby

[download ruby source code ruby-2.2.2](https://ruby.taobao.org/mirrors/ruby/ruby-2.2.2.tar.gz)

``` bash
$tar -xzvf ruby-2.2.2.tar.gz
$cd ruby-2.2.2
$./configure
//check dependency, warnning 并不会影响ruby的安装，但是会对之后某一些gem的安装产生影响，那时候就需要重新编译ruby安装。
$make   
//compile  src code
$sudo make install
//默认情况下，Ruby 安装到 /usr/local 目录。如果想使用其他目录，可以把 --prefix=DIR 选项传给 ./configure 脚本。
```

因为无法使用任何工具来管理通过源码编译安装的 Ruby，所以使用第三方工具或者包管理器或许是更好的选择。例如，[rvm](https://github.com/rvm/rvm)(管理多个版本的ruby，如果你的机器有足够的带宽，并且你只是想setup env ASAP)

``` bash
$curl -L https://get.rvm.io | bash -s stable
//有时候会无法访问rvm.io，可以直接download github上的master
$source ~/.rvm/scripts/rvm
$rvm install 2.2.3
$rvm use 2.2.3 --default
```

查看ruby是否安装成功，gem和ruby是绑定的，所以只要ruby安装成功，自然也就可以使用gem
``` bash
$ruby -v
```

### 2 install rails&bundler by gem

#### 2.1 （如果你有一台墙外机器请忽略）配置[淘宝gem源](https://ruby.taobao.org/)
``` bash
$echo "gem: --no-ri --no-rdoc" > ~/.gemrc
//注：每次gem安装，不下载相应的文档,加快安装速度，可跳过
$ gem sources --add https://ruby.taobao.org/ --remove https://rubygems.org/
$ gem sources -l
*** CURRENT SOURCES ***
https://ruby.taobao.org
//请确保只有 ruby.taobao.org
```

#### 2.2 install rails&bundler
``` bash
$gem install bundler
$gem install rails4.2
$bundler -v //mange all third-party gems of your ruby application
$rails -v 
```

#### 3 install a js runtime(e.g. nodejs)
``` bash
// try start rails server without a js runtime
$rails s
There was an error while trying to load the gem 'uglifier'. (Bundler::GemRequireError)
//Uglifier is a JS wrapper and it needs a JS runtime running or an JS interpreter
// rails asset pipeline require a  js runtime

//if you are in ubuntu
$sudo apt-get install nodejs
```
[Or directly download from offical webstite](https://nodejs.org/en/download/)

### 4 tricky situation,如何在一台内网的机器上安装gem/rails?
其实这也是很常见的问题，一些企业内部prod的机器是不能使用外网的gem repo，而rails 本身也是一个gem，必须使用gem install来安装。

#### 4.1 下载gem包到本地
[所有的gem都可以在rubygems被找到](https://rubygems.org/)
``` bash
//搜索bundler，并下载和你ruby版本相适应的gem到本地，上传到你要安装的机器上
$gem install [gem filename]
$bundle -v
```

#### 4.2 在一个可以正常运行的rails程序的目录下，使用bundler打包gem
``` bash
$bundle package
//所有的gem都会打包到 vender/cache下，将该文件夹和Gemfile文件一起打包，上传
//解包，让Gemfile和 vender/cache在同一目录下
$bundle install --local
//done
```

> 为何不直接下载rails的gem？

rails的gem依赖于其他多个gem（有的还有多层依赖关系），e.g. actionview，而且gem之间依赖有很严格的版本限制，所以手动去下载它们是不现实的，而bundler使用Gemfile来管理所有gem的version和dependency，正好可以帮我们解决这个问题

[ruby 中文社区](https://ruby-china.org/)
