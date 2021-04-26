---
title: MAC 开启 Docker 端口
categories: 手记
tags: 
    - macos
    - docker
---

使用socat转发为2375端口

```shell
socat TCP-LISTEN:2375,reuseaddr,fork UNIX-CONNECT:/var/run/docker.sock
```
