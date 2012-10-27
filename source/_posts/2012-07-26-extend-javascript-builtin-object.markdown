---
layout: post
title: "关于扩展JavaScript内建对象"
date: 2012-07-26 23:39
comments: true
categories: [JavaScript]
---

举个例子，如果内建的string没有capitalize方法，如果根据项目需求某处需要扩展string内建对象，比如添加了一个方法capitalize()将字符串首字母大写。

在使用一个内建对象不存在的方法时，首先可以先查看一下ECMAScript 5有没有提供，其次查看一下prototype原型链上有没有已经定义的方法。最后查看文档中有没有定义对应的方法，以及和其它team成员沟通一下有没有定义对应的方法。如果这些都不能解决你的问题，那么可以考虑扩展prototype。

可能第一时间会想到这样做:
``` javascript
if(!String.prototype.capitalize){
	String.prototype.capitalize = function(){
		return this.slice(0,1).toUpperCase() + this.slice(1).toLowerCase();
	}
}
console.log("hello".capitalize())//Hello
```
<!-- more -->

但是之后就会这样：
``` javascript
var str = "foo";
for(var i in str){
	console.log(i + ":" + str[i]);
}
//0:f
//1:o
//2:o
// capitalize:function () { return this.slice(0, 1).toUpperCase() + this.slice(1).toLowerCase(); }
```

因为for..in会一直在原型链上查找属性。String的capitalize枚举属性已经设置为true了，
所以在原型链上就能查到capitalize().如果用for的话，就看不到capitalize()，但那不代
表这个原型属性不存在。如何改变(添加，修改，删除)枚举属性？
``` javascript
if(!String.prototype.capitalize){
	Object.defineProperty(String.prototype, 'capitalize',{
		value: function(){
			return this.slice(0,1).toUpperCase() + this.slice(1).toLowerCase();
		},
		enumerable: false
	})
}

var str = "foo";
for(var i in str){
console.log(i + ":" + str[i]);
}
//0:f
//1:o
//2:o
```
以上这种方式也可以运用到我们自定义的对象中,但是又不影响原型链其它对象的使用。

:D

