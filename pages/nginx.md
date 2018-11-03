## NGINX 安装与部署

所需安装依赖

> `openSSL` version > 1.0.2

CentOS

``` shell
$ yum install gcc gcc-c++ autoconf automake zlib zlib-devel pcre-devel
```

Debain & Ubuntu

``` shell
$ apt-get install build-essential libpcre3 libpcre3-dev autoconf zlib1g-dev
```

编译检测

``` shell
$ ./configure \
--error-log-path=/var/logs/nginx/error.log \
--http-log-path=/var/logs/nginx/access.log \
--pid-path=/var/run/nginx.pid \
--lock-path=/var/run/nginx.lock \
--http-client-body-temp-path=/var/cache/nginx/client_temp \
--http-proxy-temp-path=/var/cache/nginx/proxy_temp \
--http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
--http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
--http-scgi-temp-path=/var/cache/nginx/scgi_temp \
--user=nginx \
--group=nginx \
--with-openssl=/root/openssl-1.0.2o \
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

编译安装

``` shell
$ make && make install
```

添加Nginx用户与用户组

``` shell
$ groupadd -r git
$ useradd -s /sbin/nologin -g git -r git
```

创建缓存目录

``` shell
$ mkdir /var/cache/nginx
$ mkdir /var/nginx
```

检测配置是否正常

``` shell
$ nginx -t
```

修改配置文件 nginx.conf

``` nginx.conf
user nginx nginx;
worker_processes auto;

error_log /var/run/error.log info;
pid /var/run/nginx.pid;
lock_file /var/run/nginx.lock;

events {
	worker_connections 4096; 
	accept_mutex off;
}

http {
	include mime.types;
	server_names_hash_bucket_size 64;
	default_type application/octet-stream;
	access_log off; 
	aio threads;

	sendfile on; 
	sendfile_max_chunk 512k;
 	client_max_body_size 256m;

	tcp_nopush on;
	tcp_nodelay on;
 
	keepalive_timeout 5;
 
	gzip on; 
	gzip_disable "MSIE [1-6].(?!.*SV1)";
	gzip_http_version 1.1;
	gzip_vary on;
	gzip_proxied any;
	gzip_min_length 1000;
	gzip_buffers 16 8k;
	gzip_comp_level 6;
	gzip_types text/plain text/css text/xml text/javascript application/json application/x-javascript application/xml application/xml+rss;

	log_format main $remote_addr - $remote_user [$time_local] "$request"  $status $body_bytes_sent "$http_referer"  "$http_user_agent" "$http_x_forwarded_for";
 
	proxy_connect_timeout 5;
	proxy_read_timeout 60;
	proxy_send_timeout 5;
	proxy_buffer_size 16k;
	proxy_buffers 4 64k;
	proxy_busy_buffers_size 128k;
	proxy_temp_file_write_size 128k;
	proxy_temp_path /var/cache/nginx/proxy_temp;

	server {
	    listen 80 default;
	    return 404;
	}
 
	include vhost/**/*.conf;
}
```

添加子配置，设置一个虚拟目录service.conf

``` shell
server {
	listen  80;
	server_name <域名>;
	rewrite ^(.*)$  https://<域名>$1 permanent;
}

server {
	listen 443 ssl http2;
	listen [::]:443 ssl http2;
	
	server_name api.yelinvan.cc;
	charset utf-8;
	 
	ssl_certificate <证书的绝对路径>;
	ssl_certificate_key <签名的绝对路径>;
	ssl_session_cache shared:SSL:20m;
	ssl_session_timeout 10m;
	ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
	ssl_prefer_server_ciphers on;
	ssl_ciphers ECDH+AESGCM:ECDH+AES256:ECDH+AES128:DH+3DES:!ADH:!AECDH:!MD5;
	 
	root <虚拟目录路径>;
	
	location / {
		aio threads=default;
		index index.html <index.php>;
        # 如果需要代理
        # proxy_pass http://127.0.0.1:<端口>;
	}
	  
    # 如果需要 php-fpm 解析
	# location ~ \.php$ {
	# 	fastcgi_pass 127.0.0.1:9000;
	# 	fastcgi_index index.php;
	# 	fastcgi_split_path_info ^((?U).+\.php)(/?.+)$;
	# 	fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
	# 	include fastcgi_params;
	# }

	error_page 404 403 /404.html;
	error_page 500 502 503 504 /50x.html;
}
```