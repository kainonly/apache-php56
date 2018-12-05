## 终端走代理

#### 方法 1

在终端中直接运行命令

```
# export http_proxy=http://proxyAddress:port
```

> 这个办法的好处是简单直接，并且影响面很小（只对当前终端有效，退出就不行了）。

如果你用的是ss代理，在当前终端运行以下命令，那么 `wget` `curl` 这类网络命令都会经过ss代理

```
# export ALL_PROXY=socks5://127.0.0.1:1080
```

#### 方法 2

把代理服务器地址写入 shell 配置文件 `.bashrc` 或者 `.zshrc`

直接在 `.bashrc` 或者 `.zshrc` 添加下面内容

```
export http_proxy="http://localhost:port"
export https_proxy="http://localhost:port"
```

以使用shadowsocks代理为例，ss的代理端口为 `1080`,那么应该设置为

```
export http_proxy="socks5://127.0.0.1:1080"
export https_proxy="socks5://127.0.0.1:1080"
```

或者直接设置ALL_PROXY

```
export ALL_PROXY=socks5://127.0.0.1:1080
```

或者通过设置alias简写来简化操作，每次要用的时候输入 `setproxy`，不用了就 `unsetproxy`

```
alias setproxy="export ALL_PROXY=socks5://127.0.0.1:1080"
alias unsetproxy="unset ALL_PROXY"
alias ip="curl -i http://ip.cn"
```

#### 方法 3

改相应工具的配置，比如 `apt` 的配置

```
sudo vim /etc/apt/apt.conf
```

在文件末尾加入下面这行

```
Acquire::http::Proxy "http://proxyAddress:port"
```

保存 `apt.conf` 文件即可

#### 方法 4

利用proxychains在终端使用socks5代理

##### proxychains安装

```
git clone https://github.com/rofl0r/proxychains-ng.git
cd proxychains-ng
./configure
make && make install
cp ./src/proxychains.conf /etc/proxychains.conf
cd .. && rm -rf proxychains-ng
```

##### 编辑proxychains配置

```
vim /etc/proxychains.conf
```

##### 将socks4 127.0.0.1 9095改为

```
socks5 127.0.0.1 1080
```

> 默认的 `socks4 127.0.0.1 9095` 是tor代理，而 `socks5 127.0.0.1 1080` 是 shadowsocks 的代理

`proxychains.conf` 文件说明了代理配置格式,在需要代理的命令前加上 proxychains4

```
proxychains4 wget http://xxx.com/xxx.zip
```

