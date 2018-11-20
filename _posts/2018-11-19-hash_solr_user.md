---
layout: single
title: "Hash Solr User for curl request"
date: 2018-11-10
tag: wcs solr search hash encode buildindex
---
## How to create a hash for the build index job in WCS

The instructions [for WCS Search build index](https://www.ibm.com/support/knowledgecenter/en/SSZLC2_9.0.0/com.ibm.commerce.search.doc/tasks/tsdsearchbuildindex.htm) 
require you to pass the username and password of the search/solr user, lets assume:
| - | - | 
| user | `spiuser`|
| password | `spi_plain_text_password`|

To start the build index job you will need: 

```curl -k -s -X POST -u spiuser:spi_plain_text_password https://ts-server-hostname:ts-https-prt/wcs/resources/admin/index/dataImport/build?masterCatalogId=master-catalog-id```

In my project we have adopted the practice of passing it as a hash using a command like the following: 

```curl -k -H "Authorization: Basic the_hash_32dsadffd242" -d "masterCatalogId=10002&fullBuild=true&indexType=CatalogEntry&localeName=en_US&indexSubType=Structured" -X POST https://localhost:5443/wcs/resources/admin/index/dataImport/build```

So to generate a hash that encodes the username and password string, in linux you can use the [base64](https://linux.die.net/man/1/base64) cmd

```
# echo spiuser:spi_plain_text_password | base64
c3BpdXNlcjoxMjM0NXBhc3N3ZAo
```

and that will output: `c3BpdXNlcjoxMjM0NXBhc3N3ZAo=` and that is what you will use in the command

```curl -k -H "Authorization: Basic c3BpdXNlcjoxMjM0NXBhc3N3ZAo" -d "masterCatalogId=master-catalog-id&fullBuild=true&indexType=CatalogEntry&localeName=en_US&indexSubType=Structured" -X POST https://localhost:5443/wcs/resources/admin/index/dataImport/buildhttps://localhost:5443/wcs/resources/admin/index/dataImport/status?jobStatusId={jobId}```



## How to decode a hash?

To decode a hash in linux you can run: 

```
#echo c3BpdXNlcjoxMjM0NXBhc3N3ZAo | base64 -d
spiuser:spi_plain_text_password 
```
