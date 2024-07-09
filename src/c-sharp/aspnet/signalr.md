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

>⚠️ 备注
>
>**中心是暂时性的：**
>
>- 请勿将状态存储在中心类的属性中。 每个中心方法调用都在新的中心实例上执行。
>- 请勿通过依赖关系注入直接实例化中心。 若要从应用程序中的其他位置向客户端发送消息，请使用 IHubContext。
>- 调用依赖于保持活动状态的中心的异步方法时请使用 await。 例如，如果在没有 await 的情况下进行调用，则 Clients.All.SendAsync(...) 这类方法会失败，并且中心方法会在 SendAsync 完成之前完成。

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
	
	
	
### 客户端对象
Hub 类具有一个 Clients 属性，该属性包含适用于服务器与客户端之间的通信的以下属性：

|属性|	说明|解释|
| -------------- | --------------------------------------------------------------------------------------------------------------------- | ---- |
|All	|对所有连接的客户端调用方法||
|Caller	|对调用了中心方法的客户端调用方法||
|Others	|对所有连接的客户端调用方法（调用了方法的客户端除外）||
|Hub.Clients |还包含以下方法：||

|方法	|说明|解释|
| -------------- | --------------------------------------------------------------------------------------------------------------------- | ---- |
|AllExcept	|对所有连接的客户端调用方法（指定连接除外）||
|Client	|对连接的一个特定客户端调用方法||
|Clients	|对连接的多个特定客户端调用方法||
|Group	|对指定组中的所有连接调用方法||
|GroupExcept	|对指定组中的所有连接调用方法（指定连接除外）||
|Groups	|对多个连接组调用方法||
|OthersInGroup	|对一个连接组调用方法（不包括调用了中心方法的客户端）||
|User	|对与一个特定用户关联的所有连接调用方法||
|Users	|对与多个指定用户关联的所有连接调用方法||

以上表中的每个属性或方法都返回具有 SendAsync 方法的对象。 SendAsync 方法接收要调用的客户端方法的名称和任何参数。

Client 和 Caller 方法返回的对象还包含一个 InvokeAsync 方法，该方法可用于等待来自客户端的结果。


### 向客户端发送消息
若要对特定客户端发出调用，请使用 Clients 对象的属性。 在下面的示例中，有三个中心方法：

- SendMessage 使用 Clients.All 将消息发送到所有连接的客户端。
- SendMessageToCaller 使用 Clients.Caller 将消息发送回调用方。
- SendMessageToGroup 将消息发送给 SignalR Users 组中的所有客户端。

```C#
public async Task SendMessage(string user, string message)
    => await Clients.All.SendAsync("ReceiveMessage", user, message);

public async Task SendMessageToCaller(string user, string message)
    => await Clients.Caller.SendAsync("ReceiveMessage", user, message);

public async Task SendMessageToGroup(string user, string message)
    => await Clients.Group("SignalR Users").SendAsync("ReceiveMessage", user, message);
```

### 强类型中心
使用 SendAsync 的缺点在于，它依赖于字符串来指定要调用的客户端方法。 如果客户端中的方法名称拼写错误或缺失，则这会使代码可能出现运行时错误。

使用 SendAsync 的替代方法是使用 Hub<T> 将 Hub 类设为强类型。 在下面的示例中，ChatHub 客户端方法提取到名为 IChatClient 的接口中：

```C#
public interface IChatClient
{
    Task ReceiveMessage(string user, string message);
}
```
此接口可用于将上面的 ChatHub 示例重构为强类型：

```C#
public class StronglyTypedChatHub : Hub<IChatClient>
{
    public async Task SendMessage(string user, string message)
        => await Clients.All.ReceiveMessage(user, message);

    public async Task SendMessageToCaller(string user, string message)
        => await Clients.Caller.ReceiveMessage(user, message);

    public async Task SendMessageToGroup(string user, string message)
        => await Clients.Group("SignalR Users").ReceiveMessage(user, message);
}
```

