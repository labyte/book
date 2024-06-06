# CSharp-格式化参数

## DateTime 格式化

```C#
dateTime.ToString("yyyy-MM-DD hh:mm:ss");
```
## TimeSpan 格式化

`常用：timeSpan.ToString(@"dd\.hh\:mm\:ss");` 或则 `timeSpan.ToString("dd\\.hh\\:mm\\:ss");`区别是否使用转义符号。

```C#
using System;

public class Example
{
   public static void Main()
   {
      TimeSpan duration = new TimeSpan(1, 12, 23, 62);

      string output = null;
      output = "Time of Travel: " + duration.ToString("%d") + " days";
      Console.WriteLine(output);
      output = "Time of Travel: " + duration.ToString(@"dd\.hh\:mm\:ss");
      Console.WriteLine(output);

      Console.WriteLine("Time of Travel: {0:%d} day(s)", duration);
      Console.WriteLine("Time of Travel: {0:dd\\.hh\\:mm\\:ss} days", duration);
   }
}
// The example displays the following output:
//       Time of Travel: 1 days
//       Time of Travel: 01.12:24:02
//       Time of Travel: 1 day(s)
//       Time of Travel: 01.12:24:02 days
```