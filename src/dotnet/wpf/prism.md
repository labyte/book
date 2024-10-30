# Prism 框架

## IDialogService 集成 MaterialDesign

> **需求**：通过 Prism 的对话框服务来管理 MaterialDesign 的 DialogHost 功能，实现既有Prism的框架注入服务，又具备 MaterialDesign 的界面，同时保持 Prism 的默认对话框功能（可拖动移动）。


### Prism 8.0 和 9.0 接口变动

Prism 8.0 到 9.0 的命名空间以及 Dialog的接口有变动，需要分别处理

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
    font-size: 14px; /* 设置字体大小 */
    table-layout: fixed; /* 固定表格布局 */
}

.excel-table th, .excel-table td {
    border: 1px solid #d0d7de;
    padding: 8px;
    text-align: left;
}

.excel-table th {
    background-color: #f0f3f5;
    font-weight: bold;
}

.excel-table td {
    
    background-color: #ffffff;
    vertical-align: top;
}

.excel-table td ul {
    padding:14px;
}

.excel-table td ol {
    padding:14px;
}

.excel-table th:nth-child(1), .excel-table td:nth-child(1) {
    /* width: 30%; */
      width: 100px; /*固定第一列宽度 */
}

.excel-table th:nth-child(2), .excel-table td:nth-child(2) {
    width: 50%;
}

.excel-table th:nth-child(3), .excel-table td:nth-child(3) {
    width: 50%;
}
</style>

<div class="table-container">
    <table class="excel-table">
        <thead>
            <tr>
                <th>接口</th>
                <th>Prism 8.0</th>
                <th>Prism 9.0</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>IDialogService</td>
                <td>
                命名空间：Prism.Services.Dialogs
                <ul>
                    <li>void Show(string name, IDialogParameters parameters, Action<IDialogResult> callback);</li>
                    <li>void Show(string name, IDialogParameters parameters, Action<IDialogResult> callback, string windowName);</li>
                    <li>void ShowDialog(string name, IDialogParameters parameters, Action<IDialogResult> callback);</li>
                    <li>void ShowDialog(string name, IDialogParameters parameters, Action<IDialogResult> callback, string windowName);</li>
                </ul>
                </td>
               <td>
               命名空间：Prism.Dialogs
                   <ul>
                        <li>void ShowDialog(string name, IDialogParameters parameters, DialogCallback callback);</li>
                    </ul>
                备注：其他的接口改为扩展来提供。
                </td>
            </tr>
            <tr>
                <td>IDialogAware</td>
                <td> 命名空间：Prism.Dialogs
                    <ul>
                        <li>string Title { get; }</li>
                        <li>bool CanCloseDialog();</li>
                        <li>void OnDialogClosed();</li>
                        <li>void OnDialogOpened(IDialogParameters parameters);</li>
                        <li>event Action<IDialogResult> RequestClose;</li>
                    </ul>
                </td>
                <td> 命名空间：Prism.Dialogs
                    <ul>
                        <li>bool CanCloseDialog();</li>
                        <li>void OnDialogClosed();</li>
                        <li>void OnDialogOpened(IDialogParameters parameters);</li>
                        <li>DialogCloseListener RequestClose { get; }</li>
                    </ul>
                    备注：这里主要是将 RequestClose 从事件更改为 属性
                </td>
            </tr>
        </tbody>
    </table>
</div>

### 集成过程

**IDialogAware** 接口，注意命名空间以及 `RequestClose`  在 9.0 中的变动


#### 定义 `DialogServiceExtensions` 

对 `IDialogService` 扩展，该脚本在8.0 和 9.0 中仅命名空间名称不一样（注意将 `using Prism.Services.Dialogs;` 改为 `using Prism.Dialogs;`）。

