## 镜像加速

为了永久性保留更改，可以修改 `/etc/docker/daemon.json` 文件并添加上 registry-mirrors 键值

``` json
{
  "registry-mirrors": ["https://registry.docker-cn.com"]
}
```