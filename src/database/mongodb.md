# MongoDb

[官方文档](https://mongodb.github.io/mongo-csharp-driver/2.0/reference/bson/mapping/)

[MongoDB C#驱动程序](https://www.mongodb.com/docs/drivers/csharp/current/)

[Mongosh 文档](https://www.mongodb.com/zh-cn/docs/mongodb-shell/#std-label-mdb-shell-overview)

## Windows

### 重启

在 Windows 上安装 MongoDB 后，你可以按照以下步骤重启 MongoDB 服务：

#### 使用命令提示符（适用于服务安装）

打开命令提示符：以管理员身份运行命令提示符。

停止 MongoDB 服务：

```bash
net stop MongoDB
```

启动 MongoDB 服务：

```bash
net start MongoDB
```

重启 MongoDB 服务（可以直接使用此命令代替上述两个命令）：

```bash
net stop MongoDB && net start MongoDB
```

#### 使用 Windows 服务管理器

打开服务管理器：

按 Win + R，输入 services.msc，然后按回车。
找到 MongoDB 服务：

在服务列表中找到 MongoDB 或者 MongoDB Server。
重启服务：

右键点击 MongoDB 服务，选择 重启。或者选择 停止，然后再点击 启动。

#### 手动启动和停止（适用于手动启动的 MongoDB）

停止 MongoDB：

打开命令提示符，执行以下命令找到并终止 MongoDB 进程：

```bash
taskkill /f /im mongod.exe
```

启动 MongoDB：

通过命令提示符进入 MongoDB 安装目录，然后执行以下命令：

```bash
mongod --config "C:\Program Files\MongoDB\Server\5.0\bin\mongod.cfg"
```

配置文件路径根据你的安装路径调整。

通过这些步骤，你可以在 Windows 上重启 MongoDB 服务。

### 远程连接

⚠️⚠️⚠️ 设置远程连接，容易遭到攻击，谨慎使用 ⚠️⚠️⚠️

> 失败信息：mongodb远程连接出现connect ECONNREFUSED（连接被拒绝）错误的解决方法

**阿里云ECS(Windows Server)**

在 Windows 上安装，Mongodb 的配置文件中的 bind_ip 默认为 `127.0.0.1`，默认只有本机 IP 可以连接，需要将 `bind_ip` 配置为：`0.0.0.0`，标识接收任何 `IP` 的连接。默认只绑定了本机IP

配置文件地址： `C:\Program Files\MongoDB\Server\7.0\bin\mongod.cfg`

修改为如下图

```bash
# network interfaces
net:
  port: 27017
  bindIp: 0.0.0.0

```

重启 `net stop MongoDB && net start MongoDB`

## MacOS

### 重启

macOS 上安装 MongoDB 后，使用以下命令来重启 MongoDB 服务：

1. **停止 MongoDB 服务：**
  
```bash
brew services stop mongodb
```

2. **启动 MongoDB 服务：**

```bash
brew services stop mongodb
```

3. **重启 MongoDB 服务：**
   
```bash
brew services stop mongodb
```

如果你是手动启动的 MongoDB（而不是通过 `brew` 服务管理），你可以使用以下命令：

1. **停止 MongoDB：**
   
```bash
sudo pkill -f mongod
```

2. **启动 MongoDB：**
   进入 MongoDB 的安装目录，然后执行：
   
```bash
mongod --config /usr/local/etc/mongod.conf
```


这个命令假设你在安装时使用了默认的配置文件路径 `/usr/local/etc/mongod.conf`。如果你的配置文件位于其他路径，请替换为实际的路径。

通过这些步骤，你可以成功地在 macOS 上重启 MongoDB 服务。



## 用户管理

用户管理需要通过 Mongosh 操作，Mongosh 是嵌入到 MongoDB Compass 中的一个Javascript 运行环境，官方文档没怎么看懂

[官方 用户管理方式](https://www.mongodb.com/zh-cn/docs/mongodb-shell/reference/methods/#user-management-methods)

**添加用户**

```javascript

use admin

db.createUser({
    user:"admin",
    pwd:"tzj001",
    roles:[
    {role:"readWrite",db:"TSIM"}]
})
```

**删除 `admin` 用户**

```shell
db.drop("admin")
```


**查看当前用户**

```javascript
db.getUsers()
```

或者

```javascript
db.system.users.find()
```

或者

```javascript
show users
```

## 连接字符串

当在Web程序中配置MongoDB的连接字符串，有多种方式，简单的记录两种

**第一种**： 连接本机上的 **MongoDB** ,适用于服务程序和数据库在同一个主机

```txt
"ConnectionString": "mongodb://localhost:27017/数据库名称?authSource=admin",
```

**第二种**： 连接非本机上的 **MongoDB** ,使用密码连接

```txt
"ConnectionString": "mongodb://userName:password@domain:27017/数据库名称?authSource=admin",
```

**authSource=admin 说明**：认证源属于管理员级别

## 过滤器

当使用 MongoDB C# 驱动程序进行数据查询和操作时，可以通过 Builders `<T>`.Filter 构造过滤器（Filter），它们用于定义查询条件或者更新/删除操作的条件。以下是一些常用的过滤器方法及其用法解释：

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

Builders `<BsonDocument>`.Filter.AnyIn 方法用于创建一个数组字段的过滤器，该方法接受两个参数：

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


**使用情况**

1. 新版本中将某个属性或字段删除
2. 新版本中给某个属性或字段添加 `BsonIgnore` 特性

注意，若在基类中定义的属性，也需要在子类中添加此特性才有效！

## 时区

**原因1：** MongoDB自带的Date是UTC的时间，中国是东八区，所以差了8个小时。

**解决方法：** 在mongodb可视化工具Robomongo中，我们可以通过"Options" - “Display Dates in…” - "Local Timezone"来设置显示本地时间。

**原因2：** MongoDB中存储的时间是标准时间 `UTC +0:00`

**解决方法：** C#的驱动支持一个特性，将实体的时间属性上添加上这个特性并指时区就可以了。

例如：

```csharp
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

> 注意：我们安装 Mongodb 数据库时，并没有附带安装 mongodb 的命令行工具，需要另外下载

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

```cmd
mongodump --uri="mongodb://username:password@source_host:port/dbname" --out=/path/to/backup
```

这个命令会把 dbname 数据库的所有数据导出到指定路径 /path/to/backup。


### 定时备份

> ☀️最好创建定时任务，定时备份数据，避免数据丢失。


**一、创建定时任务脚本，示例：**

```bat
@echo off

:: 处理时间的小时数为个位数时，出现空格问题。使用0补位
set t=%time:~0,2%%time:~3,2%%time:~6,2%
set t=%t: =0%


:: 定义备份目录（可以根据需要更改）
set backupDir=C:\TZJ\TSIM\mongodb_backup\backup\%date:~0,4%-%date:~5,2%-%date:~8,2%-%t%

:: 创建备份目录
if not exist %backupDir% (
    mkdir %backupDir%
)

:: 备份 MongoDB 数据库（修改为实际的数据库和路径）
mongodump --uri="mongodb://localhost:27017/TSIM" --out=%backupDir%

:: 输出备份完成信息
echo Backup completed at %date% %time%

```

> ⚠️ 脚本注意事项
> - 需要处理当小时数小于10时出现空格，需要补位0
> - 脚本中不要出现 `pause`，否则在计划中，当前实例会一直存在，导致后续无法创建新实例（在设置中默认配置“请勿创建新实例”），即使设置了可以并行运行，那也会无限制的创建新实例，资源浪费。


**二、配置 Windows 任务计划程序**

通过 Windows 任务计划程序来定时执行上面的备份脚本。

步骤：

- 打开任务计划程序：按下 Win + S，搜索“任务计划程序”并打开。
- 创建基本任务：
- 在任务计划程序窗口中，点击右侧的“创建基本任务”。
- 为任务命名，例如“MongoDB 定时备份”。
- 选择触发器，例如每日、每周、每月等。比如选择“每日”。
- 设置时间，选择希望执行任务的时间。
- 设置操作：
- 在“操作”步骤，选择“启动程序”。
- 浏览并选择上一步中创建的批处理文件 (例如 backup_mongo.bat)。
- 完成任务：点击完成，任务将自动按照设置的计划执行。

**三、验证任务**

完成后可以手动运行任务以验证是否正常工作。在任务计划程序中，右键点击任务，选择“运行”，查看备份文件是否生成。

### 将备份文件传输到目标服务器

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

如果用户名或密码中包含特殊字符（如 @, :, # 等），需要对这些字符进行 URI 编码。你可以使用 [URL编码在线工具 ](https://www.bejson.com/enc/urlencode/) 来对特殊字符进行编码，常见的有：

- `@ 编码为 %40`
- `: 编码为 %3A`
- `# 编码为 %23`
- `% 编码为 %25`

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

## Windows 账户问题

使用 windwos 账户A 安装 MongoDB，切换到 windows 账户B 通过localhost:27017 来访问可能失败

这通常与文件和服务的权限设置有关。以下是详细的解决方法：

1. 为账户B授予MongoDB安装目录的访问权限
   - 打开 MongoDB 安装目录（通常是 C:\Program Files\MongoDB\Server\<version>\）。
   - 右键点击安装目录，选择“属性”。
   - 转到“安全”选项卡，点击“编辑”按钮。
   - 点击“添加”按钮，输入账户B的用户名，然后点击“检查名称”确认。
   - 为账户B授予“读取和运行”、“列出文件夹内容”、“读取”和其他必要的权限。
   - 点击“应用”并保存更改。
2. 配置MongoDB服务的权限（重启即可）
   - 打开“服务”窗口（按 Win + R，输入 services.msc，然后按 Enter）。
   - 找到 MongoDB 服务，右键点击选择“属性”。
   - 转到“登录”选项卡。
   - 选择“此账户”，然后输入账户A的用户名和密码。
   - 点击“应用”并重启MongoDB服务。

**备注：MongoDBCompass 的安装是在账户目录下：`C:\Users\XXX\AppData\Local\MongoDBCompass`**
