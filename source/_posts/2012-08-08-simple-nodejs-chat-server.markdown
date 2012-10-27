---
layout: post
title: "实现简单的Node聊天客户端"
date: 2012-08-08 00:02
comments: true
categories: [Node.js]
---
```javascript
var net = require('net');
var chatServer = net.createServer();
var client_list = [];

chatServer.on('connection', function(client){
	client.name = client.remoteAddress + ':' + client.remotePort;
	client.write("Welcome "+client.name+"!\n");
	console.log(client.name + " joined.");

	client_list.push(client);

	client.on('data', function(msg){
		broadcast(msg, client);
	});

	client.on('end', function(){
		console.log(client.name + " leave.");
		client_list.splice(client_list.indexOf(client), 1);
	});

	client.on('error', function(e){
		console.log(e);
	});
}).listen(9000);
```
<!--More-->
```javascript
function broadcast(msg, client){
	var removedClients = [],
		client_len = client_list.length;

	for(var index = client_len; index--;){
		if(client !== client_list[index]){
			if(client_list[index].writable){
				client_list[index].write(client.name + " says :" + msg + "\n");
			}else{
				removedClients.push(client_list[index])
				client_list[index].destroy();
			}
		}
	}

	var remove_client_len = removedClients.length;
	for(var index=remove_client_len; index--;){
		client_list.splice(client_list.indexOf(removedClients[index]), 1);
	}

}

console.log("chat server is running...");
```
