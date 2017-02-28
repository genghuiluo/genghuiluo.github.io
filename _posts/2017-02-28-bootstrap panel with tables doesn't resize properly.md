---
layout: post
title: bootstrap panel with tables doesn't resize properly
date: 2017-02-23 17:19:22 +0800
categories: web
---
> [@bootstrap github issue](https://github.com/twbs/bootstrap/issues/13202)

table overflow the parent container e.g. a panel
![]({{ site.url }}/assets/noresponse_table.jpg)

we can use .table-responsive wrap the table, but this only work when browser width less than 768px
``` html
<div class="table-responsive">
    <table class="table table-striped">
        ... 
    </table>
</div>
```
parent container will generate a scrollbar for table.
![]({{ site.url }}/assets/response_table.jpg)

add overflow-x: auto, can solve this tricky status
``` html
<div class="table-responsive" style="overflow-x: auto">
    <table class="table table-striped">
        ... 
    </table>
</div>
```
