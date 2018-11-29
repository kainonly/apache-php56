## FTP 配置之 Vsftpd

在 `centos` 下通过 `yum` 安装

```shell
# yum -y install vsftpd
```

配置 `/etc/vsftpd/vsftpd.conf` ,将匿名用户登录关闭

```
anonymous_enable=NO
```

对ftp外用户做出限制

```
chroot_local_user=YES
```

如果用户被限定在了其主目录下，则该用户的主目录不能再具有写权限了

```
allow_writeable_chroot=YES
```

创建FTP用户

```
useradd -s /sbin/nologin -d /home/website kain
```

给kain添加密码

```
passwd kain
```

让防火墙允许21端口

```
/sbin/iptables -I INPUT -p tcp --dport 21 -j ACCEPT
```

重启vsftpd

```
systemctl restart vsftpd
```