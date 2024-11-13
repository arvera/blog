 ---
layout: single
title: HCL Commerce DB2 Maintenance 
date: 2023-05-25
tag: db maintenance 
---

On this post I want to address a topic that is comming up more frequently on my discussions as an HCL Commerce Devops Architect, DB maintenance. 

Almost any Enterprise level application will have to persist information in a repository, in the case of HCL Commerce the Data repository is an RDBMS database. As the application runs over the years the stored objects growths, and maintenance is required to delete and reorganize the data. HCL Commerce at the time of this write up supports DB2 and Oracle as backend data repositories. I will focus on DB2 maintenance  as that is what the mayority of my customer are using, but data mantaintance is aplicable to both DB systems I am just not aware of all the  Oracle tools to use, although you should keep reading as the tool DBCLEAN is still applicable to both system.

You should look at having a cleanup strategy of running this tasks in a scheduled basis taking in consideration load on the website(store), as well as the individual load on the DB like a dataload, backup activities or others.

This article written by a collegue of mine back in the day of IBM is still very much applicable and should probably be your first reading: 
(Maintaining a WebSphere Commerce DB2 Database)[https://www.ibm.com/support/pages/maintaining-websphere-commerce-db2-database-85256dd000531442852570d0006e89c6]

Comming from the article you should now understand that there are 3 main tasks: dbclean, runstats and reorg.

# Definition 

DBCLEAN, refers to a script provided by HCL Commerce and is well documented here: https://help.hcltechsw.com/commerce/9.0.0/admin/refs/rducommand.html. Is important to mention that this is not a set of SQLs that are run manualy to delete data from tables. 

RUNSTAS, is a DB2 command that looks at the table and data, analyses it by identify most frequent used, and create internal paths so that when the DB Queries come the data can be retrieved faster.

REORG, is a DB2 command that physically changes the data in a table so that the overall performance can be improved.

# Schedule

RUNSTATS should be done before REORG. REORG can cause locks and it is a much longer task, thus it is recommended to run off it hours during low traffic days (weekends if weekends apply to low traffic), after the REORG is done RUNSTAS can be run again to update data location that have potentially been moved. Lastly there is a REBIND cmd that can be run to update store procedures access paths.

It is very important to do these activities during initial usage of the DB (although we are well beyond that point now) as statistics information and access path to the data will drastically change on an EMPTY database with no data, vs a database that has been populated. As the DB continues on its usage, REORG, RUNSTATS and REBIND are still necessary but not with the same frequency.

Some users adopt to do RUNSTAS every other day or so, vs REORG do it once a week.

Here is an example of how to ideally scheduled the tasks:
RUNSTATS executes daily at or about 02:00 server time , usually GMT/UTC.
REORG execute on Saturday’s either 5:00 or 06:00 GMT/UTC.

Needless to say that every client has different needs, so the tasks can be adjusted as needed. The one thing to be cognizant about is the start and end times for each activity and plan their other jobs around these maintenance jobs.

How long these take is dependent upon the size of the site and the amount of traffic it gets. 

So the job execution time can be variable, and if the activity has not been done in a while the first times it will take longer, until you are able to find the average execution time,  a few runs would be needed to know for any particular site.


