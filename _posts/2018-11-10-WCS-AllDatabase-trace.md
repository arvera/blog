---
layout: single
title: "WCS AllDBConnection trace"
date: 2018-11-10
tag: wcs trace servisability 
---
## WCS v9 Dataextract and other tools tracing
While doing some debugging in WCS v9 with the (dataextract)[https://www.ibm.com/support/knowledgecenter/en/SSZLC2_9.0.0/com.ibm.commerce.data.doc/refs/rml_dataextract_dup.htm] utility I found out that enabled **-Dcom.ibm.commerce.catalog.dataload.level=FINER** per the troubleshooting instruction, I needed more tracing.

I found a hidden trace setting finside of IBM Commerce, for a alldbconnector.xml kind of thing.
```
[root@live_utils /]# find / -name alldbconnector.xml -type f 
/opt/WebSphere/CommerceServer90/xml/config/alldbconnector.xml
```

In this config file I found different sections for different dbs: <db2>, <oracle> and so on.. I noticed that a few dbs had a entry for <logoutput> but others didn't. I added <logoutput value="stdout" enabled="yes"/> to the oracle section and voila! more tracing info showed up when running dataextract.

