---
layout: post
title: "更新到Mountain Lion后，rake失效"
date: 2012-08-26 22:53
comments: true
categories: [配置]
---

如果使用Ruby on Rails开发的人员可能会遇到这样的问题，如果Mac OS X升级到
Mountain Lion时，可能有时候rake 失效，会报告如下错误:
```
IOError: invalid Python installation: unable to open /usr/include/python2.7/pyconfig.h (No such file or directory)
```
特别是在用Octopress时，发现无法watch, preview等等。
解决方法是建立软连接到Python的安装目录中的pyconfig.h
```
$>sudo find / -name pyconfig.h  #首先找到文件
$>sudo mkdir -p /usr/include/python2.7/
$>sudo ln -s 找到的安装目录 /usr/include/python2.7/pyconfig.h
```
OK :D
