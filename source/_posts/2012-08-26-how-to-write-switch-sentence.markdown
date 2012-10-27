---
layout: post
title: "如何写出优美的switch"
date: 2012-08-26 20:50
comments: true
categories: [JavaScript]
---

当代码中出现多个条件分支时(if...else if...else if...else)时可以考虑使用
switch语句。目前不同的浏览器针对到此是if..else效率高还是switch效率高没有
基准。条件过多的话还是建议使用switch语句。为了提高条件匹配的效率，建议把命中
率高的条件，或者经常出现的条件提升到最前面。

下面看一段代码实例:
```javascript
var num = 0;
	result = 0;
switch (num) {
case 0://case条件的缩进和switch一样
	result += 0;//case中的语句需要缩进
	break;//每一个case条件执行完成后要break,否则会继续执行剩下的case
case 1:
	result += 1;
	break;
default://所有条件都不满足时执行默认的语句
	result += num;
}
```
如果你确信自己的代码需要顺序执行剩下的语句，那么也可以不使用break。  :D


