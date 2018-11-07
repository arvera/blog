---
layout: single
title: "Oracle listener handy cmds"
date: 2018-11-02
tag: oracle listener
---
I don't often play with oracle cmds too much, but reccently I had a need for it when someone reported that they were not able to connect to the DB.

Doing quick research and I found a few handy commands:

## Display the directory of the trace location
```
LSNRCTL> show TRC_Directory
Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
LISTENER parameter "trc_directory" set to /...somepath../listener/trace
The command completed successfully
```

## Display the name of the trace file
```
LSNRCTL> show TRC_FILE
Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
LISTENER parameter "trc_file" set to ora_1234_<...somenumber...>.trc
The command completed successfully
LSNRCTL> 
```

## Display the logs 

```
LSNRCTL> show LOG_file
Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
LISTENER parameter "log_file" set to /...somepath.../listener/alert/log.xml
The command completed successfully
```

All of this commands are referenced in the oracle documentation but I put them here for convience of the ones I used, find a full reference at: https://docs.oracle.com/cd/E11882_01/network.112/e10835/lsnrctl.htm#NETRF129

I also found this article on how to enable the trace but that didn't provide any useful information in my case:
http://www.dba-oracle.com/teas_prae_util25.htm. I think I need to understand how the trace works
