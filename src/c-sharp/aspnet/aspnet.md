# Asp.Net

## Page

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
