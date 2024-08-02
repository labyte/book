# Npm

## 安装

通过安装 `Nodejs` 来一起安装

**Windows环境安装**：下载msi文件安装

- [Node.js官网地址(需要VPN)](https://nodejs.org/zh-cn)

- [Node.js中文网 有广告 但是都能下载](https://nodejs.org/zh-cn)
 
- [Npm Cli 手册](https://npm.nodejs.cn/cli/v10/commands/npm)


## 设置镜像源

国内使用 `npm` 非常慢，甚至就用不了，要么使用淘宝镜像，或者使用 `cnpm`

[博客文章](https://blog.csdn.net/weixin_45046532/article/details/139681731)



使用 淘宝 镜像

```shell
npm config set registry https://registry.npm.taobao.org/
```

使用 `cnpm`，‌这是淘宝提供的 `npm` 镜像，‌使用 `cnpm` 安装依赖通常会比使用 `npm` 快很多。‌例如，‌通过命令 `npm install -g cnpm --registry=https://registry.npm.taobao.org/` 来安装 `cnpm` ，‌然后使用 `cnpm install` 来安装包。‌

```shell
npm install -g cnpm --registry=https://registry.npm.taobao.org/
```

## 错误解决

### code CERT_HAS_EXPIRED

Npm 的证书过期，需要安装证书，可以创建自定义证书，但是比较麻烦，可以设置忽略证书

```shell
npm config set strict-ssl false
```

恢复证书


```shell
npm config set strict-ssl true
```