---
layout: post
title: "Git远程操作介绍"
date: 2012-09-05 23:53
comments: true
categories: [Git]
---

下面介绍git远程的一些相关操作：

1.Clone一个远程仓库
2.列出远程仓库
3.Fetch远程仓库中的更新
4.Merge更新
5.从远程仓库Pulling
6.Pushing更新到远程仓库
7.使用tags

<!--More-->
```javascript
#################################

> git clone https://github.com/jquery/jquery.git #下载这个仓库的所有分支，以及提交的历史

> cd jquery

> git log

> git log --oneline #显示所有的log，每条log占用一行

#################################
```

一般情况下我们在本地的仓库中工作，但是如果想让我们的修改被其他人看见，那么需要将本地仓库的变更提交
到远程仓库中。

要明白Git是一个分布式的仓库管理系统，所以远程的仓库和本地的仓库没有什么区别。



