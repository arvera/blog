---
layout: single
title: Deploying Alpine to GKE micro
date: 2020-07-24
tag: gke k8s Alpine
---
In this post I will document the link and steps that I use to create a micro cluster in GKE and deploy the Alpine container. I will not repeat steps that are well documented, instead I will provide links to those steps (why duplicate the wheel, right?)

- The Alpine container is a very simple Linux distro build on top of busybox. [For more info refer to the docker hub docs](https://hub.docker.com/_/alpine)

- A Micro cluster, is a very small cluster for testing purposes

# Plan your cluster
The options are:
- Public endpoint access disabled
- Public endpoint access enabled, master authorized networks enabled
- Public endpoint access enabled, master authorized networks disabled

What type of cluster do you want you is the starting point, for that you can use this document:
[https://cloud.google.com/kubernetes-engine/docs/concepts/private-cluster-concept](https://cloud.google.com/kubernetes-engine/docs/concepts/private-cluster-concept), they also have a nice table for you to consider the right option for your cluster.

# Create the micro cluster
I decided to create a Private Cluster, that is one that Public endpoint access enabled, and master authorized networks enabled. This topic is well describe in the google docs here: [https://cloud.google.com/kubernetes-engine/docs/how-to/private-clusters#all_access](https://cloud.google.com/kubernetes-engine/docs/how-to/private-clusters#all_access)

# Getting the charts for alpine
To deploy alpine in the cluster, I configured my Laptop gcloud tools.

'gcloud container clusters get-credentials av-test --zone=us-east1-c'

'helm repo add stable https://kubernetes-charts.storage.googleapis.com/'

To get the alpine charts from the helm repo testdata located here: https://github.com/helm/helm/tree/master/cmd/helm/testdata/testcharts/alpine, you can opt to do a sparseCheckout, but for me it didn't work it simply downloaded everything as opposed of just the `cmd/helm/testdata/testcharts/alpine/`, the steps should work as per [this post](https://unix.stackexchange.com/questions/233327/is-it-possible-to-clone-only-part-of-a-git-projec) but that is a problem for another time. I leave the steps here to see if they work for you.

```
mkdir helm
cd helm
git init
git remote add -f origin https://github.com/helm/helm.git
git config core.sparseCheckout true
echo "cmd/helm/testdata/testcharts/alpine/" >.git/info/spare-checkout
git pull origin master
```

# Installing Alpine on the clusters
Move into the `cmd/helm/testdata/testcharts/` directory. At this time of this write up using: `version.BuildInfo{Version:"v3.1.2", GitCommit:"d878d4d45863e42fd5cff6743294a11d28a9abce", GitTreeState:"clean", GoVersion:"go1.13.8"}` I run into a problem that caused me to modify the charts and remove/comment line 15, on template/alpine-pod.yaml.
```
#app.kubernetes.io/version: {{ .Chart.AppVersion }}
```

After removing that line you can do:
1. `helm install alpine-demo ./alpine`


# Check that alpine is working
Using the following cmd, you should see one pod called *my-alpine*
* `kubectl get pods`

Using the following cmd, you should be able to get into the pod
* `kubectl exec -it my-alpine sh`


# Connecting to a VM outside of the cluster, but still in GCP
I have the requirement to connect the pods running in the cluster to a Compute Engine (VM) running with an internal IP and not exposed to the internet. I have not completed this work at this time but will create a post when I do.
