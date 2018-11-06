---
layout: single
title: RAD and multiple workspace
date: '2018-10-25T08:49:00.001-07:00'
tags: 
modified_time: '2018-10-25T08:55:58.841-07:00'
blogger_id: tag:blogger.com,1999:blog-17927613.post-4602970267751420900
blogger_orig_url: https://gunfus.blogspot.com/2018/10/rad-and-multiple-workspace.html
---
Having been a developer for RAD and Eclipse, and now a SME for IBM Commerce Toolkit in the IBM consultant community. I am often asked what is the better setup for developers when working with Git.

There is not one approach that works for everyone, each have Pro and Cons. For Git usage I suggest and advocate for a separate workspace and repository, specially if you are using git-flow or any other approach where you will be switching branches often.

## Approach 1: Having a workspace separate from the repo

- workspace dir: w:\wcde\workspace
- repository: c:\gitRepo

### Pro

1. Less workspace corruptions
2. Ease of `git pull`
3. Less Git conflicts/merges (as developers can pull content from GIT any time)
4. very easy to explain to developers where git repo is vs workspace
5. Adaptable for entire workspace check in or only delta check-ins

### Con

1. Developers have to download a separate tool for merges (beyond compare is recommended)
2. Deleted files in the repo may not always be deleted by the developers
3. Developers can forget to check in files


## Approach 2: Having a workspace attach to git

- workspace dir: w:\wcde\workspace
- repository: w:\wcde\workspace

### Pro

1. Easy to keep in sync with git
2. Deleted files will be removed during pulls and merges
3. No need for a separate compare tool

### Con

1. Need to setup .git-ignore rules
2. In the past eGit performance and bugs have had some troubles
3. If developers swtich branches often, can cause workspace corruption, if the server is up
4. Merge issues can easily cause workspace corruption