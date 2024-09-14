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

### 搭建包管理器

搭建私有 **Nuget** 仓库，[BaGetter-github](https://github.com/bagetter/BaGetter)

以下流程基于群晖的 **Docker** 进行部署。

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

**五、浏览包**


在浏览器中浏览包，在群晖的上部署的不方便使用 `localhost` 来访问，使用域名，并在开发 `8008` 端口外部访问

通过访问 `http://你的域名:8008`

只能使用 `http` ，没看到相关的 `https` 设置。

### 发布包

**一、设置包属性**

**包ID**：在部署的仓库中必须是唯一的，设置好后，就不要更改了

**标题**：与ID相同即可

**包版本**：每次打包必须更新版本号，不能存在相同的版本号，[版本规范](https://learn.microsoft.com/zh-cn/nuget/concepts/package-versioning?tabs=semver20sort)，特定版本号的格式为 Major.Minor.Patch[-Suffix]，其中的组件具有以下含义：

- 主要：重大更改
- 次要：新增功能，但可向后兼容
- 补丁：仅可向后兼容的 bug 修复
- -Suffix（可选）：连字符后跟字符串，表示预发布版本（遵循语义化版本控制或 SemVer 约定）。

排序：

```text
1.0.1
1.0.1-zzz
1.0.1-rc.10
1.0.1-rc.2
1.0.1-open
1.0.1-beta
1.0.1-alpha2
1.0.1-alpha10
1.0.1-aaa
```

**作者、公司**：自定义

**产品**：默认

**说明**：包的简要说明

**发行说明**：更新日志

**许可证**：可选择许可证表达式、填写MIT


**二、打包**


右键项目->打包，输出窗口查看打包信息，打包文件默认在: `bin/Release/xxx.nuget`

**三、发布包**

在 `vs` 中打开 `powershell` 终端，使用命令发布，将 `NUGET-SERVER-API-KEY` 替换为自己的Key（若搭建的库中没配置key，不需要key），`package.1.0.0.nupkg` 替换为实际的包名（注意路径）

```bash
dotnet nuget push -s http://xxxx:8008/v3/index.json -k NUGET-SERVER-API-KEY package.1.0.0.nupkg

```

### 使用包

- 在VS工具栏：工具->Nuget 包管理器->程序包管理器设置，打开设置窗口
- 选择：程序包源标签
- 点击右上角的 **+**
  - 名称：自定义
  - 源：`http://xxxx:8008/v3/index.json` （警告要求使用 `https` 很烦，可通过 [反向代理服务器](../synology/反向代理服务器.md#反向代理服务器) 实现https访问）
  - 点击更新保存
- 使用时切换程序包源即可。



### 注意事项

- 需要在环境变量中配置 `ASPNETCORE_HTTP_PORT=8008` 或者在群晖的界面设置中更改,否则在运行命令中设置的端口无效

- 目前暂时无法使用 `https`，或者不方便使用

- 如果配置了 `ApiKey`， 发布包时要携带 `Key`

