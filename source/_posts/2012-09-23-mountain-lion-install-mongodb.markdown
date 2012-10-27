---
layout: post
title: "Mountain lion 安装 mongoDB"
date: 2012-09-23 23:06
comments: true
categories: [配置, 安装] 
---

Mountain Lion通过Macport安装MongoDB报如下错误:
```
Error: mongodb 2.0.7 requires boost 1.49.0 or older but you have boost 1.50.0.
Error: To downgrade boost, see https://trac.macports.org/wiki/howto/InstallingOlderPort
Error: or more specifically https://trac.macports.org/ticket/35118#comment:12
Error: After installing boost 1.49.0, install mongodb without upgrading dependencies, i.e.:
Error:     sudo port -n install mongodb
Error: org.macports.configure for port mongodb returned: boost 1.50.0 is too new
Please see the log file for port mongodb for details:
    /opt/local/var/macports/logs/_opt_local_var_macports_sources_rsync.macports.org_release_tarballs_ports_databases_mongodb/mongodb/main.log
To report a bug, follow the instructions in the guide:
    http://guide.macports.org/#project.tickets
Error: Processing of port mongodb failed
```
<!--More-->
这个说明在安装MongoDB时需要安装boost，但是安装的版本是1.50.0版本，需要降级安装MongDB:
```
$ svn co -r 93341 'http://svn.macports.org/repository/macports/trunk/dports/devel/boost/'
$ cd boost
$ sudo port install
#安装好boost后安装mongodb
$ sudo port -n install mongodb
# 为mongodb设置文件保存目录：
$ sudo mkdir /data/db
$ sudo chown `id -u` /data/db
# 启动MongoDB服务：
$ mongod
# 在另外一个Terminal窗口（或标签页）中运行mongo客户端：
$ mongo
...
```
