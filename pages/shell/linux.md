## Linux 常用命令

查看内核版本

```shell
# uname -a
```

查看系统版本

```shell
# lsb_release -a
```

查看cpu型号

```shell
# cat /proc/cpuinfo
```

查看物理CPU个数

```shell
# cat /proc/cpuinfo| grep "physical id"| sort| uniq| wc -l
```

查看每个物理CPU中core的个数(即核数)

```shell
# cat /proc/cpuinfo| grep "cpu cores"| uniq
```

查看逻辑CPU的个数

```shell
# cat /proc/cpuinfo| grep "processor"| wc -l
```

查看内存信息

```shell
# cat /proc/meminfo
```

查看内存使用率

```shell
# free -m 
```

查看硬盘空间情况

```shell
# df -l
```

