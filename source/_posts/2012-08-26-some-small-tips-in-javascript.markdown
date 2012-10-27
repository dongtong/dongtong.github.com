---
layout: post
title: "JavaScript语言中的一些小建议"
date: 2012-08-26 23:22
comments: true
categories: [JavaScript]
---

下面列举一些JavaScript编程过程中的小建议，这些也可以编程项目开发中的
一些约定，其实这些小建议可能大家有些地方不是很赞同，其实遵守一些约定比
这些约定的内容更重要，即使是一些比较糟糕的约定，如果大家都去遵守了，我
想这些糟糕的约定也就不会惹来话柄了。下面看看这些小建议:

<!--More-->
1. 在做比较的时候，为了避免隐式类型转换，请使用 '===', '!==='而不是
   '=='和'!=='。
   因为 false == 0, "" == 0这些都是"真的",你不会期望这样吧

2. 不要使用eval()函数。
   首先是不安全，可能会执行ajax获取的脚本，万一这些脚本被修改过，那么
   前台就可能存在危险。关于eval更深入的详述，以后再细说。

3. 使用parseInt()时，最好加上第二个参数指明转换成什么进制.
   parseInt('09')会转换成0,因为在转换过程中首先遇到了'0'，那么就把
   它当做八进制转换，但是八进制中没有9，所以非法，最后就得到了0.
   应该这样：parseInt('09', 10)

   +'09'和Number('09')其实更快，但是 Number('09 foobar')就得不到
   9了。

4. 关于代码缩进问题，很多程序员都不是很统一，有的使用tab,有的使用空格
   其实使用tab会有一些小麻烦，因为不同的编辑器对待tab的长度不全是一致的。
   所以建议使用空格，至于多少个空格，可以在项目约定中指出，个人偏好使用
   4个空格。

5. 语句块最好使用{}包围。

```javascript
    for (var i = 0; i < 10; i++)
        console.log('foo');//这样是正确的，但是如果以后添加语句呢？

    for (var i = 0; i < 10; i++){
   		console.log('bar');
	}
```
6. {}最好第一个括号添加在语句末尾
```javascript
   function print(){
   		return  
   		{
   			name: 'foobar'
   		};
   }
   //你知道哪里出问题了吗?
   function print(){
   		return{
   			name: 'foobar'
   		};
   }
```
   这里牵涉到"分号插入机制"，第一种情形会return undefined;分号自动添加在return
   后面。

7. 代码要有空格
```javascript
	for (var i = 0; i < 10; i++){...}
	function printFoo() {...}
	var arr = [1, 2, 3];
	printBar(str1, str2);
	var myFunc = function () {...};
	//等等
```
8. 命名约定。
    函数名使用驼峰标志,如printFooBar().变量使用下划线 first_name, my_own_val.
    常量可以使用全是大写字母PI, WIDTH。私有方法前加一个下划线(_getName())。其实
    JavaScript没有私有方法一说。似有属性使用两个下划线等等，这些都是可以在项目中约
    定的。

9. 代码一定要有注释(后面阐述如何使用YUI Doc注释工具)。

10. 代码一定需要review。在review中别人可以很容易发现我们的错误，所谓"旁观者清，当局者迷"。

11. 开发过程中，最好经常使用JSLint工具

12. 最终发布代码时，最好使用工具来压缩代码，精简代码，加快浏览器的加载速度。

以后继续添加Tips  :D






