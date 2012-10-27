---
layout: post
title: "Nodejs 介绍"
date: 2012-09-16 19:51
comments: true
categories: [Node.js]
---
##开始
首先通过一个实例看看nodejs执行程序:
```javascript
var fs = require("fs");//包含file system 模块
console.log("开始读取文件...");//类似于浏览器环境
//第一个参数是文件地址，第二个是callback
//callback第一个参数是error,第二个参数文件的内容
fs.readFile("file.txt", function(error, data){
	console.log("文件内容为:"+data);
});
console.log("读取文件结束");
```
你认为执行的结果是不是应该是
```javascript
开始读取文件...
//文件内容
读取文件结束
```
实际上是:
```javascript
开始读取文件...
读取文件结束
//文件内容
```
原因是Nodejs是非阻塞执行地，一般语言都是一行一行阻塞执行代码。
非阻塞执行是Nodejs一个特性。
<!--More-->
##文件操作

下面使用fs模块对文件进行读写操作。上面已经介绍过异步读取文件。下面介绍同步读取文件。
一般情况下，程序在运行时，先要读取必要的配置文件，然后在执行程序，这时就需要同步(阻塞)
读取文件内容。
```javascript
var fs = require("fs");
console.log("同步读取文件...");
var content = fs.readFileSync("file.txt");
console.log("文件内容:"+content);
console.log("读取文件内容结束");
```

如何处理JSON数据?
```javascript
var fs = require("fs");
console.log("读取配置文件");
var content = fs.readFileSync("config.json");
console.log("配置文件内容:\n"+content);
console.log("读取配置文件结束");

var config = JSON.parse(content);//JSON类内置在Node.js中
for( var key in config){
	console.log("" + key + ":" + config[key]);
}
```
读取config.json内容为:
```javascript
{
	"name": "foo",
	"api_key": "Wzs123CDW",
	"version": "1.0"
}
```
以上代码执行的结果:
```javascript
name:foo
api_key:Wzs123CDW
version:1.0
```
下面介绍使用fs模块同步写文件:
```javascript
var fs = require("fs");
console.log("同步写入文件开始...");
fs.writeFileSync("write_sync.txt", "node.js write content synchronous!");
console.log("写文件结束");
```
一般情况下都使用异步写入文件，比如程序在运行时，异步写入log而不使应用程序变缓慢。
```javascript
var fs = require("fs");
console.log("异步写入文件...");
//error是当找不到文件，或者写文件无法返回之类的错误。
fs.writeFile("write_async.txt", "write asynchronous!", function(error){
	console.log("正在异步写入---->");
});
console.log("结束");
```
执行信息:
```
异步写入文件...
结束
正在异步写入---->
```

接下来介绍监视文件是否被修改。一般情况我们有这样的需求，就是监视配置文件被更新了，并且被
谁更新了等等。
```javascript
var fs = require('fs');
console.log("监视文件开始...");
var config = JSON.parse(fs.readFileSync("config.json"));
console.log("配置文件初始内容为:\n");
for(var key in config){
	console.log("" + key + ":" + config[key]);
}

fs.watchFile("config.json", function(current_content, prev_content){
	console.log("文件内容改变>>>");
	config = JSON.parse(fs.readFileSync("config.json"));
	console.log("新的文件内容为:\n");
	for(var key in config){
		console.log("" + key + ":" + config[key]);
	}
});
```
先修改config.json的内容，然后观察控制台会发现config.json内容改变时，控制台将显示最新的
内容。

