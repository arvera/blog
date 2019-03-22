---
layout: single
title: How to load a WCS OOTB image to private registry
date: 2019-03-21
tag: wcs docker registry
category: docker
---
Download the image that you want to download in this case we will be working with WCS 9.0.1.4 util docker
## Unzip and load the image
0. download it to the server
1. `gzip -d WC_Ent_9014_utility_MPEN.tgz`
2. `docker load < WC_Ent_9014_utility_MPEN.tar` <br/>
   You will see the following messages:
   ```
   a5f64efdbe4b: Loading layer [==================================================>]  28.02MB/28.02MB
   2d46e2d87f89: Loading layer [==================================================>]   34.3kB/34.3kB
   9ebccd732bf6: Loading layer [==================================================>]   1.87GB/1.87GB
   3a03860a3b4f: Loading layer [==================================================>]  3.959MB/3.959MB
   da298d9738e9: Loading layer [==================================================>]  12.78MB/12.78MB
   29e8bdc9fc91: Loading layer [==================================================>]  644.1MB/644.1MB
   9a24ee60619d: Loading layer [==================================================>]  1.402GB/1.402GB
   1ab9c7fefff1: Loading layer [==================================================>]   12.8kB/12.8kB
   78297271e1be: Loading layer [==================================================>]  29.81MB/29.81MB
   Loaded image: commerce/ts-utils:9.0.1.4
   ```
3.  List the new image using:<br/>
   `docker image ls`
   ```
   ...
   commerce/ts-utils                                    9.0.1.4               ba7fab5d9f57        10 days ago         4.09GB
   ...
   ```


## Tag and Push the image to the private registry
4. `docker tag commerce/ts-utils:9.0.1.4 10.176.103.130:5000/commerce/ts-utils:9.0.1.4` 
5. `docker push 10.176.103.130:5000/commerce/ts-utils:9.0.1.4`
   ```
   The push refers to a repository [10.176.103.130:5000/commerce/ts-utils]
   78297271e1be: Pushed 
   1ab9c7fefff1: Pushed 
   9a24ee60619d: Pushed 
   29e8bdc9fc91: Pushed 
   da298d9738e9: Pushed 
   3a03860a3b4f: Pushed 
   9ebccd732bf6: Pushed 
   2d46e2d87f89: Pushed 
   a5f64efdbe4b: Pushed 
   6421b254a4a3: Layer already exists 
   1d31b5806ba4: Layer already exists 
   9.0.1.4: digest: sha256:425dcb4bee390931c8f4b9f06e8136b1fd60683d35063abb190d610786103b9b size: 2639
   ```

## Verify that the image got pushed
6. `curl http://10.176.103.130:5000/v2/commerce/ts-utils/tags/list`
   ```{"name":"commerce/ts-utils","tags":["9.0.1.4"]}```

