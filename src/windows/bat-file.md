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

双击`hello.bat`文件后，会弹出一个命令行窗口，显示`Hello, World!`，然后等待用户按下任意键后关闭窗口。

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