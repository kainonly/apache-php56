## iptable基本使用

添加规则，开放端口（例如80端）

``` base
/sbin/iptables -I INPUT -p tcp --dport 80 -j ACCEPT
```

删除规则，如上先查询规则列表

``` base
iptables -L -n --line-number
```

然后再通过号码进行删除

``` base
iptables -D INPUT 2
```