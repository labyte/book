# SignalR

[Signal Sample](https://gitee.com/AByte-L/csharp-dev-demo/tree/master/AspNetCore/SignalRSample/doc)# SignalR

## 中心

### 配置中心

若要注册 SignalR 中心所需的服务，请调用 Program.cs 中的 AddSignalR：

```C#
var builder = WebApplication.CreateBuilder(args);

builder.Services.AddRazorPages();
builder.Services.AddSignalR();
```

若要配置 SignalR 终结点，请调用同时在 Program.cs 中的 MapHub：

```C#
app.MapRazorPages();
app.MapHub<ChatHub>("/Chat");

app.Run();
```

> ⚠️ 备注
> ASP.NET Core SignalR 服务器端程序集现在随 .NET Core SDK 一起安装。 有关详细信息，请参阅共享框架中的 SignalR 程序集。

### 创建和使用中心

通过声明从 Hub 继承的类来创建中心。 将 public 方法添加到类，使其可从客户端调用：

```C#
public class ChatHub : Hub
{
    public async Task SendMessage(string user, string message)
        => await Clients.All.SendAsync("ReceiveMessage", user, message);
}
```

 ⚠️ 备注

**中心是暂时性的：**

- 请勿将状态存储在中心类的属性中。 每个中心方法调用都在新的中心实例上执行。
- 请勿通过依赖关系注入直接实例化中心。 若要从应用程序中的其他位置向客户端发送消息，请使用 IHubContext。
- 调用依赖于保持活动状态的中心的异步方法时请使用 await。 例如，如果在没有 await 的情况下进行调用，则 Clients.All.SendAsync(...) 这类方法会失败，并且中心方法会在 SendAsync 完成之前完成。

### 上下文对象

Hub 类具有一个 Context 属性，该属性包含具有连接相关信息的以下属性：

| 属性           | 说明                                                                                                                  | 解释 |
| -------------- | --------------------------------------------------------------------------------------------------------------------- | ---- |
| ConnectionId   | 获取连接的唯一 ID（由 SignalR 分配）。 每个连接有一个连接 ID。                                                        | 每次调用方法时，Hub都是新示例     |
| UserIdentifier | 获取用户标识符。 默认情况下，SignalR 使用与连接关联的 ClaimsPrincipal 中的 ClaimTypes.NameIdentifier 作为用户标识符。 |      |
|User|获取与当前用户关联的 ClaimsPrincipal。||
|Items|获取可用于在此连接范围内共享数据的键/值集合。 数据可以存储在此集合中，会在不同的中心方法调用间为连接持久保存。||
|Features|获取连接上可用的功能的集合。 目前，在大多数情况下不需要此集合，因此未对其进行详细记录。||
|ConnectionAborted|获取一个 CancellationToken，它会在连接中止时发出通知。||


Hub.Context 还包含以下方法：


| 方法           | 说明                                                                                                                  | 解释 |
| -------------- | --------------------------------------------------------------------------------------------------------------------- | ---- |
| GetHttpContext   | 返回连接的 HttpContext，如果连接不与 HTTP 请求关联，则返回 null。 对于 HTTP 连接，可以使用此方法获取 HTTP 标头和查询字符串等信息。                                                        | 每次调用方法时，Hub都是新示例     |
| Abort | 中止连接。 |      |
	
	
	
