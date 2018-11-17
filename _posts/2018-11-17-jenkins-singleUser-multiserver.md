---
layout: single
title: "Single user multi server setup"
date: 2018-11-10
tag: jenkins authentication ssh
---
## How to setup Jenkins ssh remote plugin with a single user that connects to different server
Sometimes it surprises me that some of the jenkins information is either out of date or not suficient for some users.

1. Generate a key. 
1. Copy your private key into jenkins inside of the credentials part.
2. Then used the public part of the key for your system (any system that you want to connect)
```
cd .ssh
cat given_a_public_key.pub > authorized_keys
chmod 644 authorized_keys 
```