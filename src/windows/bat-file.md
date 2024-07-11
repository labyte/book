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

.excel-table tr:nth-child(even) {
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

</style>


# 批处理文件

## 创建批处理文件

在Windows中，批处理文件以`.bat`为扩展名。

创建一个名为`hello.bat`的文件，并输入以下内容：

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



双击`hello.bat`文件后，会弹出一个命令行窗口，显示`Hello, World!`，然后等待用户按下任意键后关闭窗口。


## 示例

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

## 批处理文件语法

批处理文件使用`DOS`命令和`Windows`命令，以及一些自定义的命令。

### 注释

批处理文件中的注释以`rem`开头，直到行尾结束。

```bat
rem 这是一个注释
```
    
### 变量

批处理文件中的变量以`set`命令开头，后面跟变量名和变量值。

```bat
set name=John
set age=25
```

### 条件语句

批处理文件中的条件语句使用`if`命令和`else`命令。

```bat
if %var%==1 echo 变量等于1
if %var%==2 echo 变量等于2
if %var%==3 echo 变量等于3
if %var%!=1 echo 变量不等于1
if %var%!=2 echo 变量不等于2
if %var%!=3 echo 变量不等于3
```

### 循环语句

批处理文件中的循环语句使用`for`命令和`do`命令。

```bat
for /L %%i in (1,1,10) do echo %%i
```
    
### 调用其他批处理文件

批处理文件可以使用`call`命令调用其他批处理文件。

```bat
call other.bat
```

### 调用外部程序

批处理文件可以使用`start`命令调用外部程序。

```bat
start notepad.exe
```

### 调用其他语言程序

批处理文件可以使用`call`命令调用其他语言程序，如`C`语言程序。

```bat
call myprogram.exe
```
    
### 调用其他操作系统程序

批处理文件可以使用`start`命令调用其他操作系统程序，如`Linux`程序。

```bat
start /D C:\Program Files\Git\bin\bash.exe
```


### 中文编码

在文件中加入

``` batch
chcp 65001 > nul
```