接下来介绍如何使用Node.js创建一个简单的Http Server来接受和处理客户端浏览器的请求。
在开始构建这个Http Server前，先查看一下官方的文档，找到http这个模块，里面提供给详细的方法
调用以及说明。下面开始实现:
```javascript
//加载需要的模块
//定义http server的host和port
var http = require('http'),
	host = "127.0.0.1",
	port = "8888";
//创建server
//第一个参数是接受客户端的请求，
//第二个参数是http server的响应
var server = http.createServer(function(request, response){
	console.log("接受请求:"+request.url);
	//定义响应的类型
	response.writeHead("200", {"Content-Type":"text/plain"});
	//response.write();
	//结束响应
	response.end("Hello Node.js");
});
//侦听一个端口
server.listen(port, host, function(){
	console.log("侦听" + host + ":" + port);
});
```
打开浏览器输入127.0.0.1:8888后查看控制台输出:
```
侦听127.0.0.1:8888
接受请求:/
接受请求:/favicon.ico
```
为什么会有两次请求？因为chrome会自动发送一个请求去获取favicon(这里使用的是chrome)。
但是如果使用的是firefox，是没有第二次请求的。接下来看看如何显示更多的信息:
```javascript
var http = require('http'),
	host = "127.0.0.1",
	port = "8888";
var fs = require("fs");

var server = http.createServer(function(request, response){
	console.log("接受请求:"+request.url);
	fs.readFile("./public"+request.url, function(error, data){
		if(error){
			//如果文件找不到的话，显示404
			response.writeHead(404, {"Content-type":"text/plain"});
			response.end("对不起，文件不存在!");
		}else{
			//显示html文件内容
			response.writeHead(200, {"Content-type":"text/html"});
			response.end(data);
		}
	});
});

server.listen(port, host, function(){
	console.log("侦听" + host + ":" + port);
})
```
下面结合config.json配置文件来动态决定host和port:
```javascript
var http = require('http'),
	fs = require("fs"),
	config = JSON.parse(fs.readFileSync("configuration.json")),//这里要同步读取，以免下面获取不到host和port值
	host = config.host,
	port = config.port;

var server = http.createServer(function(request, response){
	console.log("接受请求:"+request.url);
	fs.readFile("./public"+request.url, function(error, data){
		if(error){
			response.writeHead(404, {"Content-type":"text/plain"});
			response.end("对不起，文件不存在!");
		}else{
			console.log("获取到文件");
			response.writeHead(200, {"Content-type":"text/html"});
			response.end(data);
		}
	});
});

server.listen(port, host, function(){
	console.log("侦听" + host + ":" + port);
})
```
configuration.json的内容为:
```json
{
	"host": "127.0.0.1",
	"port": "1314"
}
```
启动应用后，http server现在侦听的是1314端口了。如果想动态修改port并且让http server能响应?
```javascript
var http = require('http'),
	fs = require("fs"),
	config = JSON.parse(fs.readFileSync("configuration.json")),
	host = config.host,
	port = config.port;

var server = http.createServer(function(request, response){
	console.log("接受请求:"+request.url);
	fs.readFile("./public"+request.url, function(error, data){
		if(error){
			response.writeHead(404, {"Content-type":"text/plain"});
			response.end("对不起，文件不存在!");
		}else{
			console.log("获取到文件");
			response.writeHead(200, {"Content-type":"text/html"});
			response.end(data);
		}
	});
});

server.listen(port, host, function(){
	console.log("侦听" + host + ":" + port);
});

fs.watchFile("configuration.json", function(curr, prev){
	//只要内容以改变，重新读取config内容
	config = JSON.parse(fs.readFileSync("configuration.json"));
	host = config.host;
	port = config.port;
	server.close();//关闭之前的server,重新启动
	server.listen(port, host, function(){
		console.log("重新侦听" + host + ":" + port);
	});
});
```
##npm介绍

