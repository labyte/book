### CancellationTokenSource

1. 每次使用要 new

2. Cancel 和 Dispose

```
    CancellationTokenSource  Cancel = new CancellationTokenSource();

    UniTask.Delay(5000, cancellationToken: Cancel.Token).ContinueWith(() =>
    {
        Debug.Log("执行了");
    }).Forget();

```

Cancel： 不会输出 执行了

Dispose： 会输出 执行了