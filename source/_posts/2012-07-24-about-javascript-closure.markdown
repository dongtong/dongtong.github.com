---
layout: post
title: "关于JavaScript闭包"
date: 2012-07-24 22:25
comments: true
categories: [JavaScript]
---

首先看看大牛是怎么定义闭包的:

“…一个内部函数可以访问外部函数的vars, 或者parameters.即使是外部函数已经返回”
-“Douglas Crockford”

要想理解closure,最好是写一些代码，或是看一些例子。
``` javascript
function myClosure(){
     var date = new Date();
     //nested function
     return function(){
           return date.getMilliseconds();
     }
}
```
即使是当myClosure中的匿名函数(即闭包)返回，但是date变量仍然驻留在内存中，而不
像普通的函数执行完成后就随时可能被garbage collection回收了。闭包提供了封装
(encapsulation)。这里把myClosure看作是一个容器，而date和nested function被看做
是这个容器中的元素。

另外一种实现方式:
``` javascript
var myClosure2 = function(){
     var date = new Date();
     var myNestedFunc = function(){
           return date.getMilliseconds();
     }
     return {// revealing modular pattern
           foo: myNestedFunc
     }
}
var bar = new myClosure2();
console.log(bar.foo());
```
<!-- more -->

在JavaScript的一些高级应用中常常用到了闭包，在面试前端工程师时，也常常会问及
闭包相关问题。要想理解好闭包，首先必须弄清楚变量作用域。

JavaScript变量作用域分为全局(global)和局部(local),在function局部作用域中可以
访问全局变量，但是在function外部，不可以单纯地访问函数内部的局部变量，如果想
要访问，那就需要借助闭包(closure)。下面看一些简单的实例。
``` javascript 局部访问全局变量
var bar = "bar";
function printFooBar(){
       console.log("foo " + bar);//函数体内部访问全局变量bar
}
```
``` javascript function外部访问内部局部变量
function getFoo(){
    var str = "foo";
    return function(){
        return str;
    }
}
var result = getFoo();
console.log(result());
```
由于JavaScript中的链式作用域(chain scope)特性, getFoo中的匿名函数可以访问str, 但
是这里如果匿名函数中有局部变量的话。getFoo不能访问匿名函数中的局部变量。

这里通俗理解闭包为”能够访问其它函数变量的函数”或者是“函数内部定义函数，然后返回这
个内部函数”。可以看出闭包是链接函数内部和函数外部的桥梁。

闭包有两个直接用途: 一是访问function内部局部变量，二是让内部局部变量持续在内存中。
``` javascript
function getNumber(){
    var num = 1;
    numSum = function(){//注意这个匿名函数是全局的，并且也是一个closure
        num += 1;
    }
    return function(){//返回closure
        return num;
    }
}
var result = getNumber();//指向返回的closure
console.log(result());//1
numSum();
console.log(result());//2,说明num一直驻留在内存中，不会因为getNumber调用结束就释放
num,主要是有全局引用(result)引向getNumber的闭包使得num一直没有被garbage collection
回收。
```

使用闭包需要注意的是，不能滥用，看项目的大小以及需求，否则会导致内存持续膨胀，性能
下降，在IE环境中内存会泄露。最好是在用完闭包后，能手动释放局部变量。另外一种情况是
如果闭包能改变容器函数(即包含闭包的函数)中的局部变量，使用时需要小心。

下面看一个JavaScript闭包实例，听说能理解的话，基本闭包就没有问题了。
``` javascript
var name = "The Window";
var object = {
　　　　name : "My Object",
　　　　getNameFunc : function(){
　　　　　　return function(){
　　　　　　　　return this.name;
　　　　　　};
　　　　}
};
console.log(object.getNameFunc()()); 

var name = "The Window";
　　var object = {
　　　　name : "My Object",
　　　　getNameFunc : function(){
　　　　　　var that = this;
　　　　　　return function(){
　　　　　　　　return that.name;
　　　　　　};
　　　　}
};
console.log(object.getNameFunc()());
```
放到firebug或者chrome中试试吧，如果在IE下，将console.log()换成alert()。

站在巨人肩膀上学习 :D







