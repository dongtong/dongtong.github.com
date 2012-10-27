---
layout: post
title: "Git简要介绍"
date: 2012-08-27 22:33
comments: true
categories: [Git]
---

A. 首先介绍版本控制的历史:

1. 第一代版本控制是单文件的，比如.c文件，没有网络的参与，例如使用到了SCCS, RCS。
[TODO]

2. 第二代版本控制采用的是多文件，集中式，这里代表的有CVS,VSS, SVN, TFS,Perforce.
[TODO]

3. 第三代版本控制采用的分布式，变体。其中代表的有Git, Hg, Bazzar, BitKeeper。
[TODO]

<!--More-->

B. 不同版本控制系统的特征:
1. 如果采用集中式版本控制，那么开发人员只能向一个集中的仓库中提交代码和更新，如果这个
仓库的服务器宕机的话，那么开发人员的工作将会受到限制。

2. 如果采用层级式管理的话，那么开发人员首先将更新提交到本地的库，然后最后向中心库合并。

3. 如果采用分布式管理的话，开发人员首先可以将更新提交到本地的库，没有网络支持也可以工作。
最后开发人员可以将更新提交到官方的库中，这里典型代表的是github。分布式的备份其实是每一个
clone版本。	采用分布式可以轻松地建立分支，以及合并分支，可以将修改bug或添加新功能建立不同的分支，
最后合并这些分支。使用分布式可以浏览本地的所有历史记录，并分析这些历史记录。使用分布式还
可以轻松实现发布任务，比如流行的Heroku, github等等。
[TODO]

C. 简要介绍什么是Git?

1. 有Linux创始人Linus Torvalds开发

2. 从Linux-BitKeeper版本控制系统中抽离出来并经过改善

3. Git开发项目自2005开始启动

4. 使用Perl和C开发

5. 可以运行在Windows, Linux, OS X， Soloris以及其他系统中

6. 设计目标是创建一个快速, 简单,增强的分支管理和合并功能，分布式并且针对大型的可伸缩的项目
   版本控制系统。 

[TODO]

D. Git安装:

1. Windows安装
	到	http://msysgit.github.com上下载最新的Git版本安装即可
	注意: 在"select component"时，去掉前两个选项，当然也可是采用默认的。第二就是"Adjust
	your PATH environment"选项时，选择"Run git and include unix...."
	安装完成后在控制台中输入以下命令，将会显示Git的版本:
	>git --version

2. Mac OS X安装
	可以选择: sudo brew install git或者sudo port install git或者到
	(http://git-scm.com/download/mac)下下载dmg文件安装

3. Linux 安装
	sudo apt-get install git-core (Debian/Ubuntu)
	sudo yum install git-core (Fedora)
	其他的可以根据不同的安装管理器去安装

E. 配置Git

1.系统级别的配置:
	>git config --system
	配置文件存储在/etc/gitconfig或者c:\Program Files\Git\git\etc\gitconfig 
	这些配置是针对所用用户的

2.用户级别的配置:
	>git config --global
	配置文件存储在~/.gitconfig或者c:\users\your name\ .gitconfig
	这些文件是针对特定用户的配置

3. 仓库级别的配置:
	>git config
	存储在每一个仓库中.git/config


```javascript
>cat ~/.gitconfig  #首先看一下用户级别有没有配置:

>git config --global --list  #列出用户级别的所有相关配置

>git config --global user.name "Foobar" #配置一下用户名

>git config --global user.email "jinhu.tung@gmail.com" #配置一下email

>git config --global --list #再回过头来看看

>cat ~/.gitconfig

#其实还可以给git添加其他属性的配置

>git config --global core.editor vim #制定主要的编辑器

>git config --global help.autocorrect 1 #如果输入的git命令有错误，将会给出提示

>git config --global color.ui auto #显示的信息将会添加颜色，如diff，status等

>git config --global core.autocrlf input #针对mac osx, 默认是false

>git conig user.name 'Tong'

在仓库中添加和用户级别相同的配置，不会覆盖用户级别的，只是在在config中追加相同的配置
属性。

> git config --global --unset core.autocrlf #移除某个配置属性
```










