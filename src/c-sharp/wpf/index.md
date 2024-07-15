# WPF
## 剪切板错误

>❌ WPF剪切板问题-OpenClipboard HRESULT:0x800401D0 (CLIPBRD_E_CANT_OPEN))


错误示例：

![1717641062860](image/剪切板/1717641062860.png)


**原实现：**

```csharp
 Clipboard.SetText(content);
```

**解决方法：**

```csharp
 Clipboard.SetDataObject(content);
```

**参考（其中的处理方式不优）**

[WPF剪切板问题-OpenClipboard HRESULT:0x800401D0 (CLIPBRD_E_CANT_OPEN))](https://www.cnblogs.com/tranw/p/6150276.html)


## 元素焦点问题


> **Focus()** 函数常常设置失败

通过以下方式可设置成功 `pwdBoxPWD`  需要设置的UI元素

```C#
Dispatcher.BeginInvoke(System.Windows.Threading.DispatcherPriority.Render,
new Action(() => pwdBoxPWD.Focus()));
```

**项目示例：**

在某项目中，有一组菜单按钮，一个菜单对应一个页面，假设A按钮对应A页面，B按钮对应B页面，同时有个需求，在A页面，按下空格键后代码控制跳转到B页面。

**出现问题**：当点击A按钮后，然后按下空格键，不会跳到B页面。

**调试结果**：按下空格键后执行代码跳转到B页面后，会再次跳转到A页面。

**分析原因**：

- 点击A按钮，此时A按钮获得键盘焦点。
- 按下空格键，执行跳转到B的代码逻辑，跳转到B页面。
- 执行完成后，由于A按钮具有焦点会响应键盘，所以会执行A按钮的点击事件，既点击了A按钮，跳转到A页面。