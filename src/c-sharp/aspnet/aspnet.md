# Asp.Net

## 快速使用

### 不要复制Razor文件

当复制一个界面作为一个新的界面时，配置了新的 `@page` ，但是无法路由到此界面，最后新建页面解决，感觉复制页面容易出现Bug，通过新建，把内容复制过来比较靠谱。

### 页面中注入服务

不能通过构造函数注入

服务不加 ? 会有警告

```c#
[Inject][NotNull] NavigationManager? nav { get; set; }
```

## 脚本函数

### OnInitializedAsync

页面加载进行初始化。

⚠️该函数异步执行，其他函数可能在此函数执行完成后就执行了，所以注意数据的使用

## Page

### 路由问题

在ASP.NET Core Razor页面上，我们可以执行以下操作来更改默认的基于文件夹的路由：

```razor
@page"/student-list"
```

希望 将 `/student-list` 定义为常量，以便在其他地方共用（如授权策略，菜单导航等），避免重复编写字符

```
public const string Myroute ="/student-list";
```

```razor
@page @Constants.Routes.Myroute
```

编译时出现错误：`The 'page' directive expects a string surrounded by double quotes.`

总结：网上有一些解决办法，但是都比较复杂，没必要使用，就按照标注的使用双引号字符直接编写。

## Display特性

在ASP.NET Core中，Display属性是用来定义模型的某个属性在视图中显示的格式。它通常在使用Entity Framework Core的模型类中使用，并且通常与Data Annotations模型进行配合使用。

定义一个枚举，每个值添加Display特性，在使用枚举集合绑定到下拉列表上的时候，视图上显示Display的名称，如果想获取我们选择的值对应的名称，按下面方式实现

```csharp

 public enum MajorType
 {
     [Display(Name = "运营专业")]
     YunYing = 0,
     [Display(Name = "车辆专业")]
     CheLiang = 1,
     [Display(Name = "通号专业")]
     TongHao = 1,
     [Display(Name = "机电专业")]
     JiDian = 1,
     [Display(Name = "供电专业")]
     GongDian = 1,
     [Display(Name = "工务专业")]
     GongWu = 1,
 }
private string GetMajorText(MajorType type)
{

    // 获取枚举类型的字段信息  
    FieldInfo? field = type.GetType().GetField(type.ToString());
    if(field == null) return type.ToString();
    // 检查字段是否有Display特性  
    DisplayAttribute? attribute = Attribute.GetCustomAttribute(field, typeof(DisplayAttribute)) as DisplayAttribute;

    // 返回Display特性的Name属性值，如果没有找到Display特性，则返回枚举值的名称  
    return attribute?.Name ?? type.ToString();
  
}
```

## 部署 IIS

> 说明：使用IIS部署，通常是 `http` 协议，后面要通过 **Nginx** 来代理访问，因为 **Nginx** 配置证书等比较方便

[官网手册](https://learn.microsoft.com/zh-cn/aspnet/core/tutorials/publish-to-iis?view=aspnetcore-8.0&tabs=visual-studio)

以 Windows Server 为例：

### 先决条件

- [NET Core SDK](https://learn.microsoft.com/zh-cn/dotnet/core/sdk) 安装在开发计算机上。如果发布的程序勾选了独立运行，可以不安装SDK。
- 安装IIS，自行网上查找资料。
- 在 IIS 服务器上安装 [.NET Core 托管捆绑包](https://dotnet.microsoft.com/permalink/dotnetcore-current-windows-runtime-bundle-installer)。 捆绑包可安装 .NET Core 运行时、.NET Core 库和 ASP.NET Core 模块。 该模块允许 ASP.NET Core 应用在 IIS 后面运行。
- 上面安装的托管捆绑包应该包含了 AspNetCoreModuleV2

### 发布Asp.NET程序

发布到文件夹。

不要发布单文件格式，好像无法运行。

### 创建站点

**创建应用程序池**：在IIS管理器中创建一个新的应用程序池，注意：

- 当部署Blazor项目时：设置.NET CLR版本为“No Managed Code”，正常运行
- 当部署 **Web API** 项目，并且从 Blazor 项目中跨域访问时(注：API项目中已经配置了跨域策略)，这里要选择一个版本，否则会因 **跨域问题** 无法访问。

![1723516732615](image/aspnet/1723516732615.png)

**创建网站**：设置网站名称（仅显示作用），选择自己创建的应用程序池，选择程序目录，设置端口，IP地址和主机名不用填，默认就行

![1723516895463](image/aspnet/1723516895463.png)

## 使用 Nginx部署

## 问题汇总

### 部署后有的浏览器不能访问

**环境**：

- 阿里云域名
- 阿里云免费云解析
- 阿里云服务器（带固定公网IP）
- 未备案

阿里云售后给出的答复是，网站未备案，详细回复如下：

您好，www.11training.com看解析到阿里云大陆主机，未在阿里云备案导致备案拦截无法访问

网站托管在中国内地（大陆）的服务器上，您需根据所在省市的管局规则进行备案申请。当您使用阿里云中国内地（大陆）节点服务器时，您可以在PC端或移动端的阿里云ICP代备案系统中提交ICP备案申请，审核通过便可开通网站访问服务。
https://help.aliyun.com/document_detail/61819.html

**备案后**：

网站正常访问。
