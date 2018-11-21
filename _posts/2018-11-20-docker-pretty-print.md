---
layout: single
title: "Docker pretty print"
date: 2018-11-20
tag: wcs docker format default
---
## Configuring docker ps default formating
In this particular post from Eric.scott [Getting started with Commerce v9 Search](https://www.ibm.com/developerworks/community/blogs/wcs/entry/Getting_Started_With_Commerce_v9_Search?lang=en)
he talks about formating the output of while you do `docker ps`. In my team we have not been particularly concern about the formating, we have been focused on getting things working and getting familiar with the new infra for IBM Commerce v9.

One day I got fedup with the verbose output and figure out a way to make it work for me. 

We all use a `docker` user common to all systems that we mantain, this makes it easy for us to track the work of the commands that we run, that makes collaboration and handing tasks off easy. So for that user I did the following setup:

1. `mkdir -p /home/docker/.docker`
2. `vi config.json`
3. copy the content below:

    ```
    {
        "psFormat":  "table \{\{.ID\}\}\\t\{\{.Names\}\}\\t\{\{.Image\}\}\\t\{\{.RunningFor\}\} ago\\t \{\{.Status\}\}"
    }
    ```

4. save the file

Now everytime we do `docker ps` we get better output
```
CONTAINER ID        NAMES                                  IMAGE                                                      CREATED ago          STATUS
ac74dc63b95f        dockercomposescripts_utils_1           192.168.2.34:5000/commerce/ts-utils:9.0.0.6              11 days ago ago      Up 11 days (healthy)
47c3c97a8dfb        dockercomposescripts_store_1           192.168.2.34:5000/commerce/crs-app:9.0.0.6               11 days ago ago      Up 11 days (healthy)
062f7bdacf3f        dockercomposescripts_web_1             192.168.2.34:5000/commerce/ts-web:9.0.0.6.1              11 days ago ago      Up 11 days (healthy)
60d00c6ffa6f        dockercomposescripts_txn_1             192.168.2.34:5000/commerce/ts-app:9.0.0.6                11 days ago ago      Up 4 hours (healthy)
f2f3cd05a597        dockercomposescripts_search_master_1   192.168.2.34:5000/commerce/search-app:v9.0.0.6           11 days ago ago      Up 7 days (healthy)
6408f1a14d1a        dockercomposescripts_kafka_1           192.168.2.34:5000/ches/kafka:latest                      5 weeks ago ago      Up 5 weeks (healthy)
93d49b2e14ef        dockercomposescripts_zookeeper_1       192.168.2.34:5000/zookeeper:latest                       5 weeks ago ago      Up 5 weeks (healthy)
ca8f3d761877        dockercomposescripts_xc_1              192.168.2.34:5000/commerce/xc-app:9.0.0.6                5 weeks ago ago      Up 5 weeks
6a37926d6b15        dockercomposescripts_mig_utils_1       9cd856c90bd6                                               2 months ago ago     Up 5 weeks (healthy)
```

