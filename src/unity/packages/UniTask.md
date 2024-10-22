# UniTask

[官网](https://github.com/Cysharp/UniTask)

## RunOnThreadPool


❌❌❌ RunOnThreadPool **不支持** WEBGL❌❌❌

在WebGL平台上，这个方法可能不起作用，因为WebGL不支持标准的线程池或异步编程模型。

如下示例：

```c#
private async UniTask Execute()
{
    await UniTask.Delay(1000);
    Debug.Log($"Delay 1000!");
    UniTask.RunOnThreadPool(async e =>
    {
        await UniTask.Delay(2000); //在PC上这里可以执行，但是在WEBGL中，这里不会执行
        Debug.Log($"Delay 2000!");
    },true).Forget();
}

       
```

更新后

```c#
private async UniTask Execute(ICommand command, EventDataBase evt)
{
    await UniTask.Delay(1000);
    Debug.Log($"Delay 1000!");
    MyDelay().Forget();
}

private async UniTaskVoid MyDelay()
{
    await UniTask.Delay(2000);
    Debug.Log($"Delay 2000!");
}
```




## CancellationTokenSource

1. 每次使用要 new

2. Cancel 和 Dispose

```c#
    CancellationTokenSource  Cancel = new CancellationTokenSource();

    UniTask.Delay(5000, cancellationToken: Cancel.Token).ContinueWith(() =>
    {
        Debug.Log("执行了");
    }).Forget();

```

Cancel： 不会输出 执行了

Dispose： 会输出 执行了