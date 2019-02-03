## Kubernetes 集群

Kubernetes 是用于自动部署，扩展和管理容器化应用程序的开源系统。

#### kubeadm 概述

Kubeadm 是一个工具，它提供了 kubeadm init 以及 kubeadm join 这两个命令作为快速创建 kubernetes 集群的最佳实践。

| kubeadm | 说明                                                                                                   |
| ------- | ------------------------------------------------------------------------------------------------------ |
| init    | 启动一个 Kubernetes 主节点                                                                             |
| join    | 启动一个 Kubernetes 工作节点并且将其加入到集群                                                         |
| upgrade | 更新一个 Kubernetes 集群到新版本                                                                       |
| config  | 如果使用 v1.7.x 或者更低版本的 kubeadm 初始化集群，您需要对集群做一些配置以便使用 kubeadm upgrade 命令 |
| token   | 管理 kubeadm join 使用的令牌                                                                           |
| reset   | 还原 kubeadm init 或者 kubeadm join 对主机所做的任何更改                                               |
| version | 打印 kubeadm 版本                                                                                      |
| alpha   | 预览一组可用的新功能以便从社区搜集反馈                                                                 |