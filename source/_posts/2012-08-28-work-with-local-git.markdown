---
layout: post
title: "Git本地操作介绍"
date: 2012-08-28 23:37
comments: true
categories: [Git]
---

下面介绍本地化git库的一些相关操作:

1. 创建本地git仓库
2. 添加文件
3. 提交修改
4. 查看历史
5. 查看差异
6. 工作空间copy, staging和仓库
7. 删除文件
8. 清理工作空间copy
9. 使用.gitignore忽略相关文件

<!--More-->

```javascript
> git init  #初始化空的git仓库,创建了.git目录
#在git仓库中添加文件

> git status #将会列出不在git track范围内的文件

> git add <不在track范围内的文件>

> git add -A #添加所有的不在track中的新文件，当心使用，因为有一些是需要忽略的

> git status #刚刚添加的不在track范围内的文件已经添加到stage中了，但是没有提交到仓库中

> git commit <添加到stage中的文件> #这里会调用配置中的编辑器添加提交历史，也可以直接制定 -m选项

> git log #查看提交的日志文件

#如果修改了文件

> git stauts #提示修改了哪些文件，字体显示为红色。

> git add -u #添加修改的文件到stage中，这些文件必须是在track当中的，新添加的文件不可以

> git status #显示stage中需要提交的文件

> git commit -m 'XXX' #提交文件，并添加提交记录

> git diff 61a83..96901 #比较这两个区间的差异，前5位是commit hash编码 

> git diff HEAD~1..HEAD #也可以制定从第一个版本到当前最新的版本比较
[TODO]

> git diff HEAD~1.. #也可以制定从第一个版本到当前最新的版本比较
[TODO]

##############################################################
#如果修改了多个文件，那么运行以下命令
> git status #将会显示多个红色标记的文件(modified: xxx,...)，这些文件都是被修改过的，但是没有提交到stage中

> git add xxx  #添加其中一个文件

> git status #发现添加的文件变成了绿色，说明这个文件已经提交到了stage中，等待提交到库中

> git commit  -m "Fix bug #2325" #将这个修改提交到本地库中

##############################################################

> rm REDME.txt #如果不需要某个文件，将其从文件系统中删除

> git status #将会显示被删除的文件(红色 delete:REDME.txt)

> git add -u #将文件存入stage中,准备提交到本地库中(红色变成绿色 delete:REDME.txt)

#如果这时又添加了新的文件(todo.txt)

> git status #将会显示新的文件没有被tracked

> git add todo.txt #将新文件纳入track行列

#如果将A.txt文件重命名为B.txt
> git status #将会显示A被删除，并且新添加了B

> git add -A #将删除的文件和新建的文件都提交到stage中等待提交到库中

##############################################################

#如果不小心修改了todo.txt文件，希望撤销这样的操作
> git checkout todo.txt

#如果修改了多个文件，或者删除了多个文件
> git reset --hard #将会撤销到最新的HEAD

##############################################################

#如果发现最新提交的注释有问题

> git reset --soft HEAD~1 #先让提交回退一个版本

> git status #发现要提交的修改正是上次的

> git commit -m "新的注释" #添加新的注释

> git reset --hard HEAD~1 #如果发现最新提交的这个版本有问题，想撤销到上一个版本

# HEAD就是一个堆栈，最先提交的在最底下，最新提交的在上面
# HEAD~2是回撤两次提交

##############################################################

#有时候在我们的工作空间中有一些log文件，或者临时文件是不需要被track的
#例如 development.log, tmp.txt

> git clean -f #将会移除这些文件

##############################################################

#一些情况下我们需要忽略文件夹和文件被track
# logs/
# .log

> vim .gitignore
/logs

> git status #.gitignore文件被修改了

> git add .gitignore

> git commit -m "ingore logs directory files"






```


