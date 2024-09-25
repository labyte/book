# ListBox

常用于导航

自定义ItemContainerStyle

在使用ListBox的时候，发现鼠标移入到item上，会有一个很宽的背景，想把它去除，我们自己定义鼠标移入的状态，可以通过 `ItemContainerStyle` 来定义模板，以下实现一个理论考试的题目选择样式，有如下需求:

* 题目有 未做、已做、正确、错误，四种状态，不同的状态显示不同的背景
* 鼠标移入有状态变化（因为这里有四种状态，采用鼠标移入的时候，先死一个透明度40的遮罩，或者显示一个边框，否则要基于4种颜色来设计4种不同的over 色）
* 注意：不能将 `ItemContainerStyle` 样式设定为： `ItemContainerStyle="{x:Null}"` ，会引起其他异常。

```xml
 <ListBox.ItemContainerStyle>
     <Style TargetType="ListBoxItem">
         <Setter Property="Padding" Value="0"/>
         <Setter Property="BorderThickness" Value="0"/>
         <Setter Property="BorderThickness" Value="0"/>
         <Setter Property="Template" >
             <Setter.Value>
                 <ControlTemplate >
                     <Border x:Name="_border"  Style="{StaticResource subnum_border}">
                         <Grid>
                             <TextBlock   Text="{Binding SubNum}" Style="{StaticResource subnum_text}"/>
                             <Border x:Name="_mask" VerticalAlignment="Stretch" HorizontalAlignment="Stretch" Visibility="Collapsed" 
                                 Opacity="0.4" Background="#FFF7E9C2"/>
                         </Grid>
                     </Border>
                     <ControlTemplate.Triggers>

                         <!--未做-->
                         <DataTrigger Binding="{Binding OperateState}" Value="0">
                             <Setter TargetName="_border" Property="Background" Value="#FFB9B9B9"/>
                         </DataTrigger>
                         <!--已做-->
                         <DataTrigger Binding="{Binding OperateState}" Value="1">
                             <Setter TargetName="_border" Property="Background" Value="#FF428DD2"/>

                         </DataTrigger>
                         <!--正确-->
                         <DataTrigger Binding="{Binding OperateState}" Value="2">
                             <Setter TargetName="_border" Property="Background" Value="Green"/>

                         </DataTrigger>
                         <!--错误-->
                         <DataTrigger Binding="{Binding OperateState}" Value="3">
                             <Setter TargetName="_border" Property="Background" Value="#FFAD1E1E"/>
                         </DataTrigger>

                         <!-- 鼠标悬停时，改变背景色  -->
                         <Trigger Property="IsMouseOver" Value="True">
                             <Setter TargetName="_mask" Property="Visibility" Value="Visible" />
                         </Trigger>
                     </ControlTemplate.Triggers>

                 </ControlTemplate>

             </Setter.Value>
         </Setter>
         <Style.Triggers>
             <Trigger Property="IsMouseOver" Value="True">
                 <!-- 当鼠标移入时重置背景色为透明 -->
                 <Setter Property="Background" Value="Transparent"/>
                 <!-- 其他的属性重置 -->
             </Trigger>
         </Style.Triggers>
     </Style>
 </ListBox.ItemContainerStyle>
```

### 设置ItemContainerStyle 为null(出现问题)

这种方式，我们可以单独定义我们的item 模板，如果不自定义模板，还需要，重置 ListItem的风格

```xml

  <!-- 自定义 ListBoxItem 的控件模板  去除自带的模板样式-->
  <Style TargetType="ListBoxItem">
      <Setter Property="Template">
          <Setter.Value>
              <ControlTemplate TargetType="ListBoxItem">
                  <ContentPresenter />
              </ControlTemplate>
          </Setter.Value>
      </Setter>
  </Style>

```

```xml
<ListBox ItemsSource="{Binding YourItems}"
         ItemTemplateSelector="{StaticResource MyTemplateSelector}"
         ItemContainerStyle="{x:Null}" />
```
