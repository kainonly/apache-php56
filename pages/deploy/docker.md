## Docker 容器

#### 容器生命周期管理

##### - 创建一个新的容器并运行一个命令

```shell
#docker run [OPTIONS] IMAGE [COMMAND] [ARG...]
```

- `-a stdin`: 指定标准输入输出内容类型，可选 `STDIN` `STDOUT` `STDERR` 三项
- `-d`: 后台运行容器，并返回容器ID
- `-i`: 以交互模式运行容器，通常与 `-t` 同时使用
- `-p`: 端口映射，格式为：主机(宿主)端口:容器端口
- `-t`: 为容器重新分配一个伪输入终端，通常与 -i 同时使用
- `--name="nginx"`: 为容器指定一个名称
- `--dns 223.5.5.5`: 指定容器使用的DNS服务器，默认和宿主一致
- `--dns-search example.com`: 指定容器DNS搜索域名，默认和宿主一致
- `-h "develop"`: 指定容器的hostname
- `-e username="kute"`: 设置环境变量
- `--env-file=[]`: 从指定文件读入环境变量
- `--cpuset="0-2" or --cpuset="0,1,2"`: 绑定容器到指定CPU运行
- `-m`: 设置容器使用内存最大值
- `--net="bridge"`: 指定容器的网络连接类型，支持 `bridge` `host` `none` `container`
- `--link=[]`: 添加链接到另一个容器
- `--expose=[]`: 开放一个端口或一组端口

##### - 启动一个或多个已经被停止的容器

```shell
# docker start [OPTIONS] CONTAINER [CONTAINER...]
```

##### - 停止一个运行中的容器

```shell
# docker stop [OPTIONS] CONTAINER [CONTAINER...]
```

##### - 重启容器

```shell
# docker restart [OPTIONS] CONTAINER [CONTAINER...]
```

##### - 杀掉一个运行中的容器

```shell
# docker kill [OPTIONS] CONTAINER [CONTAINER...]
```

- `-s` :向容器发送一个信号

##### - 删除一个或多少容器

```shell
# docker rm [OPTIONS] CONTAINER [CONTAINER...]
```

- `-f` :通过SIGKILL信号强制删除一个运行中的容器
- `-l` :移除容器间的网络连接，而非容器本身
- `-v` :-v 删除与容器关联的卷

##### - 暂停容器中所有的进程

```shell
# docker pause [OPTIONS] CONTAINER [CONTAINER...]
```

##### - 恢复容器中所有的进程

```shell
# docker unpause [OPTIONS] CONTAINER [CONTAINER...]
```

##### - 创建一个新的容器但不启动它

```shell
# docker create [OPTIONS] IMAGE [COMMAND] [ARG...]
```

##### - 在运行的容器中执行命令

```shell
# docker exec [OPTIONS] CONTAINER COMMAND [ARG...]
```

- `-d` :分离模式: 在后台运行
- `-i` :即使没有附加也保持STDIN 打开
- `-t` :分配一个伪终端

#### 容器操作

#### 国官方镜像加速

为了永久性保留更改，可以修改 `/etc/docker/daemon.json` 文件并添加上 registry-mirrors 键值

``` json
{
  "registry-mirrors": ["https://registry.docker-cn.com"]
}
```