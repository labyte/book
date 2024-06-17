# MongoDb

[官方文档](https://mongodb.github.io/mongo-csharp-driver/2.0/reference/bson/mapping/)

[MongoDB C#驱动程序](https://www.mongodb.com/docs/drivers/csharp/current/)


## 过滤器

当使用 MongoDB C# 驱动程序进行数据查询和操作时，可以通过 Builders<T>.Filter 构造过滤器（Filter），它们用于定义查询条件或者更新/删除操作的条件。以下是一些常用的过滤器方法及其用法解释：

### Eq 方法
Eq 方法用于创建一个等于（equal）条件的过滤器。它适用于需要匹配指定字段与特定值相等的情况。

```csharp
var filter = Builders<BsonDocument>.Filter.Eq("fieldName", value);
```

例如，如果要查询字段 "name" 等于 "Alice" 的文档，可以使用：

```csharp
var filter = Builders<BsonDocument>.Filter.Eq("name", "Alice");
```

### In 方法

In 方法用于创建一个包含于（in）条件的过滤器。它用于匹配指定字段的值在一个给定的列表或集合中的情况。

```csharp
var filter = Builders<BsonDocument>.Filter.In("fieldName", values);
```

例如，如果要查询字段 "department" 的值在 ["IT", "HR", "Finance"] 中的文档，可以使用：

```csharp
var filter = Builders<BsonDocument>.Filter.In("department", new List<string> { "IT", "HR", "Finance" });
```



### And 方法
And 方法用于创建一个与（and）条件的过滤器，即多个条件必须同时满足。

```csharp
var filter = Builders<BsonDocument>.Filter.And(
    Builders<BsonDocument>.Filter.Eq("field1", value1),
    Builders<BsonDocument>.Filter.Eq("field2", value2)
);
```

例如，如果要查询同时满足 "name" 等于 "Alice" 和 "age" 大于等于 30 的文档，可以使用：

```csharp
var filter = Builders<BsonDocument>.Filter.And(
    Builders<BsonDocument>.Filter.Eq("name", "Alice"),
    Builders<BsonDocument>.Filter.Gte("age", 30)
);
```

### Gte, Gt, Lte, Lt 等方法
这些方法用于创建比较条件的过滤器：

Gte（greater than or equal）：大于等于
Gt（greater than）：大于
Lte（less than or equal）：小于等于
Lt（less than）：小于

```csharp
var filter = Builders<BsonDocument>.Filter.Gte("fieldName", value);
```
例如，如果要查询 "score" 大于等于 80 的文档，可以使用：

```csharp
var filter = Builders<BsonDocument>.Filter.Gte("score", 80);
```

### 组合多种过滤器
你可以通过组合多个过滤器来构建复杂的查询条件。例如，如果要查询 "department" 是 "IT" 或者 "HR" 且 "age" 大于等于 25 的文档，可以这样组合：

```csharp
var filter = Builders<BsonDocument>.Filter.And(
    Builders<BsonDocument>.Filter.In("department", new List<string> { "IT", "HR" }),
);
```

### AnyIn 方法

在 MongoDB 的 C# 驱动程序中，AnyIn 方法用于创建一个过滤器，用于检查一个数组字段中是否至少包含一个指定的值。这在需要查询数组字段中是否存在特定元素的情况下非常有用。

用法示例
假设你有一个文档结构如下：

```json
{
  "_id": ObjectId("60a9e54d95b06b84cf6e832f"),
  "name": "Alice",
  "interests": ["Reading", "Music", "Sports"]
}
```
其中，interests 是一个数组字段，包含了 Alice 的兴趣爱好。

如果你想要查询具有特定兴趣爱好的文档，例如查询兴趣包括 "Music" 或 "Sports" 的文档，可以使用 AnyIn 方法来构建过滤器：

```csharp
var filter = Builders<BsonDocument>.Filter.AnyIn("interests", new BsonArray { "Music", "Sports" });
```
解释
Builders<BsonDocument>.Filter.AnyIn 方法用于创建一个数组字段的过滤器，该方法接受两个参数：
第一个参数是字段名 "interests"，这是你要进行过滤的数组字段。
第二个参数是一个 BsonArray，其中包含了要匹配的值的列表。在上面的例子中，我们使用了 new BsonArray { "Music", "Sports" } 来表示我们要查询包含 "Music" 或 "Sports" 的兴趣爱好的文档。
注意事项
AnyIn 方法是针对数组字段进行查询的一种特定方式。它只匹配数组中至少包含一个指定值的文档。如果数组字段中同时包含了多个指定值，文档也会被匹配。
在实际应用中，可以根据具体的业务需求和数据结构来灵活使用 AnyIn 方法，从而实现复杂的查询操作。
以上是关于 AnyIn 方法在 MongoDB C# 驱动程序中的基本用法和示例解释。


### 总结
以上是一些常见的 MongoDB C# 驱动程序中过滤器方法的用法。它们可以帮助你构建灵活且强大的查询条件，以满足各种数据查询、更新和删除的需求。在实际应用中，根据具体的业务需求和数据结构，你可以灵活地组合这些方法来实现复杂的数据操作。

## 事务

https://www.mongodb.com/docs/manual/core/transactions/

```C#
// For a replica set, include the replica set name and a seedlist of the members in the URI string; e.g.
// string uri = "mongodb://mongodb0.example.com:27017,mongodb1.example.com:27017/?replicaSet=myRepl";
// For a sharded cluster, connect to the mongos instances; e.g.
// string uri = "mongodb://mongos0.example.com:27017,mongos1.example.com:27017/";
var client = new MongoClient(connectionString);

// Prereq: Create collections.
var database1 = client.GetDatabase("mydb1");
var collection1 = database1.GetCollection<BsonDocument>("foo").WithWriteConcern(WriteConcern.WMajority);
collection1.InsertOne(new BsonDocument("abc", 0));

var database2 = client.GetDatabase("mydb2");
var collection2 = database2.GetCollection<BsonDocument>("bar").WithWriteConcern(WriteConcern.WMajority);
collection2.InsertOne(new BsonDocument("xyz", 0));

// Step 1: Start a client session.
using (var session = client.StartSession())
{
    // Step 2: Optional. Define options to use for the transaction.
    var transactionOptions = new TransactionOptions(
        writeConcern: WriteConcern.WMajority);

    // Step 3: Define the sequence of operations to perform inside the transactions
    var cancellationToken = CancellationToken.None; // normally a real token would be used
    result = session.WithTransaction(
        (s, ct) =>
        {
            collection1.InsertOne(s, new BsonDocument("abc", 1), cancellationToken: ct);
            collection2.InsertOne(s, new BsonDocument("xyz", 999), cancellationToken: ct);
            return "Inserted into collections in different databases";
        },
        transactionOptions,
        cancellationToken);
}
```

## Bson序列化特性

### BsonIgnoreExtraElements

- 类特性
- 描述：反序列化时用来忽略多余的字段，一般版本兼容需要考虑，低版本的协议需要能够反 序列化高版本的内容,否则新版本删除字段，旧版本结构反序列化会出错

