# 创建自定义包

✨ [官网：创建自定义包](https://docs.unity.cn/cn/current/Manual/CustomPackages.html)

文章参看：

- [简书：【教程】开发Unity PackageManager 插件包](https://www.jianshu.com/p/153841d65846)
- [简书：Unity:使用Package Manager开发和管理自定义插件](https://www.jianshu.com/p/6e5e2947df31)
- [使用OpenUPM发布自己的Unity项目]( https://yomunchan.moe/Post/582)

## 创建包

- 创建一个空项目
- 方式一：根据官网规则，手动创建相应的文档结构
- 方式二：使用 `Package Development` 插件来创建包（Unity 2019.4 版本后，此包都没出现了）
  -  通过地址：`com.unity.upm.develop` 导入开发扩展包
  -  点击 “+” ->"Create Package" ，输入包名，点击“Add”，在Packages文件夹下，创建对应包名的文件夹，说白了，这里的包就是按照一定规范创建了文件夹和文件
  -  创建后是在 `Packages` 目录下
  -  注意：作者名是你登录Unity的名称,显示得有点奇怪，自行修改文件夹名、类命名空间、包id信息等
  -  个人发现无法编写示例（因为不在Assets下）【有可能没找对方法】，解决方法是把整个包移动到 Assets下操作


## 使用Git存储

- 整个包的源码放在主分支上
- 将包目录下的分割推送到指定分支
- 给分支创建标签来管理包，便于包的版本管理
- 在Unity中通过引入git url 地址来获取包


 **文件结构**：
- 包文件放在Assets目录下，进行开发，里面的设置还是包的规范要求
- 开发完成后通过命令上传包，以及打版本


**一、** ⚠️先更新 package.json 文件 中的版本信息

**一、** ⚠️先更新 package.json 文件 中的版本信息

**一、** ⚠️先更新 package.json 文件 中的版本信息

```json
"version": "0.1.0",
```

**二、** 更新 CHANGELOG （日志）

```md
# 更新日志
All notable changes to this package will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2024-11-14

### This is the first release of *\<Cwss.Shared\>*.

*Short description of this release*

```

**三、** 提交到主分支

```bash
git add * 
```

**四、** 提交信息

```bash
git commit -m'提交信息' 
```


**五、** 推送到主分支

```bash
git push 
```


**六、** 分离到分支 `Assets/UKit` 和 `unp` 根据实际情况修改

```bash
git subtree split --prefix=Assets/UKit --branch upm 
```

**七、** 打标签和package.json版本一致

```bash
git tag 1.0.0 upm 
```


**八、** 推送标签

```bash
git push origin upm --tags 
```


 **注意：** 

- 不要使用其他命令或者方式创建分支
- master分支作为开发分支，其他分支作为版本分支

## git 扩展

 **删除本地标签** 

```
git tag -l #列出本地标签
git tag -d 0.1.0 # 删除 0.1.0 标签，其他标签同理（一个一个的删除）
```
 **删除远程标签** 

假设我们在仓库中有一个名为 prod1.0 的远程标签。我们可以使用带有 --delete 选项的 git push 命令删除远程标签。

```
$ git push --delete origin prod1.0

To https://github.com/myrepos/prod.git
 - [deleted]         prod1.0
```

有时，我们可能有一个与分支同名的标签。在这种情况下，我们需要使用带有 refs 语法的 git push 命令而不是 --delete 选项，如下所示。

```
$ git push origin :refs/tags/prod1.0

To https://github.com/myrepos/prod.git
 - [deleted]         prod1.0
```

删除分支：https://www.php.cn/tool/git/493215.html


