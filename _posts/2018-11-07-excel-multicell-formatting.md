---
layout: single
title: "Excel multicell formating"
date: 2018-11-07
tag: excel
---
I am no expert in excel, so for a few years already I have been trying to find a way to format all cells in Column A based on the text enter in Column B. Call me excel dummy, but every time that I have this requirement I spend hours searchs and I find macros and tools that do it, but no free way, and the documentation doesn't help me.

Fast forward to TODAY.. EUREKA! I found a way.. 

## How to highlight all(or a range) of cells in Column A from a value in Column B cells
### Requirement
| Column A | Column B |
| --- | ---|
| <font color="red">format this cell red</font>     | <font color="red">not working </font>| 
| <font color="green">format this cell green</font> | <font color="green">working </font>|
| <font color="red">format this cell red</font>     | <font color="red">not working </font>|
| <font color="red">format this cell red</font>     | <font color="red">not working </font>| 
| <font color="red">format this cell red</font>     | <font color="red">not working </font>| 
| <font color="green">format this cell green</font> | <font color="green">working </font>|
| <font color="green">format this cell green</font> | <font color="green">working </font>|
| <font color="red">format this cell red</font>     | <font color="red">not working </font>|
| <font color="green">format this cell green</font> | <font color="green">working </font>|

You get the idea

## The solution
Using `Excel for Mac v16`. The gist of it is,
1. Select the range that you want the formating to take effect in our case Column A and Column B (but can you select only Column A)
2. Click on **Conditional formatting** -> **New rule** 
3. Select Style: Classic
4. Select Use a formula to determine which cells to format
5. enter `=search("not",$B2)`
![Step 2](/images/posts/2018/Screen Shot 2018-11-07 at 10.26.54 PM.png)

Steps #1 #5 are the key here. Step 1 defines the area to change the formatting to, and Step 5 is the formula for find a text **not** on only Columb B mantain `$B` as constant but rows are variable `2`, in other words always evalute the row where the formula is executed.

In the video I show you how to go about formatting all of the table, but I used a cheap trick, rules ordering.
- I created two rules: one green, one red
- I use ordering to make the `working` cells green and the `not working` cells red.

{% include youtubePlayer.html id=M6Z3X55WWw4 %}

