---
title: Selinux 开启和关闭
categories: 手记
tags: redis
---

如果SELinux status参数为enabled即为开启状态

```shell
/usr/sbin/sestatus -v

getenforce
```

临时关闭SELinux

```shell
setenforce 0
```

修改 `/etc/selinux/config`，将SELINUX=enforcing改为SELINUX=disabled，关闭SELinux
