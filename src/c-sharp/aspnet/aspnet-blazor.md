# Balzor


## 不要复制Razor文件

当复制一个界面作为一个新的界面时，配置了新的 `@page` ，但是无法路由到此界面，最后新建页面解决，感觉复制页面容易出现Bug，通过新建，把内容复制过来比较靠谱。

## 注入服务

### 页面中中注入服务

不能通过构造函数注入

服务不加 ? 会有警告

```c#
[Inject][NotNull] NavigationManager? nav { get; set; }
```

### 服务中注入其他服务

最好通过构造函数注入，如 “A” 服务依赖 “B” 服务，在 “A” 中通过构造函数注入 “B”服务，通过属性注入的方式可能会导致注入失败。






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

## BlazorInputFile-不支持同步读取

> BlazorInputFile - Synchronous reads are not supported

在 `Blazor` 中上传文件，不支持同步读取，仅支持异步，如下方法中上传文件：


```c#
private async Task Upload(InputFileChangeEventArgs e)
{
    MemoryStream ms = new MemoryStream();
    e.File.OpenReadStream().CopyTo(ms);
    var bytes = ms.ToArray();
    UploadFile file = new UploadFile
    {
        FileName = e.File.Name,
        FileContent = bytes,
        Size = e.File.Size,
        ContentType = e.File.ContentType
    };
        await Http.PostAsJsonAsync<UploadFile>("/api/uploadfile", file);
        await OnInitializedAsync();
}
```

报错：

```txt
ortunately I keep getting an error/exception from BlazorInputFile which says "Synchronous reads are not supported".
```

**解决办法**： 将 `OpenReadStream`  的复制改为 异步复制：

```c# 
MemoryStream ms = new MemoryStream();
await e.File.OpenReadStream().CopyToAsync(ms);
```

如下写法在非Blazor程序中正确，但是在Blazor中不行：

```c# 
MemoryStream ms = new MemoryStream();
await e.File.OpenReadStream().CopyTo(ms);

//or
MemoryStream ms =  e.File.OpenReadStream();
```


[Blazor 文件上传说明文档](https://learn.microsoft.com/en-us/aspnet/core/blazor/file-uploads?view=aspnetcore-8.0&pivots=server)


**阿里云对象存储（OSS）接口** 


- 在阿里云的对象存储接口中，只提供了同步方法，导致用户认为，无法在 Blazor 中使用

- 上传文件只能先将客户端的资源保存到服务端，然后使用服务端的本地路径进行上传，不能使用 `Stream` 上传，否则报 “数组越界”









