---
layout: single
title: Using Dynamic templates with HCL Commerce and Elastic Search
date: 2021-06-24
tag: search commerce elasticsearch
---
I have been doing a lot of experimenting and reading on the capabilities of HCL Commerce when combined with the Elasticsearch solution.

My experimenting has been mostly around the schemas definition and to see what is possible, and how to interact with what HCL Commerce provides OOTB.

In my most recent experimenting I am trying out a capability of Elasticsearch known as (dynamic templates)[https://www.elastic.co/guide/en/elasticsearch/reference/7.13/dynamic-templates.html]. To say that they are cool is understament. Dynamic template allow you to define a Mappings for an Object Type that can exists anywhere in the _doc tree. This will make more sense as we explore the example on this post. Just understand that the idea is that you define a Mapping for a type of Object Type of a particular data structure like "keyword" or "long" or anything like that and then you define where in the _doc tree should this be applied by means of a pattern.
