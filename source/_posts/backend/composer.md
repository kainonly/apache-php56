---
title: composer 全局设置阿里云镜像源
categories: 后端技术
tags:
  - php
---

首先把默认的源给禁用掉

```shell
composer config -g secure-http false
```

再修改镜像源

```shell
composer config -g repo.packagist composer https://mirrors.aliyun.com/composer
```

修改成功后可以先查看一下配置

```shell
composer config -g -l
```
