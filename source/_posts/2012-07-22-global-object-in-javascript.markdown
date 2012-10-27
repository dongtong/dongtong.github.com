---
layout: post
title: "JavaScript中的全局对象"
date: 2012-07-22 14:29
comments: true
categories: [JavaScript]
---

JavaScript使用function来界定作用域，如果在function内部定义一个变量，那么它就是local的，如果
在function外部定义一个变量，那么就是global的。

在浏览器上下文中，有一个window属性指向的是global对象，不论是否在function内部还是外部，只要
声明变量不使用var那么浏览器就把它当做window的属性，如果在function外部，this指代的也是window。
下面声明的就是window对象的属性:

``` javascript Declare global object
globalVar1 = "hello world";
console.log(window.globalVar1);// hello world

(function declareGlobalVar(){
	globalVar2 = "foo bar";//如果在其余代码中申明globalVar2这个全局变量就会出问题
})();
console.log(window['globalVar2']);//foo bar
console.log(this.globalVar2);//foo bar

(function chainAssign(){
    var foo = bar = "hello world";//这里其实首先执行的是 bar = "hello world",没有使用var
})();
console.log(window.bar);//bar变成了window的属性
console.log(window.foo);//foo还是local

(function chainAssign2(){
    var foo, bar2 = "hello world again";
})();
console.log(window.bar2);//bar2是local
console.log(window.foo);//foo还是local

(function chainAssign3(){
    var foo, bar3;
    foo = bar3 = "hello world again too";
})();
console.log(window.bar2);//bar3是local
console.log(window.foo);//foo还是local

```
<!-- more -->
声明全局对象有什么问题？声明的全局对象共享同一个namespace,在同一个应用中的所有代码都可以访问
和修改全局对象，如果应用程序变得庞大了，那么很有可能会声明相同名字的全局对象，但是声明的目的
又不相同，那么就会导致访问这个全局对象不是程序所预期的。另外一种情况是使用多个第三方类库，而
这些类库中出现同名的全局对象，这样也会导致全局对象冲突问题。还有一种情况是运行在别的JavaScript
环境中，如Node.js运行在服务器上，如果这时声明的全局对象和内置的全局对象同名，还有一中情形是用测试的JS脚本去运行，如果测试脚本中包含了应用中相同的全局变量名，那么就有可能导致冲突。:D

可以通过delete删除全局对象，在ECMAScript 5版本中，如果声明变量没有使用var,程序就会抛出错误。这里说明一些，有些文章说使用var声明的全局变量不可以使用delete删除，实践检验是可以删除的。
```
var global1 = "foo";
global2 = "bar";
(function(){
    global3 = "goo";
})();
console.log(this.global1);//foo
console.log(this.global2);//bar
console.log(this.global3);//goo
console.log(delete global1);//true
console.log(delete global2);//true
console.log(delete global3);//true
console.log(this.global1);//undefined
console.log(this.global2);//undefined
console.log(this.global3);//undefined
```

如何访问全局对象?
```
var global = (function(){
    return this;
}());

console.log(global)// Window
```
这样就不拘泥于是否是浏览器环境了，否则访问全局对象需要使用window.XXX
但是这在ECMAScript 5中被废弃了，注意使用。

在function中定义变量最好放在function顶端:
在定义变量的同时最好做一些实质性的动作，例如赋值等等。
```
function declareVar(){
    var a = 'bar',
        b = 'foo',
        sum = a + b,
        result = function(){return 2};
    //...
}
```
这样的好处就是不会漏掉var, 让变量成为全局对象。








