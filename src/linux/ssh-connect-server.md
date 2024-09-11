# SSH 连接服务器

## 连接步骤

在 **Windows** 上，首先安装 `OpenSSH`，然后使用 `PowerShell` 连接

假设服务器名称为：`SVRNAME`，域名为：`domain.com`，账户为：`zhangsan`，默认端口 **22** 开放


**一、连接服务器**

```bash
ssh zhangsan@domain.com -p 22
```

若端口为 `22` ，可不写，否则要指定端口

**二、若连接成功提示如下提示输入密码，输入的密码不会显示，输入完成后按回车键（若提示连接失败，检查域名和端口是否正确，可使用IP地址等尝试）**

```bash
zhangsan@domain.com's password:
```

**三、成功后进入当前账号的家目录（ `~`: 表示家目录，`$`：表示非 root 账号），登陆时都是非 root 账号类型**

```bash
zhangsan@SVRNAME:~$ 
```

此时可以查看当前家目录下的目录结构

```bash
zhangsan@SVRNAME:~$ ls
```


**四、切换到 `root` 账号 (只有具有管理员权限的才可以切换成功)**

```bash
zhangsan@SVRNAME:~$ sudo -i
```

**五、再次输入密码**

```bash
zhangsan@SVRNAME:~$ sudo -i
password:
```

**六、输入成功后，`zhangsan` 变为 `root`, `$` 变为 `#`**

```bash
root@SVRNAME:~# 
```

使用 `ls`，提示 `FOR SYSTEM USE ONLY. DO NOT UPLOAD FILES HERE.`，后面再详细讲解。

```bash
root@SVRNAME:~#  ls
```


**七、切换到根目录，任何时候都可以使用 `cd /` 切换到根目录**

```bash
root@SVRNAME:~# cd /
root@SVRNAME:/# 
```

**八、切换到家目录，任何时候都可以使用 `cd ~` 切换到家目录**

```bash
root@SVRNAME:/# cd /
root@SVRNAME:~# 
```


**九、退出登陆,如果是 root 登陆状态，那么将退出到 非root账号登陆状态，再次退出才能完全退出登陆**

```bash
exit
```



## 拓展

### 符号认知

- `~` : 表示当前登录用户的 home 目录

- `/` : 表示根节点

- `$` : 非 root 账户

- `#` : root 账户


### 根目录

根目录就是整个设备目录的最开始处，注意并不是某个存储盘的根，任何账户使用 `cd /`，都可进入根目录：

```bash
bin  boot  config  dev  etc  etc.defaults  initrd  lib  lib32  lib64  lost+found  mnt  opt  proc  root  run  sbin  sys  tmp  tmpRoot  usr  var  var.defaults  volume1  volume2
```

- `root` 是 root 账号的家目录，也就是 `~#` 对应的文件夹，此文件夹拒绝访问，可看到它也是属于根目录下的
- `volume1` 是 存储盘1
- `volume2` 是 存储盘2


- `/$` : 非 **root** 账户在根目录下，注意 `/$` 并不是连在一起的，如 `/lib$`  表示在根目录的 `lib` 文件夹下

- `/#` : **root** 账户在根目录下。



### 家目录

每个账户都有自己的 **home** 目录，它实际上也是对应了一个以根开始的目录，只是用 `~` 来代替根目录到 家文件夹这段路径，使用 `cd ~`，都可进入根目录：


如 `root` 的家目录

```text
~# 等价于 /root
```

如 `zhangsan` 的家目录

```text
~$ 等价于 /volume1/homes/zhangsan

注意：这里的家目录是设置在 volume1 存储盘上，其他可能不同
```


### 常用命令
- `sudo -i` 切换到 **root** 登陆
- `cd /` 进入根目录
- `cd ~` 进入家目录
- `cd ..` 进入上级目录
- `cd ../..` 进入上级的上级目录，依次...
- `exit` 退出登陆,如果是 **root** 登陆状态，那么将退出到 非 **root** 账号登陆状态，再次退出才能完全退出登陆
