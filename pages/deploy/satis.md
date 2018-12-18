## 搭建 Satis 私有 Packagist

使用 composer 初始化 Satis 项目

```shell
# composer create-project composer/satis --keep-vcs
```

配置 satis.json

```json
{
	"name": "My Repository",
	"require": {
		"topthink/think": "5.1.*",
		"overtrue/wechat": "~4.0",
		"aliyuncs/oss-sdk-php": "^2.3",
		"phpseclib/phpseclib": "^2.0",
		"kain/think-bit": "^1.4",
		"lcobucci/jwt": "^3.2",
		"doctrine/collections": "^1.5",
		"nesbot/carbon": "^2.5",
		"php-amqplib/php-amqplib": "^2.8",
		"ajaxray/short-code": "^1.1",
		"ramsey/uuid": "^3.8"
	}
}
```

- `homepage` 在satis上显示的默认私有镜像地址
- `repositories` 需要被索引的git代码仓库地址
- `require` 明确定义包名可以减少索引内容中使用require-all经过测试发现会索引全网的php包

对镜像中的 packages 创建索引

```shell
# php bin/satis build satis.json ./web -v
```