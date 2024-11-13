---
layout: single
title: jsx-rendering.md
date: 2024-11-13
tag: jsx react rendering  
---
# Coding in React
It has been a few years since I done react. Everytime I try to learn react I either get distracted or find it too complex and when I start going down the rabbit hole of redux or axios, I then get distracted and never get to the end. 

Today's post is short, there are many thoughts in my head about how to teach what I have learn on this post, but I really just wanted to share one VERY IMPORTANT thought about react. 

React is dynamic and very opinionated finding tutorials that follow the same pattern or coding practices is HARD. To add on to it, the React libraries keep changing often for the better (or worst) of the community you will find LOTS and LOADS of material that is out of date. In fact even the same [redux tutorial part 5](https://redux.js.org/tutorials/fundamentals/part-5-ui-react) website says it in big bold letters. And don't forget there is also the possiblity to do TypeScript to make your life easier... 

![Part 5 React UI](/blog/assets/images/posts/2024/jsx_rend0.png)


Learning about react has been a steep hill.. but at least I think I am getting somewhere. For now before I start writing other post I want to leave you with one thought that really kick me on the head today as I get more familiar writting in jsx, and call me dummy but I want to really highlight is the fact that you have to be flexible and bend your head side ways sometimes when learning react and when learning ensure that you stick to one person/tutorial and be patient with it. 

The following is an example of how one code can do the same but yet look different, which makes it hard to read when you are kumping in between tutorials:

In this first case we have logic inside of the main return function of the component
![JSX render all in one return](/blog/assets/images/posts/2024/jsx_rend1.png)

... in this second example, it might not be obvious to you, but we have a separate function that renders the component that belongs to the individual profile, separating the logic and making one part of the code easier to read.
![JSX render all in split return](/blog/assets/images/posts/2024/jsx_rend2.png)


Now which is better is up to the eye of the beholder. Here is another example that I was able to come up with it quickly...
![Function sample 1](/blog/assets/images/posts/2024/jsx_rend3.png)


In this case this is a little more obvious that it provides the same results,
![Function sample 2](/blog/assets/images/posts/2024/jsx_rend4.png)

But the point is that there are many different style of programming that can affect the learning curve, and when it comes to folder structure well that is a another topic on its own...  as I once read in a blog somewhere. Just be consistent with your own self..!!