```c#
 public static class DialogServiceExtensions
 {
     public static void ShowDialogHost(this IDialogService dialogService, string name,
      string windowName)
     {
         if (!(dialogService is MaterialDialogService materialDialogService))
             throw new NullReferenceException("DialogService must be a MaterialDialogService");

         materialDialogService.ShowDialogHost(name, windowName, null, null
             );
     }


     /// <summary>
     /// Shows a modal dialog using a <see cref="MaterialDesignThemes.Wpf.DialogHost"/>.
     /// </summary>
     /// <param name="dialogService"></param>
     /// <param name="name">The name of the dialog to show.</param>
     /// <param name="parameters">The parameters to pass to the dialog.</param>
     /// <param name="callback">The action to perform when the dialog is closed.</param>
     /// <exception cref="NullReferenceException">Thrown when the dialog service is not a MaterialDialogService</exception>
     public static void ShowDialogHost(this IDialogService dialogService, string name, IDialogParameters parameters, Action<IDialogResult> callback)
     {
         if (!(dialogService is MaterialDialogService materialDialogService))
             throw new NullReferenceException("DialogService must be a MaterialDialogService");

         materialDialogService.ShowDialogHost(name, parameters, callback);
     }

     /// <summary>
     /// Shows a modal dialog using a <see cref="MaterialDesignThemes.Wpf.DialogHost"/>.
     /// </summary>
     /// <param name="dialogService"></param>
     /// <param name="name">The name of the dialog to show.</param>
     /// <param name="parameters">The parameters to pass to the dialog.</param>
     /// <param name="callback">The action to perform when the dialog is closed.</param>
     /// <param name="windowName">The name of the <see cref="MaterialDesignThemes.Wpf.DialogHost"/> that will contain the dialog control</param>
     /// <exception cref="NullReferenceException">Thrown when the dialog service is not a MaterialDialogService</exception>
     public static void ShowDialogHost(this IDialogService dialogService, string name,
         IDialogParameters parameters, Action<IDialogResult> callback, string windowName)
     {
         if (!(dialogService is MaterialDialogService materialDialogService))
             throw new NullReferenceException("DialogService must be a MaterialDialogService");

         materialDialogService.ShowDialogHost(name, windowName, parameters, callback);
     }
 }
```


####  定义 `MaterialDialogService`

