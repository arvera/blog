---
layout: single
title: Meet HCL Commerce 9.1 Search - Part 1
date: 2020-09-01
tag: wcs intro search 9110 9.1.1.0 9.1 Elasticsearch NiFi
---
In this post I introduce the new HCL Commerce Search 9.1 solution. In ***part 1***(this post) I will cover the new components of search, such as Apache NiFi and Elasticsearch and in [part 2](/Meet_Search_Commerce9111_part2/) I will cover how to enable Trace.

The HCL Commerce 9.1 release involved a huge effort from many people in the product team and as they continue to come up with updated releases that effort is on-going. The changes that went into the platform feel like a renewed product, a fresh start in many aspects, a much needed change. Many clients struggled with preprocessing/indexing and search relevancy issues with Solr and the new search solution provides some exciting improvemments in those areas.  

Many of us are navigating through this new path with a blind fold due to the updated technologies in the new search solution, such as: Apache Nifi, the Ingest and the Query Services. Not everyone embraces changes as new opportunities, but I do. In this post I want to share some interesting aspects of the new HCL Commerce 9.1 Search.

IBM Websphere Commerce introduced IBM Commerce Search in v7 FEP2 and subsequently RESTified and separated the search service from the transaction server in v7 FEP7, that marked a transition point to a new era. A new era where the search component is now a separate component and it is as important as the Database. Fast forward to 2020, HCL Commerce in 9.1 adopted a more cloud ready platform by hooking it up with Elasticsearch and splitting the server based approach that was designed with Solr to a multiple services. The services are now split into a container architecture: Nifi, Query, Ingest, Elasticsearch, Kafka, Zookeeper. All of these components work together to provide the HCL Commerce Search solution in 9.1.

Without going too much into detail [Elasticsearch](https://www.google.com/search?q=What+is+elastic+search) is a search engine based on the [Apache lucene project](https://www.google.com/search?q=What+is+apache+lucene), Solr was also based on [Apache lucene project](https://www.google.com/search?q=What+is+apache+lucene) but that is where the similarities end.

Moving from Solr to Elasticsearch will require carefully planning and thorough analysis of your current search services and customizations. My colleague Rhett Daniel recently posted a blog that touches on considerations in moving to the new search solution: [The Journey to New HCL Commerce V9.1 Search](https://support.hcltechsw.com/community?id=community_blog&sys_id=adb71920db729850a45ad9fcd39619cf)

During the deploying [HCL Commerce v9.1 on a Kubernetes cluster](https://help.hcltechsw.com/commerce/9.1.0/install/tasks/tdeploykubern91-commerce.html), early in the process you are faced with the task of deciding whether you will use Elasticsearch or Solr. If you select Elasticsearch, the first step is to install the Elasticsearch component:

# First step related to Elasticsearch: Installing Elasticsearch
Following the steps from the Help Center in the topic ***Deploying HCL Commerce on a Kubernetes cluster***, see the section on ["Deploy Elasticsearch."](https://help.hcltechsw.com/commerce/9.1.0/install/tasks/tdeploykubern91-commerce.html)
1. `kubectl create ns elastic`
1. `helm repo add elastic https://helm.elastic.co`
1. `helm repo update`
1. In the bundle for the HELM Charts, navigate to: `hcl-commerce-helmchart/sample_values/elasticsearch-values.yaml`, there is a sample file to use for your Elastisearch deployment
1. `helm install elasticsearch elastic/elasticsearch -n elastic -f localvalues.yaml`
1. Ensure that container is running: `kubectl get pods -n elastic`


# Second step related to Elasticsearch: Modifying the Commerce Helm charts
Later in the ***Deploying HCL Commerce on a Kubernetes cluster***, after completing other install procedures, when you will get to the Commerce Helm charts where you need to specify that you are deploying with Elasticsearch, note the following property/value pairs controls the deployment in the values.yaml file.

| package | helm file | property|
| --- | --- | --- |
| HCLCommerceDevOps | `hcl-commerce-helmchart/stable/hcl-commerce` |`searchEngine: elastic`|

After modifying the Helm charts you will proceed to install the shared commerce components for HCL Commerce, for more information on the what is shared refer to the [HCL Commerce production environment overview](https://help.hcltechsw.com/commerce/9.1.0/install/refs/riginfrastructure.html)

As you can see the the enablement of HCL Commerce Search with Elasticsearch is straight forward. There is a few extra containers that come to play to make the entire solution work refer to [Using the V9.1 HCL Commerce Search service](https://help.hcltechsw.com/commerce/9.1.0/search/concepts/csdsearchingest.html):

* [Ingest](https://help.hcltechsw.com/commerce/9.1.0/search/concepts/csdsearchconnectors.html) for loading data
* [Query](https://help.hcltechsw.com/commerce/9.1.0/search/concepts/csdelasticsearchquery.html) for getting data
* [NiFi](https://nifi.apache.org/) for visualizing, modifying and controlling the pipeline of services that are used to load the data and make it consumable by Elasticsearch
* [Elasticsearch](https://www.elastic.co/elasticsearch/) for storing the data and the core search engine
* [Kafka](https://kafka.apache.org/)/[Zookeeper](https://zookeeper.apache.org/) for storing and sharing the configuration

Using the HCL Commerce with Elasticsearch will require some new terminology, and new practices. [The Journey to New HCL Commerce V9.1 Search](https://support.hcltechsw.com/community?id=community_blog&sys_id=adb71920db729850a45ad9fcd39619cf) together with the part 1 of this article will provide you with some high level understanding of the new components in play. Stay tuned for part 2 of this post on ***"Meet HCL Commerce 9.1 Search"*** series where I will discuss how to turn on debugging in the new containers.
