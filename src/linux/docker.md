# Docker

[B站博主的网站-Docker 快速入门](https://docker.easydoc.net/doc/81170005/cCewZWoN/lTKfePfP)

## 连接服务器

连接Docker所在的服务器：[前往](ssh-connect-server.md#ssh-连接服务器)，连接成功后即可使用 `docker` 命令

## 命令

[Docker-菜鸟教程](https://www.runoob.com/docker/docker-container-usage.html)

## 文件路径

当使用某个文件时，除非使用绝对路径（以 根目录`/`开头的路径），都是以执行 `docker` 命令的目录开始查找。

以配置 **bagetter** 为例，使用了一个环境变量配置文件 `bagetter.env`，和文件夹的挂载 `/vulome2/docker/bagetter/8008/data`

目录结构如下：

```text
/vulome2/docker/bagetter/8008/
    + data
    - bagetter.env
```

**使用绝对路径**

```bash
docker run -d --rm --name nuget-server -p 8008:8008 --env-file /vulome2/docker/bagetter/8008/bagetter.env -v "/vulome2/docker/bagetter/8008/data:/data" bagetter/bagetter:latest
```
**使用相对路径，此时假设在 `/vulome2/docker/bagetter/8008` 下执行的 `docker`**

```bash
docker run -d --rm --name nuget-server -p 8008:8008 --env-file bagetter.env -v "data:/data" bagetter/bagetter:latest
```

- 注意 `docker-compose`，在官网上写的是 `docker compose` 无法执行。

## 实例-BaGetter

搭建私有 **Nuget** 仓库，[BaGetter-github](https://github.com/bagetter/BaGetter)

**一、[连接Docker所在的服务器](ssh-connect-server.md#ssh-连接服务器)**

**二、创建外部挂载的文件夹 `/volume2/docker/bagetter/8008/data`，如果不创建会报错找不到文件夹**

> 备注：这里根据自己设定文件夹的位置

切换到根目录

```bash
cd /
```

创建目录(使用 `-p` 可创建多层)

```bash
mkdir -p /volume2/docker/bagetter/8008/data
```

切换到8008目录，这样比较方便

```bash
cd volume2/docker/bagetter/8008
```


**三、在 `/volume2/docker/bagetter/8008`下创建环境变量配置文件 `bagetter.env`，并添加如下内容：**

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
ASPNETCORE_HTTP_PORTS=8008
```

主要点：

- 自定义一个ApiKey，方便后期发布包时使用，若未配置会出现警告，但是也能上传包，若配置了必须携带key才能发布
- 设置 `ASPNETCORE_HTTP_PORTS`否则端口映射失败

**四、使用配置文件运行并创建容器，**

```bash
docker run -d --rm --name nuget-server -p 8008:8008 --env-file bagetter.env -v "data:/data" bagetter/bagetter:latest
```
> 注意使用 `-d` 设置为后台运行，否则终端退出后，容器会移除。

此命令会检查本地是否存在镜像，若不处存在会先拉去，再创建。也可以先拉取。


搜索镜像

```bash
docker search bagetter
```

拉取镜像

```bash
docker pull bagetter/bagetter:latest
```

**五、发布包**

在 vs 的程序包管理器控制台窗口中输入（注意路径）

```bash
dotnet nuget push -s http://xxxx:8008/v3/index.json -k NUGET-SERVER-API-KEY package.1.0.0.nupkg

```

**六、在VS中添加源**

- 名称：自定义
- 源：`http://xxxx:8008/v3/index.json`，有要求使用 `https` 的警告，不影响

**七、浏览包**

通过访问 `http://你的域名:8008`


**注意事项**：

- 需要在环境变量中配置 `ASPNETCORE_HTTP_PORT=8008` 或者在群晖的界面设置中更改,否则在运行命令中设置的端口无效

- 目前暂时无法使用 `https`，或者不方便使用

- 如果配置了 `ApiKey`， 发布包时要携带 `Key`

