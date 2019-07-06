## 开启 SSH 服务

修改 `/etc/ssh/sshd_config`

```conf
PasswordAuthentication yes;
PermitRootLogin yes;
```

重启服务

```shell
systemctl restart ssh
```