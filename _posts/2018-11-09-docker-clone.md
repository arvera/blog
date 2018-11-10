---
layout: single
title: "Docker clone"
date: 2018-11-09
tag: docker
---
Given an image 4eac482914ec 

`docker commit 4eac482914ec angels_util`

`docker image ls` to confirm the image is there in the registry

Create a yaml file 
`cp docker-compose_scripts/<original>.yaml ./angels_util.yaml`

Edit the yaml file and deploy the image using
`docker-compose -f angels_util.yaml -d up`
