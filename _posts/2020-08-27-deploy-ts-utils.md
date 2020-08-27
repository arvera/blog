---
layout: single
title: Deploying utility container to K8S
date: 2020-08-27
tag: deploy ts-utils
---
In today post I will describe the usage and deployment of the ts-util container using HCL Commerce v9.1.1

The ts-util is the container where HCL Commerce has placed the scripts to support the activities related to command lines utilities. HCL Commerce uses several utilities that run under the command line. This activities used non-rest API interfaces to load data into the database(dataload), encrypt passwords(wcs_encrypt), extract data from the database(dataextract), load policies mappings(acpolicies), and many other activities.

One of the first activities you will be faced with when deploying HCL Commerce is encrypting the password for the spiuser. For this activity you will need to launch the ts-util container and use the wcs_encrypt.

# Deploying the ts-utils in Kubernetes
To deploy the ts-util container in a K8S environment is very simple:

1. Download [ts-util.yaml](/../assets/2020/hcl_commerce/ts-utils.yaml)
1. Edit the file, specifcally the ***image*** variable, and use your docker image repository path
1. `kubectl apply -f ts-utils.yaml`
1. wait until the container is running
1. `kubectl exec -it ts-utls-5656599bdf-9khjb bash`
1. `cd /opt/WebSphere/CommerceServer90/bin`
1. `./wcs_encrypt.sh aGo0d.sTRong.pAsw8rd!`
