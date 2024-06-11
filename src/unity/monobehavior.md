# Awake

```
    private void Awake()
    {
        Debug.Log("Awake");
    }
```

- 引擎首先调用的函数
- 游戏对象被隐藏时，不会执行
- enabel： 启用与否都会执行
- 脚本执行顺序：Awake->...

# OnEnable

```
    private void OnEnable()
    {
        Debug.Log("OnEnable");
    }

```

- 游戏对象被隐藏时，不会执行
- enabel = true 才会执行
- 脚本执行顺序：Awake->OnEnable->...


# Start

## 说明

- 当游戏对象显示后调用
- 仅调用一次，即来回切换游戏对象显示隐藏时，仅在第一次显示时被调用
- 当在Awake函数设置 gameobject.setactive(false); 时，不会被调用

- 游戏对象被隐藏时，不会执行
- enabel = true 才会执行
- 脚本执行顺序：Awake->OnEnable->Start->...

## 一个案例说明

- 在 Awake 里面设置 对象隐藏，运行后，Awake被执行，此时 Start 不会被调用
- 通过点击一个按钮来 调用gameobject.setactive(true) 显示对象
- 此时要注意，onclick函数里的代码要完全执行完成后，才会执行start
- 通常的 误解是 只要 gameobject.setactive(true) start就会立刻被调用


下面代码示例输出：
运行后：awake
点击调用onclick:
for i = 0
for i = 1
onclick end
start

这里就导致了start在其他函数后面调用了，容易出问题

```

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestStart : MonoBehaviour
{
    private void Awake()
    {
        gameObject.SetActive(false);
        Debug.Log("awake");
    }
    void Start()
    {
        Debug.Log("start");
    }

    public void OnClick()
    {
        gameObject.SetActive(true);
        for(int i = 0; i<100;i++)
        {
            Debug.Log("for i = "+ i);
        }
        Debug.Log("onclick end");

    }


}

```

## 一个错误示例

```
public class Test:MonoBehaviour
{
    bool state;
    private void Awake()
    {
        gameObject.SetActive(false);
    }
    private void Start()
    {
        state = true;
    }
    //点击调用
    public void onclick()
    {
        gameObject.SetActive(true);
        Debug.Log(state);
    }
}

```

上面代码中，我在onclick函数里面，预期的输出是 true，但是实际结果是 false, 因为在运行后，wake将 游戏对象设置为未激活状态，导致，star未被执行，而在onclick时,虽然激活了游戏对象，但是当前代码域未执行完，不会调用start，所以先输出 false，然后才执行start ，赋值为 true。


# Update

```
    private void Update()
    {
        Debug.Log("Update");
    }

```

- 游戏对象被隐藏时，不会执行
- enabel = true 才会执行
- 脚本执行顺序：Awake->OnEnable->Start->Update->...

# OnBecameVisible

```

    private void OnBecameVisible()
    {
        Debug.Log("OnBecameVisible");
    }

```
- 游戏对象被隐藏时，不会执行
- **enabel 不影响调用**
- **脚本所在的游戏对象需要meshRenderder组件 且 enable =true**
- **当进入相机视野内时调用**
- **在编辑模式 Scene 窗口，进入窗口范围时调用**
- 若一开始就在相机范围内，脚本执行顺序：Awake->OnEnable->Start->Update->Update->OnBecameVisible->... （注意：在调用两次 Update后调用这个函数）

# OnBecameInvisible

```

    private void OnBecameInvisible()
    {
        Debug.Log("OnBecameInvisible");
    }
```

- 游戏对象被隐藏时，不会执行
- **enabel 不影响调用**
- **脚本所在的游戏对象需要meshRenderder组件 enable =true** 
- **当离开相机视野内时调用**
- **在编辑模式 Scene 窗口，离开窗口范围时调用**


# OnTriggerEnter/OnTriggerExit


```

    private void OnTriggerEnter(Collider other)
    {
        Debug.Log("OnTriggerEnter");
    }

    private void OnTriggerExit(Collider other)
    {
        Debug.Log("OnTriggerExit");
    }


     //一般情况下不用，耗性能
     private void OnTriggerStay(Collider other) {
        Debug.Log("OnTriggerStay");
    }

```

- 一般用于检车玩家进入某个触发区域
- **enabel 不影响调用**
- 游戏对象需要显示
- 两个对象至少有个挂载 `刚体(Rigidbody)`  组件，两个都挂也会触发
- 两个对象都要挂载 `Collider` 组件,至少有个设置IsTrigger = true
- 两个对象可以挂载多个 Collider，但是不能同时存在 IsTrigger = false 的 Collider

| 组件挂载情况  |对象1(都勾选IsTrigger)   |对象2(都勾选IsTrigger)    | 效果  |
|---|---|---|---|
|  1 | Collider x1 |  Collider x1  |  触发1次 Enter/Exit |
| 2 | Collider x2 |  Collider x1  |  触发2次 Enter/Exit |
| 3 | Collider x1 |  Collider x2  |  触发2次 Enter/Exit |
| 4 | Collider x2 |  Collider x2  |  触发4次 Enter/Exit |

## 注意事项

- 角色进入触发器中，若此时隐藏掉触发器对象，不会触发Exit方法


# OnDisable

```
    private void OnDisable()
    {
        Debug.Log("OnDisable");
    }
```
- 游戏对象需要显示
- 当设置 enable = false 时触发
- 对象删除时触发
- 场景卸载时触发



# OnDestroy

```
    private void OnDestroy()
    {
        Debug.Log("OnDestroy");
    }
```

- 游戏对象需要显示
- **enabel 不影响调用**
- 对象删除时触发
- 场景卸载时触发