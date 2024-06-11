> UI插件，功能模板非常强大



- 提供了大量的容器组件，如列表，树等
- 容器组件支持拖拽，但是此时鼠标按下内容区域无法滚动视图，若需要滚动，移除支持拖拽的组件
- 支持定位，如打开面板的时候希望定位到某个位置，Unity内置功能里面很垃圾，搞了半天，效果不好，这个组件里提供了方便的接口，如定位到我选择的item的位置，定位到最后等，注意定位到最后的位置并不是1，需要求出最后一个item的位置


# 常用需求对应功能

## 1 列表自动选择指定条目

接口：
```
void SelectNode(TreeNode<TItem> node)
```

## 2 列表自动滚动显示选择的条目
- 移这里是列表文本动到指定Item:
```
void ScrollTo(TItem item);
```

- 移动到指定Item(带动画):
```
void ScrollToAnimated(TItem item);
```
- 移动到指定索引值:
```
void ScrollTo(int index);
```
- 移动到指定滚动位置：
```
void ScrollToPosition(float position);
```

- 移动到指定位置:
```
void ScrollToPosition(Vector2 position);

```

## 3 树控件

注意：对于树控件，默认未展开的节点，不会被选择，所以如果需要选中，一种方式是先展开节点，另外一种是在属性面板取消勾选  ** Deselect Collapsed Nodes **

展开父级示例代码：
``` C#
 TreeNode<ICatalogueItem> pNode = node.Parent;                      
 while (pNode != null)
 {
     pNode.IsExpanded = true;
     pNode = pNode.Parent;
 }
```

在开发中遇到一个问题，用Timeline制作一个教学流程，然后根据时间节点设计了目录，使用树控件来显示目录，能够点击跳转。但是在这个流程中第 6 章节 和 第 3 章节的内容是一样的，配置Timeline 时就没配置 第6章节的，但是在目录中需要有，点击第6章节，跳转到第3章节的内容，这个时候就导致了 节点的id相同，所以自动选择的时候出现错乱，需要做特殊处理

## 4 虚拟化

开启比较好，否则，在树控件中，如果大量节点导致拖动很卡顿


# 组件介绍



## EasyLayout

> 布局组件，对应引擎自带的 VerticalLoayout 和 HorizontalLayout

插件自带使用的这个，不使用这个会导致代码更新滚动视图位置无效

![1718094735942](image/NewUIWidgets/1718094735942.png)

- Main Axis: 搞不懂这个属性，似乎没影响
- Sikp Inactive: 勾选时，被隐藏的子对象不会参加布局，此时和引擎自带的功能一直，否则即使隐藏，也会占位置



--- 

## 输入框组件

![1718094742970](image/NewUIWidgets/1718094742970.png)

- Character Limit: 设置字符的个数，用于在设置密码、或者激活码等，可以显示个数
- Content Type: 数据类型： 如激活码，只能输入整数 Integer Number
- Caret Blink Rate: 光标闪烁的频率
- Caret Width: 光标宽度： 默认的宽度比较小，基本看不见，建议这里设置大点
- Custom Caret Color: 光标颜色



## ListViewCustomBase
这个基类当中有一个属性：ListType ， 当你对面板进行布局的时候，可能需要重写这个变量的值来满足布局要求
 **ListViewCustom<TComponent, TItem>** 继承于它。
也就是基本上所有的容器都可以使用这个功能

```
 public class TaskCatalogueTreeView : TreeViewCustom<CatalogueComponent, ICatalogueItem>
 {
    //需要重写
    public override ListViewType ListType { get =>ListViewType.ListViewWithVariableSize; }
    //..
}
```
---

### 已知问题

- 在某些Unity版本的命名空间中，无法使用结构（Strcut）或接口(Interface)类型,需要使用Class

---

## TreeViewCustom<TComponent, TItem>

- 树形控件视图，一一般我们要编写自己的组件来继承此组件
- TCompoenet: 树形控件中每个节点上挂载的 monobehavior组件，需要继承：TreeViewComponentBase<ICatalogueItem>
- Item: TCompoenet对应的数据接口，需要继承 INotifyPropertyChanged
- 根据插件自带的例子，参照实现接口和组件





---



## INotifyPropertyChanged Support
> 插件使用的ObservableList提供了对数据类型的INotifyPropertyChanged接口的支持，因此如果属性更新并引发PropertyChanged事件，那么视图将被更新。

> 如果您想在项目数据更改时自动更新集合小部件(如ListView、TileView、Table)，那么你需要添加 `INotifyPropertyChanged` 实现到你的数据类型。

- 例子
```
public class ListViewIconsItemDescription : INotifyPropertyChanged
{
    [SerializeField]
    string name;
    public string Name
    {
        get
        {
            return name;
        }
        set
        {
            name = value;
            Changed("Name");
        }
    }
    public event PropertyChangedEventHandler PropertyChanged = (x, y) => { };
    protected void Changed(string propertyName)
    {
        PropertyChanged(this, new PropertyChangedEventArgs(propertyName));
    }
    ...
}
```
- 通过这种方式，界面的第一个将被更新为新的名称
```
ListView.DataSource[0].Name = "New name";
```
- 可以通过属性 ObserveItems 来禁用通知行为
``` 
ListView.DataSource.ObserveItems = false;
// name displayed with the widget will be not changed
ListView.DataSource[0].Name = "New name";
```


# 案例

## 制作目录章节的树形


- 存在节点嵌套
- 当节点是一个组（类似文件夹）节点时，应显示 三角图标，打开时，箭头向下，关闭时，箭头向右
- 当节点是一个数据（类似文件）节点时，不显示图标


### TeachFlowCatalogue 

数目录组件

```
 public class TeachFlowCatalogue : TreeViewCustom<CatalogueComponent, ICatalogueItem>
    {
        public override ListViewType ListType { get => ListViewType.ListViewWithVariableSize; }//布局需要
    }

```

![1718094755079](image/NewUIWidgets/1718094755079.png)

# FAQ
#### 问：使用ListView，想改变Item的显示状态（文本颜色），但是失败
> 答：ListView 使用的 DataSource 来绑定数据并显示，如果要改变状态的显示，那么你要改变DataSource的源数据，需要注意两点

- 数据类型不能是Struct 和 interface,必须是class
- 需要提供 INotifyPropertyChanged 支持,详见 INotifyPropertyChanged 的介绍
- **提示：通过单独修改Item的Color是无效的，因为源数据没改变**






