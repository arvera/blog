---
layout: single
title: "Single user multi server setup"
date: 2018-11-10
tag: jenkins authentication ssh
---
Sometimes it surprises me that some of the jenkins information is either out of date or not suficient for some users.
So I am creating this post to help the community. 

## How to setup Jenkins ssh remote plugin with a single user that connects to different server
Say you have a farm of servers to mantain. 

| Server name | purpose |
| - | - |
| serverA | need to run some cmds |
| serverB | need to run some cmds |
| serverJ | Jenkins |

And that you want to connect to `serverA` and `serverB` and run some jobs, and you want to use a single user `commonUser`, and same credentials. I am not going to say
this is very secure, in fact I haven't looked into how secure this approach is, but regardless of it for now. The option is there for you to use.

### Create a common user
1. Logon to each server individially: `serverA` and `serverB`
2. create a user using [useradd](https://askubuntu.com/questions/345974/what-is-the-difference-between-adduser-and-useradd)
3. Don't forget you need to create the account in both servers

### Craete a key for the user
1. Login to `serverA`
2. follow your favourite instruction on using [ssh-keygen](https://stackoverflow.com/questions/37331571/how-to-setup-ssh-keys-for-jenkins-to-publish-via-ssh)


### Copy the public key into `serverB`
1. From `serverA`, 
2. Copy from `serverA` `~/.ssh/rsa_id.pub` into `serverB` `~/.ssh/rsa_id.pub`
   1. You can use: `scp commonUser@serverA:/home/commonUser/.ssh/rsa_id.pub commonUser@serverB:/home/commonUser/.ssh/rsa_id.pub`
3. Then in `serverB` used the public part of the key to add it to the authorized_keys: `cat rsa_id.pub >> authorized_keys`
4. Finally ensure the proper permissions are given in case the file got created `chmod 644 authorized_keys`

### Now go into jenkins and create the one credendial
1. I don't cover this steps but they should be easy to figure out as there is lots of info out there on this


### The Short version
```
scp commonUser@serverA:/home/commonUser/.ssh/given_a_public_key.pub commonUser@serverB:/home/commonUser/.ssh/given_a_public_key.pub
cat given_a_public_key.pub > authorized_keys
chmod 644 authorized_keys 
```