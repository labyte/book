# ListView

## 表头动态显示和隐藏

在WPF中，表头不在VisualTree里面，无法通过绑定属性值动态控制列的显示隐藏，此示例通过附件属性实现该功能， 以 `ListView`为例，其他具有表头的组件

如DataGrid应类似处理。

1. 添加附加属性

```C#
public class GridViewColumnVisibilityManager
{
    static void UpdateListView(ListView lv)
    {
        GridView gridview = lv.View as GridView;
        if (gridview == null || gridview.Columns == null) return;
        List<GridViewColumn> toRemove = new List<GridViewColumn>();
        foreach (GridViewColumn gc in gridview.Columns)
        {
            if (GetIsVisible(gc) == false)
            {
                toRemove.Add(gc);
            }
        }
        foreach (GridViewColumn gc in toRemove)
        {
            gridview.Columns.Remove(gc);
        }
    }

    public static bool GetIsVisible(DependencyObject obj)
    {
        return (bool)obj.GetValue(IsVisibleProperty);
    }

    public static void SetIsVisible(DependencyObject obj, bool value)
    {
        obj.SetValue(IsVisibleProperty, value);
    }

    public static readonly DependencyProperty IsVisibleProperty =
        DependencyProperty.RegisterAttached("IsVisible", typeof(bool), typeof(GridViewColumnVisibilityManager), new UIPropertyMetadata(true));


    public static bool GetEnabled(DependencyObject obj)
    {
        return (bool)obj.GetValue(EnabledProperty);
    }

    public static void SetEnabled(DependencyObject obj, bool value)
    {
        obj.SetValue(EnabledProperty, value);
    }

    public static readonly DependencyProperty EnabledProperty =
        DependencyProperty.RegisterAttached("Enabled", typeof(bool), typeof(GridViewColumnVisibilityManager), new UIPropertyMetadata(false,
            new PropertyChangedCallback(OnEnabledChanged)));

    private static void OnEnabledChanged(DependencyObject obj, DependencyPropertyChangedEventArgs e)
    {
        ListView view = obj as ListView;
        if (view != null)
        {
            bool enabled = (bool)e.NewValue;
            if (enabled)
            {
                view.Loaded += (sender, e2) =>
                {
                    UpdateListView((ListView)sender);
                };
                view.TargetUpdated += (sender, e2) =>
                {
                    UpdateListView((ListView)sender);
                };
                view.DataContextChanged += (sender, e2) =>
                {
                    UpdateListView((ListView)sender);
                };
            }
        }
    }
}
```



1. 前端使用
- 引入附加属性脚本的命名空间 `xmlns:foo="clr-namespace:LotteryPredict.Control"` 
- 在ListView里面使用附件属性 用  `foo:GridViewColumnVisibilityManager.Enabled="true"`,启用附件属性的功能
- GridViewColumn 中使用  `foo:GridViewColumnVisibilityManager.IsVisible="{Bindg IsFullAuth}"`控制该列



```XML
...
xmlns:foo="clr-namespace:LotteryPredict.Control"
...
 <ListView Grid.Row="1" ItemContainerStyle="{StaticResource CenterLVItemStyle}" ItemsSource="{Binding CurVersionCatalogs}"
            foo:GridViewColumnVisibilityManager.Enabled="True">
            ...
             <GridViewColumn Header="目录名称" DisplayMemberBinding="{Binding Name}" Width="110" 
                 foo:GridViewColumnVisibilityManager.IsVisible="{Binding IsFullAuth}"
                 ></GridViewColumn>
...
```

