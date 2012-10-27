---
layout: post
title: "Mac OS X Leopard 安装mysql"
date: 2012-07-21 23:23
comments: true
categories: [配置, 安装]
---

在安装mysql之前必须要安装的是port, xcode(用它的工具包)

第一步: 通过控制台安装MySQL 5
``` 
sudo port install mysql5 +server
```

第二步: 让Mac OS X每次启动时启动MySQL服务
```
sudo launchctl load -w /Library/LaunchDaemons/org.macports.mysql5.plist
```
<!-- more -->
第三步: 查找MySQL的server socket
```
mysql_config5 --socket
```

第四步: 配置server socket, 让PHP, RoR, Python,以及其他语言能够访问
```
sudo ln -s /opt/local/var/run/mysql5/mysqld.sock /tmp/mysql.sock
sudo mkdir /var/mysql
sudo ln -s /opt/local/var/run/mysql5/mysqld.sock /var/mysql/mysql.sock
```

第五步: 要想配置生效，先停下MySQL服务
```
sudo launchctl unload -w /Library/LaunchDaemons/org.macports.mysql5.plist
```

第六步: 设置root用户和MySQL的默认数据库,修改root密码并使之立刻生效
```
sudo /opt/local/lib/mysql5/bin/mysql_install_db --user=mysql
sudo launchctl load -w /Library/LaunchDaemons/org.macports.mysql5.plist
mysql5 -u root
UPDATE mysql.user SET Password = PASSWORD('password') WHERE User = 'root';
FLUSH PRIVILEGES;
```
OK...


