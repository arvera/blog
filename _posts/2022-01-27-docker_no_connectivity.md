---
layout: single
title: Docker problems with internet connectivity
date: 2022-01-27
tag: docker connectivity diagnosis
---
Today I am creating this post as a way to remind me and also to spread the knowledge of this one problem that keeps coming back to me every few months.  

Let me first describe the problem, not sure if it is related to the version of docker that I am on or the OS/DOCKER combination that I am using either way here it goes.

The problem was brought to my attention as "Hey [sous-chef] using the jenkins container I can't seem to clone the repo", so that is when I had to get into action and bring up all my cooking tools and knowledge.

As I went on to test, first I needed to recreate the problem, and I noticed that the jenkins container was deployed in docker using docker-compose. Second I noticed that the git repository in question was outside of the docker local network.

With that information I used my handy dandy set of tools nc to test the connectivity and my packets where not reaching the outside world. I then tried outside of the container in the Host computer and things worked okay. After playing around with the network settings and IP rules, looking into the log, bringing down/up the container, there was nothing that seemed to be working. Connection between the container appeared to be fine so it was just the internet connection from inside the container.

That is when Google came to help... and after a few minutes of research I found:

(https://stackoverflow.com/questions/39828185/no-internet-connection-inside-docker-containers)[
https://stackoverflow.com/questions/39828185/no-internet-connection-inside-docker-containers]

```
pkill docker
iptables -t nat -F
ifconfig docker0 down
brctl delbr docker0
docker -d
```

And to ensure completeness on this record, I am using:

```
::::::::::::::
/etc/os-release
::::::::::::::
NAME="Red Hat Enterprise Linux"
VERSION="8.3 (Ootpa)"
```

Docker version

```
Docker version 20.10.5, build 55c4c88
```

This problem seems to happen every couple of months, thus I am making recording this as a post so that I can persist the knowledge in my head.
