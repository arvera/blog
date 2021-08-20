---
layout: single
title: Adding a New Field to the Index, aka: Mappings
date: 2021-06-22
tag: es search customizing
---
In previous post I have covered the new architecture of HCL Commerce 9.1 Search when deployed with Elastic Search based solution, ingest, query, NiFi, Elastic Search, Query and others. In this post we will use a magnifying glass to dive deeper and we will concentrate on one: Elastic Search. Through out life I have never stopped my inner child, it always shows a passion at being curious. I am keen to understand the core concepts, the basics, How-is-it-made!

This is a bit of a long introduction but stay with me..[skip the intro](#step-1:-create-an-index) let's state what we are going to do and what we are not doing. In a future post I hope to cover how to apply what you learn in this post to HCL Commerce in the meantime you can use this post to help you understand better what you are doing on the [Profit Margin tutorial on the Help Center](https://help.hcltechsw.com/commerce/9.1.0/tutorials/tutorial/tsd_search6_intro_elastic.html) more specifically on the step related to [Configuring Nifi](https://help.hcltechsw.com/commerce/9.1.0/tutorials/tutorial/tsd_connectorconfigure_elastic.html) in the part where you are updating the Processor to *Populate Index Schema*.

In Step 1, in this post we create a new index. Using a new empty index helps me break the steps and provide insights about the simplicity of the process. The same concepts can be applied when using more complex index like the one provided with HCL Commerce, just be aware that in our case we are creating our own index and when applying the steps to HCL Commerce, the index is already created for you.

In Step 2, we add some data, because having an empty index is boring. Step 3, then modifies the mappings or better known as the schema and finally in Step 4, we add the data that maps to the new schema object added.

You can use the documentation directly from elastic search here to understand how things work: https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-put-mapping.html

With our magnifying glass looking into HCL Commerce 9.1 Search, we look into the Elasticsearch(ES) server only and make request directly to the ES server mine is deployed at: http://gunfus_es:30200/


But in this post we are removing NIFI, and the Ingest container we are only going to be working with the Elasticsearch container. The intention of this post is just to explain how to add/update an already existing Elasticsearch index with a new field that in the Elasticsearch terms is reffered to as a (object field)[https://www.elastic.co/guide/en/elasticsearch/reference/7.13/object.html]. Because we are using just Elasticsearch to explain the process lets create an index that uses a small mappings to explain all steps.

You can use postman or a curl cmd for all the APIs call here, I will post the CURL command.

# Step 1: Create an Index

In this step we want to create an index with a simple mapping. In HCL Commerce v9.1 the index are already created for you, so although in this post we use this step, in the HCL Commerce world you can skip this step.

```
curl --location --request PUT 'http://gunfus_es:30200/.av.index' \
--header 'Content-Type: application/json' \
--data-raw '{
  "mappings" : {
    "properties": {
      "user": {
        "type": "keyword"
      }
    }
  }
}'
```

The expected response is:

```
{
    "acknowledged": true,
    "shards_acknowledged": true,
    "index": ".av.index"
}
```

You can request your index by get a list of the indeces using `_cat/indices` as documented here: https://www.elastic.co/guide/en/elasticsearch/reference/7.13/cat-indices.htm`

# Step 2: Add data into the index

This step is not required but for the sake of providing a complete example, let's add some data into the index. The data can match the index schema that we just created, such data structure would look like:

```
curl --location --request PUT 'http://gunfus_es:30200/.av.index/_doc/1' \
--header 'Content-Type: application/json' \
--data-raw '{
  "user": "gunfus"
}'
```

The expected response is:

```
{
    "_index": ".av.index",
    "_type": "_doc",
    "_id": "1",
    "_version": 1,
    "result": "created",
    "_shards": {
        "total": 2,
        "successful": 1,
        "failed": 0
    },
    "_seq_no": 0,
    "_primary_term": 1
}
```


# Step 3: Add the new field to an already existing schema with an object field

This is the part that is not done by HCL Commerce and is also the part that we are interested to show in this post.

At this time our index is very simple and it only has one object field, of type (keyword)[https://www.elastic.co/guide/en/elasticsearch/reference/7.13/keyword.html].

To add a new type we follow this document from the Elasticsearch documentation: (Updating mapping API)[https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-put-mapping.html]. In our case we are going to add a child Object Type under the user. Notice that we are adding `user.fields.name` and not just `user.name`. This is because upon trying to add `user.name` I encountered errors, didn't do much research but `user.fields.name` is what the Elasticsearch tutorial does so we followed along.

```
curl --location --request PUT 'http://gunfus_es:30200/.av.index/_mappings' \
--header 'Content-Type: application/json' \
--data-raw '{
    "properties": {
      "user": {
        "type": "keyword",
        "fields": {
            "name": {
                "type": "keyword"
            }
        }
      }
    }
}'
```

The expected response is very verbose about the action

```
{
    "_index": ".av.index",
    "_type": "_doc",
    "_id": "1",
    "_version": 1,
    "result": "created",
    "_shards": {
        "total": 2,
        "successful": 1,
        "failed": 0
    },
    "_seq_no": 0,
    "_primary_term": 1
}
```

# Step 4: Adding data into the new data structure

At this time our index schema now has 3 object types: user, user.field and user.field.name. So we can now insert data in user.field.name.

```
curl --location --request PUT 'http://rhettnifi:30200/.av.index/_doc/1' \
--header 'Content-Type: application/json' \
--data-raw '{
  "user": "gunfus",
  "fields": {
      "name": "firstNameGunfus"
  }
}'
```