使用 Hub<IChatClient> 可以对客户端方法进行编译时检查。 这可防止由于使用字符串而导致的问题，因为 Hub<T> 只能提供对接口中定义的方法的访问。 使用强类型 Hub<T> 会禁止使用 SendAsync。

>**备注**
>
>Async 后缀不会从方法名称中去除。 除非使用 .on('MyMethodAsync') 定义客户端方法，否则不要使用 MyMethodAsync 作为名称。

### 客户端结果
除了对客户端进行调用外，服务器还可以从客户端请求结果。 这要求服务器使用 ISingleClientProxy.InvokeAsync，并且客户端从其 .On 处理程序返回结果。

有两种方法可以在服务器上使用 API，第一种方法是在中心方法中对 Clients 属性调用 Client(...) 或 Caller：

```C#
public class ChatHub : Hub
{
    public async Task<string> WaitForMessage(string connectionId)
    {
        var message = await Clients.Client(connectionId).InvokeAsync<string>(
            "GetMessage");
        return message;
    }
}
```

第二种方法是对 IHubContext<T> 的实例调用 Client(...)：

```C#
async Task SomeMethod(IHubContext<MyHub> context)
{
    string result = await context.Clients.Client(connectionID).InvokeAsync<string>(
        "GetMessage");
}
```
强类型中心还可以从接口方法返回值：

```C#
public interface IClient
{
    Task<string> GetMessage();
}

public class ChatHub : Hub<IClient>
{
    public async Task<string> WaitForMessage(string connectionId)
    {
        string message = await Clients.Client(connectionId).GetMessage();
        return message;
    }
}
```

客户端在其 .On(...) 处理程序中返回结果，如下所示：

#### .NET 客户端

```C#
hubConnection.On("GetMessage", async () =>
{
    Console.WriteLine("Enter message:");
    var message = await Console.In.ReadLineAsync();
    return message;
});
```
#### Typescript 客户端

```TypeScript
hubConnection.on("GetMessage", async () => {
    let promise = new Promise((resolve, reject) => {
        setTimeout(() => {
            resolve("message");
        }, 100);
    });
    return promise;
});

```
#### Java 客户端

```Java
hubConnection.onWithResult("GetMessage", () -> {
    return Single.just("message");
});
```

更改中心方法的名称
默认情况下，服务器中心方法名称是 .NET 方法的名称。 若要更改特定方法的此默认行为，请使用 HubMethodName 属性。 调用方法时，客户端应使用此名称，而不是 .NET 方法名称：

```C#
[HubMethodName("SendMessageToUser")]
public async Task DirectMessage(string user, string message)
    => await Clients.User(user).SendAsync("ReceiveMessage", user, message);
```

### 将服务注入中心

中心构造函数可以接受 DI 中的服务作为参数，这些参数可以存储在类的属性中，以便在中心方法中使用。

为不同的中心方法注入多个服务或作为编写代码的替代方法时，中心方法也可以接受来自 DI 的服务。 默认情况下，如果可能，将从 DI 检查和解析中心方法参数。

```C#
services.AddSingleton<IDatabaseService, DatabaseServiceImpl>();

// ...

public class ChatHub : Hub
{
    public Task SendMessage(string user, string message, IDatabaseService dbService)
    {
        var userName = dbService.GetUserName(user);
        return Clients.All.SendAsync("ReceiveMessage", userName, message);
    }
}
```

如果不需要隐式解析来自服务的参数，请使用 DisableImplicitFromServicesParameters 禁用它。 若要在中心方法中显式指定从 DI 解析的参数，请使用 DisableImplicitFromServicesParameters 选项，并使用 [FromServices] 属性或自定义属性，该属性在应从 DI 解析的中心方法参数上实现 IFromServiceMetadata。

```C#
services.AddSingleton<IDatabaseService, DatabaseServiceImpl>();
services.AddSignalR(options =>
{
    options.DisableImplicitFromServicesParameters = true;
});

// ...

public class ChatHub : Hub
{
    public Task SendMessage(string user, string message,
        [FromServices] IDatabaseService dbService)
    {
        var userName = dbService.GetUserName(user);
        return Clients.All.SendAsync("ReceiveMessage", userName, message);
    }
}
```

