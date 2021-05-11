---
title: Angular 内存栈溢出
categories: 手记
tags: angular
---

在 Angular 编译构建时突然出现

```shell
FATAL ERROR: CALL_AND_RETRY_LAST Allocation failed - process out of memory
```

<!-- more -->

主要原因可能是 angular 引用了较多的非 es6 module 库，在编译的时候造成包体积过大，因此对 CPU 和内存的需求比较大，出现了内存不足的情况。目前的解决办法是提高 node 的内存上限，例如：增加 `max_old_space_size` 参数

```json
{
  "scripts": {
    "build": "node --max_old_space_size=8192 ./node_modules/@angular/cli/bin/ng build --prod --buildOptimizer"
  }
}
```
