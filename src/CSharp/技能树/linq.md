# Linq

## 多个属性具有相同处理逻辑

使用 Expression 来实现

> Expression：将强类型lambda表达式表示为表达式树形式的数据结构。该类不能被继承，当一个对象存在多个相同类型的属性，且这些属性控制的功能相同时,可以使用 Expression 来实现


- 有一组 Person, 需要遍历每个person，根据属性  **A** 或者  **B**，判断是说 `Hello` 还是 `Bye`
- Person

```
    public class Person
    {
        public string Name { get; set; }
        public bool pA { get; set; }
        public bool pB { get; set; }
    }

```
- 创建 Person List

```
    class ExpressionTest
    {
        List<Person> persons = new List<Person>();
        public ExpressionTest()
        {
            persons.Add(new Person { Name = "Jerry", pA = true, pB = false });
            persons.Add(new Person { Name = "Shin", pA = true, pB = false });
        }
        ...
    }
```

### 常规解法
- 分别写两个方法，根据属性A 或者 属性B 来判断

``` C#
  internal class ExpressionTest
    {
        List<Person> persons = new List<Person>();
        public ExpressionTest()
        {
            persons.Add(new Person { Name = "Jerry", pA = true, pB = false });
            persons.Add(new Person { Name = "Shin", pA = true, pB = false });
        }

        /* 需求： 遍历 persons， 根据 pA 或者 pB 的值，判断每个人是说 hello 还是 bye
         * 常规写法： 分别些两个方法遍历判断
         * Expression: 通过表达式实现通用写法
         * 
         */
        #region 常规写法

        private void SayHelloByA()
        {
            foreach (var p in persons)
            {
                if (p.pA)
                    Console.WriteLine($"[{p.Name}]\tSay Hello！");
                else
                    Console.WriteLine($"[{p.Name}]\tSay Bye！");
            }
           
        }
        private void SayHelloByB()
        {
            foreach (var p in persons)
            {
                if (p.pB)
                    Console.WriteLine($"[{p.Name}]\tSay Hello！");
                else
                    Console.WriteLine($"[{p.Name}]\tSay Bye！");
            }

        }

        #endregion
       // 测试
       public void Test()
        {
            SayHelloByA();// 输出: Say Hello!
            SayHelloByB();// 输出: Say Bye!
        }
    }
```

-  **存在的问题** ： 如果我们有多个属性 C D E F，那么我们就需要写多少方法，但是发现这些方法的逻辑都是一样的。总感觉很别扭，此时就要用到 **Expression** 

### Expression 写法

```C#
 internal class ExpressionTest
    {
        List<Person> persons = new List<Person>();
        public ExpressionTest()
        {
            persons.Add(new Person { Name = "Jerry", pA = true, pB = false });
            persons.Add(new Person { Name = "Shin", pA = true, pB = false });
        }
       
        #region  Expression
        public void SayHello(Expression<Func<Person, bool>> expr)
        {
            var valProp = (PropertyInfo)(((MemberExpression)expr.Body).Member);
            foreach (var p in persons)
            {
                bool isShow = (bool)valProp.GetValue(p, null);
                if (isShow)
                    Console.WriteLine($"[{p.Name}]\tSay Hello！");
                else
                    Console.WriteLine($"[{p.Name}]\tSay Bye！");
            }
        }
        #endregion
       // 测试
       public void Test()
        {
            SayHello(x => x.pA);// 输出: Say Hello!
            SayHello(x => x.pB);// 输出: Say Bye!
        }
    }
```
- 通过表达式，让调用者来确定条件的值。

