# Zenject

[官网github](https://github.com/modesttree/Zenject)

## 注入

- 带Id的注入：[Inject(Id ="myId")] Transform myTransform;


## 执行顺序

### MonoBehaviour

普通的MonoBehavior执行顺序就是 Awake -> Start

加入Zennject有个 **方法注入**，执行顺序：注入的方法 > wake -> Start

```
void Awake()
{
    Debug.Log(2);    
}

void Start()
{
    Debug.Log(3);  
}

[Inject]
void Construct()
{
    Debug.Log(1);
}

```

以上的代码按顺序输出 1 2 3

需要注意一下几点：

- 在 注入方法 中 执行gameobject.SetActive(false); //无效
- 在 Awake 中 执行 gameobject.SetActive(false); 那么 Start 不会 被执行

```

void Awake()
{
    Debug.Log(2);   
    gameobject.SetActive(false); //Start函数不会被执行     
}

void Start()
{
    Debug.Log(3);  
}

[Inject]
void Construct()
{
    Debug.Log(1);
    gameobject.SetActive(false); //无效
}

```

以上的代码按顺序输出 1 2

## 与UniRx联合使用

1. 添加预定义UniRx是一个将Reactive Extensions带到Unity的库。 通过将类之间的某种通信视为数据的“流”，可以大大简化您的代码。

2. 默认情况下，UniRx的Zenject是禁用的。启用方式：必须将定义`ZEN_SIGNALS_ADD_UNIRX` 添加到项目， Edit -> Project Settings -> Player，将ZEN_SIGNALS_ADD_UNIRX添加进“Scripting Define Symbols"
对于zenject版本7.0.0，您还必须将Zenject.asmdef文件更改为以下内容：

```
    {
        "name": "Zenject",
        "references": [
            "UniRx"
        ]
    }

```

## Resovel ID 失败

1. 检查Container是否是任务场景的容器，如果是父容器会失败

2. 检查 id 是否存在多个，当存在多个时，调用解析一个的方法会失败






