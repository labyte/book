<style>
.table-container {
    display: flex;
    justify-content: center;
    width: 100%;
}

.excel-table ,.excel-table-c2 {
    width: 100%;
    border-collapse: collapse;
    font-family: Arial, sans-serif;
    font-size: 15px; /* 设置字体大小 */
    table-layout: fixed; /* 固定表格布局 */
}

.excel-table th,.excel-table-c2 th, .excel-table td,.excel-table-c2 td {
    border: 1px solid #d0d7de;
    padding: 12px;
    text-align: left;
    vertical-align: top; 
}

.excel-table th,.excel-table-c2 th  {
    background-color: #f0f3f5;
    font-weight: bold;
}

.excel-table tr:nth-child(even),.excel-table-c2 tr:nth-child(even) {
    background-color: #f9f9f9;
}

/* .excel-table tr:hover {
    background-color: #e9e9e9;
} */

.excel-table th:nth-child(1), .excel-table td:nth-child(1) {
    width: 20%;
    font-weight: bold;
}

.excel-table th:nth-child(2), .excel-table td:nth-child(2) {
    width: 40%;
}
.excel-table th:nth-child(3), .excel-table td:nth-child(3) {
    width: 40%;
}

/*c2*/
.excel-table-c2 th:nth-child(1), .excel-table-c2 td:nth-child(1) {
    width: 50%;
    /* font-weight: bold; */
}

.excel-table-c2 th:nth-child(2), .excel-tablec-2 td:nth-child(2) {
    width: 50%;
}

</style>

# 批处理文件

