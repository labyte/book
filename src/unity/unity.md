# Unity

## Enum

### 自定义特性实现

定义特性

```c#
using UnityEngine;
#if UNITY_EDITOR
using UnityEditor;
#endif

namespace EnumTest
{
  public class EnumFlags : PropertyAttribute
  {
    public EnumFlags() { }
  }

  #if UNITY_EDITOR
  [CustomPropertyDrawer( typeof( EnumFlags ) )]
  public class EnumFlagsPropertyDrawer : PropertyDrawer
  {
    public override void OnGUI( Rect position, SerializedProperty property, GUIContent label )
    {
      property.intValue = EditorGUI.MaskField( position, label, property.intValue, property.enumNames);
    }
  }
#endif
}
```

定义枚举，定义枚举需标记1，2，4...,一次2的次方，代码如下：

```c#
public enum MyEnum
{
    A=1,
    B=2,
    V=4
}
```

使用特性标记属性面板多选

```c#
[EnumFlags]
public MyEnum val;
```

判断两个枚举值是否包含相同

```c#
public bool IsSelectEnumType(MyEnum e1, MyEnum e2)
{         
    return ((int)e1 & (int)e2) != 0 ;
}
```

### Flags实现

略

## 使用DLL

在开发过程中，我们需要将一些dll放入Pulgins文件夹下，这时最好使用对应Unity版本的dll，并不是dll的版本越高越好，不同版本在引用Unity中的dll的路径不同，具体参照下表

| 版本          | dll路径                                                  | 备注                        |
| :------------ | :------------------------------------------------------- | :-------------------------- |
| 以前版本      | `C:\Program Files\Unity\Editor\Data\Mono\lib\mono\2.0` | 没有使用HUB安装的以前的版本 |
| Unity2020.3.x | `Editor\Data\MonoBleedingEdge\lib\mono\unityjit`       | 在对应版本的 `Editor` 下  |

开发中，我们可能需要使用到如下的dll

- I18N.CJK.dll
- I18N.dll
- Mono.Data.Sqlite.dll
- System.Data.dll

注：某些dll是可以在Unity安装的目录找到的，有些不能，这时需要在官网上看是否有对应Unity的版本，不要一味的最求最新版本

## 多场景加载

异步加载时，需要设置 `asyncOp.allowSceneActivation = false;`

加载完成后，需要设置 `asyncOp.allowSceneActivation = true;`

注意，此时被加载的场景并不是活跃场景，我们一般都是需要把被加载的场景设置为活跃场景

```csharp
//...
  SceneManager.sceneLoaded += SceneLoadHandler;
//...

private void SceneLoadHandler(Scene scene, LoadSceneMode mode)
{
    Debug.Log("激活场景: " + scene.name);
    SceneManager.SetActiveScene(scene);
}
//...
  SceneManager.sceneLoaded -= SceneLoadHandler;
//...
```

## 证书问题崩溃

查看崩溃日志：`C:\Users\ABYTE\AppData\Local\Temp\Unity\Editor\Crashes`,找到最近一次崩溃的文件夹，查看 `Editor.log` 文件，若出现 `[Licensing::Client] Error: Code 10 while verifying Licensing Client signature` 这种错误信息。

删除 `C:\ProgramData\Unity\Unity_lic.ulf` ，重新激活即可。

- 注意，在使用 "+="时，要匹配使用 “-=”,否则响应会叠加

激活场景的目的：多场景时，引擎会使用活跃场景的天空盒

## Dictionary的key 为 null导致报错

ArgumentNullException: Value cannot be null.

```
Parameter name: key
  at System.Collections.Generic.Dictionary`2[TKey,TValue].FindEntry (TKey key) [0x00008] in <695d1cc93cca45069c528c15c9fdd749>:0 
  at System.Collections.Generic.Dictionary`2[TKey,TValue].ContainsKey (TKey key) [0x00000] in <695d1cc93cca45069c528c15c9fdd749>:0 
```

Dictionary 的 key 值不能为null.

查看代码追踪 key 的来源，进行修改

**注意此问题**：
在编辑模式下，应该也会报错，但是有些时候莫名不会提示你错误，但是在发布后会报错
所以在使用 字典 时，最好对key进行判断**

## 挂载脚本顺序导致依赖失败

**Unity版本**：Unity2017.3.0

**使用情景**：组件依赖问题，自定义了两个脚本，其中A依赖B，但是当停止Play时，报错：`CAN'T REMOVE HIGHLIGHTER (SCRIPT) BECAUSE HIGHLIGHTERREGISTER (SCRIPT) DEPENDS ON IT。`

**解决办法**：更改两个脚本的组件顺序，先是依赖项，后为被依赖项。

![1721199810487](image/unity/1721199810487.png)

改为

![1721199816545](image/unity/1721199816545.png)

## FAILED TO LOAD MONO

**Unity版本**：Unity2017.1.0

 **解决办法**：文件夹不能包含中文名，之前发现有的版本在中文路径下可以，所以觉得后面的版本也应该可以，导致花了很多时间，最后还是中文路径的问题。

## Unity打包后画面灰色、重影、带错误的彩色现象。

Unity版本：Unity2017.1.0

 **解决办法**：更新显卡

## Unity编译时间过长

可能有很多问题导致的

- 项目过大，资源过多，没办法，或者优化资源（不要有重复的资源）
- VS 影响的，关闭VS ,删除 .vs文件夹，打开VS时，重新生成

## 将所有配置关联场景导致内存爆了

某次项目，配置文件都是使用“ScriptableObject”的方式来配置，为了方便读取，就把它关联的启动场景（Launch,一直存在）上，导致在移动端启动就闪退。
（1）刚开始将所有的配置文件(ScriptableObject)全部挂在到启动场景（Launch）上，导致在移动端启动时，直接闪退。
原因：
所有的配置文件占用大量内存，启动时内存不够用了，直接闪退
解决办法：
（1）按需加载，不要将太多的资源直接关联到场景中，应该按需加载
（2）手动进行Gc回收，可能导致系统卡顿，且存在问题，最好是在退出任务的时候，进下gc回收

## 链接

* [贴图(有些需要收费，支持Unity和UE)](https://freepbr.com/materials/fiber-textured-wall1/)
* [Unity 插件收集](https://gitee.com/jackyuzju/UnityAssetsResources)
