# MongoDb

[官方文档](https://mongodb.github.io/mongo-csharp-driver/2.0/reference/bson/mapping/)

[MongoDB C#驱动程序](https://www.mongodb.com/docs/drivers/csharp/current/)

## 过滤器

当使用 MongoDB C# 驱动程序进行数据查询和操作时，可以通过 Builders`<T>`.Filter 构造过滤器（Filter），它们用于定义查询条件或者更新/删除操作的条件。以下是一些常用的过滤器方法及其用法解释：

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

- Gte（greater than or equal）：大于等于

- Gt（greater than）：大于

- Lte（less than or equal）：小于等于

- Lt（less than）：小于


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

**用法示例**

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

**解释**

Builders`<BsonDocument>`.Filter.AnyIn 方法用于创建一个数组字段的过滤器，该方法接受两个参数：

第一个参数是字段名 "interests"，这是你要进行过滤的数组字段。

第二个参数是一个 BsonArray，其中包含了要匹配的值的列表。在上面的例子中，我们使用了 new BsonArray { "Music", "Sports" } 来表示我们要查询包含 "Music" 或 "Sports" 的兴趣爱好的文档。

**注意事项**

AnyIn 方法是针对数组字段进行查询的一种特定方式。它只匹配数组中至少包含一个指定值的文档。如果数组字段中同时包含了多个指定值，文档也会被匹配。
在实际应用中，可以根据具体的业务需求和数据结构来灵活使用 AnyIn 方法，从而实现复杂的查询操作。
以上是关于 AnyIn 方法在 MongoDB C# 驱动程序中的基本用法和示例解释。

### 总结

以上是一些常见的 MongoDB C# 驱动程序中过滤器方法的用法。它们可以帮助你构建灵活且强大的查询条件，以满足各种数据查询、更新和删除的需求。在实际应用中，根据具体的业务需求和数据结构，你可以灵活地组合这些方法来实现复杂的数据操作。

## 事务

[官方文档](https://www.mongodb.com/docs/manual/core/transactions/)

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
**类特性描述**：反序列化时用来忽略多余的字段，一般版本兼容需要考虑，低版本的协议需要能够反序列化高版本的内容,否则新版本删除字段，旧版本结构反序列化会出错

## 时区

**原因1：** MongoDB自带的Date是UTC的时间，中国是东八区，所以差了8个小时。

**解决方法：** 在mongodb可视化工具Robomongo中，我们可以通过"Options" - “Display Dates in…” - "Local Timezone"来设置显示本地时间。

**原因2：** MongoDB中存储的时间是标准时间 `UTC +0:00`

**解决方法：** C#的驱动支持一个特性，将实体的时间属性上添加上这个特性并指时区就可以了。

例如：

``` csharp
[BsonDateTimeOptions(Kind = DateTimeKind.Local)]
public DateTime CreateTime{get;set;}
```


## 数据库迁移

> Windows 环境
> 工具：Cmd、PowerShell

将 MongoDB 数据库迁移到另一台服务器或集群通常涉及以下几个步骤：

1. 安装 Mongodb 数据库工具
2. 备份现有数据库
3. 将备份文件传输到目标服务器
4. 在目标服务器上恢复备份

具体步骤如下：


### 安装 MongoDB 数据库工具

>注意：我们安装 Mongodb 数据库时，并没有附带安装 mongodb 的命令行工具，需要另外下载

**1. 下载工具**

- 访问 [MongoDB Command Line Database Tools Download](https://www.mongodb.com/try/download/database-tools)

- 选择适用于你的操作系统（Windows）的安装包进行下载。

**2. 安装工具**

下载完成后，解压缩安装包并将其内容放置在你希望安装的目录中，例如 C:\mongodb-database-tools。

**3. 配置环境变量**

为了在命令提示符中使用 `mongodump` 和 `mongorestore` 命令，需要将 MongoDB 数据库工具的安装路径添加到系统的 PATH 环境变量中：



- 右键单击“此电脑”或“计算机”图标，然后选择“属性”。
- 在左侧菜单中选择“高级系统设置”。
- 在“系统属性”窗口中，点击“环境变量”按钮。



- 在“系统变量”部分找到并选择 Path 变量，然后点击“编辑”。
- 在“编辑环境变量”窗口中，点击“新建”，并输入 MongoDB 数据库工具的安装路径，例如 `C:\mongodb-database-tools\bin`。
- 点击“确定”保存更改。

**4. 重启命令提示符：**

关闭所有打开的命令提示符窗口，然后重新打开一个新的命令提示符窗口，以确保更改生效。
  
**5. 验证安装**

打开新的命令提示符窗口，输入以下命令以验证 mongodump 是否可用：


```powershell
mongodump --version
```
如果命令输出了版本信息，则说明安装和配置成功，现在，可以使用 mongodump 和 mongorestore 命令来备份和恢复 MongoDB 数据库。


### 备份现有数据库

你可以使用 mongodump 工具来创建数据库的备份。以下是命令示例：


``` cmd
mongodump --uri="mongodb://username:password@source_host:port/dbname" --out=/path/to/backup
```
这个命令会把 dbname 数据库的所有数据导出到指定路径 /path/to/backup。



###  将备份文件传输到目标服务器
你可以使用 scp 命令（对于 Linux）或其他文件传输工具（如 SFTP、FTP 等）将备份文件传输到目标服务器：

Windows

通过远程桌面直接拷贝即可。

Linux
```bash
scp -r /path/to/backup user@target_host:/path/to/destination
```


### 在目标服务器上恢复备份

在目标服务器上使用 mongorestore 工具来恢复备份的数据：

```bash
mongorestore --uri="mongodb://username:password@target_host:port/dbname" /path/to/destination/backup
```


### 异常处理   

SASL（Simple Authentication and Security Layer）错误通常与身份验证和安全相关，特别是在连接到 MongoDB 时使用用户名和密码进行身份验证时。为了排查和解决这个问题，请按照以下步骤操作：

**1. 检查连接字符串**
   
确保你的连接字符串格式正确，包括用户名、密码、主机和端口，例如：

```bash
mongodb://username:password@source_host:port/dbname
```

**2. 使用 URI 编码特殊字符**

如果用户名或密码中包含特殊字符（如 @, :, # 等），需要对这些字符进行 URI 编码。你可以使用在线工具来对特殊字符进行编码。例如：

- `@ 编码为 %40`
- `: 编码为 %3A`
- `# 编码为 %23`

例如，如果密码是 pa@ss:word#123，则连接字符串应为：

```bash
mongodb://username:pa%40ss%3Aword%23123@source_host:port/dbname
```
**3. 使用 --authenticationDatabase 选项**

如果用户名和密码属于 admin 数据库（或其他非目标数据库），需要指定 --authenticationDatabase 选项。例如：

备份数据库：

```bash
mongodump --uri="mongodb://username:password@source_host:27017/dbname" 
--authenticationDatabase="admin" --out="C:\path\to\backup"
```
恢复数据库：

```bash
mongorestore --uri="mongodb://username:password@target_host:27017/dbname" --authenticationDatabase="
```

**4. 启用 SCRAM-SHA-1 或 SCRAM-SHA-256**

MongoDB 3.0 及以上版本默认使用 SCRAM-SHA-1 进行身份验证，MongoDB 4.0 及以上版本默认使用 SCRAM-SHA-256。如果你的 MongoDB 服务器配置了不同的身份验证机制，需要确保客户端也支持该机制。


### 其他注意事项

**确保版本兼容性**：确保源 MongoDB 服务器和目标 MongoDB 服务器的版本兼容。如果版本差异过大，可能需要进行数据格式的转换。

**网络带宽和速度**： 考虑到数据传输的时间和速度，特别是对于大数据量的情况下，可能需要更长的时间。

**安全性**：在传输敏感数据时，请确保使用安全的传输协议和方法。

### 使用 MongoDB Atlas
如果你使用的是 MongoDB Atlas，MongoDB 官方提供了一些迁移工具，如 mongomirror，可以帮助你将自托管的 MongoDB 数据库迁移到 Atlas 上。这些工具可以实现实时数据同步和迁移。

### 在线迁移
如果你需要在迁移过程中保持数据库的高可用性，可以考虑使用 MongoDB 的副本集（replica set）来进行无缝迁移。这个方法更为复杂，但可以确保在迁移过程中数据的持续可用。


