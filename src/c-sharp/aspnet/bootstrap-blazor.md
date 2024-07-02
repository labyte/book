# Bootstrp Blazor

## 更改组件的样式

通过组件属性 `AdditionalAttributes`  来实现，组件都提供了 `class` 和 `style` 两种方式来更改。

在后端定义一个属性 `AdditionalAttributes`，分别加了 `class` 和 `style` 两个key和对应的值

```c#
public Dictionary<string, object> AdditionalAttributes { get; set; } = new Dictionary<string, object>() { { "style", "border:none;bacground-color:red;" } ,{ "class", "custom-cls" }};
```

**style** : 直接编写样式字符串

**class** ：值为定义的css类名，这里定义类名为 `custom-cls` 的样式，设置颜色为红色

```css
.custom-cls { color:red; }
```

前端假设设置ListView组件，直接绑定我们的属性

```html
<ListView  AdditionalAttributes="@AdditionalAttributes" >
</ListView>
```

发现**class**设置的有些值可能无效，可能是优先级的原因，我们添加class的优先级并没有原有的高，但是**style**设置的值都是有效的。

## 对象绑定

对于框架封装的组件，如Table、ListView等，有时需要手动查询数据，此时需要获得组件对象，通过 `@ref`来绑定对象，以**ListView**为例：

前端通过 `@ref` 绑定对象

```html
<ListView @ref="listview" >
</ListView>
```

后端定义对象属性，并通过对象调用手工查询方法来更新组件内容

```csharp
private ListView<VideoCollModel> listView { get; set; } 

//如果是表格
//private Table<VideoCollModel> table { get; set; } 

//通过对象查询更新内容
listView.QueryAsync();
```
