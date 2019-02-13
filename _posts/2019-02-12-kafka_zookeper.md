---
layout: single
title: kafka_zookeper
date: 2019-02-12
tag: kafka servisability caching
---

The purpose of this post is to show how IBM Commerce v9 works with kafka and zookeper. We start from a already configured KAFKA and ZOOKEPER containers installed, we do not cover the installation or setup, maybe I'll do that in a different post.

## Where our adventure begins

We are using docker-compose files to deploy our images. 
`docker ps`

```
CONTAINER ID        NAMES                   IMAGE                                                         CREATED              STATUS
1d2dd42f442a        wcs_store_1             10.176.103.130:5000/commerce/crs-app:9.0.1.2                  4 days ago           Up 4 days (healthy)
483e820d2398        wcs_web_1               10.176.103.130:5000/commerce/ts-web:9.0.1.2                   4 days ago           Up 4 days (healthy)
6c069caa391c        wcs_search_slave_1      10.176.103.130:5000/commerce/search-app:v9012-ltr-search-774   4 days ago           Up 4 days (healthy)
793d37593563        wcs_kafka_1             10.176.103.130:5000/ches/kafka:latest                         4 days ago           Up 4 days (healthy)
16c25f94c9a5        wcs_search_repeater_1   10.176.103.130:5000/commerce/search-app:v9012-ltr-search-774   4 days ago           Up 4 days (healthy)
5d0e7773757f        wcs_utils_1             10.176.103.130:5000/commerce/ts-utils:v9012-ltr-util-774       4 days ago           Up 4 days (healthy)
09277557c010        wcs_zookeeper_1         10.176.103.130:5000/zookeeper:latest                          4 days ago           Up 23 hours (unhealthy)
652def4df73c        wcs_txn_1               10.176.103.130:5000/commerce/ts-app:v9012-ltr-ts-774           4 days ago           Up 4 days (healthy)
d078bb64d7d2        wcs_xc_1                10.176.103.130:5000/commerce/xc-app:9.0.1.2                   4 days ago           Up 4 days
```

By default docker compose creates its own docker `networks` components, and below is the listing:
`docker network ls`
```
NETWORK ID          NAME                DRIVER              SCOPE
6a2eed1fa166        bridge              bridge              local
32d98311bb09        host                host                local
6ee485982f5a        none                null                local
5b0b97016d25        wcs_default         bridge              local
```

## Step 0 - Get ready

### Server URLs to create caching entries
With all the configuration identified, we now need:
1. To identify a URL `https://myhostname/myurl` 
2. Ensure that the path for this URL is defined in the (cachespecs.xml)[https://www.ibm.com/support/knowledgecenter/en/SSAW57_9.0.0/com.ibm.websphere.nd.multiplatform.doc/ae/rdyn_cachespec.html] 
3. Use the (cachemonitor application)[https://www.ibm.com/support/knowledgecenter/en/SSZLC2_7.0.0/com.ibm.commerce.admin.doc/tutorial/tdcperf1b.htm] to ensure entries are being cached (hint: here is the URL for the cahce monitor application after installed https://1.11.111.2:5443/cachemonitor)

### Ensure the configuration matches 
In order to use kafka inside the container you will need to always unset the JMX_PORT. You will see this `unset JMX_PORT;` always ahead of the command to run as in step 3 below.

1. login to the server and run: `docker exec -it wcs_kafka_1 bash`
2. once inside the `kafka@kafka` enter `cd bin`
3. `unset JMX_PORT;kafka-topics.sh --list --zookeeper zookeeper`
   Which will list
   ```
   WCdemo
   WCdemoCacheInvalidation
   __consumer_offsets
   ```

***WCdemo*** is the topic queue setup in the txn image during the build process. For more information on configuring kafka refer to this (other post)[2019-02-12_configure_kafka.md]


## Step 1 - Enable caching tracing
1. Enable extended tracing with the following string: `com.ibm.commerce.dynacache.*=all`
 

## See all the msgs
`unset JMX_PORT;kafka-console-consumer.sh --zookeeper zookeeper --topic WCdemoCacheInvalidation --from-beginning`
```
cache:services/cache/WCStoreDistributedMapCache===WCT+STORECONF
cache:services/cache/WCStoreDistributedMapCache===WCT+STORECONF+STOREENT_ID+NAME:%:0:%:skipConnectOnceStudent
cache:services/cache/WCStoreDistributedMapCache===WCT+STORECONF+NAME:%:skipConnectOnceStudent
cache:services/cache/WCStoreDistributedMapCache===WCT+STORECONF+STOREENT_ID:%:0
cache:services/cache/WCStoreDistributedMapCache===WCT+STORECONF
cache:services/cache/WCStoreDistributedMapCache===WCT+STORECONF+STOREENT_ID+NAME:%:0:%:DATABASE_TIMEZONE
cache:services/cache/WCStoreDistributedMapCache===WCT+STORECONF+NAME:%:DATABASE_TIMEZONE
cache:services/cache/WCStoreDistributedMapCache===WCT+STORECONF+STOREENT_ID:%:0
cache:services/cache/WCStoreDistributedMapCache===WCT+STORECONF
```



