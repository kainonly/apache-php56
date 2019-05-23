## 自定义 Cordova 插件 

安装 `plugman`

```shell
npm install plugman -g
```

创建插件模板

```shell
plugman create --name <名称> --plugin_id <id> --plugin_version <版本> --path <路径>
```

增加Android平台

```shell
plugman platform add --platform_name android
```

增加iOS平台

```shell
plugman platform add --platform_name ios
```