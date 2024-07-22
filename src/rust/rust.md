<style>
.table-container {
    display: flex;
    justify-content: center;
    width: 100%;
}

.excel-table {
    width: 100%;
    border-collapse: collapse;
    font-family: Arial, sans-serif;
    font-size: 15px; /* 设置字体大小 */
    table-layout: fixed; /* 固定表格布局 */
}

.excel-table th, .excel-table td {
    border: 1px solid #d0d7de;
    padding: 12px;
    text-align: left;
    vertical-align: top; 
}

.excel-table th {
    background-color: #f0f3f5;
    font-weight: bold;
}

.excel-table tr:nth-child(even), table tr:nth-child(odd) {
    background-color: transparent; /* 确保所有行背景色一致 */
}

.excel-table tr:hover {
    background-color: inherit;
}

.excel-table tr:hover {
    background-color: #e9e9e9;
}
.excel-table th:nth-child(1), .excel-table td:nth-child(1) {
    width:200px;
}

.excel-table th:nth-child(2), .excel-table td:nth-child(2) {
    width: 100%;
}

</style>

# Rust

## 安装

[Rust 编程语言](https://doc.rust-lang.org/book/ch01-01-installation.html)

**Windows上安装**

下载安装文件进行安装：[rustup-init.exe](https://static.rust-lang.org/rustup/dist/x86_64-pc-windows-msvc/rustup-init.exe)


**Linux Mac上安装**

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

## 更新和卸载
通过 安装 Rust 后rustup，更新到新发布的版本就很容易了。从 shell 运行以下更新脚本：

```
rustup update
```

要卸载 Rust 和rustup，请从 shell 运行以下卸载脚本：

```
rustup self uninstall
```

## Cargo

[Cargo Book](https://doc.rust-lang.org/stable/cargo/index.html)

### 常用命令

注意命令全是小写，错误示范：Cargo run hello❌

<div class="table-container">
    <table class="excel-table">
        <thead>
            <tr>
                <th>功能/命令</th>
                <th>说明</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>创建项目<br><br><code>cargo new hello_cargo</code></td>
                <td>创建项目</td>
            </tr>
             <tr>
                <td>构建项目<br><br><code>cargo build --release</code></td>
                <td>此命令在`target/debug/hello_cargo（或 Windows 上的target\debug\hello_cargo.exe ）`中创建一个可执行文件，而不是在当前目录中。由于默认构建是调试构建，因此 Cargo 将二进制文件放在名为debug的目录中。</td>
            </tr>
              <tr>
                <td>构建发布<br><br><code>cargo build</code></td>
                <td>当您的项目最终准备好发布时，您可以使用cargo build --release优化来编译它。此命令将在target/release而不是target/debug中创建可执行文件。</td>
            </tr>
              <tr>
                <td>运行项目<br><br><code>cargo run</code></td>
                <td>编译和运行一键执行
                </td>
            </tr>
             <tr>
                <td>检查项目<br><br><code>cargo check</code></td>
                <td>此命令可以快速检查您的代码，以确保它可以编译但不会产生可执行文件</td>
            </tr>
            <tr>
                <td>测试<br><br><code>cargo test</code></td>
                <td>测试</td>
            </tr>
        </tbody>
    </table>
</div>

### 配置子项目在父项目中运行

通过配置工作区来实现，[官方文档](https://doc.rust-lang.org/cargo/reference/workspaces.html)

首先创建父级项目：

``` 
cargo new rust_examples
```

然后在 rust_examples 下创建 hello 等其他一系列子项目，

切换到 rust_examples
```
cd rust_examples

```

创建hello
```
cargo new hello
```

项目目录结构如下：

![1721616093714](image/rust/1721616093714.png)

**配置方式：**

首先在 rust_examples 项目的 Cargo.toml 文件中配置 `workspace` 工作区成员，

```toml
[package]
name = "rust_examples"
version = "0.1.0"
edition = "2021"

[workspace]
members = [
    "hello"
]
[dependencies]
```

运行hello项目：

```
cargo run --package hello
```

其他命令如 `build` 均可以用，但是构建的文件在 rust_examples 的 target文件夹下。

## 问题汇总

### Cargo config deprecated

当构建或者运行时，显示警告：

```
warning: `C:\Users\ABYTE\.cargo\config` is deprecated in favor of `config.toml`
note: if you need to support cargo 1.38 or earlier, you can symlink `config` to `config.toml`
```

### 构建的GUI程序，运行时会出现控制台窗口

当使用 `iced` 来构建GUI程序，启动时出现控制台窗口，可以在`main.rs`文件的顶部添加以下代码来去除该控制台窗口：

```
#![windows_subsystem = "windows"]
```


## 国内源

[子节跳动镜像](https://rsproxy.cn)


