## iptable基本使用

添加规则，开放端口（例如80端）

```
/sbin/iptables -I INPUT -p tcp --dport 80 -j ACCEPT
```

删除规则，如上先查询规则列表

```
iptables -L -n --line-number
```

然后再通过号码进行删除

```
iptables -D INPUT 2
```