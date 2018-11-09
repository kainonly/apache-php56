## 自定义证书

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

