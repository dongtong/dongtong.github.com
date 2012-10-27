---
layout: post
title: "Mac OS X Leopard 安装Postgresql和pg gem"
date: 2012-07-21 23:38
comments: true
categories: [配置, 安装] 
---

这里安装Postgresql不是通过port,而是直接下载.dmg文件安装。

第一步: 到Postgresql官网下载Postgresql.dmg文件
想到http://www.postgresql.org/download/macosx/下点击"Download"，页面
跳转到http://www.enterprisedb.com/products-services-training/pgdownload#osx
这里下载的是9.1.4版本，下载完成后直接点击安装。

第二步: 安装前先看一下README文件，里面说明了如何配置Postgresql的内存使用情况

第三步: 安装过程中如果数据库使用了汉字的话，要选择zh的，不然数据库中无法存储汉字。
<!-- more -->
第四步: 做RoR开发的，可能要安装pg gem，用来连接Postgresql数据库
```
gem install pg
Gem::Installer::ExtensionBuildError: ERROR: Failed to build gem native extension.

        /Users/ryan/.rvm/rubies/ruby-1.9.2-p290/bin/ruby extconf.rb 
checking for pg_config... no
No pg_config... trying anyway. If building fails, please try again with
 --with-pg-config=/path/to/pg_config
checking for libpq-fe.h... no
Can't find the 'libpq-fe.h header
*** extconf.rb failed ***
Could not create Makefile due to some reason, probably lack of
necessary libraries and/or headers.  Check the mkmf.log file for more
details.  You may need configuration options.

Provided configuration options:
    --with-opt-dir
    --without-opt-dir
    --with-opt-include
    --without-opt-include=${opt-dir}/include
    --with-opt-lib
    --without-opt-lib=${opt-dir}/lib
    --with-make-prog
    --without-make-prog
    --srcdir=.
    --curdir
    --ruby=/Users/ryan/.rvm/rubies/ruby-1.9.2-p290/bin/ruby
    --with-pg
    --without-pg
    --with-pg-dir
    --without-pg-dir
    --with-pg-include
    --without-pg-include=${pg-dir}/include
    --with-pg-lib
    --without-pg-lib=${pg-dir}/lib
    --with-pg-config
    --without-pg-config
    --with-pg_config
    --without-pg_config
```
解决办法是,首先找到pg_config的位置:
```
sudo find / -name pg_config
```
然后在安装时加上路径
```
gem install pg -- --with-pg-config=/Library/PostgreSQL/9.1/bin/pg_config
```
就OK了  :D

