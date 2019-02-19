---
layout: single
title: kafka_zookeper_part2
date: 2019-02-19
tag: kafka zookepeer servisability 
---

# How to test kafka zookeper - Part #2
In part #1 of this article, I was able to see the messages posted in the zookeper queue. I wanted to go one step further and actualy create invalidation entries and see it getting invalidated.

# Step #1 - View messages in queue
 setup myself to watch the messages in the queue.
![2_messages](/blog/assets/images/posts/2019/2_messages.png)

# Step #2 - Check the cachemonitor
![cachemonitor_display_10900](/blog/assets/images/posts/2019/cachemonitor_display_10900.png)

# Step #3 - Generate a entry
Using an SQL Client enter (for this client we are working with oracle):

`insert into cacheivl (dataid,insettime) alues ('##locatecoursematerial:storeId:10900',CURRENT_TIMESTAMP);`

where `##locatecoursematerial:storeId:10900` is the ID of the cache entry to invalidate as per the given id in the cachemonitor app.

# Step #4 - Wait
Wait for a few minutes until the cache invalidation scheduled process kicks in

# Step #5 - Refresh the cachemonitor app
By refreshing the cache monitor app you will see the entry for `##locatecoursematerial:storeId:10900` disapear.
![3_messages](/blog/assets/images/posts/2019/3_messages.png)

![cachemonitor_invalid_10900](/blog/assets/images/posts/2019/cachemonitor_invalid_10900.png)
