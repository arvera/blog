---
layout: single
title: How to install/configure kafka/Zookeper in HCL Commerce v9
date: 2020-03-07
tag: wcs install kafka zookeper cache
---

 In this blog post I will describe the process on how to install Kafka/Zookeeper how to set it setup with commerce. We will focus the Kubernetes setup, but it can also be done in docker using a docker-compose file, but that is outside of the scope of this post.  

This is part #1 of another article that talks about the need of Kafka as part of HCL Commerce. In part #2 we will talk why Kafka is now a required component as part of the caching infrastructure of HCL Commerce. Kafka ensure caching invalidation across the different interested parties in the system.

There are several ways to install Kafka inside a kubernetes cluster. My friend  Andres Voldman the architect of performance, got his team to install Kafka using a separate namespace other than the commerce and default namespace, this is not required is just simply what is provided as a sample. Kubernetes namespaces are a logical way to group kubernetes artifacts, the intend of this post is not to cover the pro/cons of using a single namespaces or multiple.

The official instructions that we follow to install Kafka are the out of the box instructions at: https://github.com/helm/charts/tree/master/incubator/kafka

## Install Kafka using Helm

```helm install --name my-kafka --set persistence.enabled=false
  –namespace kafka  incubator/kafka```

In this command we are using `persistence.enable=false` which allows us to quickly get up and running, but will not give you the availability to persist the message. For production we recommend to look into the details of setting `persistence.enabled=true`, but that is outside of the scope of this post.

The single command above will creates Kafka brokers and Zookeeper servers as Statefulsets, under the namespace ***kafka***

```
[kube@comlnx91 ~]$ kubectl get pods -n kafka
NAME                   READY   STATUS    RESTARTS   AGE
my-kafka-0             1/1     Running   0          47h
my-kafka-1             1/1     Running   87         3d2h
my-kafka-2             1/1     Running   0          47h
my-kafka-zookeeper-0   1/1     Running   14         3d2h
my-kafka-zookeeper-1   1/1     Running   0          47h
my-kafka-zookeeper-2   1/1     Running   13         3d2h
testclient             1/1     Running   0          30h
```

### Services:
The helm charts contained a load-balanced and headless services. The services are only made available within the cluster:

```
[kube@comlnx91 ~]$ kubectl get services -n kafka
NAME                          TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                      AGE
my-kafka                      ClusterIP   10.107.26.40     <none>        9092/TCP                     15d
my-kafka-headless             ClusterIP   None             <none>        9092/TCP                     15d
my-kafka-zookeeper            ClusterIP   10.101.237.171   <none>        2181/TCP                     15d
my-kafka-zookeeper-headless   ClusterIP   None             <none>        2181/TCP,3888/TCP,2888/TCP   15d
```

The service is setup as per the following table:
| Description | Name |  Value |
| - | - | - |
| Short format (for pods within namespace) | service.port |  my-kafka:9092 |
| Long format (for pods from any namespace) | service.namespace.svc.cluster:port | my-kafka-zookeeper.kafka.svc.cluster.local:2181 |
| Headless service | append pod | my-kafka-0.my-kafka-headless.kafka.svc.cluster | 

# Commerce configuration
For commerce container to hook up to kafka/zookeeper, all is required is 3 variables. There two main ways to do this:
- Using Vault
- Using Environment Variables at the guest OS.

We will describe the “Environment Variables” approach.

Add the following 3 variables will need to be added:
```
ZOOKEEPER_SERVERS: my-kafka-zookeeper.kafka.svc.cluster.local:2181
KAFKA_SERVERS: my-kafka.kafka.svc.cluster.local:9092
KAFKA_TOPIC_PREFIX: sample
```

To add environment variables the best way would be to edit helm charts used for commerce deployment. one can easily add environment variables for the container and immediately have Commerce working with Kafka.

The KAFKA_TOPIC_PREFIX, is to be used so that the required topic queue can be uniquely identified with a prefix of your preference, as long as you are using the same topic prefix, all should work.

You can find the information about this parameters at: https://help.hcltechsw.com/commerce/9.0.0/install/refs/rigstart_txn.html?hl=zookeeper_servers

Using the helm charts you will want to update the values.yaml for both ts-app and crs:
```
crsApp:
  name: crs-app
  image: testbed/crs-app
  tag: v9-latest
  replica: 1
  resources:
    requests:
      memory: 2048Mi
      cpu: 500m
    limits:
      memory: 4096Mi
      cpu: 2
  ## when using custom envParameters, use key: value format
  envParameters:
    ZOOKEEPER_SERVERS: my-kafka-zookeeper.kafka.svc.cluster.local:2181
    KAFKA_SERVERS: my-kafka.kafka.svc.cluster.local:9092
    KAFKA_TOPIC_PREFIX: sample   nodeLabel: ""
  fileBeatConfigMap: ""
```
```
tsApp:
  name: ts-app
  replica: 1
  image: testbed/ts-app
  tag: v9-latest
  resources:
    requests:
      memory: 2048Mi
      cpu: 500m
    limits:
      memory: 4096Mi
      cpu: 2
  merchantKey: eZrWIdOyaDv5FCOTK32Uni288…
  ## when using custom envParameters, use key: value format
  envParameters:
    ZOOKEEPER_SERVERS: my-kafka-zookeeper.kafka.svc.cluster.local:2181
    KAFKA_SERVERS: my-kafka.kafka.svc.cluster.local:9092
    KAFKA_TOPIC_PREFIX: sample
  nodeLabel: ""
  fileBeatConfigMap: ""
```

Once all the configuration is done you can start or restart your pods, and commerce will start utilizing kafka/zookeper.
