## 搭建 IKEv2 VPN

搭建 IKEv2 VPN 的主要是为了外网访问内网资源的 `无 Internet` 解决方案，例如：你们公司有内部网络其中数据库、缓存、版本管理等等资源只能在内网才可访问，此时就可以通过 `VPN 虚拟专用网络` 来访问内网的资源

#### 申请 CA 证书

可以选择腾讯、阿里等云平台进行申请免费的域名证书

#### 安装 strangswan

操作系统Debian 9，除了安装strongswan，还需要安装libcharon-extra-plugins

```shell
apt-get install strongswan libcharon-extra-plugins
```

#### 配置文件

修改文件 `/etc/ipsec.conf`

```conf
# ipsec.conf - strongSwan IPsec configuration file

# basic configuration

config setup
	# strictcrlpolicy=yes
	# uniqueids = no

# Add connections here.

# Sample VPN connections

conn ikev2-eap
	left=%any
	leftsubnet=0.0.0.0/0
	right=%any
	rightsourceip=10.0.3.0/24
	dpdaction=clear
	keyexchange=ikev2
	ike=aes256-sha256-modp1024,3des-sha1-modp1024,aes256-sha1-modp1024!
	esp=aes256-sha256,3des-sha1,aes256-sha1!
	rekey=no
	leftauth=pubkey
	leftcert=/etc/strongswan.d/ssl/vpc.crt # 域名证书
	leftsendcert=always
	leftid=vpc.xxx.com # 域名
	rightauth=eap-mschapv2
	rightsendcert=never
	eap_identity=%any
	fragmentation=yes
	auto=add
```

#### 账号配置

修改文件 `/etc/ipsec.secrets`

```conf
# This file holds shared secrets or RSA private keys for authentication.

# RSA private key for this host, authenticating it to any other host
# which knows the public part.

# RSA 密钥
: RSA /etc/strongswan.d/ssl/vpc.xxx.cc.key

# 设置连接账户 <username> : EAP <password>
kain : EAP "abc123"
```

#### 服务

- `ipsec start` 开启服务
- `ipsec restart` 重启服务
- `ipsec status` 查看状态

