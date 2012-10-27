---
layout: post
title: "如何优化for loops"
date: 2012-07-22 21:46
comments: true
categories: [JavaScript]
---

一般大多数JavaScript代码中关于迭代循环的，都使用的是for循环，如果循环的是基本
类型还好，如果循环的是DOM数组的话，效率就会降低。

首先for循环中判断数组，或类数组对象的长度是在每次迭代中都会计算的。
``` javascript
for(var i = 0; i < arr.length; i++){//arr.length每次都会计算
	//...
}
```

浏览器处理DOM对象本来代价就比较大，如果在数组中处理代价就更大了，虽然现在的CPU
和内存都不是问题了，但是可以优化的地方还是需要

注意的。
``` javascript
for(var i = 0; i < divArr.length; i++){
	console.log($(divArr[i]).attr('id'));//每一次访问div对象都会重新搜索一下DOM树
}
```

下面有几种改善方式:
<!-- more -->
第一种，缓存数组的长度。
``` javascript
for(var i = 0, length = arr.length; i < length; i++){
//...
}
```

第二种, 使用JavaScript中的trick,和任何大于0的数字的比较都没有和0比较效率高。
``` javascript
var i, arr = [....];
for(i = arr.length; i--){
	console.log(arr[i]);//如果i--变为0时，for就会做转换 0 == false, 0确实是false.
}
```

第三种，使用while循环

``` javascript
var arr = [...],
	i = arr.length;
while(i--){
	console.log(arr[i]);
}
```

如果你的应用程序是要求效率的，那么就可以考虑考虑上面的方法。 :D



