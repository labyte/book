# 自定义特性实现
1. 定义特性

```
using UnityEngine;
#if UNITY_EDITOR
using UnityEditor;
#endif

namespace EnumTest
{
	//-------------------------------------------------------------------------
	public class EnumFlags : PropertyAttribute
	{
		public EnumFlags() { }
	}


#if UNITY_EDITOR
	//-------------------------------------------------------------------------
	[CustomPropertyDrawer( typeof( EnumFlags ) )]
	public class EnumFlagsPropertyDrawer : PropertyDrawer
	{
		public override void OnGUI( Rect position, SerializedProperty property, GUIContent label )
		{
			property.intValue = EditorGUI.MaskField( position, label, property.intValue, property.enumNames );
		}
	}
#endif
}
```
2.  定义枚举，定义枚举需标记1，2，4...,一次2的次方，代码如下：
```
 public enum MyEnum
    {
        A=1,
        B=2,
        V=4
    }
```

3. 使用特性标记属性面板多选

```
     [EnumFlags]
     public MyEnum val;
```

4. 判断两个枚举值是否包含相同

```
    public bool IsSelectEnumType(MyEnum e1, MyEnum e2)
        {           
            return ((int)e1 & (int)e2) != 0 ;
        }
```




# Flags实现


