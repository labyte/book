# Nativefileso

> Github 上的资源
> 
> 功能：跨平台的文件操作插件，是一个国外大牛在github上的unity插件，提供调用应用程序分享功能，如：微信分享，你不用去注册微信的开放平台。直接可以分享到微信，钉钉等。非常强大
 
## 说明

[仓库地址](https://github.com/keiwando/nativefileso)

注意事项：

1. 在发布安卓端时，删除掉 Mac os, IOS对应的插件，否则打包会报错
2. Windows 发布， 提示 .forms.dll 警告

最后说明：使用起来不是很满意，用 Unity商城里面的 [NativeShare](https://assetstore.unity.com/packages/tools/integration/native-share-for-android-ios-112731) 代替

## Android 设置
NativeShare 不再需要在 Android 上进行任何手动设置。如果您使用的是旧版本的插件，则需要<provider ... />从AndroidManifest.xml中删除 NativeShare 。

作为参考，旧文档可在以下位置找到：https：//github.com/yasirkula/UnityNativeShare/wiki/Manual-Setup-for-Android

## iOS 设置
有两种方法可以在 iOS 上设置插件：

a. 自动设置：在Unity中（ 可选）在项目设置/yasirkula/Native Share中勾选自动设置，并添加更改照片库使用说明描述：“该应用程序需要访问照片才能将媒体保存到其中”
b. 手动设置：参见：https://github.com/yasirkula/UnityNativeShare/wiki/Manual-Setup-for-iOS