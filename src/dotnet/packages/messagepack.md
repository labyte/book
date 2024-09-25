# Messagepack

速度超快的序列化工具。

## Union 使用

* 当存在多层多态时，在最基类上标注所有的子类
* 中间层为抽象层也需要使用Union

```C#
/*Union应用所有的实现类*/
[MessagePack.Union(0, typeof(Foo1))]
[MessagePack.Union(1, typeof(Foo2))]
[MessagePack.Union(2, typeof(Bar1))]
public interface Root { }

[MessagePackObject]
[MessagePack.Union(0, typeof(Foo1))] //中间层使用Union,否则报错
[MessagePack.Union(1, typeof(Foo2))] //中间层使用Union,否则报错
public abstract class FooRoot : Root
{
    [Key(0)] public string F1 { get; set; }

}

[MessagePackObject]
[MessagePack.Union(0, typeof(Bar1))] //中间层使用Union,否则报错
public abstract class BarRoot : Root { }

[MessagePackObject]

public class Foo1 : FooRoot { [Key(1)] public string Name { get; set; } }
[MessagePackObject]

public class Foo2 : FooRoot { [Key(1)] public string Name { get; set; } }


[MessagePackObject]
public class Bar1 : BarRoot { [Key(0)] public string Name { get; set; } }



public class Test
{

    public static void TestMessagepack()
    {
        List<Root> arr = new List<Root>();
        arr.Add(new Foo1() {  F1 = "f" , Name = " nam"});
        arr.Add(new Bar1() {  Name = "b"});

        var bin = MessagePackSerializer.Serialize(arr);
        var list = MessagePackSerializer.Deserialize<List<Root>>(bin);
        foreach (var item in list)
        {
            Console.WriteLine("00");
        }
    }

}
```

## Mpc

进行AOT编译时，请仔细检查输出信息，是否有错误，这一步导致的错误，在后面无法跟踪查找