>**备注**
>
>此功能使用 IServiceProviderIsService，通过 DI 实现来实现（可选）。 如果应用的 DI 容器不支持此功能，则不支持将服务注入中心方法。

### 依赖项注入中的键控服务支持

密钥服务是指使用密钥注册和检索依赖项注入 (DI) 服务的机制。 通过调用 AddKeyedSingleton （或 AddKeyedScoped 或 AddKeyedTransient）来注册服务，与密钥相关联。 使用 [FromKeyedServices] 属性指定密钥来访问已注册的服务。 以下代码演示如何使用键化服务：

```C#
using Microsoft.AspNetCore.SignalR;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddKeyedSingleton<ICache, BigCache>("big");
builder.Services.AddKeyedSingleton<ICache, SmallCache>("small");

builder.Services.AddRazorPages();
builder.Services.AddSignalR();

var app = builder.Build();

app.MapRazorPages();
app.MapHub<MyHub>("/myHub");

app.Run();

public interface ICache
{
    object Get(string key);
}
public class BigCache : ICache
{
    public object Get(string key) => $"Resolving {key} from big cache.";
}

public class SmallCache : ICache
{
    public object Get(string key) => $"Resolving {key} from small cache.";
}

public class MyHub : Hub
{
    public void SmallCacheMethod([FromKeyedServices("small")] ICache cache)
    {
        Console.WriteLine(cache.Get("signalr"));
    }

    public void BigCacheMethod([FromKeyedServices("big")] ICache cache)
    {
        Console.WriteLine(cache.Get("signalr"));
    }
}
```

为连接处理事件
SignalR 中心 API 提供 OnConnectedAsync 和 OnDisconnectedAsync 虚拟方法来管理和跟踪连接。 替代 OnConnectedAsync 虚拟方法可在客户端连接到中心时执行操作（例如将它添加到组）：

```C#
public override async Task OnConnectedAsync()
{
    await Groups.AddToGroupAsync(Context.ConnectionId, "SignalR Users");
    await base.OnConnectedAsync();
}
```

替代 OnDisconnectedAsync 虚拟方法可在客户端断开连接时执行操作。 如果客户端有意断开连接（例如通过调用 connection.stop()），则 exception 参数将设置为 null。 但是，如果客户端由于错误（例如网络故障）而断开连接，则 exception 参数将包含描述故障的异常：

```C#
public override async Task OnDisconnectedAsync(Exception? exception)
{
    await base.OnDisconnectedAsync(exception);
}
```

无需在 OnDisconnectedAsync 中调用 RemoveFromGroupAsync，系统会自动为你进行处理。

处理错误
在中心方法中引发的异常会发送到调用方法的客户端。 在 JavaScript 客户端上，invoke 方法会返回 JavaScript Promise。 客户端可以将 catch 处理程序附加到返回的承诺，或使用和 try/catch 和 async/await 来处理异常：

```JavaScript
try {
  await connection.invoke("SendMessage", user, message);
} catch (err) {
  console.error(err);
}
```

当中心引发异常时，连接不会关闭。 默认情况下，SignalR 将向客户端返回一般错误消息，如以下示例所示：

输出

```
Microsoft.AspNetCore.SignalR.HubException: An unexpected error occurred invoking 'SendMessage' on the server.
```

意外异常通常包含敏感信息，例如在数据库连接失败时触发的异常中会包含数据库服务器的名称。 作为安全措施，SignalR 在默认情况下不会公开这些详细错误消息。 有关为何禁止显示异常详细信息的详细信息，请参阅 ASP.NET Core SignalR 中的安全注意事项一文。

如果必须将异常情况传播到客户端，请使用 HubException 类。 如果在中心方法中引发 HubException，则 SignalR 会将整个消息发送到客户端（未修改）：

