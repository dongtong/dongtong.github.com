---
layout: post
title: "Add new page in Octopress"
date: 2012-10-26 22:33
comments: true
categories: [Octopress]
---

If you want to add new page in Octopress, just like Octopress's build-in "Blog" and "Archives" link. Firstly, you should create new page that you
want.
```
$> rake new_page["about"]
```
Then, Octopress engine will create the following fold and file:
```
mkdir -p source/about
Creating new page: source/about/index.markdown
```

Secondly, you should edit "source/_includes/custom/navigation.html" file as 
following:
```html
<ul class="nav">
  <li><a href="{{ root_url }}/">Blog</a></li>
  <li><a href="{{ root_url }}/blog/archives">Archives</a></li>
  <li><a href="{{ root_url }}/about">About</a></li>
</ul>
```

Last, you could add about informaton in "source/about/index.markdown" and run:
```
$rake generate
$rake deploy
```
You will find "About" in navigation bar. :)

