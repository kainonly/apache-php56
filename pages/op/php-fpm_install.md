## PHP-FPM 部署

#### CentOS ####

```
yum install -y libacl libacl-devel libxml2 libxml2-devel openssl openssl-devel bzip2 bzip2-devel libcurl libcurl-devel enchant enchant-devel gd gd-devel gmp gmp-devel libmcrypt libmcrypt-devel libtidy libtidy-devel libxslt libxslt-devel argon2 libargon2-devel libtidy libtidy-devel
```

#### Debian & Ubuntu ####

```
apt-get install libacl1 libacl1-dev libxml2 libxml2-dev libbz2-dev libcurl3 libcurl3-dev enchant libenchant-dev libjpeg-dev libpng-dev libxpm-dev libfreetype6-dev libgmp-dev libgmp3-dev libmcrypt-dev libtidy-dev libxslt-dev libssl-dev libargon2-0 libargon2-0-dev
```

> Debian如出现GMP错误，则需要手动建立软链接

`ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h`

#### Configure ####

```
./configure \
--disable-debug \
--disable-rpath \
--enable-fpm \
--with-fpm-user=git \
--with-fpm-group=git \
--with-fpm-acl \
--with-libxml-dir \
--with-openssl \
--with-kerberos \
--with-pcre-regex \
--with-zlib \
--enable-bcmath \
--with-bz2 \
--enable-calendar \
--with-curl \
--enable-dba \
--with-enchant \
--enable-exif \
--disable-fileinfo \
--with-pcre-dir \
--enable-ftp \
--with-gd \
--with-jpeg-dir \
--with-png-dir \
--with-zlib-dir \
--with-xpm-dir \
--with-freetype-dir \
--with-gettext \
--with-gmp \
--with-mhash \
--enable-mbstring \
--enable-mbregex \
--with-mysqli \
--enable-embedded-mysqli \
--with-mysql-sock=/tmp/mysql.sock \
--enable-pcntl \
--with-pdo-mysql \
--enable-session \
--enable-shmop \
--enable-soap \
--enable-sockets \
--enable-sysvsem \
--with-tidy \
--enable-wddx \
--with-xmlrpc \
--enable-xml \
--with-iconv-dir \
--with-xsl \
--enable-zip \
--enable-mysqlnd \
--without-pear \
--enable-shared \
--with-password-argon2
```

#### 编译安装 ####

```
make && make install
```

到 /usr/local/etc 修改 php-fpm.conf 文件

```
;pool name ('www' here)
[nginx]
user = nginx
group = nginx
include=/usr/local/etc/php-fpm.d/*.conf
```

直接到php解压后的文件夹中找/sapi/fpm/init.d.php-fpm，名称改为php-fpm并把他复制到/etc/init.d/中

```
$ chmod +x /etc/init.d/php-fpm
$ chkconfig --add php-fpm
$ chkconfig php-fpm on
```

## 编译问题

#### undefined reference to `libiconv_open`

```
wget http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.13.1.tar.gz
tar -zxvf libiconv-1.13.1.tar.gz
cd libiconv-1.13.1
./configure --prefix=/usr/local/libiconv
 make
 make install
```

再检查php，指定 iconv的位置 
```
--with-iconv=/usr/local/libiconv
```

```
./configure --with-mysql=/backup/mysql --with-freetype-dir --with-jpeg-dir --with-png-dir --with-zlib --with-curl --with-gd --enable-gd-native-ttf --with-apxs2=/usr/local/apache/bin/apxs --enable-sockets --with-iconv=/usr/local/libiconv
make
make install
```

> 另一种解决方法为去除iconv模块也能正常编译php，如下：
編輯 Makefile 大約 77 行左右的地方:
EXTRA_LIBS = ..... -lcrypt
在最後加上 -liconv，例如:
EXTRA_LIBS = ..... -lcrypt -liconv
再运行make就可以了。

#### 最后一种方法：

```
make ZEND_EXTRA_LIBS='-liconv'
make install
```