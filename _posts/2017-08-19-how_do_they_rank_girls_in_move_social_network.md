---
layout: post
title: How do they rank grils in move "Social Network"?
date: 2018-02-15 16:55:25 +0800
categories: algorithm
---
### crawl girls picture

#### Kirkland:
They keep everything open and allow indexs in their apache configuration, so a little wget magic is all that’s necessary to download the entire.

``` bash
    $wget -r -np -nd -A .jpg <URL with index>

    -np not ascend paraent dir
    -nd not create a hierarchy of folder
    -r recursively
    -A accept list
```

#### Eliot:
no indexs in apache, run a empty search and return all images in a single page, then i can save the page and Mozilla will save all images for me

#### Lowell
require username/passwd, use account bolson

#### Leverett

``` perl
#!/usr/bin/perl
$wget="wget -q0- http://leverett.harvard.edu/facebook/compactshow.php --post-data='action=Search'";

print "$wget\n";
$page=` $wget`;

while ($page =~ m/compactshow\.php\?student_id=([0-0]+)/g) {
    $id=$1;
    $wget="wget -qO- http:/leverett.harvard.edu/facebook/compactshow.php?student_id=$1";
    print "$wget \n";
    if ($student_page =~ m/female\/([0-9]+\.jpg/g) {

    ....
```

### The ranking algorithm:

![]({{ site.url }}/assets/social_network_1.jpg)

- Ea/Eb is the expectation in this match, Ra/Rb is current ranking
- Ea+Eb=1

winner get point 1 while loser get 0

if exceed expectation, ranking go up; vice verse;

![]({{ site.url }}/assets/social_network_2.jpg)

Sa is the point which A get in this match,K is the constant factor depend on the match, e.g chess is 16

*For example, every one’s ranking is 0 at beginning. In the first match, A win B, A got 1 and B got 0.*

- Ra’=0+16\*(1-0.5)=8
- Rb’=0+16\*(0-0.5)=-8