8.0 和 9.0 定义不同：

 [Prism 8.0 定义 MaterialDialogService](#prism-80-定义-materialdialogservice)

 [Prism 9.0 定义 MaterialDialogService](#prism-90-定义-materialdialogservice)




#### 在 `App.xaml.cs` 中注册

```c#
  protected override void RegisterTypes(IContainerRegistry containerRegistry)
  {
    //other...
      containerRegistry.Register<IDialogService, MaterialDialogService>();

  }
```
#### 前端容器

```xml
<UserControl x:Class="OESTS.Modules.Share.Views.MainLayout"
             xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
             xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
             xmlns:prism="http://prismlibrary.com/"    
              xmlns:materialDesign="http://materialdesigninxaml.net/winfx/xaml/themes"
              xmlns:core="clr-namespace:OESTS.Core;assembly=OESTS.Core" 
              xmlns:Selectors="clr-namespace:OESTS.Modules.Share.Selectors" 
             prism:ViewModelLocator.AutoWireViewModel="True">
    <Grid>
        <materialDesign:DialogHost Identifier="WinName" >
            <ContentControl  HorizontalAlignment="Stretch" VerticalAlignment="Stretch" Margin="0 1 0 0"
                 prism:RegionManager.RegionName="{x:Static core:RegionNames.WorkRegion}" />
        </materialDesign:DialogHost>

    </Grid>
</UserControl>

```

#### 后端调用

```c#

/*弹出班级选项面板
* ContentView: 用户控件视图的名称
* WinName: 前端定义的 DialogHost Identifier
*/
_dialogService.ShowDialogHost("ContentView", parameters, (r) =>
{
    dialogResult = r;

}, "WinName");
```
### Prism 8.0 定义 MaterialDialogService

MaterialDialogService

```C#
 public class MaterialDialogService : DialogService
 {
     private readonly IContainerExtension _containerExtension;

     public MaterialDialogService(IContainerExtension containerExtension) : base(containerExtension)
     {
         _containerExtension = containerExtension;
     }

     public void ShowDialogHost(string name, IDialogParameters parameters, Action<IDialogResult> callback) =>
         ShowDialogHost(name, null, parameters, callback);

     public void ShowDialogHost(string name, string dialogHostName, IDialogParameters parameters, Action<IDialogResult> callback)
     {
         if (parameters == null)
             parameters = new DialogParameters();

         var content = _containerExtension.Resolve<object>(name);
         if (!(content is FrameworkElement dialogContent))
         {
             throw new NullReferenceException("A dialog's content must be a FrameworkElement");
         }

         AutowireViewModel(dialogContent);

         if (!(dialogContent.DataContext is IDialogAware dialogAware))
         {
             throw new ArgumentException("A dialog's ViewModel must implement IDialogAware interface");
         }

         var openedEventHandler = new DialogOpenedEventHandler((sender, args) =>
         {
             dialogAware.OnDialogOpened(parameters);
         });
         var closedEventHandler = new DialogClosedEventHandler((sender, args) =>
         {
             dialogAware.OnDialogClosed();
         });

         dialogAware.RequestClose += res =>
         {
             if (DialogHost.IsDialogOpen(dialogHostName))
             {
                 callback?.Invoke(res);
                 DialogHost.Close(dialogHostName);
             }
         };

         var dispatcherFrame = new DispatcherFrame();
         if (dialogHostName == null)
         {
             _ = DialogHost.Show(dialogContent, openedEventHandler, null, closedEventHandler)
                 .ContinueWith(_ => dispatcherFrame.Continue = false); ;
         }
         else
         {
             _ = DialogHost.Show(dialogContent, dialogHostName, openedEventHandler, null, closedEventHandler)
                 .ContinueWith(_ => dispatcherFrame.Continue = false);
         }

         try
         {
             // tell users we're going modal
             ComponentDispatcher.PushModal();

             Dispatcher.PushFrame(dispatcherFrame);
         }
         finally
         {
             // tell users we're going non-modal
             ComponentDispatcher.PopModal();
         }

         dialogAware.RequestClose -= callback;
     }

     private static void AutowireViewModel(object viewOrViewModel)
     {
         if (viewOrViewModel is FrameworkElement view && view.DataContext is null && ViewModelLocator.GetAutoWireViewModel(view) is null)
         {
             ViewModelLocator.SetAutoWireViewModel(view, true);
         }
     }
 }
```
### Prism 9.0 定义 MaterialDialogService

MaterialDialogService

```C#
 public class MaterialDialogService : DialogService
 {
     private readonly IContainerExtension _containerExtension;

     public MaterialDialogService(IContainerExtension containerExtension) : base(containerExtension)
     {
         _containerExtension = containerExtension;
     }

     public void ShowDialogHost(string name, IDialogParameters parameters, Action<IDialogResult> callback) =>
         ShowDialogHost(name, null, parameters, callback);

     public void ShowDialogHost(string name, string dialogHostName, IDialogParameters parameters, Action<IDialogResult> callback)
     {
         if (parameters == null)
             parameters = new DialogParameters();

         var content = _containerExtension.Resolve<object>(name);
         if (!(content is FrameworkElement dialogContent))
         {
             throw new NullReferenceException("A dialog's content must be a FrameworkElement");
         }

         AutowireViewModel(dialogContent);

         if (!(dialogContent.DataContext is IDialogAware dialogAware))
         {
             throw new ArgumentException("A dialog's ViewModel must implement IDialogAware interface");
         }
         var openedEventHandler = new DialogOpenedEventHandler((sender, args) =>
         {
             dialogAware.OnDialogOpened(parameters);
         });
         var closedEventHandler = new DialogClosedEventHandler((sender, args) =>
         {
             dialogAware.OnDialogClosed();
         });

         Action<IDialogResult> requestCloseHandler = (r) =>
         {
             if (DialogHost.IsDialogOpen(dialogHostName))
             {
                 callback?.Invoke(r);
                 DialogHost.Close(dialogHostName);
             }
         };
         DialogUtilities.InitializeListener(dialogAware, requestCloseHandler);


         var dispatcherFrame = new DispatcherFrame();
         if (dialogHostName == null)
         {
             _ = DialogHost.Show(dialogContent, openedEventHandler, null, closedEventHandler)
                 .ContinueWith(_ => dispatcherFrame.Continue = false); ;
         }
         else
         {
             _ = DialogHost.Show(dialogContent, dialogHostName, openedEventHandler, null, closedEventHandler)
                 .ContinueWith(_ => dispatcherFrame.Continue = false);
         }

         try
         {
             // tell users we're going modal
             ComponentDispatcher.PushModal();

             Dispatcher.PushFrame(dispatcherFrame);
         }
         finally
         {
             // tell users we're going non-modal
             ComponentDispatcher.PopModal();
         }

     }

     private static void AutowireViewModel(object viewOrViewModel)
     {
         if (viewOrViewModel is FrameworkElement view && view.DataContext is null && ViewModelLocator.GetAutoWireViewModel(view) is null)
         {
             ViewModelLocator.SetAutoWireViewModel(view, true);
         }
     }
 }
```
