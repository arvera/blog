---
layout: single
title: logCollector_search
date: 2019-04-04
tag: wcs trace servisability 
---
We have been running into some problems into my current project with different environments QA, PreProd, Prod, and as we have multiple people working on the environments at times due to availability. I created a script to standarize the process:

(logcollector.sh)[https://github.com/arvera/utilities/blob/master/wcs/logCollector.sh] [(raw)][https://raw.githubusercontent.com/arvera/utilities/master/wcs/logCollector.sh]
```
#!/bin/bash
set -e
set -u
#set -x #For debugging

MONTH_DAY=$(date +%b%d)
SHORT_TIME=$(date +%H.%M.%S)

TARGET_TMP_DIR="/tmp/search_build/${MONTH_DAY}/${SHORT_TIME}"

mkdir -p "${TARGET_TMP_DIR}"

echo "...Collecting -/opt/WebSphere/CommerceServer90/logs-..."
cp -R /opt/WebSphere/CommerceServer90/logs "${TARGET_TMP_DIR}"

echo "...Collecting -di-parallel-process-new.properties-..."
cp /profile/installedApps/localhost/ts.ear/properties/com/ibm/commerce/search/di-parallel-process-new.properties "${TARGET_TMP_DIR}"

echo "...Collecting -nohup.out-..."
cp /opt/WebSphere/CommerceServer90/bin/nohup.out "${TARGET_TMP_DIR}"

echo "...Collecting -.txt for javacores if any-..."
COUNT_TXT=$(ls -1 *.txt 2>/dev/null |wc -l)
echo ".....*.txt found=${COUNT_TXT}"
if [[ ${COUNT_TXT} != 0 ]]
then
   cp /opt/WebSphere/CommerceServer90/bin/*.txt "${TARGET_TMP_DIR}"
fi

echo "...Compresing  all files..."
TAR_FILE_PWD="/tmp/${MONTH_DAY}_${ENVIRONMENT}_t${SHORT_TIME}.tar.gz"
tar -zcvf "${TAR_FILE_PWD}" "${TARGET_TMP_DIR}"/*

echo "...Tar file located at:"
echo "${TAR_FILE_PWD}"
echo ""

```
