## PHP CURL 证书问题

如出现该错误, 未正确配置CA证书

```shell
curl: (60) SSL certificate : unable to get local issuer certificate
```


下载证书 `http://curl.haxx.se/ca/cacert.pem`


配置 `php.ini`

curl.cainfo = "d:/wamp/php/cacert.pem"