---
layout: single
title: Adding Google AdSense
date: 2019-02-27
tag: adsense jekyll
categories: jekyll
---
To add add [Google AdSense](Google AdSense - Make Money Online through Website Monetization
https://www.google.com/adsense/start/) to a jekyll blog I found this post from [My Cyber Universe](https://mycyberuniverse.com/add-google-adsense-to-a-jekyll-website.html) was helpful but it lack of details.

# So here are the neaty greaty details
1. Create the account with [Google AdSense](Google AdSense - Make Money Online through Website Monetization
https://www.google.com/adsense/start/) 
2. During the process there will be a *blur* about some script that needs to be added to the head
   ![ad_sense_head_src](../assets/images/posts/2019/add_sense_head_src.png)
3. Copy the text from the *blur* in step 2
4. In your git repo, locate `_includes/head/custom.html` and paste the *blur* as prefered in that file
5. `git add`
6. `git commit -m "adding the blur"`
7. `git push`


