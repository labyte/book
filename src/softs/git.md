# Git

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


### 快速解决

使用终端执行命令：

```sh
git config pull.rebase false
```

再执行拉取命令
```sh
git config pull
```

如果进入 **Vim** 编辑模式，如提示我们编写 commit，修改合并后的冲突文件等，请参照 [Vim](vim.md) 操作

### 详细说明


以下是提示中提到的解决方案，在命令行终端工具中：

**合并（merge）**：合并本地和远程分支的更改。命令如下：

```sh
git config pull.rebase false
```

**重置（rebase）**：将本地分支的更改在远程分支的基础上重新应用。命令如下：

```sh
git config pull.rebase true
```

**仅快速合并（fast-forward only）**：只有在没有分歧时才进行合并。命令如下：

```sh
git config pull.ff only
```

你可以选择一种方法，配置为默认值。如果你希望对所有仓库都应用这种默认配置，可以使用 --global 选项。比如，要在所有仓库中使用合并策略，可以运行以下命令：

```sh
git config --global pull.rebase false
```

如果你只想在当前仓库中应用该策略，不使用 --global 选项：

```sh
git config pull.rebase false
```

或者，你也可以在每次拉取时指定方法。比如，要使用合并，可以运行：

```sh
git pull --no-rebase
```

要使用重置，可以运行：

```sh
git pull --rebase
```

要仅快速合并，可以运行：

```sh
git pull --ff-only
```

根据你的需求选择合适的方法，并配置 Git 即可解决这个问题。