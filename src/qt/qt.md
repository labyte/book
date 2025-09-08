# 发布可执行文件

在 `Qt Creator` 中，构建的exe 无法点击运行，需要打包

## 构建

1. 切换到 release (若无Release， 点击项目，添加Release),构建
2. 将 所有C++服务的Dll（如 `Services` 服务对应生成的为  `libServices.dll`） 和 主应用程序 `exe` 文件 拷贝到一个新文件夹下

## 发布

- 使用 `windeployqt6` 来部署，是安装 qt 的时候一起安装的，如： `D:\Qt\6.9.1\mingw_64\bin\windeployqt6.exe`
- `qmldir` : 指定项目中的qml资源目录，有多少个就配置多少个，用于打包使用到的资源
- `Minemusic.exe`  主程序exe

示例：

在新文件中运行命令行窗口，并允许以下命令

```shell

D:\Qt\6.9.1\mingw_64\bin\windeployqt6.exe --qmldir=F:\000-Labyte\Projects\mine-music\Config --qmldir=F:\000-Labyte\Projects\mine-music\Controls --qmldir=F:\000-Labyte\Projects\mine-music\Player Minemusic.exe
```
