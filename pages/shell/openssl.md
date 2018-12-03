## OpenSSL 使用

> OpenSSL是为网络通信提供安全及数据完整性的一种安全协议，囊括了主要的密码算法、常用的密钥和证书封装管理功能以及SSL协议，并提供了丰富的应用程序供测试或其它目的使用

##### 生成RSA公钥和私钥

生成RSA私钥

```shell
# openssl genrsa -out rsa_private_key.pem 1024
```

把RSA私钥转换成PKCS8格式

```shell
# openssl pkcs8 -topk8 -inform PEM -in rsa_private_key.pem -outform PEM –nocrypt
```

生成RSA公钥

```shell
# openssl rsa -in rsa_private_key.pem -pubout -out rsa_public_key.pem
```

##### 生成 ECC 密钥对

生成私密

``` shell
# openssl ecparam -genkey -name prime256v1 -out domain.key 
```

生成指定证书

``` shell
# openssl req -new -sha256 -key domain.key -out domain_csr.txt
```

> 注意事项： ECC算法加密强度有3个选项：prime256v1 ／secp384r1／secp521r1,prime256v1 目前已经足够安全，如无特殊需要请保持ECC算法prime256v1 默认即可。 SHA256目前已经足够安全，如无特殊需要请保持默认。

生成公钥

``` shell
# openssl ec -in domain.key -pubout -out pubkey.pem
```

##### 签发证书

生成签名

```shell
# openssl genrsa -des3 -out root.key 1024
```

去除口令

```shell
# openssl rsa -in server.key -out server.key
```

生成CA证书

``` shell
# openssl req -new -x509 -key root.key -out root.crt -days 365 -config openssl.conf
```