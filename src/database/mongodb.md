# MongoDb

[官方文档](https://mongodb.github.io/mongo-csharp-driver/2.0/reference/bson/mapping/)

## MongoDB C#驱动程序

https://www.mongodb.com/docs/drivers/csharp/current/



## 事务处理

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

## 时区

**原因1：** MongoDB自带的Date是UTC的时间，中国是东八区，所以差了8个小时。
解决方法：在mongodb可视化工具Robomongo中，我们可以通过"Options" - “Display Dates in…” - "Local Timezone"来设置显示本地时间。

**原因2：** MongoDB中存储的时间是标准时间UTC +0:00
解决方法：C#的驱动支持一个特性，将实体的时间属性上添加上这个特性并指时区就可以了。

例如：

``` csharp
[BsonDateTimeOptions(Kind = DateTimeKind.Local)]
public DateTime CreateTime{get;set;}
```
