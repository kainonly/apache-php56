## NGINX 隐藏版本号

#### 隐藏 Server

修改 `nginx.conf`

```conf
http {
+    server_tokens off;
}
```

#### 隐藏 X-Powered-By

修改 `php.ini`

```conf
expose_php = Off
```
