# 发布 Android 平台

## 1 开发




## 2 调试

### 2.1 使用插件Android Logcat

在插件包中安装该插件，详情可以看插件的文档


### 2.2 UnityRemot 5

这个感觉没得上面一个好用，且不是真正在手机端运行，可能和实际情况有不符合的情况

收集的文章

- https://blog.csdn.net/vegetable_haker/article/details/126864565


## 3 发布

### 3.1 发布设置

**前提条件**

1. 包体不能大于2G，否则无法安装


### 3.2 发布报错

1. 发布失败，提示IL2CPP .... 一推错误。

    - 情况1：开始勾选了development build ，发布失败，取消勾选，发布成功，再勾选，也会发布成功

2. 编辑器下运行正常，发布后失败
    
    - 是否时使用了Addressables， 是否已经打AB包

3.  repositories.cfg

File C:\Users\Lenovo\.android\repositories.cfg could not be loaded.
UnityEngine.GUIUtility:ProcessEvent (int,intptr,bool&)


4. NDK问题

```
Exception: Unity.IL2CPP.Building.BuilderFailedException: C:\Program Files\Unity\Hub\Editor\2020.3.40f1c1\Editor\Data\PlaybackEngines\AndroidPlayer\NDK\toolchains\llvm\prebuilt\windows-x86_64\bin\clang++ @"C:\Users\Lenovo\AppData\Local\Temp\tmp77D3.tmp" -o "E:\Projects\CWSS\Library\il2cpp_android_arm64-v8a\il2cpp_cache\linkresult_744F7712D2E44CF47D673819F69A85D6\libil2cpp.so" -shared -Wl,-soname,libil2cpp.so -Wl,--no-undefined -Wl,-z,noexecstack -Wl,--gc-sections -Wl,--build-id -stdlib=libc++ -static-libstdc++ -target aarch64-linux-android21 -Wl,--wrap,sigaction "C:\Program Files\Unity\Hub\Editor\2020.3.40f1c1\Editor\Data\PlaybackEngines\AndroidPlayer\Variations\il2cpp\Development\StaticLibs\arm64-v8a\baselib.a" -llog -rdynamic -fuse-ld=bfd.exe

```

5. 【Unity3D IL2CPP】构建失败，异常：Unity.IL2CPP.Building.BuilderFailedException

```
异常提示：预编译头文件来自编译器的早期版本，或者预编译头为 C++ 而在 C 中使用它(或相反)

删除项目目录Library文件夹下il2cpp_cache和Il2cppBuildCache文件夹缓存，然后尝试重新打包。

```