接下来介绍安装和更新package。访问[http://npmjs.org]http://npmjs.org。
这个网站类似于Ruby on Rails 中gem的包管理器一样。它是一个针对Node.js的包
管理器，管理Node程序之间的依赖性。使用它可以安装或者发布Node程序。

这里使用npm安装underscore.js(underscore.js是一个javascript工具库，使用它的函数库
可以实现类似于Prototype.js或者Ruby中的类似操作)。
```
$>npm install underscore
npm http GET https://registry.npmjs.org/underscore
npm http 200 https://registry.npmjs.org/underscore
npm http GET https://registry.npmjs.org/underscore/-/underscore-1.3.3.tgz
npm http 200 https://registry.npmjs.org/underscore/-/underscore-1.3.3.tgz
underscore@1.3.3 node_modules/underscore
```
安装完成以后会发现在项目目录中创建了一个node_modules文件夹，里面是安装了的node程序。
也可以全局安装npm程序,那么安装完成后，将不会在项目目录下创建新的文件夹目录。任何node程序
都可以require安装的程序。
```
$>npm install underscore -g
```
但是如果underscore.js官方更新了版本怎么办？这里只需要执行更新命令，那么响应的node程序
中引用的npm安装程序就会被更新到最新版本。
```
$>npm update underscore
```
安装完npm程序后，可以在项目中直接引用
```javascript
var underscore = require('underscore');//和引用内建的模块相同
```
##Express介绍

下面介绍使用express npm程序读取文件。Express是针对Node高性能，高层次的web开发库。
express创建Http Server是在内建http创建server的基础上增强的。这就类似于Ruby可以
开发Web应用，但是有了Rails就更加犀利，Python也可以开发web应用，但是有了Django也变得
如鱼得水。
```
$>npm install express
pm http GET https://registry.npmjs.org/express
npm http 200 https://registry.npmjs.org/express
npm http GET https://registry.npmjs.org/express/-/express-3.0.0rc4.tgz
npm http 200 https://registry.npmjs.org/express/-/express-3.0.0rc4.tgz
npm http GET https://registry.npmjs.org/connect/2.4.4
npm http GET https://registry.npmjs.org/commander/0.6.1
npm http GET https://registry.npmjs.org/range-parser/0.0.4
npm http GET https://registry.npmjs.org/mkdirp/0.3.3
npm http GET https://registry.npmjs.org/cookie/0.0.4
npm http GET https://registry.npmjs.org/crc/0.2.0
npm http GET https://registry.npmjs.org/fresh/0.1.0
npm http GET https://registry.npmjs.org/methods/0.0.1
npm http GET https://registry.npmjs.org/send/0.0.4
npm http GET https://registry.npmjs.org/debug
npm http 200 https://registry.npmjs.org/range-parser/0.0.4
npm http 200 https://registry.npmjs.org/mkdirp/0.3.3
npm http GET https://registry.npmjs.org/range-parser/-/range-parser-0.0.4.tgz
npm http GET https://registry.npmjs.org/mkdirp/-/mkdirp-0.3.3.tgz
npm http 200 https://registry.npmjs.org/cookie/0.0.4
npm http GET https://registry.npmjs.org/cookie/-/cookie-0.0.4.tgz
npm http 200 https://registry.npmjs.org/commander/0.6.1
npm http GET https://registry.npmjs.org/commander/-/commander-0.6.1.tgz
npm http 200 https://registry.npmjs.org/crc/0.2.0
npm http 200 https://registry.npmjs.org/fresh/0.1.0
npm http GET https://registry.npmjs.org/crc/-/crc-0.2.0.tgz
npm http GET https://registry.npmjs.org/fresh/-/fresh-0.1.0.tgz
npm http 200 https://registry.npmjs.org/methods/0.0.1
npm http GET https://registry.npmjs.org/methods/-/methods-0.0.1.tgz
npm http 200 https://registry.npmjs.org/range-parser/-/range-parser-0.0.4.tgz
npm http 200 https://registry.npmjs.org/mkdirp/-/mkdirp-0.3.3.tgz
npm http 200 https://registry.npmjs.org/send/0.0.4
npm http GET https://registry.npmjs.org/send/-/send-0.0.4.tgz
npm http 200 https://registry.npmjs.org/debug
npm http GET https://registry.npmjs.org/debug/-/debug-0.7.0.tgz
npm http 200 https://registry.npmjs.org/cookie/-/cookie-0.0.4.tgz
npm http 200 https://registry.npmjs.org/commander/-/commander-0.6.1.tgz
npm http 200 https://registry.npmjs.org/crc/-/crc-0.2.0.tgz
npm http 200 https://registry.npmjs.org/fresh/-/fresh-0.1.0.tgz
npm http 200 https://registry.npmjs.org/connect/2.4.4
npm http GET https://registry.npmjs.org/connect/-/connect-2.4.4.tgz
npm http 200 https://registry.npmjs.org/methods/-/methods-0.0.1.tgz
npm http 200 https://registry.npmjs.org/send/-/send-0.0.4.tgz
npm http 200 https://registry.npmjs.org/debug/-/debug-0.7.0.tgz
npm http 200 https://registry.npmjs.org/connect/-/connect-2.4.4.tgz
npm http GET https://registry.npmjs.org/mime/1.2.6
npm http GET https://registry.npmjs.org/qs/0.4.2
npm http GET https://registry.npmjs.org/formidable/1.0.11
npm http GET https://registry.npmjs.org/bytes/0.1.0
npm http GET https://registry.npmjs.org/pause/0.0.1
npm http 200 https://registry.npmjs.org/pause/0.0.1
npm http GET https://registry.npmjs.org/pause/-/pause-0.0.1.tgz
npm http 200 https://registry.npmjs.org/mime/1.2.6
npm http GET https://registry.npmjs.org/mime/-/mime-1.2.6.tgz
npm http 200 https://registry.npmjs.org/qs/0.4.2
npm http GET https://registry.npmjs.org/qs/-/qs-0.4.2.tgz
npm http 200 https://registry.npmjs.org/bytes/0.1.0
npm http GET https://registry.npmjs.org/bytes/-/bytes-0.1.0.tgz
npm http 200 https://registry.npmjs.org/formidable/1.0.11
npm http GET https://registry.npmjs.org/formidable/-/formidable-1.0.11.tgz
npm http 200 https://registry.npmjs.org/pause/-/pause-0.0.1.tgz
npm http 200 https://registry.npmjs.org/mime/-/mime-1.2.6.tgz
npm http 200 https://registry.npmjs.org/qs/-/qs-0.4.2.tgz
npm http 200 https://registry.npmjs.org/bytes/-/bytes-0.1.0.tgz
npm http 200 https://registry.npmjs.org/formidable/-/formidable-1.0.11.tgz
express@3.0.0rc4 node_modules/express
├── methods@0.0.1
├── fresh@0.1.0
├── range-parser@0.0.4
├── cookie@0.0.4
├── crc@0.2.0
├── commander@0.6.1
├── debug@0.7.0
├── mkdirp@0.3.3
├── send@0.0.4 (mime@1.2.6)
└── connect@2.4.4 (pause@0.0.1, bytes@0.1.0, qs@0.4.2, formidable@1.0.11)
```
上面就是安装express时也安装了依赖其他的module。下面写一个简单的express web应用:
```javascript
var fs = require("fs"),
	config = JSON.parse(fs.readFileSync("configuration.json"));

var host = config.host,
	port = config.port;

var express = require("express");
//var app = express.createServer();//http.createServer();
/*
Warning: express.createServer() is deprecated, express
applications no longer inherit from http.Server,
please use:

  var express = require("express");
  var app = express();
*/
var app = express();

app.get("/", function(request, response){
	response.send("Hello Express.js!");
});

app.listen(port, host);
```
打开浏览器输入http://127.0.0.1:1317界面上将显示"Hello Express.js!"。
下面让express解析静态页面:
```javascript
var fs = require("fs"),
	config = JSON.parse(fs.readFileSync("configuration.json"));

var host = config.host,
	port = config.port;

var express = require("express");
//var app = express.createServer();//http.createServer();
/*
Warning: express.createServer() is deprecated, express
applications no longer inherit from http.Server,
please use:

  var express = require("express");
  var app = express();
*/
var app = express();
app.use(app.router);//在访问静态页面时，可以使用根目录路由测试一下
app.use(express.static(__dirname + '/public'));//使用指定目录下的静态页面

app.get("/", function(request, response){
	response.send("Hello Express.js!");
});

app.listen(port, host);
```
这时在浏览器器中http://127.0.0.1:1317/hello.html将会直接显示静态html内容。这里
可以上面的做一个对比，这里不需要定义Content-type了，这就是express做为一个Node的web
开发模块的优越性，它帮你省去了一些低级操作，可以更加专注与业务层面的实现。

下面可以再看一下如果请求的url中的参数是可变的，express如何获取这些内容:
```javascript
var fs = require("fs"),
	config = JSON.parse(fs.readFileSync("configuration.json"));

var host = config.host,
	port = config.port;

var express = require("express");
//var app = express.createServer();//http.createServer();
/*
Warning: express.createServer() is deprecated, express
applications no longer inherit from http.Server,
please use:

  var express = require("express");
  var app = express();
*/
var app = express();
app.use(app.router);//在访问静态页面时，可以使用根目录路由测试一下
app.use(express.static(__dirname + '/public'));//使用指定目录下的静态页面

app.get("/", function(request, response){
	response.send("Hello Express.js!");
});

app.get("/hello/:your_world", function(request, response){
	response.send("Hello " + request.params.your_world);
});

app.listen(port, host);
```
这时你在浏览器地址栏中输入:http://127.0.0.1:1317/hello/foobar。见面上将显示"Hello foobar"。
express在解析时，将your_world当做params中的一个key,如果你的值匹配这个key的模式，那么就是这个key
的值。

在看看如何做简单的查询:
```javascript
var fs = require("fs"),
	config = JSON.parse(fs.readFileSync("configuration.json"));

var host = config.host,
	port = config.port;

var express = require("express");
//var app = express.createServer();//http.createServer();
/*
Warning: express.createServer() is deprecated, express
applications no longer inherit from http.Server,
please use:

  var express = require("express");
  var app = express();
*/
var app = express();
app.use(app.router);//在访问静态页面时，可以使用根目录路由测试一下
app.use(express.static(__dirname + '/public'));//使用指定目录下的静态页面

app.get("/", function(request, response){
	response.send("Hello Express.js!");
});

app.get("/hello/:your_world", function(request, response){
	response.send("Hello " + request.params.your_world);
});

var users = {
	"1":{
			"name":"foo",
			"age": 23
		},
	"2":{
			"name":"bar",
			"age":24
		}
};

app.get("/users/:id", function(request, response){
	var user = users[request.params.id];
	if (user){
		response.send("user name: " + user.name + "<br/>user age: " + user.age);
	}else{
		response.send("The user is not existed :(");
	}
});

app.listen(port, host);
```
在浏览器中输入http://127.0.0.1:1317/users/1看看界面上显示什么。

## 调用github API

首先浏览github官方的[http://developer.github.com/v3/]API。API的访问
是基于https的，
```javascript
var https = require("https");//github的请求是基于https
var username = "XXX";
var options = {
	host: "api.github.com",
	path: "/users/" + username + "/repos",//github给的API
	method: "GET"
};
//https的request方法封装了很多细节，如果有兴趣可以看一下源代码
var request = https.request(options, function(response){
	var str = "";
	response.on("data", function(chunk){//响应返回的数据不是一次性的
		str += chunk.toString("utf8");
	});

	response.on("end", function(){
		console.log("Github Response: " + str);
	});
});

request.end();//必须手动结束我们的请求
```
运行后将会返回一大堆JSON字符串。看看你的账户相关信息:
```javascript

	response.on("end", function(){
		var repos = [];
		var json = JSON.parse(str);
		json.forEach(function(repo){
			repos.push({
				name: repo.name,
				description: repo.description
			});
		});
		console.log("Repos detail is: ");
		for(var key in repos){
			console.log(""+key+":"+repos[key]["name"] + "\n" + repos[key]["description"]);
		}
	});
```
我们可以把这个功能封装起来，添加callback来定义我们的回调处理:
```javascript
var https = require("https");//github的请求是基于https

function getRepos(username, callback){
	var options = {
		host: "api.github.com",
		path: "/users/" + username + "/repos",
		method: "GET"
	};
	//https的request方法封装了很多细节，如果有兴趣可以看一下源代码
	var request = https.request(options, function(response){
		var str = "";
		response.on("data", function(chunk){//响应返回的数据不是一次性的
			str += chunk.toString("utf8");
		});

		response.on("end", function(){
			var repos = [];
			var json = JSON.parse(str);
			json.forEach(function(repo){
				repos.push({
					name: repo.name,
					description: repo.description
				});
			});
			callback(repos);
			
		});
	});

	request.end();//必须手动结束我们的请求
}

getRepos("XXX", function(repos){
	console.log("Repos count is : "+repos.length);		
});

getRepos("JeffreyWay", function(repos){
	console.log("JeffreyWay Repos count is : "+repos.length);		
});
```

##自定义Module并使用

将可以复用的代码提取到单独的文件中，做为Module使用。
```javascript
function print(){
	return "foobar";
}

function public_print(){
	return print() + " again";
}
//使用exports决定什么函数是对外公开
//第一个是对外的接口名，第二个是公开的函数名
//print是私有的，对外不可以访问
module.exports.print_str = public_print;
```
将上面的js发布为module
```javascript
var my_module = require("./my_module.js");
console.log(my_module.print_str());
```
可以把上面的github的访问方法封装为一个module使用。
```javascript
var https = require("https");//github的请求是基于https

function getRepos(username, callback){
	var options = {
		host: "api.github.com",
		path: "/users/" + username + "/repos",
		method: "GET"
	};
	//https的request方法封装了很多细节，如果有兴趣可以看一下源代码
	var request = https.request(options, function(response){
		var str = "";
		response.on("data", function(chunk){//响应返回的数据不是一次性的
			str += chunk.toString("utf8");
		});

		response.on("end", function(){
			var repos = [];
			var json = JSON.parse(str);
			json.forEach(function(repo){
				repos.push({
					name: repo.name,
					description: repo.description
				});
			});
			callback(repos);
			
		});
	});

	request.end();//必须手动结束我们的请求
}

module.exports.getRepos = getRepos;
```
```javascript
var github = require("./github.js");
github.getRepos("JeffreyWay", function(repos){
	console.log("JeffreyWay repos count is " + repos.length);
});
```

##发布node程序为npm

在要发布的工程目录下:
```
$> npm init
This utility will walk you through creating a package.json file.
It only covers the most common items, and tries to guess sane defaults.

See `npm help json` for definitive documentation on these fields
and exactly what they do.

Use `npm install <pkg> --save` afterwards to install a package and
save it as a dependency in the package.json file.

Press ^C at any time to quit.
name: (workspace) todo-github-example
version: (0.0.0) 0.0.1
description: export github api for node
entry point: (config.js) github.js
test command: 
git repository: 
keywords: github get user's repos api
author: todo
license: (BSD) BSD
About to write to /Users/XXX/Node/workspace/package.json:

{
  "name": "todo-github-example",
  "version": "0.0.1",
  "description": "export github api for node",
  "main": "github.js",
  "dependencies": {
    "express": "~3.0.0rc4",
    "underscore": "~1.3.3"
  },
  "devDependencies": {},
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "keywords": [
    "github",
    "get",
    "user's",
    "repos",
    "api"
  ],
  "author": "todo",
  "license": "BSD"
}


Is this ok? (yes) yes
```
输入相关信息后会在工作目录中生成一个package.json,内容如下:
```json
{
  "name": "todo-github-example",
  "version": "0.0.1",
  "description": "export github api for node",
  "main": "github.js",
  "dependencies": {
    "express": "~3.0.0rc4",
    "underscore": "~1.3.3"
  },
  "devDependencies": {},
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "keywords": [
    "github",
    "get",
    "user's",
    "repos",
    "api"
  ],
  "author": "todo",
  "license": "BSD"
}
```
接下来是使用npm连接官网，登陆
```
$>npm adduser
```
发布todo-github-example
```
$>npm publish
```
然后到https://npmjs.org/去查找刚才提交的npm程序。如果我们需要修改文件
准备发布下一个版本时，只要修改package.json中的版本信息后，再次publish
即可。使用方法在上面的npm安装程序中已经阐述过。

##MongoDB与Node结合
下面介绍使用Node对MongoDB数据库进行插入和查询操作，以及和Web Service的结合。
首先到MongoDB的官方网站下载适合的安装文件并安装，在这里介绍的是Node和MongoDB
的结合，所以还需要安装mongodb的npm安装程序。
```
$> npm install mongodb
```
Mongodb使用的是类似于json的bson数据格式存储数据。它是经过编码的二进制数据，读取
的效率一般要高于传统的关系型数据库，缺点是难于表述表与表之间的关联。详细的介绍可以
查阅相关的资料，这里就不再叙述。

下面实现连接mongdb数据库
```javascript
var mongo = require("mongodb");//相当于引用Mongodb这个对象
var host = '127.0.0.1';
var port = mongo.Connection.DEFAULT_PORT;//使用mongodb的默认端口
//创建一个连接和创建数据库nodejs_intro
//这和一般地连接MySQL数据库类似
var db = new mongo.Db("nodejs_intro", new mongo.Server(host, port,{}));
db.open(function(error){//如果连接失败，或者server有问题，将会获得error
	console.log("We have connected to " + host + ":" + port);
});
```
[TODO]

##Real Time APP与Node
下面将要介绍的是实时存储数据，以及使用socket.io将数据streaming化并显示到浏览器上。

首先要创建一个web server，第二个是有一个数据源供读写，最后是使用socket.io将读取
的数据streaming化。

[TODO]











* [http://nodejs.org]Node官网

* [http://twitter.com/#!/nodejs]Node Twitter

* [http://www.mongodb.org]MongoDB官网



