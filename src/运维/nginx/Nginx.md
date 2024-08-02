# Nginx 


## 配置证书

- 配置文件：这里的7130需要在路由器上配置映射到主机，并且要重启，然后更改防火墙设置，开发7130的进出规则

![](image/image_xsZ7NwaAq2.png)

- **证书的路径**：相对于配置文件的，这里的cert文件夹就是和配置文件同目录的，当然可以放在外边去；
- 重启生效。


## 命令行重启（勿用）

**Windows**:

> ❌不知道什么原因，使用命令行来进行重启，要么，就是启动了多个进程，要么就是关掉了进程没重启。
>
> 老老实实在任务管理器中 结束任务，再重启比较靠谱 


``` 重启
chcp 65001 > nul
@echo off
cd /d %~dp0

nginx -s reload

echo Nginx 已重启
pause

```

关闭（有效）

```shell
@echo off
cd C:/TSIM/nginx-1.25.4
nginx -s stop
timeout /t 2 /nobreak >nul
pause

```