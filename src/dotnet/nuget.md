# Nuget

## 迁移 .nuget 文件夹

**.nuget** 默认在C盘，用于缓存我们使用过的包，随着项目越来越多，文件夹越来越大，占用C盘空间。

参考 [把.nuget文件夹从C盘移到其它盘](https://blog.csdn.net/Henry_Wu001/article/details/135825699)


- 查看当前缓存路径 `dotnet nuget locals all --list`，`global-packages` 指向的就是当前的路径
- 关闭当前的所有VS
- 打开 `%AppData%\NuGet\NuGet.Config` 文件，假设将 **.nuget** 移动到 **D** 盘的 **Users** 文件夹下，添加以下配置 ` <add key="globalPackagesFolder" value="D:\Users\.nuget\packages" />`

```xml
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <packageSources>
   //...
  </packageSources>
  <packageRestore>
    <add key="enabled" value="True" />
    <add key="automatic" value="True" />
  </packageRestore>
  <bindingRedirects>
    <add key="skip" value="False" />
  </bindingRedirects>
  <packageManagement>
    <add key="format" value="0" />
    <add key="disabled" value="False" />
  </packageManagement>
  <config>
     <add key="globalPackagesFolder" value="D:\Users\.nuget\packages" />
  </config>
</configuration>
```

- 将 **.nuget** 移动到 **D** 盘的 **Users** 文件夹下
- 再次查看当前缓存路径 `dotnet nuget locals all --list`，确认修改成功

## 发布包

- 可以直接将包发布到官方网站上
- 自建 Nuget 服务器，参考：[docker-bagetter](../technology-stack/docker.md#实例-bagetter)