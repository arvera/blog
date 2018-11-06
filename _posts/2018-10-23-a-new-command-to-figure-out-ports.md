---
layout: single
title: A new command to figure out ports
date: '2018-10-23T10:21:00.001-07:00'
tags: 
modified_time: '2018-10-23T10:21:24.299-07:00'
blogger_id: tag:blogger.com,1999:blog-17927613.post-3519316890016321392
blogger_orig_url: https://gunfus.blogspot.com/2018/10/a-new-command-to-figure-out-ports.html
---
## Background
Recently in a project as we were doing the setup of the system, our hosting provider made a typo in one of the MANY ports that our solution uses and it cause a lot of confussion.

When creating the VIP (Virtual IPs) and ports mapping and the ports got flipped. Our hosting provider gave us a document saying this are your servers:

| IP | server service |
| -- | -- |
| 10.2.3.120 | VIP for live |
| 10.2.3.121 | VIP for  auth  |
|  |  | 
| 192.168.1.140 | IP for live |
| 192.168.1.141 | IP for  auth  |

But we found out it was reversed, `.120` was auth and `.121` was live.

So after a lot arguing and a lot of hours of explaining what happened, the question was

## How to test where the VIPs are pointing?

I had the need to find a way to bring down the server and effectively test  that we are hitting a particular server in a specific port, not through the ports that are used by the server and services because sometimes they may not necessarily tell me if I am hitting auth. My options:
- Check the access log in the web server
- Create different data in auth and live (a user or a product that exists in auth but not in live)
- Enable accesslog trace in the app server

Find a way to test without the app server layer?

## Solution

*From Auth:*

1. logon to auth at 192.168.1.141
2. `nc -l 5001`

*From a client try:*

3. http://10.2.3.120:5000
4. in auth, check the output of the `nc` command 