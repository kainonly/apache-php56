## NGINX 部署

适用于 `centos`、`debain` 与 `ubuntu` 系统进行编译安装与部署

##### 1.安装编译所需开发库

- 在 `centos` 下执行安装

```shell
# yum install gcc gcc-c++ autoconf automake zlib zlib-devel pcre-devel
```

- **如果是 `debain` 或 `ubuntu` 下执行安装**

```shell
# apt-get install build-essential libpcre3 libpcre3-dev autoconf zlib1g-dev
```

##### 2.准备编译源码

- [NGINX官网](http://nginx.org/en/download.html) 下载需要的版本源码
- [Openssl官网](https://www.openssl.org/source/) 下载版本 `>=1.0.2` 的版本源码

> 当今 `http2.0` 协议正在普及，因此如果使用该模块，用于编译的 `openssl` 源码包版本必须 `>=1.0.2`，`nginx` 推荐使用最新的稳定版本

将准备好的源码包分别解压，进入到 `nginx` 源码目录下

##### 3.配置安装

默认下，可以直接使用执行，但是很多模块是不包含在内的

```shell
# ./configure
```

为了减少以后再次配置编译，以下这些配置都是我们常用到的

```shell
# ./configure \
--error-log-path=/var/logs/nginx/error.log \
--http-log-path=/var/logs/nginx/access.log \
--sbin-path=/usr/sbin \
--pid-path=/run/nginx.pid \
--lock-path=/run/nginx.lock \
--http-client-body-temp-path=/var/nginx/client_temp \
--http-proxy-temp-path=/var/nginx/proxy_temp \
--http-fastcgi-temp-path=/var/nginx/fastcgi_temp \
--http-uwsgi-temp-path=/var/nginx/uwsgi_temp \
--http-scgi-temp-path=/var/nginx/scgi_temp \
--user=nginx \
--group=nginx \
--with-openssl=/root/openssl-1.1.0i \
--with-http_ssl_module \
--with-http_realip_module \
--with-http_addition_module \
--with-http_sub_module \
--with-http_dav_module \
--with-http_flv_module \
--with-http_mp4_module \
--with-http_gunzip_module \
--with-http_gzip_static_module \
--with-http_random_index_module \
--with-http_secure_link_module \
--with-http_stub_status_module \
--with-http_auth_request_module \
--with-mail \
--with-debug \
--with-mail_ssl_module \
--with-file-aio \
--with-threads \
--with-stream \
--with-stream_ssl_module \
--with-http_slice_module \
--with-http_v2_module
```

执行后，配置检测无误就可以编译与安装了

```shell
# make && make install
```

##### 4.环境配置

为 `nginx` 新增用户与用户组

```shell
# groupadd -r nginx
# useradd -s /sbin/nologin -g nginx -r nginx
```

创建运行环境需要的目录

```shell
# mkdir /var/logs/nginx
# mkdir /var/nginx
```

检测一下配置是否正常

```shell
# nginx -t
```

如果提示这些信息，就说明基础的安装配置完成了

```shell
# nginx: the configuration file /usr/local/nginx/conf/nginx.conf syntax is ok
# nginx: configuration file /usr/local/nginx/conf/nginx.conf test is successful
```

##### 5.优化配置

> 以下是我个人对 `nginx` 的一些优化与理解，主要针对常用配置合理定义并将虚拟域名分开管理

修改主配置文件 `nginx.conf`，先将使用用户加入配置

```conf
user nginx nginx;
```

让工作进程自动配置，通常情况下有多少个逻辑处理内核就对应多少个工作进程

```conf
worker_processes auto;
```

关闭惊群 `accept_mutex`，合理最大并发数设定 `worker_connections`

```conf
events {
	worker_connections 4096;
	accept_mutex off;
}
```

> `accept_mutex` 惊群是一种管理机制，例如在初始状态下少量的进程在保持运转，而并发攀升时其他休眠的进程会逐步被唤醒工作，这样的好处是正常访问下负载相对较低，但是当访问一直处于高位，这种方式反而效率会变低，所以关闭惊群让进程一直待命处理更加高效稳定。

开启文件异步线程池

```conf
http {
    aio threads;
}
```

> 大幅度提高IO性能，有数据表示开启与不开启性能相差31倍，请求不再因为工作进程被阻塞在读文件，而滞留在事件队列中，等待处理，它们可以被空闲的进程处理掉

开启 `sendfile`

```conf
http {
    sendfile on;
    sendfile_max_chunk 256;
}
```

> `sendfile` 是一种高效的传输模式，对比传统的(read、write/send方式)能减少拷贝次数，从而避免了数据在内核缓冲区和用户缓冲区之间的拷贝，操作效率很高。开启后内对文件的解析处理会有很大提升，`sendfile_max_chunk` 可以减少阻塞调用sendfile()所花费的最长时间，因为Nginx不会尝试一次将整个文件发送出去，而是每次发送大小为256KB的块数据

开启 `tcp_nopush`、 `tcp_nodelay`

```conf
http {
	tcp_nopush on;
	tcp_nodelay on;
}
```

> `tcp_nopush` 是让一个数据包里发送所有头文件，而不一个接一个的发送，`tcp_nodelay` 是不要缓存数据，而是一段一段的发送，这样有助于解决网络堵塞

开启GZIP

```conf
http {
	gzip on; 
	gzip_disable "MSIE [1-6].(?!.*SV1)";
	gzip_http_version 1.1;
	gzip_vary on;
	gzip_proxied any;
	gzip_min_length 1000;
	gzip_buffers 16 8k;
	gzip_comp_level 5;
	gzip_types text/plain text/css text/xml text/javascript application/json application/x-javascript application/xml application/xml+rss;
}
```

> 开启GZIP的目的是压缩静态请求，提高加载速度

优化反向代理

```conf
http {
	proxy_connect_timeout 5;
	proxy_read_timeout 60;
	proxy_send_timeout 5;
	proxy_buffer_size 16k;
	proxy_buffers 4 64k;
	proxy_busy_buffers_size 128k;
	proxy_temp_file_write_size 128k;
	proxy_temp_path /var/nginx/proxy_temp;
}
```

- `proxy_connect_timeout` 给反向代理的服务设置连接的超时时间
- `proxy_read_timeout` 连接成功后，等候等待反向代理服务的响应时间
- `proxy_send_timeout` 反向代理服务数据回传时间
- `proxy_buffer_size`  指令设置缓冲区大小
- `proxy_buffers` 指令设置缓冲区的大小和数量
- `proxy_busy_buffers_size` 缓冲区满载后写入磁盘的临时文件大小
- `proxy_temp_file_write_size` 一次访问能写入的临时文件的大小
- `proxy_temp_path` 临时文件目录

设置长连接

```conf
http {
    keepalive_timeout 5;
}
```

> 设置keep-alive客户端连接在服务器端保持开启的超时值