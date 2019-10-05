## SSH 私密取消密码

使用openssl命令去掉私钥的密码

```shell
openssl rsa -in ~/.ssh/id_rsa -out ~/.ssh/id_rsa_new
```

备份旧私钥

```shell
mv ~/.ssh/id_rsa ~/.ssh/id_rsa.backup
```

使用新私钥

```shell
mv ~/.ssh/id_rsa_new ~/.ssh/id_rsa
```

设置权限

```shell
chmod 600 ~/.ssh/id_rsa
```