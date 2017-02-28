---
layout: post
title: Distinct Subsequences
date: 2017-02-23 17:19:22 +0800
categories: leetcode
---
[@leetcode](https://leetcode.com/problems/distinct-subsequences/)

> treat as a DP question, child string is T, length is t_len; paraent string is S, length is s_len. Sub(i,j) represent how many times first j chars of T show in first i chars of S.(0<=j<=t_len, 0<=i<=s_len)

```
Sub(i,j)=
    0, i<j
    1, j=0
    Sub(i-1,j), T[j-1]!=S[i-1]  *last character of T&S is different*
    Sub(i-1,j)+Sub(i-1,j-1),  T[j-1]=S[i-1] *last character of T&S is same*
```

### way #1, recursion

``` ruby
def num_distinct(s, t)
    if s.size<t.size
        0
    elsif t.size==0
        1
    elsif s[0]==t[0]
        num_distinct(s[1..-1],t)+num_distinct(s[1..-1],t[1..-1])
    else
        num_distinct(s[1..-1],t)
    end
end
```

### way #2, iteration

``` ruby
def num_distinct(s, t)
   s_len=s.size
   t_len=t.size
   match=Array.new(t_len+1,0)
   if s_len<t_len
       return 0
   end
   match[0]=1
   for i in (1..s_len)
    t_len.downto(1) do |j|
        if s[i-1]==t[j-1]
            match[j]+=match[j-1]
        end
    end
   end
    return match[t_len]
end
```

> for reference, idea of iteration

![]({{ site.url }}/assets/distinct-subseq-iteration.jpg)
