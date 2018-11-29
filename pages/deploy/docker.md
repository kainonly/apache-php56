## Docker 容器

#### Docker 中国官方镜像加速

为了永久性保留更改，您可以修改 /etc/docker/daemon.json 文件并添加上 registry-mirrors 键值

``` json
{
  "registry-mirrors": ["https://registry.docker-cn.com"]
}
```

#### redis

``` shell
docker run -p 6379:6379 -v D:/Docker/redis:/data -d redis redis-server --appendonly yes
```

#### MariaDB

``` shell
docker run --name some-mariadb -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mariadb:tag
```