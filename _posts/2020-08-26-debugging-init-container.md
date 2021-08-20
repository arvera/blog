---
layout: single
title: The supportcontainer and how to debug init container
date: 2020-08-26
tag: wcs trace servisability init container
---
In this post I explain the usage of the ***supportcontainer*** in its usage as a K8S ***initContainer***, you can use this example to debug other initContainer in other K8S deployments.

# What is the supportcontainer

The support container is a mini-container that runs scripts related to kubernetes and is required to properly start the HCL Commerce platform. The container is used as a way to ensure the correct startup sequence of the platform. Here are some of the activities that it does:

- Is used as an init container for most container deployments when using the helm charts
- It does dependency checks between the containers, for example the search and store containers will not start until transaction server is running.
- Using some of the values defined in the helm chart it may also create some K8S objects

As this container runs as an init container debugging failures on it might not be always obvious to some.

# How to debug init containers

In a recent deployment of v9.1, I ran into a problem where my ts-app container was not starting. If ts-app doesn't start there is a bunch of other things that do not start due to the pre-check failures. The problem was related to the initContainer defined in the helm charts, thus the ***supportcontainer***.

To diagnose the problem I had to:
1. `kubectl get pods -n commerce |grep -i ts-app`
   ```
   demodevauthts-app-55fb86fb48-mxk9m              0/1     Init:CrashLoopBackOff   10         30m
   ```

1. `kubectl describe pod -n commerce demodevauthts-app-55fb86fb48-mxk9m`
   ```
Events:
  Type     Reason     Age                  From                                                Message
  ----     ------     ----                 ----                                                -------
  Normal   Scheduled  25m                  default-scheduler                                   Successfully assigned commerce/demodevauthts-app-55fb86fb48-mxk9m to gke-av-cluster-default-pool-272c6888-n12j
  Normal   Pulling    25m                  kubelet, gke-av-cluster-default-pool-272c6888-n12j  Pulling image "us.gcr.io/commerce-product/release/9.1.1.0/supportcontainer:2.1.0"
  Normal   Pulled     25m                  kubelet, gke-av-cluster-default-pool-272c6888-n12j  Successfully pulled image "us.gcr.io/commerce-product/release/9.1.1.0/supportcontainer:2.1.0"
  Normal   Created    23m (x5 over 25m)    kubelet, gke-av-cluster-default-pool-272c6888-n12j  Created container transaction-dependence-check
  Normal   Pulled     23m (x4 over 25m)    kubelet, gke-av-cluster-default-pool-272c6888-n12j  Container image "us.gcr.io/commerce-product/release/9.1.1.0/supportcontainer:2.1.0" already present on machine
  Normal   Started    23m (x5 over 25m)    kubelet, gke-av-cluster-default-pool-272c6888-n12j  Started container transaction-dependence-check
  Warning  BackOff    14s (x115 over 25m)  kubelet, gke-av-cluster-default-pool-272c6888-n12j  Back-off restarting failed container
   ```

1. Looking into the events it tells me that there is a problem with the `transaction-dependence-check` as that is the last events
1. `kubectl logs -n commerce demodevauthts-app-55fb86fb48-mxk9m -c transaction-dependence-check`
   ```
usage: kubcli.py depcheck [-h] [-tenant TENANT] [-env ENV] [-envtype ENVTYPE]
                          [-namespace NAMESPACE] [-component COMPONENT]
                          [-interval_time INTERVAL_TIME] [-timeout TIMEOUT]
                          [-expect_during_time EXPECT_DURING_TIME]
                          [-spiuser_pwd_encrypte SPIUSER_PWD_ENCRYPTE]
kubcli.py depcheck: error: argument -spiuser_pwd_encrypte: expected one argument
   ```

Looking at the logs output it tells me that there is an error with the -spiuser_pwd_encrypte, which hints to the fact that I forgot something related to the spiuser. Looking at the helm charts I had indeed forgotten to specify all spiuser details

After setting the correct value and updating the helm charts, the deployment became successful.
