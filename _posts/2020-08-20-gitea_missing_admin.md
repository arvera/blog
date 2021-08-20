---
layout: single
title: How to make an admin account in GitTea
date: 2020-08-20
tag: mariadb gitea
---
[Gitea](https://gitea.io) is small git repository very easy to install and manage and lightweight. I have found it several times in projects related to k8s or Proof of concepts. Installing using the helms charts at [Helm hub](https://hub.helm.sh/charts/k8s-land/gitea) is straight forward and you can refer to the readme at the helm hub. In this post I go through the steps after installation, how to make an userID an admin using SQL commands when using Gitea.

In my example a collegue of my deployed gitea using the helm charts. When you deployed Gitea, the first account that you create becomes the admin. My collegue is India and he had register his account to ensure it works. I wanted to also be an admin but not wake him up, as I didn't think it was a critical need, and I also didn't have his whatasapp.

So I took matter on my own and did some research and found two options:
1. using Gitea CLI
2. modifying the user in the DB.

# 1. Using Giteas CLI in K8S (not worked)
As documented in [Gitea CLI DOCS](https://docs.gitea.io/en-us/command-line/#admin)
1. `kubectl exec -it -n gitea gitea-gitea-75658fc8d-llrzh bash`
1. `su - git` This is required because when you exec into the container you are root, and the GIT CLI are expecting you to be ***git*** user
1. `gitea admin change-password --username aUser --password <SOME_RND_PASSWORD> --email aUser@gitea.local --admin`

At this point this should had worked, but for some reason I got the error below:

```
2020/08/21 03:39:23 ...s/setting/setting.go:531:NewContext() [W] Custom config '/usr/local/bin/custom/conf/app.ini' not found, ignore this if you're running first time
2020/08/21 03:39:23 ...s/setting/setting.go:785:NewContext() [F] failed to create '/usr/local/bin/custom/conf/app.ini': mkdir /usr/local/bin/custom: permission denied
```

Without further investigation as it was late.. I moved on..


# 2. Modifying the user in the DB (worked)
This approach assumes you already created your ID
1. `kubectl exec -it gitea-mariadb-0 -n gitea bash`
1. `mysql -u root -p gitea`
1. Enter your password
1. `select id,is_admin from user;`

```
MariaDB [gitea]> select id,lower_name,is_admin from user;
+----+---------------+----------+
| id | lower_name    | is_admin |
+----+---------------+----------+
|  1 | aFriend       |        1 |
|  2 | angel.vera    |        0 |
|  3 | aFriend2      |        0 |
+----+---------------+----------+
3 rows in set (0.000 sec)
```
1.`update user set is_admin=1 where lower_name='angel.vera';`
```
MariaDB [gitea]> update user set is_admin=1 where lower_name='angel.vera';
Query OK, 1 row affected (0.004 sec)
Rows matched: 1  Changed: 1  Warnings: 0
```
1. And just to confirm: `select id,lower_name,is_admin from user;`
```
MariaDB [gitea]> select id,lower_name,is_admin from user;
+----+---------------+----------+
| id | lower_name    | is_admin |
+----+---------------+----------+
|  1 | aFriend       |        1 |
|  2 | angel.vera    |        1 |
|  3 | aFriend2      |        0 |
+----+---------------+----------+
3 rows in set (0.000 sec)
```


Voila!
