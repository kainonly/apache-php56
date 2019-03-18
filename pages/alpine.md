## Alpine 国内源

使用阿里镜像 `https://mirrors.aliyun.com`

```shell
sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
```

使用科大镜像 `http://mirrors.ustc.edu.cn`

```shell
sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
```