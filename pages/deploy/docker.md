## Docker 容器

#### 常用指令

创建一个新的容器并运行一个命令

```shell
#docker run [OPTIONS] IMAGE [COMMAND] [ARG...]
```

- -a stdin: 指定标准输入输出内容类型，可选 STDIN/STDOUT/STDERR 三项

#### 国官方镜像加速

为了永久性保留更改，您可以修改 /etc/docker/daemon.json 文件并添加上 registry-mirrors 键值

``` json
{
  "registry-mirrors": ["https://registry.docker-cn.com"]
}
```