# Material(材质)

## 通过改变材质的属性改变Gameobject的显示


在项目中，经常需要控制改变某些对象的显示状态，如红绿灯的控制，假设现在有个3个红绿灯，有三种状态，红、绿、黄，要控制他们显示不同的颜色

### 更改材质实现

- 一个材质是一个shader的实例，当改变材质的状态时，如我们在属性面板直接改变材质的颜色或者贴图等，那么会导致使用了此材质的所有对象都同步改变

- 创建三个材质，分别为 红 绿 黄

- 此时根据需求替换对应的材质即可


### 通过材质属性块实现

个人理解：材质属性块应该是材质中的一个属性实例，也就是说材质对该属性，仅是关联引用，并没有关联具体的值，当改变值时，引用不变，因此可以实现不同的游戏对象，使用一个材质，他们同时对某个属性引用，但是可以通过设置不同的值来实现不同的表现方式

实现代码

```

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MaterialTest : MonoBehaviour
{
    public Color color;
    void Start()
    {
        var render = GetComponent<Renderer>();
        MaterialPropertyBlock block = new MaterialPropertyBlock();
        render.GetPropertyBlock(block);
        block.SetColor("_BaseColor",color);
        render.SetPropertyBlock(block);
    }

    
```

##  经验记录

1. 某些材质的SurfaceTpye设置为Transparent，导致渲染前后错乱，应改为Opaque

## 参考

- https://developer.aliyun.com/article/432429