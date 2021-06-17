---
title: Linux 用户添加到组
categories: 运维技术
tags: linux
---

Linux 组是用于管理 Linux 中用户帐户的组织单位。对于 Linux 系统中的每一个用户和组，它都有惟一的数字标识号。它被称为 用户 ID（UID）和组 ID（GID）。组的主要目的是为组的成员定义一组特权。它们都可以执行特定的操作，但不能执行其他操作。

来源于 《在 Linux 中把用户添加到组的四个方法》，详细说明可查看原文

作者：Linux 中国
链接：https://zhuanlan.zhihu.com/p/63408566

<!-- more -->

Linux 中有两种类型的默认组。每个用户应该只有一个 主要组(primary group) 和任意数量的 次要组(secondary group)。

- **主要组**： 创建用户帐户时，已将主要组添加到用户。它通常是用户的名称。在执行诸如创建新文件（或目录）、修改文件或执行命令等任何操作时，主要组将应用于用户。用户的主要组信息存储在 /etc/passwd 文件中。
- **次要组**： 它被称为次要组。它允许用户组在同一组成员文件中执行特定操作。例如，如果你希望允许少数用户运行 Apache（httpd）服务命令，那么它将非常适合。

我假设你已经拥有此操作所需的组和用户。在本例中，我们将使用以下用户和组：user1、user2、user3，另外的组是 mygroup 和 mygroup1。

在进行更改之前，我希望检查一下用户和组信息。详见下文。

我可以看到下面的用户与他们自己的组关联，而不是与其他组关联。

```shell
# id user1
uid=1008(user1) gid=1008(user1) groups=1008(user1)

# id user2
uid=1009(user2) gid=1009(user2) groups=1009(user2)

# id user3
uid=1010(user3) gid=1010(user3) groups=1010(user3)
```

我可以看到这个组中没有关联的用户

```shell
# getent group mygroup
mygroup:x:1012:

# getent group mygroup1
mygroup1:x:1013:
```

## 使用 usermod 命令

usermod 命令修改系统帐户文件，以反映命令行上指定的更改。

### 如何使用 usermod 命令将现有的用户添加到次要组或附加组？

要将现有用户添加到辅助组，请使用带有 `-G` 选项和组名称的 `usermod` 命令

语法：

```shell
# usermod [-G] [GroupName] [UserName]
```

如果系统中不存在给定的用户或组，你将收到一条错误消息。如果没有得到任何错误，那么用户已经被添加到相应的组中

```shell
# usermod -a -G mygroup user1
```

让我使用 `id` 命令查看输出。是的，添加成功

```shell
# id user1
uid=1008(user1) gid=1008(user1) groups=1008(user1),1012(mygroup)
```

### 如何使用 usermod 命令将现有的用户添加到多个次要组或附加组？

要将现有用户添加到多个次要组中，请使用带有 -G 选项的 usermod 命令和带有逗号分隔的组名称

语法：

```shell
# usermod [-G] [GroupName1,GroupName2] [UserName]
```

在本例中，我们将把 `user2` 添加到 `mygroup` 和 `mygroup1` 中

```shell
# usermod -a -G mygroup,mygroup1 user2
```

让我使用 `id` 命令查看输出。是的，`user2` 已成功添加到 `myGroup` 和 `myGroup1` 中

```shell
# id user2
uid=1009(user2) gid=1009(user2) groups=1009(user2),1012(mygroup),1013(mygroup1)
```

### 如何改变用户的主要组？

要更改用户的主要组，请使用带有 `-g` 选项和组名称的 `usermod` 命令。

语法：

```shell
# usermod [-g] [GroupName] [UserName]
```

我们必须使用 `-g` 改变用户的主要组

```shell
# usermod -g mygroup user3
```

让我们看看输出。是的，已成功更改。现在，显示 `user3` 主要组是 `mygroup` 而不是 `user3`

```shell
# id user3
uid=1010(user3) gid=1012(mygroup) groups=1012(mygroup)
```

## 使用 gpasswd 命令

`gpasswd` 命令用于管理 `/etc/group` 和 `/etc/gshadow`。每个组都可以有管理员、成员和密码

### 如何使用 gpasswd 命令将现有用户添加到次要组或者附加组？

要将现有用户添加到次要组，请使用带有 -M 选项和组名称的 gpasswd 命令。

语法：

```shell
# gpasswd [-M] [UserName] [GroupName]
```

在本例中，我们将把 `user1` 添加到 `mygroup` 中

```shell
# gpasswd -M user1 mygroup
```

让我使用 `id` 命令查看输出。是的，`user1` 已成功添加到 `mygroup` 中

```shell
# id  user1
uid=1008(user1) gid=1008(user1) groups=1008(user1),1012(mygroup)
```

### 如何使用 gpasswd 命令添加多个用户到次要组或附加组中？

要将多个用户添加到辅助组中，请使用带有 `-M` 选项和组名称的 `gpasswd` 命令。

语法：

```shell
# gpasswd [-M] [UserName1,UserName2] [GroupName]
```

在本例中，我们将把 user2 和 user3 添加到 mygroup1 中

```shell
# gpasswd -M user2,user3 mygroup1
```

让我使用 getent 命令查看输出。是的，`user2` 和 `user3` 已成功添加到 `myGroup1` 中

```shell
# getent group mygroup1
mygroup1:x:1013:user2,user3
```

### 如何使用 gpasswd 命令从组中删除一个用户？

要从组中删除用户，请使用带有 `-d` 选项的 `gpasswd` 命令以及用户和组的名称

语法：

```shell
# gpasswd [-d] [UserName] [GroupName]
```

在本例中，我们将从 `mygroup` 中删除 `user1`

```shell
# gpasswd -d user1 mygroup
Removing user user1 from group mygroup
```