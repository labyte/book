# Git

## 退出代理导致连接失败

环境：macbook

现象：使用代理后，退出代理，出现无法连接仓库地址（浏览器正常），github 和 gitee都无法连接。

错误信息：

```
fatal: unable to access 'https://github.com/benjieqiang/programmer.git/': Failed to connect to 127.0.0.1 port 7890: Connection refused
```

解决方案：

查看代理
git config --global --get http.proxy
git config --global --get https.proxy

取消代理
git config --global --unset http.proxy
git config --global --unset https.proxy

## 推送失败

```
error: RPC failed; HTTP 400 curl 22 The requested URL returned error: 400
```

推送时出现以下错误提示

```bash

Enumerating objects: 22, done.
Counting objects: 100% (22/22), done.
Delta compression using up to 10 threads
Compressing objects: 100% (16/16), done.
Writing objects: 100% (16/16), 1019.20 KiB | 33.97 MiB/s, done.
Total 16 (delta 9), reused 0 (delta 0), pack-reused 0
error: RPC failed; HTTP 400 curl 22 The requested URL returned error: 400
send-pack: unexpected disconnect while reading sideband packet
fatal: the remote end hung up unexpectedly
Everything up-to-date

```

缓存区太小的原因：

设置为5大小
```bash
git config --global http.postBuffer 5242880000
```

## 在拉取中提示版本冲突

当在终端或者在VS中拉取时，提示版本冲突，此时都要回到终端来进行处理

当版本冲突时，会输出以下内容

```bash
Hint: You have divergent branches and need to specify how to reconcile them.
Hint: You can do so by running one of the following commands sometime before
Hint: your next pull:
Hint: 
Hint:   git config pull.rebase false  # merge
Hint:   git config pull.rebase true   # rebase
Hint:   git config pull.ff only       # fast-forward only
Hint: 
Hint: You can replace "git config" with "git config --global" to set a default
Hint: preference for all repositories. You can also pass --rebase, --no-rebase,
Hint: or --ff-only on the command line to override the configured default per
Hint: invocation.
```

输出的内容给出解决方案，以下作为一个中文说明

这个错误提示是因为你的本地分支和远程分支之间有分歧（divergent branches），Git 需要你指定如何处理这些分歧。在拉取（pull）代码时，Git 既可以通过合并（merge）来解决分歧，也可以通过重置（rebase）来解决分歧。


快速解决

使用终端执行命令：

```sh
git config pull.rebase false
```

再执行拉取命令
```sh
git config pull
```

如果进入 **Vim** 编辑模式，如提示我们编写 commit，修改合并后的冲突文件等，请参照 [Vim](vim.md) 操作
