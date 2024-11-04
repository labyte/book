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


## 注入模块中的服务

> 1. 服务是在模块中注册
> 2. 不能在主窗体的 MainWindowViewModel 中注入服务，会报错，需要在导航的子页面中去注入。
> 3. 在Loaded 事件中导航到子页面


以使用 ESUI 模块为例。

（1）创建一个WPF项目，并引用和店家模块

```cs
using ESUI;
using ESUITest.Services;
using ESUITest.Views;
using Prism.Ioc;
using Prism.Modularity;
using Prism.Regions;
using Prism.Unity;
using System;
using System.Windows;

namespace ESUITest
{
    /// <summary>
    /// Interaction logic for App.xaml
    /// </summary>
    public partial class App : PrismApplication
    {
        protected override Window CreateShell()
        {
            return Container.Resolve<MainWindow>();
        }

        protected override void RegisterTypes(IContainerRegistry containerRegistry)
        {
            containerRegistry.RegisterSingleton<IESUITestService, ESUITestService>();
            containerRegistry.RegisterForNavigation<MainView>();
        }

        protected override void OnStartup(StartupEventArgs e)
        {
            base.OnStartup(e);
            Uri aero = new Uri("/PresentationFramework.Classic, Version=3.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35;component/themes/classic.xaml", UriKind.Relative);
            Resources.MergedDictionaries.Add(Application.LoadComponent(aero) as ResourceDictionary);

        }
        protected override void ConfigureModuleCatalog(IModuleCatalog moduleCatalog)
        {
            moduleCatalog.AddModule<ESUIModule>();
        }
      
    }
}

```


MainWindow.xaml

```xml
<Window x:Class="ESUITest.Views.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:ESUITest"
        xmlns:prism="http://prismlibrary.com/"
        prism:ViewModelLocator.AutoWireViewModel="True"
        mc:Ignorable="d"
        Title="{Binding Title}" Height="900" Width="1600">

    <Grid>
        <ContentControl prism:RegionManager.RegionName="{x:Static local:RegionNames.ContentRegion}" />
    </Grid>
    
</Window>

```
MainWindow.cs

```c#
using Prism.Regions;
using System.Windows;

namespace ESUITest.Views
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        private readonly IRegionManager _regionManager;

        public MainWindow(IRegionManager regionManager)
        {
            InitializeComponent();
            this.Loaded += MainWindow_Loaded;
            _regionManager = regionManager;
        }

        private void MainWindow_Loaded(object sender, RoutedEventArgs e)
        {
            _regionManager.RequestNavigate(RegionNames.ContentRegion, "MainView");
        }
    }
}


```


MainViewModel.cs

```c#
using ESUI.MenuViewModels;
using ESUI.Mvvm;
using ESUI.Services.api;
using ESUITest.Services;
using Prism.Regions;

namespace ESUITest.ViewModels
{
    internal class MainViewModel : BindableBase, IDestructible, INavigationAware, IConfirmNavigationRequest
    {
        private ATS_SystemMenuVM _mainMenu;
        public ATS_SystemMenuVM MainMenu
        {
            get { return _mainMenu; }
            set { SetProperty(ref _mainMenu, value); }
        }

        public MainViewModel(IRegionManager regionManager, IESUITestService eSUITestService, IESService esService) : base(regionManager)
        {
            MainMenu = esService.CreateATS_SystemMenuVM("系统");
        }
    }
}

```