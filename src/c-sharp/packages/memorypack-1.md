# MemoryPack 基础知识

[Cysharp](https://cysharp.co.jp/)发布了一个新的序列化器。


[Cysharp/内存包](https://github.com/Cysharp/MemoryPack)

[原文](https://spacekey.dev/memorypack-1)


过去，当我在寻找一种提高与 ASP.NET Core API 服务器交互效率的方法时，我尝试过类似 MessagePack 的东西，但客户端是 Xamarin 或者非 C# web。过去，我放弃了，因为我认为这会很麻烦。 但是，不再需要 MemoryPack 和 mpc，并且现在可以使用 TypeScript 客户端，所以如果当时可以使用它，我肯定会使用它。

一般来说，我认为与API服务器的通信通常使用JSON来完成，但这是因为客户端通常使用基于JavaScript的技术，因此它具有高度兼容性，并且像REST客户端一样处理流动数据很容易。看一下，数据结构、字段名称和一些类型很容易用人眼理解，而且它是一个向公众开放并被很多人使用的API，所以我认为它是一种通用语言。这是一种由于多种原因而扎根的方法，例如人们在一定意义上采用它，并且人们已经这样做了很长时间。

但是，如果数据仅在服务器和应用程序之间的封闭空间中交换，则不需要是 JSON。

例如，在支持公司运营并使用Web或移动设备作为客户端的系统中，流动数据的可读性并不重要，而应该提高与API服务器的交互效率。乖一点。 （我以前用过一个系统，为了减少数据的大小，对字段名进行了符号化，但是当我仔细查看数据时，我发现如果删除一些未使用的字段，它会小很多。 ” 与回忆一样）

如果您只需更换序列化器就可以做到这一点，那么值得一试。 是的，仅仅尝试一下 MemoryPack 就会比购买一些奇怪的锅更让你高兴。

**基本的**

让我们从序列化和反序列化的基础知识开始。

现在，在新的控制台应用程序 (.NET 6) 上安装 MemoryPack...

```shell
PM> Install-Package MemoryPack
```

Program.cs 像这样...

```
using MemoryPack;

var bin = MemoryPackSerializer.Serialize(new TestClass
{
    Id = 100,
    Name = "Hello"
});

var obj = MemoryPackSerializer.Deserialize<TestClass>(bin);

if (obj != null)
    Console.WriteLine($"{obj.Id}:{obj.Name}");

[MemoryPackable]
public partial class TestClass
{
    public int Id { get; set; }
    public string Name { get; set; } = default!;
}
```
执行

```
100:Hello
```

只需将要序列化的类设为部分并添加 MemoryPackable 属性即可。剩下要做的就是像 JSON 一样对其进行序列化/反序列化。

**笔记**

至于格式，只是从前面按顺序提取字段值（和类型）并打包，因此对于一个MemoryPackable类来说，

更改字段的顺序
改变形状
在已存在的字段之前添加字段
如果您进行这样的更改，您将无法反序列化。因此，在更改已经运行的系统的数据结构时必须小心。

不过，下面的情况是没问题的。

之后添加字段
重命名而不更改字段顺序和类型
*补充说明：2022/11/10
在ver1.5.0中，添加了一个功能来缓解此限制。 →[我想使用 MemoryPack 5 - VersionTolerant](https://spacekey.dev/memorypack-5)

**概括**

在应用程序等中保存数据时，很多情况下会将数据序列化为 JSON 并保存为文本文件，但您可以将其替换为 MemoryPack。

好吧，我认为这样的操作不需要那么快的速度，但是从 JsonResponseModel 的图中可以看出，它比 .NET 的 JsonSerializer 快大约 20 倍，所以如果你正在处理大数据，那么它是一个很好的选择经验可能有足够的差异。在由于某种原因频繁将数据导出到文件的情况下，这将逐渐变得更加有效。而且，如果文件大小较小，那么读写所需的时间也会减少，所以完全没有问题。

在“写入文件，但仅在应用程序中使用该文件”的情况下，JSON 和二进制文件都是相同的，并且由于 .NET 的 BinaryFormatter 计划被弃用，因此可以将其替换为类似的内容。 我不知道。毕竟，只要您处理的是简单的类，`[MemoryPackable]` 您只需要添加 .

现在我们已经了解了基本用法，让我们尝试将其与 ASP.NET Core 一起使用。