# Windows

## 安装

**官网下载**

[官网](https://www.microsoft.com/zh-cn/software-download/windows10) 可以更新当前系统，以及通过下载工具下载系统制作成 U盘 或者 下载IOS文件


当下载工具后运行，可选择(win10和win11相同操作):

- **U盘**：制作U盘
- **IOS文件**：保存文件


**其他下载**

- [知乎文档](https://www.zhihu.com/search?type=content&q=windows%20%E5%8E%9F%E7%89%88%E4%B8%8B%E8%BD%BD)
  
- [山己几子木 下载](https://msdn.sjjzm.com/win10.html)
- [HelloWindwos 下载](https://www.hellowindows.cn/)
- [xitongku 下载](https://link.zhihu.com/?target=https%3A//www.xitongku.com/)


**- 最好使用原版的安装文件，不要使用各种PE自带的系统，如韩博士的在线安装会自带很多垃圾软件、垃圾游戏、垃圾广告**



## 设置共享

选择要共享的文件夹，打开属性，共享标签，设置为共享

设置可以访问的账户，如果希望无密码共享，选择Everyone，并设置权限为完全控制

设置网络控制中心，启用文件共享，设置所有网络无密码



## 磁盘管理

进行分区等操作

右键 `WIN` 图标或者按下 `win+x` -> 磁盘管理


## 删除时找不到该项目

使用 `bat` 文件处理

- 新建 `bat` 文件，内容：

```bat
:: 将要处理的文件或者文件夹拖到此命令文件上
DEL /F /A /Q \\?\%1
RD /S /Q \\?\%1
```



参考：[知乎文档](https://zhuanlan.zhihu.com/p/577237417?utm_id=0)