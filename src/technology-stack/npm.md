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



（一）使用 淘宝 镜像

```shell
npm config set registry https://registry.npm.taobao.org/
```

（二）使用 `cnpm`，‌这是淘宝提供的 `npm` 镜像，‌使用 `cnpm` 安装依赖通常会比使用 `npm` 快很多。‌安装cnpm命令 

```shell
npm install -g cnpm --registry=https://registry.npm.taobao.org/
``` 

使用 `cnpm install` 来安装包，如：

```shell
cnpm install xxxx
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

### 代理导致无法访问

错误信息：

```bash
 ECONNREFUSED
npm ERR! syscall connect
npm ERR! errno ECONNREFUSED
npm ERR! FetchError: request to https://registry.npmjs.org/create-tauri-app/-/create-tauri-app-3.10.0.tgz failed, reason: connect ECONNREFUSED 127.0.0.1:31181
npm ERR!     at ClientRequest.<anonymous> (C:\Program Files\nodejs\node_modules\npm\node_modules\minipass-fetch\lib\index.js:130:14)
npm ERR!     at ClientRequest.emit (node:events:512:28)
npm ERR!     at onerror (C:\Program Files\nodejs\node_modules\npm\node_modules\agent-base\dist\src\index.js:117:21)
npm ERR!     at callbackError (C:\Program Files\nodejs\node_modules\npm\node_modules\agent-base\dist\src\index.js:136:17)
npm ERR!     at process.processTicksAndRejections (node:internal/process/task_queues:95:5)
npm ERR!  FetchError: request to https://registry.npmjs.org/create-tauri-app/-/create-tauri-app-3.10.0.tgz failed, reason: connect ECONNREFUSED 127.0.0.1:31181
npm ERR!     at ClientRequest.<anonymous> (C:\Program Files\nodejs\node_modules\npm\node_modules\minipass-fetch\lib\index.js:130:14)
npm ERR!     at ClientRequest.emit (node:events:512:28)
npm ERR!     at onerror (C:\Program Files\nodejs\node_modules\npm\node_modules\agent-base\dist\src\index.js:117:21)
npm ERR!     at callbackError (C:\Program Files\nodejs\node_modules\npm\node_modules\agent-base\dist\src\index.js:136:17)
npm ERR!     at process.processTicksAndRejections (node:internal/process/task_queues:95:5) {
npm ERR!   code: 'ECONNREFUSED',
npm ERR!   errno: 'ECONNREFUSED',
npm ERR!   syscall: 'connect',
npm ERR!   address: '127.0.0.1',
npm ERR!   port: 31181,
npm ERR!   type: 'system'
npm ERR! }
npm ERR!
npm ERR! If you are behind a proxy, please make sure that the
npm ERR! 'proxy' config is set properly.  See: 'npm help config'

npm ERR! A complete log of this run can be found in:
npm ERR!     C:\Users\ABYTE\AppData\Local\npm-cache\_logs\2024-10-08T01_59_58_888Z-debug-0.log
```

**解决方案：**


该错误信息表明 NPM 在尝试下载 create-tauri-app 包时无法连接到 127.0.0.1:31181，导致 ECONNREFUSED 错误。这意味着你的机器拒绝了连接请求。常见的原因包括代理配置问题或网络连接问题。

以下是一些可能的解决方案：

1. 检查代理设置：如果你在公司网络或其他需要代理服务器的网络环境中，请确保 NPM 的代理配置正确。使用以下命令查看代理配置：

```bash
npm config get proxy
npm config get https-proxy
```

如果配置了代理，但网络环境不需要代理，可以通过以下命令禁用代理：


```bash
npm config delete proxy
npm config delete https-proxy
```

2. 清除 NPM 缓存：有时缓存可能会导致下载问题，可以尝试清除缓存：

```bash
npm cache clean --force
```

3. 检查是否运行了本地 NPM Registry

错误信息中的地址 127.0.0.1 是本地回环地址，通常表示 NPM 正在尝试连接到你本机上运行的服务。如果你之前配置了本地的 NPM Registry 服务，但该服务没有启动或者端口号不正确，你可能会遇到此问题。

检查本地配置：

```bash
npm config get registry
```

如果 registry 配置为 http://127.0.0.1:31181，但你并没有运行本地的 NPM Registry，改为默认的 NPM Registry：

```bash
npm config set registry https://registry.npmjs.org/
```

4. 检查网络连接

确保你可以正常访问外网，并且没有防火墙或其他网络安全设置阻止对 registry.npmjs.org 的访问。

通过命令行测试连接：

```bash
ping registry.npmjs.org
```

或者使用 curl 工具测试：

```bash
curl -I https://registry.npmjs.org/
```

5. 更新 NPM 版本

如果以上步骤无法解决问题，尝试更新 NPM 版本以修复潜在的 bug：

```bash
npm install -g npm
```

如果问题仍然存在，请告知你所处的网络环境和其他相关配置，我可以进一步帮助分析。