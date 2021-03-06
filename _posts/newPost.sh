#!/bin/bash
# AUTHOR: gunfus@gmail.com

if [ $# -eq 0 ]
  then
    echo "ERROR: No arguments supplied"
    echo "       The post requires a title, with no spaces. ex: something_something_more"
    exit -1
fi

POST_FILENAME=$(date +'%Y-%m-%d')-$1.md
touch $POST_FILENAME
echo "---
layout: single
title: "$1"
date: `date +'%Y-%m-%d'`
tag: wcs trace servisability 
---" > $POST_FILENAME

echo "A new post created with the name of"
echo "     $PWD/$POST_FILENAME"
