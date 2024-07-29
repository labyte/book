# Bootstrp Blazor

## 登出组件

[登出组件 Logout](https://www.blazor.zone/logout)

使用参看官网文档，这里讨论下使用 `LogoutLink` 的注意事项，必须配置自己的 `Url` 属性值，如果不配置，直接跳转到默认的 ` /Account/Login`  ，出现找不到页面404错误

```html
<Logout ImageUrl="./images/Argo.png" DisplayName="Administrators" UserName="Admin" class="bg-primary">
    <LinkTemplate>
        <a href="#">
            <i class="fa-solid fa-user"></i><span>个人中心</span>
        </a>
        <a href="#">
            <i class="fa-solid fa-gear"></i><span>设置</span>
        </a>
        <LogoutLink Url="/logouts" />
    </LinkTemplate>
</Logout>
```

`LogoutLink `配置了 Url，表示点击登出时，路由到 `/logouts` 页面

此时需要配置一个登出页面来处理登出逻辑，包含：清除登录数据，自动跳转到登录页：

```
@namespace xxx
@page "/logouts"
@inherits LayoutComponentBase
你已退出登录!
```

```csharp
using Blazored.LocalStorage;
using BootstrapBlazor.Components;
using Microsoft.AspNetCore.Components.Authorization;
using Microsoft.AspNetCore.Components;

namespace TSIM.Web.Components
{
    /// <summary>
    /// 
    /// </summary>
    public sealed partial class AccountLogout : LayoutComponentBase
    {
#pragma warning disable CS8618 // 在退出构造函数时，不可为 null 的字段必须包含非 null 值。请考虑声明为可以为 null。
        [Inject] NavigationManager nav { get; set; }
        [Inject] ILocalStorageService _localStorage { get; set; }
        [Inject] AuthenticationStateProvider authStateProvider { get; set; }

#pragma warning restore CS8618 // 在退出构造函数时，不可为 null 的字段必须包含非 null 值。请考虑声明为可以为 null。

        /// <summary>
        /// OnInitialized 方法
        /// </summary>
        protected async override void OnInitialized()
        {
            await this._localStorage.RemoveItemAsync("authToken");/清除登录数据
            await this.authStateProvider.GetAuthenticationStateAsync();
            nav.NavigateTo("/login", true);//导航到登录页面
        }  
    }
}

```

## 表格页面

当页面中有表格时，如果出现垂直滚动条错误，采用以下解决方式

整个页面使用 `<div>` 包裹，可添加 `class`

```css
.page-user {
    height: calc(100vh - 162px);
}
```

如果希望表格底部的页码正好显示，可以给 `table` 定义类来解决（自行调整`93px` 的值)，如：

```css
.table-users {
    height: calc(100% - 93px);
}css
```

页面：

```html
@page "/users"
@attribute [TabItemOption(Text = "花名册")]
<PageTitle>花名册</PageTitle>

<div class="page-user">
    <h1>花名册</h1>

    <p>只读数据 - 更改每页显示数量体验固定表头功能</p>

    <Table TItem="Foo" class="table-users">
        <TableColumns>
           ...
        </TableColumns>
    </Table>
</div>
```

## 更改组件的样式

通过组件属性 `AdditionalAttributes`  来实现，组件都提供了 `class` 和 `style` 两种方式来更改。

在后端定义一个属性 `AdditionalAttributes`，分别加了 `class` 和 `style` 两个key和对应的值

```c#
public Dictionary<string, object> AdditionalAttributes { get; set; } = 
new Dictionary<string, object>() 
{ 
	{ "style", "border:none;bacground-color:red;" } ,
	{ "class", "custom-cls" }
};
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

## 本地化资源缺失错误

❌ `System.Resources.MissingManifestResourceException”(位于 System.Private.CoreLib.dll 中)`

状态：⚠️**未解决**⚠️

由于当前提示的错误不影响使用，没继续研究。

[组件相关章节](https://www.blazor.zone/localization)

异常通常发生在 .NET 程序无法找到指定的资源文件时。这通常出现在使用本地化、资源文件或卫星程序集的应用程序中。

[ChatGPT 回复](https://chatgpt.com/c/0ac209cd-b5f8-4626-9e15-d807c92c58f0)
