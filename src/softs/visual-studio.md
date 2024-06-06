# 包管理器控制台

## Entity Framework

### 安装

在VS包控制台执行 `dotnet ef`错误

```text
dotnet : 无法执行，因为找不到指定的命令或文件。
所在位置 行:1 字符: 1
+ dotnet ef dbcontext scaffold "server=192.168.1.236;database=JzErp;uid ...
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : NotSpecified: (无法执行，因为找不到指定的命令或文件。:String) [], RemoteException
    + FullyQualifiedErrorId : NativeCommandError
 
可能的原因包括:
  *内置的 dotnet 命令拼写错误。
  *你打算执行 .NET 程序，但 dotnet-ef 不存在。
  *你打算运行全局工具，但在路径上找不到具有此名称且前缀为 dotnet 的可执行文件。

```

原因：

从 3.0 起，EF Core 命令列工具 (dotnet ef) 不在 .NET Core SDK 里面，需另装。命令如下：

```text
dotnet tool install --global dotnet-ef

```

安装成功如下

```text
PM> dotnet tool install --global dotnet-ef
可使用以下命令调用工具: dotnet-ef
已成功安装工具“dotnet-ef”(版本“6.0.2”)

```

参考：[http://www.manongjc.com/detail/28-rmfcuflorcnbrte.html](http://www.manongjc.com/detail/28-rmfcuflorcnbrte.html)

### 迁移

1. 先创建迁移文件

```text
dotnet ef migrations add xxxx
```

然后更新数据库

```text
dotnet ef database update
```

## 中文乱码

CSDN：[https://blog.csdn.net/Michael_fchou/article/details/104349977](https://gitee.com/link?target=https://blog.csdn.net/Michael_fchou/article/details/104349977)

第一种情况：VS的输出编码更改为UTF-8，按照图示安装UTF-8插件，若未解决问题，进行第二种操作
![1717636935171](image/visualstudio/1717636935171.png)


第二种情况：如果已经装了UTF-8插件但是控制台输出的中文仍然是乱码。

1. **打开电脑的控制面板，然后打开时钟和区域**

![1717636919260](image/visualstudio/1717636919260.png)

2. **打开区域**

![](https://wolai-secure-cdn.dingtalk.com/static/vjkaNZ366YTRQWLToGsPfp/image.png?auth_key=1717636048-xybv2Xeov9FBmnVRFipFjA-0-ba78b526b1ccce76ed473c04839b3d06)

1. **打开管理**

![](https://wolai-secure-cdn.dingtalk.com/static/tGy3QaDcXUqeRVBdQcToFT/image.png?auth_key=1717636048-n8aDtAoU3ti9phxZTbKHNL-0-3f24838cc287f1b7c2c2aeda95e7a24f)

1. **打开更改系统区域设置**

![](https://wolai-secure-cdn.dingtalk.com/static/jMokZeEBLo4S39aDM1ffZ3/image.png?auth_key=1717636048-8BD85b6ACZds9stz2KP5jP-0-cf0a10a3714d3b248c1cb597e6548158)

1. **把下面的选项打勾**

![](https://wolai-secure-cdn.dingtalk.com/static/dM5j2nUoTVb7hCiSE58SZj/image.png?auth_key=1717636048-uZfEny2NoQKFcevAtYNe7w-0-077b6198b0471eb83ee70cbe3ab11a01)

1. **最后重启电脑就ok了。**

# 查找替换无效

删除“C：\Program Files\Microsoft Visual Studio\2022[Enterprise/Pro/Community]\Common7\IDE\CommonExtensions\Microsoft\Editor\ServiceHub\Indexing.servicehub.service.json”文件并重新启动Visual Studio
