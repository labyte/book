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

## 项目中常用的命令

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
                <td>不编译直接运行</td>
            </tr>
             <tr>
                <td>检查项目<br><br><code>cargo check</code></td>
                <td>此命令可以快速检查您的代码，以确保它可以编译但不会产生可执行文件</td>
            </tr>
        </tbody>
    </table>
</div>

## 问题汇总

### 构建的GUI程序，运行时会出现控制台窗口

当使用 `iced` 来构建GUI程序，启动时出现控制台窗口，可以在`main.rs`文件的顶部添加以下代码来去除该控制台窗口：

```
#![windows_subsystem = "windows"]
```