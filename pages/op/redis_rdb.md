## Redis 快照错误

错误信息

```shell
If you get this error Can't save in background: fork: Cannot allocate memory    
it means that your current database is bigger than memory you have.

`To fix the issue enable vm.overcommit_memor`
```

解决方式是开启 `vm.overcommit_memor`

```shell
# sysctl vm.overcommit_memory=1
```