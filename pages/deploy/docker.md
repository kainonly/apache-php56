## Docker 容器

#### 国内镜像加速

为了永久性保留更改，可以修改 `/etc/docker/daemon.json` 文件并添加上 registry-mirrors 键值

``` json
{
  "registry-mirrors": ["https://registry.docker-cn.com"]
}
```

#### 常用命令记录

##### - 列出所有容器ID

```shell
# docker ps -aq
```

##### - 查看所有运行或者不运行容器

```shell
# docker ps -a
```

##### - 停止所有的容器

```shell
# docker stop $(docker ps -a -q) 或者 docker stop $(docker ps -aq)
```

##### - 删除所有容器

```shell
# docker rm $(docker ps -a -q) 或者 docker rm $(docker ps -aq)
```

###### - 查看当前镜像

```shell
# docker images
```

#### 容器生命周期管理

##### - 创建一个新的容器并运行一个命令

```shell
#docker run [OPTIONS] IMAGE [COMMAND] [ARG...]
```

| Options                            | Description                                                     |
| ---------------------------------- | --------------------------------------------------------------- |
| -a stdin                           | 指定标准输入输出内容类型，可选 `STDIN` `STDOUT` `STDERR` 三项   |
| -d                                 | 后台运行容器，并返回容器ID                                      |
| -i                                 | 以交互模式运行容器，通常与 `-t` 同时使用                        |
| -p                                 | 端口映射，格式为：主机(宿主)端口:容器端口                       |
| -t                                 | 为容器重新分配一个伪输入终端，通常与 -i 同时使用                |
| --name="nginx"                     | 为容器指定一个名称                                              |
| --dns 223.5.5.5                    | 指定容器使用的DNS服务器，默认和宿主一致                         |
| --dns-search example.com           | 指定容器DNS搜索域名，默认和宿主一致                             |
| -h "develop"                       | 指定容器的hostname                                              |
| -e username="kute"                 | 设置环境变量                                                    |
| --env-file=[]                      | 从指定文件读入环境变量                                          |
| --cpuset="0-2" or --cpuset="0,1,2" | 绑定容器到指定CPU运行                                           |
| -m                                 | 设置容器使用内存最大值                                          |
| --net="bridge"                     | 指定容器的网络连接类型，支持 `bridge` `host` `none` `container` |
| --link=[]                          | 添加链接到另一个容器                                            |
| --expose=[]                        | 开放一个端口或一组端口                                          |


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

| Options | Description        |
| ------- | ------------------ |
| -s      | 向容器发送一个信号 |


##### - 删除一个或多少容器

```shell
# docker rm [OPTIONS] CONTAINER [CONTAINER...]
```

| Options | Description                             |
| ------- | --------------------------------------- |
| -f      | 通过SIGKILL信号强制删除一个运行中的容器 |
| -l      | 移除容器间的网络连接，而非容器本身      |
| -v      | 删除与容器关联的卷                      |


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

| Options | Description                  |
| ------- | ---------------------------- |
| -d      | 分离模式: 在后台运行         |
| -i      | 即使没有附加也保持STDIN 打开 |
| -t      | 分配一个伪终端               |

#### 容器操作

##### - 列出容器

```shell
# docker ps [OPTIONS]
```

| Options    | Description                  |
| ---------- | ---------------------------- |
| -a         | 显示所有的容器，包括未运行的 |
| -f         | 根据条件过滤显示的内容       |
| --format   | 指定返回值的模板文件         |
| -l         | 显示最近创建的容器           |
| -n         | 列出最近创建的n个容器        |
| --no-trunc | 不截断输出                   |
| -q         | 静默模式，只显示容器编号     |
| -s         | 显示总的文件大小             |

##### - 获取容器/镜像的元数据

```shell
# docker inspect [OPTIONS] NAME|ID [NAME|ID...]
```

| Options | Description          |
| ------- | -------------------- |
| -f      | 指定返回值的模板文件 |
| -s      | 显示总的文件大小     |
| --type  | 为指定类型返回JSON   |

##### - 查看容器中运行的进程信息

```shell
# docker top [OPTIONS] CONTAINER [ps OPTIONS]
```

##### - 连接到正在运行中的容器

```shell
# docker attach [OPTIONS] CONTAINER
```

##### - 从服务器获取实时事件

```shell
# docker events [OPTIONS]
```

| Options | Description                  |
| ------- | ---------------------------- |
| -f      | 根据条件过滤事件             |
| --since | 从指定的时间戳后显示所有事件 |
| --until | 流水时间显示到指定的时间为止 |

##### - 获取容器的日志

```shell
# docker logs [OPTIONS] CONTAINER
```

| Options | Description                |
| ------- | -------------------------- |
| -f      | 跟踪日志输出               |
| --since | 显示某个开始时间的所有日志 |
| -t      | 显示时间戳                 |
| --tail  | 仅列出最新N条容器日志      |

##### - 阻塞运行直到容器停止

```shell
# docker wait [OPTIONS] CONTAINER [CONTAINER...]
```

##### - 将文件系统作为一个tar归档文件导出到STDOUT

```shell
# docker export [OPTIONS] CONTAINER
```

| Options | Description        |
| ------- | ------------------ |
| -o      | 将输入内容写到文件 |


##### - 列出指定的容器的端口映射

```shell
# docker port [OPTIONS] CONTAINER [PRIVATE_PORT[/PROTO]]
```

#### 容器rootfs命令

##### - 从容器创建一个新的镜像

```shell
# docker commit [OPTIONS] CONTAINER [REPOSITORY[:TAG]]
```

| Options | Description                  |
| ------- | ---------------------------- |
| -a      | 提交的镜像作者               |
| -c      | 使用Dockerfile指令来创建镜像 |
| -m      | 提交时的说明文字             |
| -p      | 在commit时，将容器暂停       |

##### - 用于容器与主机之间的数据拷贝

```shell
# docker cp
```

| Options | Description        |
| ------- | ------------------ |
| -L      | 保持源目标中的链接 |

##### - 检查容器里文件结构的更改

```shell
# docker diff [OPTIONS] CONTAINER
```