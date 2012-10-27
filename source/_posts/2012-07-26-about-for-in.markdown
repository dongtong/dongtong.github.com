---
layout: post
title: "JavaScript中for..in循环"
date: 2012-07-26 00:01
comments: true
categories: [JavaScript] 
---

for..in迭代应该用于迭代非数组对象，枚举对象属性。理论上也是可以迭代数组的，但是如果数组被扩展的话，
在迭代的时候可能就会抛出内部错误。所以一般用for迭代数组，而for..in迭代对象。
 
在使用for..in迭代对象时，最好加上判断hasOwnProperty,否则会顺着迭代对象的原型链一直查找属性。看一下下面的例子：

``` javascript
if(typeof Object.prototype.sayFoo === 'undefined'){
	Object.prototype.sayFoo = function(){ console.log('object.sayFoo')};
}

var foo = {
	name: "foo",
	nextStr: "bar",
	sayBar: function(){
		console.log('foo.sayBar');
	}
};

for(var i in foo){
	if(foo.hasOwnProperty(i)){
		if(typeof foo[i] === 'function'){
			console.log(i + ':' +foo[i]);
		}else{
			console.log(i + ':' +foo[i]);
		}
	}
}

for(var i in foo){
	console.log(i + ':' +foo[i]);
}
```
<!-- more -->
hasOwnProperty可以改善一下：
``` javascript
var i, hasOwn = Object.prototype.hasOwnProperty;
for(var i in foo){
	if(hasOwn.call(foo, i)){
		if(typeof foo[i] === 'function'){
			console.log(i + ':' +foo[i]);
		}else{
			console.log(i + ':' +foo[i]);
		}
	}
}
```

这个是为了防止foo对象重新定义了hasOwnProperty方法。
这里不是说for..in迭代对象就必须用hasOwnProperty方法去判断，这个需要根据项目情况而定。

:D