```C#
public Task ThrowException()
    => throw new HubException("This error will be sent to the client!");
```

>**备注**
>
>SignalR 仅将异常的 Message 属性发送到客户端。 异常中的堆栈跟踪和其他属性不可供客户端使用。


## 从中心外部发送

由于Hub每次调用都是新的示例，也就意味着Hub中的方法触发是被动的，只有客户端主动调用，服务端无法主动调用。那要实现服务端向客户端主动发送数据。

SignalR 中心是用于向连接到 SignalR 服务器的客户端发送消息的核心抽象。 你也可以使用 IHubContext 服务从应用中的其他位置发送消息。 本文介绍如何访问 SignalRIHubContext 以从中心外部向客户端发送通知。

>**备注**
>
>IHubContext 用于将通知发送到客户端，而非用于调用 Hub 上的方法。

### 获取 IHubContext 实例

在 ASP.NET Core SignalR 中，你可以通过依赖项注入来访问 IHubContext 实例。 你可以将 IHubContext 实例注入控制器、中间件或其他 DI 服务。 使用该实例向客户端发送消息。

### 在控制器中注入 IHubContext 实例
通过将 IHubContext 实例添加到构造函数，可以将其注入控制器：

```C#
public class HomeController : Controller
{
    private readonly IHubContext<NotificationHub> _hubContext;

    public HomeController(IHubContext<NotificationHub> hubContext)
    {
        _hubContext = hubContext;
    }
}
```

获权访问 IHubContext 实例后，就像在中心本身一样调用客户端方法：

```C#
public async Task<IActionResult> Index()
{
    await _hubContext.Clients.All.SendAsync("Notify", $"Home page loaded at: {DateTime.Now}");
    return View();
}
```

### 在中间件中获取 IHubContext 实例
访问中间件管道中的 IHubContext，如下所示：

```C#
app.Use(async (context, next) =>
{
    var hubContext = context.RequestServices
                            .GetRequiredService<IHubContext<ChatHub>>();
    //...
    
    if (next != null)
    {
        await next.Invoke();
    }
});
```


>**备注**
>
>当从 Hub 类外部调用客户端方法时，没有与该调用关联的调用方。 因此，无法访问 ConnectionId、Caller 和 >Others 属性。
>
>需要将用户映射到连接 ID 并保留该映射的应用可以执行以下操作之一：
>
>将单个或多个连接的映射保留为组。 有关详细信息，请参阅SignalR 中的组。
>通过单一实例服务保留连接和用户信息。 有关详细信息，请参阅将服务注入中心。 单一实例服务可以使用任何存储方法，>例如：
>字典中的内存中存储。
>永久性外部存储。 例如，使用 Azure.Data.Tables NuGet 包的数据库或 Azure 表存储。
>在客户端之间传递连接 ID。

### 从 IHost 获取 IHubContext 实例
从 Web 主机访问 IHubContext 对于与 ASP.NET Core 之外的区域集成很有用，例如，使用第三方依赖项注入框架：

```C#
    public class Program
    {
        public static void Main(string[] args)
        {
            var host = CreateHostBuilder(args).Build();
            var hubContext = host.Services.GetService(typeof(IHubContext<ChatHub>));
            host.Run();
        }

        public static IHostBuilder CreateHostBuilder(string[] args) =>
            Host.CreateDefaultBuilder(args)
                .ConfigureWebHostDefaults(webBuilder => {
                    webBuilder.UseStartup<Startup>();
                });
    }
```

### 注入强类型 HubContext
若要注入强类型 HubContext，请确保中心继承自 Hub<T>。 使用 IHubContext<THub, T> 接口而不是 IHubContext<THub> 进行注入。

```C#
public class ChatController : Controller
{
    public IHubContext<ChatHub, IChatClient> _strongChatHubContext { get; }

    public ChatController(IHubContext<ChatHub, IChatClient> chatHubContext)
    {
        _strongChatHubContext = chatHubContext;
    }

    public async Task SendMessage(string user, string message)
    {
        await _strongChatHubContext.Clients.All.ReceiveMessage(user, message);
    }
}
```

