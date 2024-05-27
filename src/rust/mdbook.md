# mdBook

> 将markdown 文件转换为html的工具

## 官方

- [仓库地址]([https://github.com/rust-lang/mdBook]())

- [官方文档]([https://rust-lang.github.io/mdBook/())


注意：国内有很多个人翻译的中文版本，时间比较久远，还是看官网的英文版本或者翻译为中文来查看。

## 页面中文显示

网页的工具栏等都是英文显示，在国内使用需要更改为中文。

### 设置网页为中文

在国内使用应该使用中文

- 在 `book.toml`中设置为中文 `language = "zh-CN"`，这仅仅是说明我们的网页使用的是中文

```C#
[book]
authors = ["LIXINGJUN"]
language = "zh-CN"
multilingual = false
src = "src"
title = "成都轨道学院培训楼使用指南"
description = "该文档仅用于成都轨道学院培训楼使用，禁止外传。"
```

### 设置工具栏为中文

- 工具栏默认提示为英文，如下图中的目录切换：

![1716796122067](image/mdbook/1716796122067.png)

- 这需要通过修改主题来实现，在默认创建的书中没有主题的配置，根据官网文档，通过执行命令 `mdbook init --theme` 来创建默认的主题文件，然后通过修改文件中内容来修改.
- 通过修改 ` index.hbs` 文件中的对应内容

![1716796153384](image/mdbook/1716796153384.png)

![1716796162203](image/mdbook/1716796162203.png)

![1716796171171](image/mdbook/1716796171171.png)

![1716796178418](image/mdbook/1716796178418.png)

## 支持中文搜索

**说明**： 默认不支持中文搜索，也就是在搜索框总输入中文，搜索不到结果，具体见社区： [Rust社区支持中文说明](https://rustcc.cn/article?id=fd75c670-4e8a-40be-855c-4a5ad1da350a)，总结以下的处理方式：

1. 安装指定插件


```shell
cargo install mdbook-mermaid
cargo install mdbook-plantuml
```

2. 本地创建 `assets`，在社区中指示的仓库下载指定的文件到 `assets`中
3. 配置 `book.toml`

  ```Toml
[output.html]
mathjax-support = true
additional-css = ["assets/mermaid.css", "assets/print.css", "assets/all-page.css"]
additional-js = ["assets/fzf.umd.js", "assets/elasticlunr.js", "assets/mermaid.min.js", "assets/import-html.js","assets/searcher.js"]
```

4.  配置成功案例 [https://gitee.com/shtzj/userguide.git](https://gitee.com/shtzj/userguide.git) 项目设置。

### 搜索结果描述的修改

如下图显示，我们搜索到内容后提示有多少个结果，默认是英文显示的，要改为中文，这里通过 ` index.hbs`无法修改，因为这个数据是动态显示的，在后端实现。

![1716796189226](image/mdbook/1716796189226.png)

通过在渲染输出中，通过字符串查找，在 `seracher.js` 文件中找到了响应的代码位置，简单的操作，就是每次我们只要将对应的地方改为中文即可，但是存在一个问题，每次构建都会覆盖改好的内容。

**原代码**

```JavaScript
    function formatSearchMetric(count, searchterm) {
        if (count == 1) {
            return count + " search result for '" + searchterm + "':";
        } else if (count == 0) {
            return "No search results for '" + searchterm + "'.";
        } else {
            return count + " search results for '" + searchterm + "':";
        }
    }
```

**希望的代码**

```JavaScript
    function formatSearchMetric(count, searchterm) {
        if (count == 1) {
            return count + " 个搜索结果 '" + searchterm + "':";
        } else if (count == 0) {
            return "无搜索结果 '" + searchterm + "'.";
        } else {
            return count + " 个搜索结果 '" + searchterm + "':";
        }
    }
```

**临时解决方式（不理想）**

1. 将 `seracher.js`  先改好，拷贝到 `assets `文件夹下；
2. 配置 ` book.toml` 文件，如下图增加 `searcher.js` 的引用

```Toml
[output.html]
mathjax-support = true
additional-css = ["assets/mermaid.css", "assets/print.css", "assets/all-page.css"]
additional-js = ["assets/fzf.umd.js", "assets/elasticlunr.js", "assets/mermaid.min.js", "assets/import-html.js","assets/searcher.js"]
```

3. 每次构建后，会在输出目录的assts下，创建 `searcher.js`文件，但是同时根目也有相同的文件，需要删除根目下的 `searcher.js` 文件，否则导致点击 搜索按钮无效。
