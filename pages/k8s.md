## Kubernetes 集群

Kubernetes 是用于自动部署，扩展和管理容器化应用程序的开源系统。

#### kubeadm 概述

Kubeadm 是一个工具，它提供了 kubeadm init 以及 kubeadm join 这两个命令作为快速创建 kubernetes 集群的最佳实践。

| 命令            | 说明                                                                                                   |
| --------------- | ------------------------------------------------------------------------------------------------------ |
| kubeadm init    | 启动一个 Kubernetes 主节点                                                                             |
| kubeadm join    | 启动一个 Kubernetes 工作节点并且将其加入到集群                                                         |
| kubeadm upgrade | 更新一个 Kubernetes 集群到新版本                                                                       |
| kubeadm config  | 如果使用 v1.7.x 或者更低版本的 kubeadm 初始化集群，您需要对集群做一些配置以便使用 kubeadm upgrade 命令 |
| kubeadm token   | 管理 kubeadm join 使用的令牌                                                                           |
| kubeadm reset   | 还原 kubeadm init 或者 kubeadm join 对主机所做的任何更改                                               |
| kubeadm version | 打印 kubeadm 版本                                                                                      |
| kubeadm alpha   | 预览一组可用的新功能以便从社区搜集反馈                                                                 |

#### kubeadm init

此命令初始化一个 Kubernetes master 节点

| 参数                                                       | 说明                                                                                              |
| ---------------------------------------------------------- | ------------------------------------------------------------------------------------------------- |
| --apiserver-advertise-address string                       | API Server将要广播的监听地址。如指定为 `0.0.0.0` 将使用缺省的网卡地址。                           |
| --apiserver-bind-port int32     缺省值: 6443               | API Server绑定的端口                                                                              |
| --apiserver-cert-extra-sans stringSlice                    | 可选的额外提供的证书主题别名（SANs）用于指定API Server的服务器证书。可以是IP地址也可以是DNS名称。 |
| --cert-dir string     缺省值: "/etc/kubernetes/pki"        | 证书的存储路径。                                                                                  |
| --config string                                            | kubeadm配置文件的路径。警告：配置文件的功能是实验性的。                                           |
| --cri-socket string     缺省值: "/var/run/dockershim.sock" | 指明要连接的CRI socket文件                                                                        |
| --dry-run                                                  | 不会应用任何改变；只会输出将要执行的操作。                                                        |
| --feature-gates string                                     | 键值对的集合，用来控制各种功能的开关。                                                            |
| -h, --help                                                 | 获取init命令的帮助信息                                                                            |
| --ignore-preflight-errors stringSlice                      | 忽视检查项错误列表，列表中的每一个检查项如发生错误将被展示输出为警告，而非错误。                 |
| --kubernetes-version string     缺省值: "stable-1"         | 为control plane选择一个特定的Kubernetes版本。                                                     |
| --node-name string                                         | 指定节点的名称。                                                                                  |
| --pod-network-cidr string                                  | 指明pod网络可以使用的IP地址段。                                                                   |
| --service-cidr string     缺省值: "10.96.0.0/12"           | 为service的虚拟IP地址另外指定IP地址段                                                             |
| --service-dns-domain string     缺省值: "cluster.local"    | 为services另外指定域名, 例如： "myorg.internal".                                                  |
| --skip-token-print                                         | 不打印出由 `kubeadm init` 命令生成的默认令牌。                                                    |
| --token string                                             | 这个令牌用于建立主从节点间的双向受信链接。                                                        |
| --token-ttl duration     缺省值: 24h0m0s                   | 令牌被自动删除前的可用时长 (示例： 1s, 2m, 3h). 如果设置为 '0', 令牌将永不过期。                  |

##### feature-gates 可选项有:
- Auditing=true | false (当前为ALPHA状态 - 缺省值=false)
- CoreDNS=true | false (缺省值=true)
- DynamicKubeletConfig=true | false (当前为BETA状态 - 缺省值=false)