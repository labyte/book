# Asp.Net


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