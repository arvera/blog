---
layout: single
title: Meet Search Commerce 9111 Part 2
date: 2020-09-17
tag: ingest query search commerce servisability
---
This is part 2 of a series of article that aim to introduce the new feature in HCL Commerce Search that uses Elasticsearch as an engine. In this post we will focus on two components ingest and query, I will provide a high level description and then show how to turn trace on for those components. But before jumping into the main topic...

Notice that I am not just saying HCL Commerce with Elasticsearch and that is intentional. HCL Commerce search have added benefits on top of Elasticsearch, HCL Commerce does not uses Elasticsearch standalone, there are added components and features on top of Elasticsearch. Thus it is not HCL Commerce + Elasticsearch, it is HCL Commerce + HCL Commerce Search, and HCL Commerce Search, uses Elasticsearch as a data layer. It is important to understand that unlike its old Solr based solution, the adoption of Elasticsearch has been architected to ensure a clean separation and cut of the components, this allows for better component isolation making HCL Commerce Search leap into the new era of Microservices.

[!/../2020/hcl_commerce/search_part2.png]

Let's get to the topic on this post, the ingest and the query services are two of the added components which enable HCL Commerce Search to work with elasticsearch. You can read the detailed description of this services in the HCL Commerce Help Center at: [Using the V9.1 HCL Commerce Search service](https://help.hcltechsw.com/commerce/9.1.0/search/concepts/csdsearchingest.html) I only intend to describe it here at high level and then jump into how to turn on the trace on:

* They each are a container on its own
* They can be scaled individually to support HA and Load Balance

# The ***query*** container
* Full description and details at: [The Query Service](https://help.hcltechsw.com/commerce/9.1.0/search/concepts/csdelasticsearchquery.html)
* It builds the query and then talks to Elasticsearch for consumption of the query
* Is used to extract information from elasticsearch and making it ready for the API
* It has support for natural language processor (NLP)
* It has extensions that can participate as part of a specific query
* It is implemented using [spring-boots](https://spring.io/guides/gs/spring-boot/)

# The ***ingest*** container
* Full description and details at: [The Ingest service](https://help.hcltechsw.com/commerce/9.1.0/search/concepts/csdsearchconnectors.html)
* Is used to consume data from different sources and populate the elasticsearch index. The dataflow and transformation of such data is controlled using the NIFI Pipeline.
* Ts-app calls ingest for index building, and status of the index build job
* It talks to Registry, the Registry is a complementary application to NIFI: https://nifi.apache.org/registry
* It talks to Zookeeper, for storage of the configuration and other details of the connectors
* It talks to NIFI, to execute the process and interface with the pipeline in a graphical way
* It talks to elasticsearch
* is responsible for creating the connectors in NIFI using the Registry
* It is implemented using [spring-boots](https://spring.io/guides/gs/spring-boot/)


# Turning Trace on HCL Commerce Search
The development team for HCL Commerce Search continues to work hard implementing new features, one of the feature that is having a lot of attention is serviceability and I know they will be driving important changes when it comes to logging. For now you can turn on logging and tracing in two different ways the documented way in the HCL Commerce Help Center:
[Logging and troubleshooting the Ingest and Query services](https://help.hcltechsw.com/commerce/9.1.0/search/refs/rsdingest_troubleshooting.html?hl=log)
 and also by turning adding an environment flag that enables the tracing for spring boots. You can add that flag in your helm charts or the docker-compose yaml. In K8S using the helm chart you will do the following:
 1. Open the chart.yaml
 2. Find the `ingestApp:` section
 3. Add to the `envParameters:` section: `logging.level.org.springframework: DEBUG`
 4. Redeploy the container.

 The result should be:

 ```
 ingestApp:
  name: ingest-app
  image: search-ingest-app
  tag: 9.1.1.0
  replica: 1
  resources:
    requests:
      memory: 2048Mi
      cpu: 500m
    limits:
      memory: 4096Mi
      cpu: 2
  ## when using custom envParameters, use key: value format
  envParameters: {
    logging.level.org.springframework: DEBUG
    }
  nodeLabel: ""
  fileBeatConfigMap: ""
 ```
