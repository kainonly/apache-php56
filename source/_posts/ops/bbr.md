---
title: 开启Google BBR
categories: 运维技术
tags: linux
---

Google BBR 是一款 Google 开发的拥堵控制算法，通过优化和控制 TCP 的拥塞，充分利用带宽并降低延迟，使得服务器的带宽得到合理化应用

<!-- more -->

修改系统配置 `/etc/sysctl.conf`

```conf
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
```

立即生效

```shell
sysctl -p
```

查看是否开启

```shell
sysctl net.ipv4.tcp_available_congestion_control

# net.ipv4.tcp_available_congestion_control = bbr cubic reno
```

查看启动

```shell
lsmod | grep bbr

# tcp_bbr                20480  14
```