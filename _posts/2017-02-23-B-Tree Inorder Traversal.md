---
layout: post
title: B-Tree Inorder Traversal
date: 2017-02-23 17:19:22 +0800
categories: leetcode
---
[@leetcode](https://leetcode.com/problems/binary-tree-inorder-traversal/)

``` ruby
#recursion
def inorder_traversal(root,output=[])
    if not root.left.nil?
        inorder_traversal(root.left,output)
    end

    output << root.val

    if not root.right.nil?
        inorder_traversal(root.right,output)
    end
    return output
end

# http://www.geeksforgeeks.org/inorder-tree-traversal-without-recursion-and-without-stack/
#Threaded B-Tree
def inorder_traversal(root)
    current=root
    output=[]
    while ! current.nil?
        if current.left.nil?
            output << current.val
            current=current.right
        else
            pre=current.left
            while (! pre.right.nil?) && (pre.right!=current)
                pre=pre.right
            end
            if pre.right.nil?
                pre.right=current
                current=current.left
            else
                pre.right=nil
                output << current.val
                current=current.right
            end
        end
    end
    return output
end

# http://www.geeksforgeeks.org/inorder-tree-traversal-without-recursion-and-without-stack/
#Stack
def inorder_traversal(root)
    current=root
    stack=[]
    output=[]
    begin
        if ! current.nil?
            stack.push current
            current=current.left
        end
        if current.nil? && ! stack.empty?
            popped=stack.pop
            output << popped.val
            current=popped.right
        end
    end until current.nil? && stack.empty?
    return output
end
```
