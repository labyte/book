# Docker

[B站博主的网站-Docker 快速入门](https://docker.easydoc.net/doc/81170005/cCewZWoN/lTKfePfP)

##　命令

[DOCKER-菜鸟教程](https://www.runoob.com/docker/docker-container-usage.html)

## 连接

[以群晖为例](../synology/synology.md#powershell-连接)


## BaGetter

- 搭建私有Nuget仓库
- [BaGetter-github](https://github.com/bagetter/BaGetter)

1. 创建外部挂载的文件夹 `docker/bagetter/8008/data`，如果不创建会报错找不到文件夹

2. 创建环境变量配置文件 `bagetter.env`，放置在之前创建的文件夹下，这里主要自定义一个ApiKey，方便后期发布包时，需要使用，如果不配置会报错，但是也能上传包，配置了必须携带key发布

```ini
# The following config is the API Key used to publish packages.
# You should change this to a secret value to secure your server.
ApiKey=NUGET-SERVER-API-KEY

Storage__Type=FileSystem
Storage__Path=/data
Database__Type=Sqlite
Database__ConnectionString=Data Source=/data/db/bagetter.db
Search__Type=Database

# 这个需要在环境变量中进行配置，否则无效
ASPNETCORE_HTTP_PORT=8008
```

3. 使用配置文件运行容器

```bash
docker run --rm --name nuget-server -p 8008:8008 --env-file bagetter.env -v "/vulome2/docker/bagetter/8008/data:/data" bagetter/bagetter:latest
```


4. 发布包

```bash
dotnet nuget push -s http://xxxx:8008/v3/index.json -k NUGET-SERVER-API-KEY package.1.0.0.nupkg

```


5. 浏览包

通过访问 `http://你的域名:8008`




**注意事项**：

- 需要在环境变量中配置 `ASPNETCORE_HTTP_PORT=8008` 或者在群晖的界面设置中更改,否则在运行命令中设置的端口无效

- 目前暂时无法使用 `https`，或者不方便使用

- 如果配置了 `ApiKey`， 发布包时要携带 `Key`

