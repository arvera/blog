---
layout: single
title: How to Elastic_Mappings
date: 2021-05-20
tag: elasticsearch elastic search91
---
In this post I am going to explain how HCL Commerce using Elasticsearch Solution extracts the data out of the DB tables and transforms it into an format that creates an index in Elasticsearch. The data in the Elasticsearch index is later prepare using the Query container to prepare the data for the storefront consumption but the display of the data is not the focus of this topic. I am only concern about from DB Records into Elasticsearch index format.


The HCL Commerce Search with Elasticsearch solution does an ETL process of the data in the Database to a flat format into Elasticsearch. That process is done with NIFI doing the work(logic) of the transformation and then pushing the transformed data into an Elasticsearch index. That entire process looks like:

![images/adding_new_mappings_image1.png]
