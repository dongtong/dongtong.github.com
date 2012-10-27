---
layout: post
title: "关于 ECMAScript 5"
date: 2012-07-17 23:39
comments: true
categories: [JavaScript]
---

核心JavaScript编程语言,包括DOM,BOM,以及其它一些宿主对象都是基于ECMAScript标准的。第三版是1999年
发布的，被作为标准版，基本被当前大多数浏览器实现，第四版被抛弃，第五版是2009年采纳。

第五版添加了一些新的内建对象，方法，和一些属性到语言中，所以在一定程度上可以说语言的标准采用了严格模式，类似与HTML 4一样，有"Strict"模式。在第五版中实际上在采用"Strict"模式之后，也移除了语言中的一些"糟粕"。
例如"with"语句，如果在第五版中还是用with语句的话，将会抛出错误。如果在非"Strict"模式中使用的话，
不会抛出错误。

通过简单的字符传来设定语言是否采用的是"Strict"模式：
``` javascript Use strict mode
function useStrictMode(){
	"use strict";
	//...其他实现
}
```
ECMAScript 5只是一个过渡版，今后的将会全是Strict Mode。