有关详细信息，请参阅强类型中心。

### 在泛型代码中使用 IHubContext
注入的 IHubContext<THub> 实例可以强制转换为 IHubContext，而无需指定泛型 Hub 类型。

```C#
class MyHub : Hub
{ }

class MyOtherHub : Hub
{ }

app.Use(async (context, next) =>
{
    var myHubContext = context.RequestServices
                            .GetRequiredService<IHubContext<MyHub>>();
    var myOtherHubContext = context.RequestServices
                            .GetRequiredService<IHubContext<MyOtherHub>>();
    await CommonHubContextMethod((IHubContext)myHubContext);
    await CommonHubContextMethod((IHubContext)myOtherHubContext);

    await next.Invoke();
}

async Task CommonHubContextMethod(IHubContext context)
{
    await context.Clients.All.SendAsync("clientMethod", new Args());
}
```

此操作在以下情况下十分有用：

- 编写不引用应用正在使用的特定 Hub 类型的库。
- 编写可应用于多个不同 Hub 实现的泛型代码

## 用户和组

SignalR 允许将消息发送到与特定用户关联的所有连接，以及指定的连接组。

### SignalR 中的用户

SignalR 中的单个用户可以与一个应用建立多个连接。 例如，用户可以在桌面和手机上进行连接。 每台设备都有一个单独的 SignalR 连接，但它们都与同一个用户关联。 如果向用户发送消息，则与该用户关联的所有连接都会收到消息。 可以通过中心内的 Context.UserIdentifier 属性访问连接的用户标识符。

默认情况下，SignalR 使用与连接关联的 ClaimsPrincipal 中的 ClaimTypes.NameIdentifier 作为用户标识符。 若要自定义此行为，请参阅使用声明自定义标识处理。

通过将用户标识符传递给中心方法中的 User 函数，向特定用户发送消息，如以下示例所示：

>**备注**
>
>用户标识符区分大小写。

```C#
public Task SendPrivateMessage(string user, string message)
{
    return Clients.User(user).SendAsync("ReceiveMessage", message);
}
```

### SignalR 中的组
组是与名称关联的连接集合。 你可以将消息发送到组中的所有连接。 建议通过组发送到一个或多个连接，因为组由应用程序管理。 一个连接可以是多个组的成员。 组非常适合聊天应用程序之类的应用，其中每个聊天室都可以表示为一个组。

### 添加或删除组的连接
可通过 AddToGroupAsync 和 RemoveFromGroupAsync 方法在组中添加或删除连接：

```C#
public async Task AddToGroup(string groupName)
{
    await Groups.AddToGroupAsync(Context.ConnectionId, groupName);

    await Clients.Group(groupName).SendAsync("Send", $"{Context.ConnectionId} has joined the group {groupName}.");
}

public async Task RemoveFromGroup(string groupName)
{
    await Groups.RemoveFromGroupAsync(Context.ConnectionId, groupName);

    await Clients.Group(groupName).SendAsync("Send", $"{Context.ConnectionId} has left the group {groupName}.");
}
```

多次将用户添加到组是安全的，如果组中已存在用户，不会引发异常。

重新连接时不会保留组成员身份。 重新建立连接后，需要重新加入组。 无法计算组的成员数，因为如果将应用程序扩展到多台服务器，则无法获取此信息。

组保留在内存中，因此在服务器重启时不会保留。 对于需要保留组成员身份的方案，请考虑 Azure SignalR 服务。 有关详细信息，请参阅 Azure SignalR

若要在使用组时保护对资源的访问，请使用 ASP.NET Core 中的身份验证和授权功能。 如果仅当凭据对组有效时才将用户添加到该组，则发送到该组的消息将仅发送给授权用户。 但是，组不是一项安全功能。 身份验证声明具有组不具备的功能，例如到期和吊销。 如果撤销用户对组的访问权限，应用必须从组中显式删除该用户。

> **备注**
>
>组名称区分大小写。