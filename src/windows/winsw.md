# WinSW

> Windows Service Wrapper in a permissive license
> 
> 在 Windows 中将普通程序作为服务安装，这样开机可自动运行，避免去添加任务计划

[github-仓库地址](https://github.com/winsw/winsw)


## 实例：安装Nginx服务


**普通使用模式**：运行 Nginx 后，直接闪过一个控制台窗口，在任务管理器中查看 **Nginx** 是否运行，电脑重启后需要手动去启动，有点不方便

**使用WinSW将Nginx安装为服务**：

1. 下载 Nginx并解压，假设解压后的路径为 `D:\nginx-1.25.4`
2. 下载 WinSW，下载后是一个 `WinSW-x64.exe` 文件，将其放到 `D:\nginx-1.25.4` 下，也就是和 `nginx.exe` 同层级
3. 将 `WinSW-x64.exe`  重命名为 `nginx-service.exe` 
4. 创建文件 `nginx-service.xml` 文件

```xml
<!-- nginx-service.xml -->
<service>
    <id>nginx</id>
    <name>nginx</name>
    <description>nginx</description>
    <logpath>logs</logpath>
    <logmode>roll</logmode>
    <depend></depend>
    <executable>nginx.exe</executable>
	<arguments>--service</arguments>
</service>
```
    - id: 服务id，假设启动了多个 nginx ，这里需要填一个唯一的
    - name: 服务名称
    - description：服务描述
    - logpath：日志保存的文件夹，当前目录的logs文件夹下，这里不要填绝对路径，否则文件移动后就不对了
    - logmode：日志模式，滚动
    - executable：服务安装的二进制文件，这里不要填绝对路径，否则文件移动后就不对了
    - arguments：服务启动时，命令行参数：如果有需要就填，这里没有需要可以不填

5. 以管理员身份运行 `PowerShell`
6. 将目录切换到 `nginx.exe` 相同的目录
   1. 执行语句 `nginx-service.exe install` 进行服务安装，名称为：`nginx`，可通过 `logs/nginx-service.wrapper.log` 查看日志信息
   2. 执行语句 `nginx-service.exe start` 启动服务
   3. 执行语句 `nginx-service.exe stop` 停止服务
   4.  执行语句 `nginx-service.exe restart` 重启服务
   5. 执行语句 `nginx-service.exe uninstall` 卸载服务
7. 打开服务窗口里面同样可以进行相关的操作



## 服务模式下不要操作窗口句柄

控制台程序中不要使用和界面相关的接口，如下面这段代码将会出现获取句柄为空的错误

```c#
 [DllImport("user32.dll ", EntryPoint = "RemoveMenu")]
 extern static int RemoveMenu(IntPtr hMenu, int nPos, int flags);

 private static void SetWinStyle()
 {

    /* 设置窗口样式 */

    Console.WindowWidth = 120;
    Console.BufferWidth = 220;//240 为最大值 保证可以换行
    Console.BufferHeight = 1000;

    Console.Title = title;
    //与控制台标题名一样的路径
    //  string fullPath = System.Environment.CurrentDirectory + "\\" + title + ".exe";

#if !DEBUG
    //根据控制台标题找控制台
    int WINDOW_HANDLER = FindWindow(null, Console.Title);
    Thread.Sleep(100);
    //找关闭按钮
    IntPtr CLOSE_MENU = GetSystemMenu((IntPtr)WINDOW_HANDLER, IntPtr.Zero);
    int SC_CLOSE = 0xF060;
    //关闭按钮禁用
    RemoveMenu(CLOSE_MENU, SC_CLOSE, 0x0);
#endif
    Console.CancelKeyPress += new ConsoleCancelEventHandler(CloseConsole);
}
```

**解决方案**：

这里就要用到命令行参数，在 `xxx-service.xml` 文件中添加一个参数 `<arguments>--service</arguments>` ，如果多个参数空格隔开

当使用服务启动时，命令行参数中将包含： `--service` 参数

```c#
  //这里根据命令行参数来判断是否为服务模式启动，服务模式下不能设置窗口样式

  bool isServiceMode = args.Contains("--service");
  if (!isServiceMode)//非服务下，设置窗口样式
  {
      SetWinStyle(); 
  }
```