# Addressables

## 使用说明

https://blog.csdn.net/linxinfa/article/details/122390621?spm=1001.2014.3001.5501


## AddressablesGroups 窗口

### 注意事项

1. 不用时关闭它，当打开状态下，选中场景中的对象，对属性面板进行改动时，会导致取消对场景中对象的选中

2. 调试android时，当我们仅更改代码，勾选 scripts only build 以加快发布，不要卸载手机上的应用，因为资源不会再重新构建


## Unity代码剥离导致ResourceManagerRuntimeData为空


Unity代码剥离为High，代码剥离，但我们遇到了 Addressables 包的问题。由于使用反射，ProviderOperation 被剥离。导致ResourceManagerRuntimeData为空

大概报错如下：

```txt
MissingMethodException: Default constructor not found for type UnityEngine.ResourceManagement.AsyncOperations.ProviderOperation`1[[UnityEngine.AddressableAssets.Initialization.ResourceManagerRuntimeData, Unity.Addressables, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null]]
  at System.RuntimeType.CreateInstanceMono (System.Boolean nonPublic) [0x0007b] in <71d402037f2643fe94cabbbe0d22d04d>:0
  at System.RuntimeType.CreateInstanceSlow (System.Boolean publicOnly, System.Boolean skipCheckThis, System.Boolean fillCache, System.Threading.StackCrawlMark& stackMark) [0x00009] in <71d402037f2643fe94cabbbe0d22d04d>:0
  at System.RuntimeType.CreateInstanceDefaultCtor (System.Boolean publicOnly, System.Boolean skipCheckThis, System.Boolean fillCache, System.Threading.StackCrawlMark& stackMark) [0x00027] in <71d402037f2643fe94cabbbe0d22d04d>:0
  at System.Activator.CreateInstance (System.Type type, System.Boolean nonPublic) [0x00020] in <71d402037f2643fe94cabbbe0d22d04d>:0
  at System.Activator.CreateInstance (System.Type type) [0x00000] in <71d402037f2643fe94cabbbe0d22d04d>:0
  at UnityEngine.ResourceManagement.Util.LRUCacheAllocationStrategy.New (System.Type type, System.Int32 typeHash) [0x00055] in D:\Project\Designer\Designer\Library\PackageCache\com.unity.addressables@1.1.9\Runtime\ResourceManager\Util\ResourceManagerConfig.cs:134
  at UnityEngine.ResourceManagement.ResourceManager.CreateOperation[T] (System.Type actualType, System.Int32 typeHash, System.Int32 operationHash, System.Action`1[T] onDestroyAction) [0x00032] in D:\Project\Designer\Designer\Library\PackageCache\com.unity.addressables@1.1.9\Runtime\ResourceManager\ResourceManager.cs:358
  at UnityEngine.ResourceManagement.ResourceManager.ProvideResource (UnityEngine.ResourceManagement.ResourceLocations.IResourceLocation location, System.Type desiredType) [0x000d1] in D:\Project\Designer\Designer\Library\PackageCache\com.unity.addressables@1.1.9\Runtime\ResourceManager\ResourceManager.cs:260
  at UnityEngine.ResourceManagement.ResourceManager.ProvideResource[TObject] (UnityEngine.ResourceManagement.ResourceLocations.IResourceLocation location) [0x00001] in D:\Project\Designer\Designer\Library\PackageCache\com.unity.addressables@1.1.9\Runtime\ResourceManager\ResourceManager.cs:287
  at UnityEngine.AddressableAssets.Initialization.InitializationOperation.CreateInitializationOperation (UnityEngine.AddressableAssets.AddressablesImpl aa, System.String playerSettingsLocation, System.String providerSuffix) [0x0009a] in D:\Project\Designer\Designer\Library\PackageCache\com.unity.addressables@1.1.9\Runtime\Initialization\InitializationOperation.cs:42
  at UnityEngine.AddressableAssets.AddressablesImpl.InitializeAsync (System.String runtimeDataPath, System.String providerSuffix) [0x0008d] in D:\Project\Designer\Designer\Library\PackageCache\com.unity.addressables@1.1.9\Runtime\AddressablesImpl.cs:280
  at UnityEngine.AddressableAssets.AddressablesImpl.InitializeAsync () [0x00013] in D:\Project\Designer\Designer\Library\PackageCache\com.unity.addressables@1.1.9\Runtime\AddressablesImpl.cs:289
  at UnityEngine.AddressableAssets.AddressablesImpl.get_InitializationOperation () [0x00013] in D:\Project\Designer\Designer\Library\PackageCache\com.unity.addressables@1.1.9\Runtime\AddressablesImpl.cs:306
  at UnityEngine.AddressableAssets.AddressablesImpl.LoadContentCatalogAsync (System.String catalogPath, System.String providerSuffix) [0x0004c] in D:\Project\Designer\Designer\Library\PackageCache\com.unity.addressables@1.1.9\Runtime\AddressablesImpl.cs:296
  at UnityEngine.AddressableAssets.Addressables.LoadContentCatalogAsync (System.String catalogPath, System.String providerSuffix) [0x00001] in D:\Project\Designer\Designer\Library\PackageCache\com.unity.addressables@1.1.9\Runtime\Addressables.cs:231
  at Ubiant.Common.Adressables.AddressablesLoader+<InitializeAddressables>d__2.MoveNext () [0x00020] in D:\Project\Designer\Designer\Assets\Scripts\Runtime\Addressables\AddressablesLoader.cs:49
  at UnityEngine.SetupCoroutine.InvokeMoveNext (System.Collections.IEnumerator enumerator, System.IntPtr returnValueAddress) [0x00027] in <1cc3984764e64bdeb5a66b5d2a3bc7e1>:0
UnityEngine.MonoBehaviour:StartCoroutineManaged2(IEnumerator)
UnityEngine.MonoBehaviour:StartCoroutine(IEnumerator)
```


 解决方案：

在Assets文件夹里面添加 link.xml文件，内容如下：

```xml

 
<linker>
    <assembly fullname="Unity.ResourceManager, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null" preserve="all">
    <type fullname="UnityEngine.ResourceManagement.ResourceProviders.LegacyResourcesProvider" preserve="all" />
    <type fullname="UnityEngine.ResourceManagement.ResourceProviders.AssetBundleProvider" preserve="all" />
    <type fullname="UnityEngine.ResourceManagement.ResourceProviders.BundledAssetProvider" preserve="all" />
    <type fullname="UnityEngine.ResourceManagement.ResourceProviders.InstanceProvider" preserve="all" />
    <type fullname="UnityEngine.ResourceManagement.AsyncOperations" preserve="all" />
    </assembly>
    <assembly fullname="Unity.Addressables, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null" preserve="all">
    <type fullname="UnityEngine.AddressableAssets.Addressables" preserve="all" />
    </assembly>
</linker>
```

若项目中已经存在 `link.xml` 直接追加即可。

参考文章：

- [CSDN：Unity代码剥离导致ResourceManagerRuntimeData为空](https://discussions.unity.com/t/addressables-and-code-stripping-il2cpp/748486)
- [Unity 社区：addressables and code stripping il2cpp](https://discussions.unity.com/t/addressables-and-code-stripping-il2cpp/748486)
