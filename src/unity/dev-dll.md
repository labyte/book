
在开发过程中，我们需要将一些dll放入Pulgins文件夹下，这时最好使用对应Unity版本的dll，并不是dll的版本越高越好，不同版本在引用Unity中的dll的路径不同，具体参照下表

| 版本 | dll路径 | 备注 |
| :-----| :---- | :---- |
| Unity2020.3.x | Editor\Data\MonoBleedingEdge\lib\mono\unityjit | 在对应版本的Editor下 |
| 以前 | C:\Program Files\Unity\Editor\Data\Mono\lib\mono\2.0 | 没有使用HUB安装的以前的版本 |

开发中，我们可能需要使用到如下的dll
- I18N.CJK.dll
- I18N.dll
- Mono.Data.Sqlite.dll
- System.Data.dll


注：某些dll是可以在Unity安装的目录找到的，有些不能，这时需要在官网上看是否有对应Unity的版本，不要一味的最求最新版本