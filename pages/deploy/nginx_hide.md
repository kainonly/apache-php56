## NGINX 隐藏版本号

#### 隐藏 nginx

修改 `nginx.conf`

```conf
http {
    server_tokens off;
}
```

#### 隐藏 php-fpm

修改 `fastcgi.conf`

```conf
fastcgi_param SERVER_SOFTWARE nginx/$nginx_version;
# 修改为
fastcgi_param SERVER_SOFTWARE nginx;
```