[官网](https://learn.microsoft.com/zh-cn/windows-server/administration/windows-commands/cd)

## 命令行语法项

下表描述用于指示命令行语法的表示法。

<div class="table-container">
    <table class="excel-table-c2">
        <thead>
            <tr>
                <th>表示法</th>
                <th>说明</th>   
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>不含方括号或大括号的文本</td>
                <td>必须按所显示键入的项。</td>
            </tr>
              <tr>
                <td><code><Text inside angle brackets></code></td>
                <td>必须为其提供值的占位符。</td>
            </tr>
             <tr>
                <td><code>[Text inside square brackets]</code></td>
                <td>可选项。</td>
            </tr>
            <tr>
                <td><code>{Text inside braces}</code></td>
                <td>一组必需的项。 你必须选择一个。</td>
            </tr>
             <tr>
                <td>竖线 (|</code>)</td>
                <td>互斥项的分隔符。 你必须选择一个。</td>
            </tr>
             <tr>
                <td>省略号 (…)</td>
                <td>可重复使用多次的项。</td>
            </tr>
        </tbody>
    </table>
</div>

## 创建批处理文件

在Windows中，批处理文件以 `.bat`为扩展名。

创建一个名为 `hello.bat`的文件，并输入以下内容：

```bat
echo Hello, World!
pause
```

保存文件后，双击该文件即可运行。

## 执行批处理文件

执行一个批处理文件，可以通过双击运行，也可以右键以管理员身份运行，但他们有区别。

<div class="table-container">
    <table class="excel-table">
        <thead>
            <tr>
                <th>区别项目</th>
                <th>双击运行</th>
                <th>管理员运行</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>执行目录</td>
                <td>工作目录是该<code>.bat</code>文件所在的目录</td>
                <td>工作目录是 <code>C:\Windows\System32</code>，这容易导致某些文件路径错误，解决办法，添加以下代码：<br>
                    <code>@echo off<br>cd /d %~dp0 </code>
                </td>
            </tr>
              <tr>
                <td>权限</td>
                <td>以当前用户的权限运行，如果当前用户没有管理员权限，某些操作（如修改系统文件、注册表、安装软件等）可能会失败</td>
                <td>以管理员权限运行。能够执行需要提升权限的操作</td>
            </tr>
             <tr>
                <td>环境变量</td>
                <td>使用当前用户的环境变量，有些环境变量仅加入到了系统环境变量中，可能无法访问</td>
                <td>使用系统管理员的环境变量，这可能会导致一些变量（如用户目录等）不同</td>
            </tr>
            <tr>
                <td>用户账户控制（UAC）</td>
                <td>不会触发 UAC 提示</td>
                <td>会触发 UAC 提示，要求用户确认提升权限。这是为了确保用户有意图执行管理员级别的操作。</td>
            </tr>
             <tr>
                <td>安装路径和访问权限</td>
                <td>对用户目录（如 C:\Users\Username）有完全访问权限，但对系统目录（如 C:\Windows、C:\Program Files）的访问可能受限。</td>
                <td>对所有目录都有完全访问权限，包括系统目录。</td>
            </tr>
             <tr>
                <td>操作系统保护机制</td>
                <td>受操作系统保护机制的约束较多，不能执行某些系统级操作。</td>
                <td>如果脚本涉及到计划任务，可能需要管理员权限来创建或修改计划任务。</td>
            </tr>
        </tbody>
    </table>
</div>

双击 `hello.bat`文件后，会弹出一个命令行窗口，显示 `Hello, World!`，然后等待用户按下任意键后关闭窗口。

## 中文编码

在文件中加入

```bat
chcp 65001 > nul
```

备注：`>nul` ：表示将输入重定向到空设备，也就是不输出这条命令的操作信息，此处如果不加会输出一条消息：`Active code page:6 5001`，

## 参考

### call（调用批处理程序）

从另一个批处理程序调用一个批处理程序，而不停止父批处理程序。 call 命令接受标签作为调用的目标。

若要从另一个批处理程序运行 checknew.bat 程序，请在父批处理程序中键入以下命令：

```shell
call checknew
```

如果父批处理程序接受两个批处理参数，并且你希望它将这些参数传递给 checknew.bat，请在父批处理程序中键入以下命令：

```
call checknew %1 %2
```

### cd（同chdir：显示或更改当前目录）

显示当前目录的名称或更改当前目录。 如果仅与驱动器号一起使用（例如，`cd C:`），cd 将显示指定驱动器中当前目录的名称。 如果使用时不带参数，cd 将显示当前驱动器和目录。

语法：

```shell
cd [/d] [<drive>:][<path>]
cd [..]
chdir [/d] [<drive>:][<path>]
chdir [..]
```

参数

<div class="table-container">
    <table class="excel-table">
        <thead>
            <tr>
                <th>参数</th>
                <th>说明</th>   
            </tr>
        </thead>
        <tbody>  
              <tr>
                <td><code>/d</code></td>
                <td>更改当前驱动器以及驱动器的当前目录。</td>
            </tr>
             <tr>
                <td><code><drive>:</code></td>
                <td>指定要显示或更改的驱动器（如果与当前驱动器不同）。</td>
            </tr>
            <tr>
                <td><code><<path>></code></td>
                <td>指定要显示或更改的目录的路径。</td>
            </tr>
            <tr>
                <td><code>[..]</code></td>
                <td>指定要更改为父文件夹。</td>
            </tr>
             <tr>
                <td><code>/?</code></td>
                <td>在命令提示符下显示帮助。</td>
            </tr>  
        </tbody>
    </table>
</div>

**注解**

如果启用了命令扩展，则以下条件适用于 cd 命令：

* 当前目录字符串将转换为使用与磁盘上的名称相同的大小写。 例如，`cd c:\temp` 会将当前目录设置为 C:\Temp（如果磁盘上是这种大小写）。
* 系统不会将空格视为分隔符，因此 `<path>` 可以包含不带引号的空格。 例如：
  复制

  ```
  cd username\programs\start menu
  ```

  相当于：

  复制

  ```
  cd "username\programs\start menu"
  ```

  如果禁用扩展，则需要引号。
* 若要禁用命令扩展，请键入：
  复制

  ```
  cmd /e:off
  ```

**示例**

要返回到根目录，即驱动器的目录层次结构顶层：

```
cd\
```

要更改与你当前所在驱动器不同的驱动器上的默认目录，请输入以下命令：

```
cd [<drive>:[<directory>]]
```

若要验证对目录的更改，请键入：

```
cd [<drive>:]
```

### chcp（设置语言）

设置代码页和语言

| 代码页 | 国家/地区或语言   |
| ------ | ----------------- |
| 437    | 美国              |
| 850    | 多语言 (拉丁文我) |
| 852    | 西里尔语 （俄语） |
| 855    | 西里尔语 （俄语） |
| 857    | 土耳其语          |
| 860    | 葡萄牙语          |
| 861    | 冰岛语            |
| 863    | 加拿大法语        |
| 865    | 北欧              |
| 866    | 俄语              |
| 869    | 现代希腊语        |
| 936    | 中文（gbk）       |
| 65001  | utf-8             |

若要查看活动的代码页设置，请键入︰

```
chcp
```

将显示类似于以下内容的消息：`Active code page: 437`

若要将活动代码页更改为 936（中文），请键入：

```
chcp 936
```

如果指定的代码页无效，将显示以下错误消息：`Invalid code page`

### clean（删除分区）

从获得焦点的磁盘中删除所有分区或卷格式设置。

不要轻易使用

### cls（清除命令窗口）

清除命令提示符窗口。

若要清除命令提示符窗口中显示的所有信息并返回到空白窗口，请键入：

```
cls
```

### cmd

启动命令解释器的新实例 Cmd.exe。 使用时如果没有参数，cmd 将显示操作系统的版本和版权信息。

### copy（复制）

将一个或多个文件从一个位置复制到另一个位置。

[copy 文档](https://learn.microsoft.com/zh-cn/windows-server/administration/windows-commands/copy)

 若要将名为 memo.doc 的文件复制到当前驱动器中的 letter.doc，并确保文件结束字符 (CTRL+Z) 位于复制的文件的末尾，请键入：

```
copy memo.doc letter.doc /a
```

 若要将名为 robin.typ 的文件从当前驱动器和目录复制到驱动器 C 上名为 Birds 的现有目录，请键入：

```
copy robin.typ c:\birds
```

> 备注
>
> 如果 Birds 目录不存在，则会将文件 robin.typ 复制到名为 Birds 的文件中，该文件位于磁盘驱动器 C 上的根目录中。

 若要合并当前目录中的 Mar89.rpt、Apr89.rpt 和 May89.rpt，并将其放入名为 Report 的文件（也在当前目录中），请键入：

```
copy mar89.rpt + apr89.rpt + may89.rpt Report
```

> 备注
>
> 如果合并文件，copy 命令会使用当前日期和时间标记目标文件。 如果省略 destination，将使用列表中第一个文件的名称合并和存储文件。

 若要合并 Report 中的所有文件，当名为 Report 的文件已存在时，请键入：

```
copy report + mar89.rpt + apr89.rpt + may89.rpt
```

 若要将当前目录中所有文件扩展名为 .txt 的文件合并到名为 Combined.doc 的单个文件，请键入：

```
copy *.txt Combined.doc
```

 若要使用通配符将多个二进制文件合并为一个文件，请包含 /b。 这可以防止 Windows 将 CTRL+Z 视为文件结束字符。 例如，键入：

```
copy /b *.exe Combined.exe
```

> 注意
>
> 如果合并二进制文件，生成的文件可能因内部格式问题而无法使用。

* 将扩展名为 .txt 的每个文件与其相应 .ref 文件合并会创建文件名相同，但扩展名为 .doc 的文件。 Copy 命令将 file1.txt 与 file1.ref 合并成 file1.doc，然后该命令将 file2.txt 与 file2.ref 合并成 file2.doc，依此类推。 例如，键入：

```
copy *.txt + *.ref *.doc
```

 若要合并扩展名为 .txt 的所有文件，然后将扩展名为 .ref 的所有文件合并为一个名为 Combined.doc 的文件，请键入：

```shell
copy *.txt + *.ref Combined.doc
```

### create（创建分区）

创建分区命令

### del（删除文件）

删除一个或多个文件。 此命令执行与 erase 命令相同的操作。

 del 命令还可以使用不同参数从 Windows 恢复控制台运行。 有关详细信息，请参阅 [Windows 恢复环境 (WinRE)](https://learn.microsoft.com/zh-cn/windows-hardware/manufacture/desktop/windows-recovery-environment--windows-re--technical-reference)。

> 警告
>
> 如果使用 del 从磁盘中删除某个文件，则无法检索该文件。

要删除驱动器 C 上名为 test 的文件夹中的所有文件，请键入以下任一命令：

```
del c:\test
del c:\test\*.*
```

若要删除文件夹中名称中包含空格的所有文件，需要用双引号将完整路径括起来。 键入以下任一命令：

```
del "c:\test folder\"
del "c:\test folder\*.*"
```

要从当前目录中删除文件扩展名为 .bat 的所有文件，请键入：

```
del *.bat
```

要删除当前目录中的所有只读文件，请键入：

```
del /a:r *.*
```

### delete（删除分区）

删除分区或卷。 此命令还会从磁盘列表中删除动态磁盘。

### dir（显示目录）

显示目录的文件和子目录的列表。 如果使用此命令时不带参数，则将显示磁盘的卷标和序列号，后跟磁盘上的目录和文件列表（包括其名称以及上次修改每个目录和文件的日期和时间）。 对于文件，此命令显示扩展名和大小（以字节为单位）。 此命令还显示列出的文件和目录总数、其累积大小以及磁盘上剩余的可用空间（以字节为单位）。

dir 命令还可以使用不同参数从 Windows 恢复控制台运行。 有关详细信息，请参阅 [Windows 恢复环境 (WinRE)](https://learn.microsoft.com/zh-cn/windows-hardware/manufacture/desktop/windows-recovery-environment--windows-re--technical-reference)。

#### 语法

```
dir [<drive>:][<path>][<filename>] [...] [/p] [/q] [/w] [/d] [/a[[:]<attributes>]][/o[[:]<sortorder>]] [/t[[:]<timefield>]] [/s] [/b] [/l] [/n] [/x] [/c] [/4] [/r]
```

#### 参数

| 参数                    | 说明                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| ----------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `[<drive>:][<path>]`  | 指定要查看其列表的驱动器和目录。                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| `[<filename>]`        | 指定要查看其列表的特定文件或文件组。                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| /p                      | 一次显示一个列表屏幕。 要查看下一个屏幕，请按任意键。                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| /q                      | 显示文件所有权信息。                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| /w                      | 以宽格式显示列表，每行最多包含五个文件名或目录名称。                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| /d                      | 以与 /w 相同的格式显示列表，但文件按列排序。                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| /a[[:]`<attributes>`] | 仅显示具有指定属性的目录和文件的名称。 如果不使用此参数，此命令将显示除隐藏文件和系统文件之外的所有文件的名称。 如果在未指定任何属性的情况下使用此参数，则此命令将显示所有文件的名称，包括隐藏文件和系统文件。 可能的属性值列表包括：* d - 目录* h - 隐藏文件* s - 系统文件* l - 重新分析点* r - 只读文件* a - 可用于存档的文件* i - 非内容索引文件你可以使用这些值的任意组合，但不要使用空格分隔值。 （可选）可以使用冒号 (:) 分隔符，或者你可以使用连字符 (-) 作为前缀来表示“非”。 例如，使用 -s 属性不会显示系统文件。 |
| /o[[:]`<sortorder>`]  | 根据 sortorder 对输出进行排序，可以是以下值的任意组合：* n - 按名称字母顺序排列* e - 按扩展名字母顺序排列* g - 首先列出组目录* s - 按大小，最先列出最小的文件* d - 按日期/时间，最先列出最早的文件* 使用**-** 前缀可反转排序顺序多个值将按照你列出它们的顺序进行处理。 不要用空格分隔多个值，但可以选择使用冒号 (:)。如果未指定 sortorder，则 dir /o 将按字母顺序列出目录，后跟文件，这些文件也按字母顺序排序。                                                                                                             |
| /t[[:]`<timefield>`]  | 指定要显示或用于排序的时间字段。 timefield 的可用值包括：* c - 创建时间* a - 上次访问时间* w - 最后写入时间                                                                                                                                                                                                                                                                                                                                                                                                                 |
| /s                      | 列出指定目录和所有子目录中出现的指定文件名的每个匹配项。                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| /b                      | 显示纯粹的目录和文件列表，不含其他信息。 /b 参数将覆盖 /w。                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| /l                      | 使用小写显示未排序的目录名称和文件名。                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| /n                      | 在屏幕最右侧显示带有文件名的长列表格式。                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| /x                      | 显示为非 8dot3 文件名生成的短名称。 显示内容与 /n 的显示内容相同，但短名称插入到长名称之前。                                                                                                                                                                                                                                                                                                                                                                                                                                |
| /c                      | 以千位分隔符显示文件大小。 此选项为默认行为。 使用 /-c 隐藏分隔符。                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| /4                      | 以四位数格式显示年份。                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| /r                      | 显示文件的备用数据流。                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| /?                      | 在命令提示符下显示帮助。                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |

#### 注解

* 若要使用多个 filename 参数，请用空格、逗号或分号分隔每个文件名。
* 可以使用通配符（***** 或 ?）来表示文件名的一个或多个字符，并显示文件或子目录的子集。
* 可以使用通配符 ***** 来替换任何字符串，例如：

  * `dir *.txt` 将列出当前目录中扩展名以 .txt 开头的所有文件，例如 .txt、.txt1、.txt_old。
  * `dir read *.txt` 将列出当前目录中以 read 开头并且扩展名以 .txt 开头的所有文件，例如 .txt、.txt1 或 .txt_old。
  * `dir read *.*` 将列出当前目录中以 read 开头的所有文件（无论任何扩展名）。

  星号通配符始终使用短文件名映射，因此你可能会得到意外的结果。 例如，以下目录包含两个文件（t.txt2 和 t97.txt）：
  复制

  ```
  C:\test>dir /x
  Volume in drive C has no label.
  Volume Serial Number is B86A-EF32

  Directory of C:\test

  11/30/2004  01:40 PM <DIR>  .
  11/30/2004  01:40 PM <DIR> ..
  11/30/2004  11:05 AM 0 T97B4~1.TXT t.txt2
  11/30/2004  01:16 PM 0 t97.txt
  ```

  你可能期望键入 `dir t97\*` 后将返回文件 t97.txt。 但是，键入 `dir t97\*` 会返回这两个文件，因为星号通配符使用其短名称映射 T97B4~1.TXT，因此会认为文件 t.txt2 与 t97.txt 匹配。 同样，键入 `del t97\*` 会删除这两个文件。
* 可以使用问号 (?) 代替名称中的单个字符。 例如，键入 `dir read???.txt` 会列出当前目录中扩展名为 .txt 的任何文件，这些文件以 read 开头，后跟最多三个字符。 这包括 Read.txt、Read1.txt、Read12.txt、Read123.txt 和 Readme1.txt，但不包括 Readme12.txt。
* 如果在 attributes 中使用 /a 和多个值，则此命令仅显示具有所有指定属性的文件的名称。 例如，如果将 /a 与 r 和 -h 一起使用作为属性（使用 `/a:r-h` 或 `/ar-h`），则此命令将仅显示未隐藏的只读文件的名称。
* 如果指定多个 sortorder 值，则此命令将首先按第一个条件对文件名进行排序，然后按第二个条件排序，依此类推。 例如，如果将 /o 与 sortorder 的 e 和 -s 参数一起使用（使用 `/o:e-s` 或 `/oe-s`），则此命令按扩展名对目录和文件的名称进行排序，首先显示最大的文件，然后显示最终结果。 按扩展名按字母顺序排序会导致首先显示没有扩展名的文件名，然后显示目录名称，然后显示带有扩展名的文件名。
* 如果使用重定向符号 (`>`) 将此命令的输出发送到文件，或者使用管道符号 (`|`) 将此命令的输出发送到另一个命令，则必须使用 `/a:-d` 和 /b，以仅列出文件名。 可以将 filename 与 /b 和 /s 一起使用，以指定此命令要在当前目录及其子目录中搜索与 filename 参数匹配的所有文件名。 此命令仅列出它找到的每个文件名的驱动器号、目录名、文件名和文件扩展名（每行一个路径）。 在使用管道符号将此命令的输出发送到另一个命令之前，应首先在 Autoexec.nt 文件中设置 TEMP 环境变量。

#### 示例

若要按字母顺序、宽格式逐个显示所有目录，并在每个屏幕后暂停，请确保根目录是当前目录，然后键入：

```
dir /s/w/o/p
```

输出列出了根目录、子目录和根目录中的文件，包括扩展名。 此命令还会列出树中每个子目录中的子目录名称和文件名。

若要更改前面的示例，以便 dir 显示文件名和扩展名，但省略目录名称，请键入：

```
dir /s/w/o/p/a:-d
```

要打印目录列表，请键入：

```
dir > prn
```

如果指定 prn，则目录列表将发送到连接到 LPT1 端口的打印机。 如果打印机连接到其他端口，则必须将 prn 替换为正确端口的名称。

还可以将 prn 替换为文件名，从而将 dir 命令的输出重定向到文件。 也可以键入路径。 例如，若要将 dir 命令的输出定向到 Records 目录中的 dir.doc 文件，请键入：

```
dir > \records\dir.doc
```

如果 dir.doc 不存在，dir 将创建此文件，除非 Records 目录不存在。 如果 Records 目录不存在，将显示以下消息：

```
File creation error
```

若要显示驱动器 C 上所有目录中扩展名为.txt 的所有文件名的列表，请键入：

```
dir c:\*.txt /w/o/s/p
```

dir 命令以宽格式显示每个目录中按字母顺序排列的匹配文件名列表，并且每次屏幕填满时都会暂停，按任意键可继续显示。

### echo（打印消息和回显功能）

显示消息或者打开或关闭命令回显功能。 如果不结合任何参数使用，echo 会显示当前回显设置。

若要显示当前的回显设置，请键入：

```
echo
```

若要在屏幕上回显空白行，请键入：

```
echo.
```

> 备注
>
> 不要在句点前面包含空格。 否则，将显示句点而不是空白行。

若要防止在命令提示符处回显命令，请键入：

```
echo off
```

> 备注
>
> 关闭回显时，命令提示符不会出现在“命令提示符”窗口中。 若要再次显示命令提示符，请键入 echo on。

若要防止批处理文件中的所有命令（包括 echo off 命令）显示在屏幕上，请在批处理文件的第一行中键入：

```
@echo off
```

可以将 `echo` 命令用作 `if` 语句的一部分。 例如，若要在当前目录中搜索文件扩展名为 .rpt 的任何文件，并在找到此类文件时回显消息，请键入：

```
if exist *.rpt echo The report has arrived.
```

以下批处理文件在当前目录中搜索文件扩展名为 .txt 的文件，并显示一条消息来指示搜索结果：

```
@echo off
if not exist *.txt (
echo This directory contains no text files.
) else (
   echo This directory contains the following text file^(s^):
   echo.
   dir /b *.txt
   )
```

如果运行该批处理文件时未找到 .txt 文件，则会显示以下消息：

```
This directory contains no text files.
```

如果运行该批处理文件时找到 .txt 文件，则会显示以下输出（此示例假设文件 File1.txt、File2.txt 和 File3.txt 存在）：

```
This directory contains the following text file(s):

File1.txt
File2.txt
File3.txt
```

### find（搜索文本字符）

在一个或多个文件中搜索文本字符串，并显示包含指定字符串的文本行。

#### 语法

```
find [/v] [/c] [/n] [/i] [/off[line]] <"string"> [[<drive>:][<path>]<filename>[...]]
```

#### 参数

| 参数                             | 说明                                               |
| -------------------------------- | -------------------------------------------------- |
| /v                               | 显示不包含指定 `<string>` 的所有行。             |
| /c                               | 对包含指定 `<string>` 的行进行计数，并显示总计。 |
| /n                               | 每行前面都有文件的行号。                           |
| /i                               | 指定搜索不区分大小写。                             |
| /off[line]                       | 如果文件设置了脱机属性，则不会被跳过。             |
| `<"string">`                   | 必需。 指定想要搜索的字符组（用引号括起来）。      |
| `[<drive>:][<path>]<filename>` | 指定要在其中搜索指定字符串的文件的位置和名称。     |
| /?                               | 在命令提示符下显示帮助。                           |

 若要显示包含字符串“pencil sharpener”的 pencil.md 中的所有行，请键入：

```
find "pencil sharpener" pencil.txt
```

 为了在 report.txt 文件中找到文本“科学家标明他们的论文仅供讨论，并不是最终报告。”（含引号），请键入：

```
find """The scientists labeled their paper for discussion only. It is not a final report.""" < report.txt
```

**若要搜索一组文件，可以使用通配符。 若要在当前目录中搜索扩展名为 .bat 且包含忽略大小写的字符串 PROMPT 的文件，请键入**：

```
find /i "PROMPT" *.bat
```

若要在包含字符串 CPU 的目录中查找文件名，请使用管道 (|) 将 dir 命令的输出定向到 find 命令，如下所示：

```
dir c:\temp /s /b | find "CPU"
```

查找不包含 “agent” 的所有正在运行的进程：

```
tasklist | find /v /i "agent"
```

检查服务是否正在运行：

```
sc query  Winmgmt | find "RUNNING" >nul 2>&1 && (echo service is started) || (echo service is stopped)
```

### for（遍历文件）

为一组文件中的每个文件运行指定命令。

#### 语法

```
for {%% | %}<variable> in (<set>) do <command> [<commandlineoptions>]
```

#### 参数

| 参数                     | 说明                                                                                                                                                                                         |
| ------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `{%% \| %}<variable>`   | 必填。 表示可替换参数。 使用单百分号 (`%`) 可在命令提示符下执行 for 命令。 使用双百分号 (`%%`) 可在批处理文件中执行 for 命令。 变量区分大小写，并且必须用字母值表示，例如 %a、%b 或 %c。 |
| (`<set>`)              | 必需。 指定要对其运行命令的一个或多个文件、目录或文本字符串或值范围。 需要使用括号。                                                                                                         |
| `<command>`            | 必需。 指定要对每个文件、目录或文本字符串执行的命令，或针对 set 中包含的值范围执行的命令。                                                                                                   |
| `<commandlineoptions>` | 指定要与指定命令一起使用的任何命令行选项。                                                                                                                                                   |
| /?                       | 在命令提示符下显示帮助。                                                                                                                                                                     |

#### 备注

* 可以在批处理文件中使用此命令，也可以直接从命令提示符使用此命令。
* 以下属性适用于 for 命令：
  * 此命令将 `% variable` 或 `%% variable` 替换为指定集中的每个文本字符串，直到指定的命令处理完所有文件。
  * 变量名称区分大小写并且是全局性的，一次最多不能超过 52 个处于活动状态。
  * 可以对变量使用任何字符，但为了避免与批处理参数 `%0` 到 `%9` 混淆，请避免使用数字 0 到 9。 对于简单的批处理文件，单个字符（如 `%%f`）将起作用。
  * 可以在复杂的批处理文件中对变量使用多个值，以区分不同的可替换变量。
* set 参数可以表示单个文件组或多组文件。 可以使用通配符（***** 和 ?）指定文件集。 以下是有效的文件集：
  复制

```
  (*.doc)
  (*.doc *.txt *.me)
  (jan*.doc jan*.rpt feb*.doc feb*.rpt)
  (ar??1991.* ap??1991.*)
```

* 使用此命令时，set 参数中的第一个值将替换 `% variable` 或 `%% variable`，然后指定的命令将处理此值。 这一直持续到与 set 值相对应的所有文件（或文件组）都被处理为止。
* In 和 do 不是参数，但必须将它们与此命令一起使用。 如果省略其中任何一个关键字，则会出现错误消息。
* 如果启用了命令扩展（默认状态），则支持下列形式的 for：
  * 仅限目录：如果 set 参数中包含通配符（***** 或 ?），则将针对与 set 参数匹配的每个目录（而不是指定目录中的一组文件）执行指定的命令。 语法为：

    ```
    for /d {%%|%}<variable> in (<set>) do <command> [<commandlineoptions>]
    ```
  * 递归：遍历以 drive:path 为根的目录树，并在树的每个目录中执行 for 语句。 如果在 /r 之后没有指定目录，则使用当前目录作为根目录。 如果 set 参数只是一个句点 (.)，则仅枚举目录树。 语法为：

    ```
    for /r [[<drive>:]<path>] {%%|%}<variable> in (<set>) do <command> [<commandlineoptions>]
    ```
  * 迭代值范围：使用迭代变量设置起始值 (start#)，然后逐步通过设置的值范围，直到该值超过设置的结束值 (end#)。 **/l** 将通过比较  *start* # 和  *end* # 来执行迭代。 如果  *start* # 小于  *end* #，则执行该命令。 当迭代变量超过 end# 时，命令 shell 退出循环。 你还可以使用 step# 来逐步减少值的范围。 例如，(1,1,5) 生成序列 1 2 3 4 5，(5,-1,1) 生成序列 5 4 3 2 1。 语法为：

    ```
    for /l {%%|%}<variable> in (<start#>,<step#>,<end#>) do <command> [<commandlineoptions>]
    ```
  * 迭代和文件解析：使用文件解析来处理命令输出、字符串和文件内容。 使用迭代变量定义要检查的内容或字符串，并使用各种 parsingkeywords 选项进一步修改解析。 使用 parsingkeywords 标记选项来指定哪些标记应作为迭代变量传递。 如果使用时不带标记选项，/f 将只检查第一个标记。
    文件解析包括读取输出、字符串或文件内容，然后将其拆分为单独的文本行，并将每一行解析为零个或多个标记。 然后调用 for 循环，并将迭代变量值设置为标记。 默认情况下，/f 传递每个文件的每一行中的第一个空白分隔标记。 空行将被跳过。
    语法为：

    ```
    for /f [<parsingkeywords>] {%%|%}<variable> in (<set>) do <command> [<commandlineoptions>]
    for /f [<parsingkeywords>] {%%|%}<variable> in (<literalstring>) do <command> [<commandlineoptions>]
    for /f [<parsingkeywords>] {%%|%}<variable> in ('<command>') do <command> [<commandlineoptions>]
    ```

    set 参数指定一个或多个文件名。 将依次打开、读取和处理每个文件，然后才会移动到 set 参数中指定的下一个文件。 要覆盖默认分析行为，请指定 parsingkeywords。 这是一个带引号的字符串，其中包含一个或多个用于指定不同分析选项的关键字。

    如果使用 usebackq 选项，请使用以下语法之一：

    ```
    for /f [usebackq <parsingkeywords>] {%%|%}<variable> in (<set>) do <command> [<commandlineoptions>]
    for /f [usebackq <parsingkeywords>] {%%|%}<variable> in ('<literalstring>') do <command> [<commandlineoptions>]
    for /f [usebackq <parsingkeywords>] {%%|%}<variable> in (`<command>`) do <command> [<commandlineoptions>]
    ```

    下表列出了可用于 parsingkeywords 的分析关键字。
    展开表

    | 关键字                | 说明                                                                                                                                                                                                                                                  |
    | --------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
    | eol=`<c>`           | 指定行尾字符（只有一个字符）。                                                                                                                                                                                                                        |
    | skip=`<n>`          | 指定文件开头要跳过的行数。                                                                                                                                                                                                                            |
    | delims=`<xxx>`      | 指定分隔符集。 这将替换默认分隔符集，即空格和制表符。                                                                                                                                                                                                 |
    | tokens=`<x,y,m–n>` | 指定每次迭代时要将每行中的哪些标记传递给 for 循环。 因此，会分配额外的变量名。 m-n 指定从第 m 个到第 n 个标记的范围。 如果 tokens= 字符串中的最后一个字符是星号 ( ***** )，则会分配一个额外的变量，并且会接收解析的最后一个标记之后的行上的剩余文本。 |
    | usebackq              | 指定将双引号字符串作为命令运行，使用单引号字符串作为文字字符串，或者对于包含空格的长文件名，允许将 `<set>` 中的每个文件名都括在双引号中。                                                                                                           |
  * 变量替换：下表列出了可选语法（适用于任何变量 I）：
    展开表

    | 带修饰符的变量 | 说明                                                                                                                                                        |
    | -------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------- |
    | `%~I`        | 扩展 `%I`，这将移除所有周围的引号。                                                                                                                       |
    | `%~fI`       | 将 `%I` 扩展为完全限定的路径名。                                                                                                                          |
    | `%~dI`       | 将 `%I` 扩展为仅包含驱动器号。                                                                                                                            |
    | `%~pI`       | 将 `%I` 扩展为仅包含路径。                                                                                                                                |
    | `%~nI`       | 将 `%I` 扩展为仅包含文件名。                                                                                                                              |
    | `%~xI`       | 将 `%I` 扩展为仅包含文件扩展名。                                                                                                                          |
    | `%~sI`       | 将路径扩展为仅包含短名称。                                                                                                                                  |
    | `%~aI`       | 将 `%I` 扩展为文件属性。                                                                                                                                  |
    | `%~tI`       | 将 `%I` 扩展为文件的日期和时间。                                                                                                                          |
    | `%~zI`       | 将 `%I` 扩展为文件的大小。                                                                                                                                |
    | `%~$PATH:I`  | 搜索 PATH 环境变量中列出的目录，然后将 `%I` 扩展为找到的第一个目录的完全限定名称。 如果未定义环境变量名称或搜索找不到该文件，则此修饰符将扩展为空字符串。 |

    下表列出了可用于获取复合结果的修饰符组合。
    展开表

    | 带组合修饰符的变量 | 说明                                                                                    |
    | ------------------ | --------------------------------------------------------------------------------------- |
    | `%~dpI`          | 将 `%I` 扩展为仅包含驱动器号和路径。                                                  |
    | `%~nxI`          | 将 `%I` 扩展为仅包含文件名和扩展名。                                                  |
    | `%~fsI`          | 将 `%I` 扩展为仅包含短名称的完整路径名。                                              |
    | `%~dp$PATH:I`    | 在 PATH 环境变量中列出的目录中搜索 `%I`，然后扩展为找到的第一个目录的驱动器号和路径。 |
    | `%~ftzaI`        | 将 `%I` 扩展为类似于 dir 命令的输出行。                                               |

    在上面的示例中，可以将 `%I` 和 PATH 替换为其他有效值。 有效的 for 变量名称将结束 **%~** 语法。
    通过使用大写的变量名（如 `%I`），可以提高代码的易读性，并避免与不区分大小写的修饰符混淆。
* 解析字符串：你可以在直接字符串上使用解析逻辑，方法是：使用双引号（不带 usebackq）或单引号（带usebackq）--例如，(MyString) 或 ('MyString')。`for /f``<literalstring>` `<literalstring>` 被视为来自文件的单行输入。 解析用双引号括起的 `<literalstring>` 时，命令符号（如 `\ & | > < ^`）被视为普通字符。
* 解析输出：可以使用 `for /f` 命令来解析命令的输出，方法是在括号之间加上反引号 `<command>`。 它将被视为命令行，随后传递给子 cmd.exe。 输出会捕获到内存中，并像文件一样进行解析。

#### 示例

要在批处理文件中使用 for，请使用以下语法：

```
for {%%|%}<variable> in (<set>) do <command> [<commandlineoptions>]
```

要使用可替换变量 %f 显示当前目录中扩展名为.doc 或.txt 的所有文件的内容，请键入：

```
for %f in (*.doc *.txt) do type %f
```

在前面的示例中，当前目录中扩展名为 .doc 或 .txt 的每个文件都将被替换为 %f 变量，直到显示每个文件的内容。 要在批处理文件中使用此命令，请将所有出现的 %f 替换为 %%f。 否则，将忽略该变量并显示错误消息。

要分析文件并忽略注释行，请键入：

```
for /f eol=; tokens=2,3* delims=, %i in (myfile.txt) do @echo %i %j %k
```

此命令将解析 myfile.txt 中的每一行。 此命令将忽略以分号开头的行，并将每行的第二个和第三个标记传递给 for 主体（标记由逗号或空格分隔）。 for 语句的主体引用 %i 以获取第二个标记，引用 %j 以获取第三个标记，引用 %k 以获取所有剩余标记。 如果你提供的文件名包含空格，请在文本两边使用引号（例如，File Name）。 要使用引号，必须使用 usebackq。 否则，引号将被解释为定义要解析的文字字符串。

%i 在 for 语句中显式声明。 %j 和 %k 是使用 tokens= 隐式声明的。 可以使用 **tokens=** 来指定最多 26 个标记，前提是不会导致尝试声明超过字母 z 或 Z 的变量。

要通过将 set 放在括号中来解析命令的输出，请键入：

```
for /f "usebackq delims==" %i in (`set`) do @echo %i
```

要对目录中的所有文件执行递归循环（包括子目录）并回显其完整路径、上次修改时间及其文件大小，请键入：

```
for /r "C:\My Dir\" %A in (*.*) do echo %~ftzA
```

### if（条件）

在批处理程序中执行条件处理。

#### 语法

```
if [not] ERRORLEVEL <number> <command> [else <expression>]
if [not] <string1>==<string2> <command> [else <expression>]
if [not] exist <filename> <command> [else <expression>]
```

如果启用了命令扩展，请使用以下语法：

```
if [/i] <string1> <compareop> <string2> <command> [else <expression>]
if cmdextversion <number> <command> [else <expression>]
if defined <variable> <command> [else <expression>]
```

#### 参数

| 参数                       | 说明                                                                                                                                                                                                                                         |
| -------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| not                        | 指定仅当条件为 false 时，才应执行该命令。                                                                                                                                                                                                    |
| errorlevel `<number>`    | 仅当由 Cmd.exe 运行的上一个程序返回等于或大于 number 的退出代码时，才指定 true 条件。                                                                                                                                                        |
| `<command>`              | 指定在满足上述条件时应执行的命令。                                                                                                                                                                                                           |
| `<string1>==<string2>`   | 仅当 string1 和 string2 相同时，才指定 true 条件。 这些值可以是字符串或批处理变量（例如，`%1`）。 无需将字符串用引号括起来。                                                                                                               |
| 存在 `<filename>`        | 如果指定的文件名存在，则指定 true 条件。                                                                                                                                                                                                     |
| `<compareop>`            | 指定三字母比较运算符，包括：* EQU - 等于* NEQ - 不等于* LSS - 小于* LEQ - 小于或等于* GTR - 大于* GEQ - 大于或等于                                                                                                                           |
| /i                         | 强制字符串比较忽略大小写。 可以采用 if 的 `string1==string2` 形式使用 /i。 这些比较是通用的，因为如果 string1 和 string2 仅由数字组成，则字符串将转换为数值并执行数值比较。                                                                |
| cmdextversion `<number>` | 仅当与 Cmd.exe 的命令扩展功能关联的内部版本号等于或大于指定的数值时，才指定 true 条件。 第一个版本为 1。 向命令扩展添加大量增强功能时，它会以 1 为增量增加。 禁用命令扩展时（默认情况下，启用命令扩展），cmdextversion 条件永远不会为 true。 |
| defined `<variable>`     | 如果定义了变量，则指定 true 条件。                                                                                                                                                                                                           |
| `<expression>`           | 指定命令行命令以及要在 else 子句中传递给该命令的任何参数。                                                                                                                                                                                   |
| /?                         | 在命令提示符下显示帮助。                                                                                                                                                                                                                     |

#### 备注

* 如果 if 子句中指定的条件为 true，则执行条件后面的命令。如果条件为 false，则忽略 if 子句中的命令，并且该命令执行 else 子句中指定的任何命令。
* 程序停止时，它将返回退出代码。 若要使用退出代码作为条件，请使用 errorlevel 参数。
* 如果使用 defined，则将以下三个变量添加到环境中：%errorlevel%、%cmdcmdline% 和 %cmdextversion%。

  * %errorlevel%：扩展为 ERRORLEVEL 环境变量的当前值的字符串表示形式。 此变量假定尚不存在名为 ERRORLEVEL 的现有环境变量。 如果存在，将获得该 ERRORLEVEL 值。
* %cmdcmdline%：扩展到在 Cmd.exe 进行任何处理之前传递给 Cmd.exe 的原始命令行。 这假定尚不存在名为 CMDCMDLINE 的现有环境变量。 如果存在，将获得该 CMDCMDLINE 值。
* %cmdextversion%：扩展为 cmdextversion 的当前值的字符串表示形式。 这假定不存在名为 CMDEXTVERSION 的现有环境变量。 如果存在，将获取该 CMDEXTVERSION 值。
* 必须在 if 后面的命令所在的同一行上使用 else 子句。

[](https://learn.microsoft.com/zh-cn/windows-server/administration/windows-commands/if#examples)### 示例

 若要显示消息“如果找不到文件 Product.dat ，则找不到数据文件”，请键入：

```
if not exist product.dat echo Cannot find data file
```

若要在驱动器 A 中格式化磁盘并在格式化过程中发生错误时显示错误消息，请在批处理文件中键入以下行：

```
:begin
@echo off
format a: /s
if not errorlevel 1 goto end
echo An error occurred during formatting.
:end
echo End of batch program.
```

若要从当前目录中删除文件 Product.dat 或在找不到 Product.dat 时显示消息，请在批处理文件中键入以下行：

```
IF EXIST Product.dat (
del Product.dat
) ELSE (
echo The Product.dat file is missing.
)
```

 备注

这些行可以组合成一行，如下所示：

```
IF EXIST Product.dat (del Product.dat) ELSE (echo The Product.dat file is missing.)
```

若要在运行批处理文件后回显 ERRORLEVEL 环境变量的值，请在批处理文件中键入以下行：

```
goto answer%errorlevel%
:answer1
echo The program returned error level 1
goto end
:answer0
echo The program returned error level 0
goto end
:end
echo Done!
```

若要在 ERRORLEVEL 环境变量的值小于或等于 1 时转到 ok 标签，请键入：

```
if %errorlevel% LEQ 1 goto okay
```

### ipconfig

显示所有当前的 TCP/IP 网络配置值，并刷新动态主机配置协议 (DHCP) 和域名系统 (DNS) 设置。 在没有参数的情况下使用时，ipconfig 会显示 Internet 协议版本 4 (IPv4) 和 IPv6 地址、子网掩码以及所有适配器的默认网关。

### mkdir（同md：创建目录）

创建目录或子目录。 命令扩展（默认情况下启用）允许使用单个 mkdir 命令在指定路径中创建中间目录。

若要在当前目录中创建名为 Directory1 的目录，请键入：

```
mkdir Directory1
```

 若要在启用命令扩展的情况下在根目录中创建目录树 Taxes\Property\Current，请键入：

```
mkdir \Taxes\Property\Current
```

 若要与上一示例中一样在根目录中创建目录树 Taxes\Property\Current，但禁用命令扩展，请键入以下命令序列：

```
mkdir \Taxes
mkdir \Taxes\Property
mkdir \Taxes\Property\Current
```

### move（移动文件）

将一个或多个文件从一个目录移动到另一个目录。

#### 语法

```
move [{/y|-y}] [<source>] [<target>]
```

#### 参数

| 参数         | 说明                                                                                                                                                                      |
| ------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| /y           | 停止确认是否要覆盖现有目标文件的提示。 COPYCMD 环境变量中可能预设了此参数。 可以使用 -y 参数替代此预设。 除非命令是从批处理脚本中运行，否则默认会在覆盖文件之前进行提示。 |
| -y           | 启动确认是否要覆盖现有目标文件的提示。                                                                                                                                    |
| `<source>` | 指定要移动的文件的路径和名称。 若要移动或重命名目录，*source* 应为当前目录的路径和名称。                                                                                |
| `<target>` | 指定要将文件移动到的路径和名称。 若要移动或重命名目录，*target* 应为目标目录的路径和名称。                                                                              |
| /?           | 在命令提示符下显示帮助。                                                                                                                                                  |

#### 示例

若要将扩展名为 .xls 的所有文件从 \Data 目录移动到 \Second_Q\Reports 目录，请键入：

```
move \data\*.xls \second_q\reports\
```

### start

启动单独的命令提示符窗口以运行指定的程序或命令。

## 样例

### 复制文件示例

本示例描述，将指定目录下的三个文件夹复制到目标文件夹下，要求：

- 复制所有子目录
- 覆盖现有文件而不提示

```bat
@echo off
rem 将执行目录切换到当前目录，因为以管理员运行默认为 c://Windwows/System32 目录
cd /d %~dp0
rem 中文编码，避免一些中文乱码
chcp 65001 > nul
rem 设置源文件夹路径和目标文件夹路径变量
set "source_folder=TSIM.Shared"  
set "destination_folder=TSIM.Unity/Packages/TSIM.Shared"  
  
:: 确保目标文件夹存在，如果不存在则创建它  
if not exist "%destination_folder%" mkdir "%destination_folder%"  
  
:: 复制文件夹  
xcopy /E /I /Y "%source_folder%\Models" "%destination_folder%\Models"  
xcopy /E /I /Y "%source_folder%\Models_Common" "%destination_folder%\Models_Common"  
xcopy /E /I /Y "%source_folder%\Services" "%destination_folder%\Services" 


echo "复制完成！"
pause
```

**选项说明**

- /E：复制所有子目录，包括空的子目录。
- /I：如果目标不存在且复制多个文件，此选项将假定目标必须是目录。这在目标目录尚未创建时尤其有用，可以避免提示确认。
- /Y：覆盖现有的目标文件而不提示。
