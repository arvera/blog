---
layout: single
title: configure_kafka
date: 2019-02-12
tag: wcs kafka
---

Edit your docker-builds/ts-app/Dockerfile and add the following line:

| From `Dockerfile` |
| --------------- |
| ... `RUN run set-kafka-server kafka:9092 WCdemo zookeeper:2181` ... |
