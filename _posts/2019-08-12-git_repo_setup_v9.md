---
layout: single
title: GIT Repo setup for v9
date: 2019-08-12
tag: wcs git v9
---

# As far as git repos what are some of the views? I can think of two two opposing ideals:
- the microservices approach,
- the one solution approach
 
When we think about Websphere Commerce Server v9 in the context of DevOps, we have to think of the component that need to be built. With WCS 9 introducing containers, there are seven unique container: transaction (txn), http (web), search, store, customization, util, and db2 (only after 9008 and for development only). Each container has a different resource that needs to be applied to the container (for details about the architecture go to: https://www.ibm.com/support/knowledgecenter/en/SSZLC2_9.0.0/com.ibm.commerce.install.doc/refs/riginfrastructure.htm).
 
I will not cover the db2 container as I haven't gotten a chance to take out for a spin. As far as the other containers go, each of the containers can be identified and deployed separately, and this where the argument begins, do we deploy them separately or together?
 
Some people have the argument that although this are separate containers at times there is dependencies on them (like an API that depends on a search customization) and for that they like to keep the containers with the same tag number, thus the idea of having one GIT repo for all containers suites better in the model; in this model you will have fl-ts-43, and fl-search-43 images always being deployed.
 
Other people are more on the bleeding edge of the market, and prefer to push the separate components idea where one can be build and deployed separately from the others. We have been seeing how WCS has been trying really hard to break the MACRO approach and providing more components. First wc.ear+search.ear, now ts.ear, search.ear, static store assets, util container, and xc.ear. This is personally my preferred approach, although not what my current project is doing.
 
# Here are some of the pro and cons that I can think off for multiple Git setup:
 
###  Multiple Git: a repo for a container
pro: 
- smaller foot print repos
- creates the view of separate services
- can easily accommodate small changes, and build them per image
- decouple members that make a complete solution (independent development, skill separation - e.g. integrations, UI, core functions, etc.)
- separate development cycles
- teams can be allocated in different locations/geos with minimum impact

 
con
- different tags for each image built (ts-app-12, search-38, web-5)
- decouple members that make a complete solution
- developers understanding of check-in files into different repos, can be confusing
- build pipeline will need to pull from different git repo (more setup of keys and stuff)
- more administration to lock branches (if that is something that is desirable)
 
 
### One Git:  a repo for all containers
pro:
- easier setup for development
- show that is one solution
- easier setup for .ignore
- easier/faster transition for workspace outside of RAD, or inside of RAD
 
con: 
- large repo
- a small change in utils will require to update the entire repo (depending on your build process)
- all eggs in one basket
- monolithic approach/thinking
- DevOps becomes limited and dependent in other components

 
The trend seems to be for smaller repos, and you can always have a submodules https://git-scm.com/book/en/v2/Git-Tools-Submodules.
 
Which approach will your project take?
