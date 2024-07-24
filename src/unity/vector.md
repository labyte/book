# 向量
## 1 基础知识
### 1.1 向量叉积

若有向量a、b 则向量的叉积为：

数学上定义：

```
a×b=|a||b|sin<a，b>  # 使用弧度计算
```

Unity 对应函数:

```
 public static Vector3 Cross(Vector3 lhs, Vector3 rhs);
```

 **三维坐标中** 
- 结果是一个向量(法向量)，方向：根据右手定则，四指从a的方向向b旋转，大拇指的方向就是结果方向
- 当a是单位向量时，计算b终点到a所在直线的距离

 **二维坐标中** 
- 叉积等于由向量A和向量B构成的平行四边形的面积

### 1.2 向量点积
若有向量a、b 则向量的点积为：

数学定义：

```
a·b=|a||b|cos<a，b>  # 使用弧度计算
```

Unity对应函数：

```
public static float Dot(Vector3 lhs, Vector3 rhs);
```

- 结果是一个标量。
- 常用于计算 **两个向量的夹角** :当a、b向量的模都为1（向量归一化），得到的为a、b向量的余玄值，求反余玄，得到夹角(弧度)



### 1.3 弧度和度
> 通常我们说两个向量的角度为30度，30指的是 **度** ，
> 弧度：180度对应的 **弧度** 是 Π，Unity里为常量： UnityEngine.Mathf.PI
- Unity里使用向量的方法都是使用弧度计算，而我们通常配置都是使用度（度在描述时更形象，一圈就是360度），所以需要将度转换为弧度

 **Unity中提供了转换的比例常数** 

- 度转弧度：Mathf.Deg2Rad，等价于 180/(UnityEngine.Mathf.PI)
- 弧度转度：Mathf.Rad2Deg，等价于 (UnityEngine.Mathf.PI)/180

 **举例：求Sin(30)的值** 

```
var v = Mathf.Sin(30*Mathf.Deg2Rad)
```


## 2 常用函数


### 2.1 两向量的夹角

```
var cosValue= Vector3.Dot(player.forward.normalized, (target.position - player.position).normalized);
float rad = Mathf.Acos(cosValue);//反余玄求夹角的弧[-1,1]
var deg = rad * Mathf.Rad2Deg;//弧度转度

```

### 2.2 判断目标点相对玩家的方位

设:

- 玩家为： player(Transform)
- 目标为： target(Transform)

#### 2.2.1 前后判断
- 原理说明：通过玩家正前方向量(forward)与玩家到目标构成的向量之间的夹角来判断，>90度（余玄值<0）在后方，<90度 (余玄值>0) 在前方
- 使用知识：点乘

```
//非归一化
var value = Vector3.Dot(player.forward,target.position - player.position);
//value > 0: 前方
//value < 0: 后方

```
或者

```
//归一化，得到的值范围：[-1,1]
var value = Vector3.Dot(player.forward.normalized, (target.position - player.position).normalized);
//value > 0: 前方
//value < 0: 后方

```

#### 2.2.2 左右判断

与“前后判断”原理相同，仅需要使用 `player.right` 进行计算即可
```
//归一化，得到的值范围：[-1,1]
var value = Vector3.Dot(player.right.normalized, (target.position - player.position).normalized);
//value > 0: 右方
//value < 0: 左方

```

#### 2.2.3 上下判断

与“前后判断”原理相同，仅需要使用 `player.up` 进行计算即可
```
//归一化，得到的值范围：[-1,1]
var value = Vector3.Dot(player.up.normalized, (target.position - player.position).normalized);
//value > 0: 上方
//value < 0: 下方

```



## 3 需求案例
### 3.1 判断对象是否在玩家视野内

 **分析** 
- 视野是以相机为起点的一个圆锥体
- 视野的正前方为 forward方向
- 求夹角，用点积

 **求解** 
 假设玩家对象为`player(transform)`,视野的大小为 `filedView`，从角色位置出发，任意一个向量和正前方的向量的 `夹角 <= filedView * 0.5` ，那么该向量上的点都在视野内。


```
private bool Check(Transform player, int filedView)
{
    Vector3 playerFoward = player.forward;// 角色正前方的向量
    Vector3 player2TagVec = transform.position - player.position;//角色到目标点的向量
    //向量归一化后求两个向量的点积(标量)
    var v = Vector3.Dot(playerFoward.normalized, player2TagVec.normalized);
    //然后反余玄求到夹角的弧度,这里的结果是要给-1 到 1 的弧度。
    float rad = Mathf.Acos(v);
    var deg = rad * Mathf.Rad2Deg;//弧度转度
    return deg <= filedView * 0.5f;//filedView：player 前方锥形角度
}
```

**存在问题**

1. 若仅仅通过角度来判断，且这个角度是固定的，当角色与目标点较近时，此时目标点在视野外，但是此时判断就很奇怪，所以应将角度 与 “玩家和目标点的距离” 同时用于判断

```
//1）假设玩家和目标点的距离（水平面上的距离）为1m时，角度判断为30度
//2）那么用于实际判断的 filedView = 30/距离
//3）当玩家与目标越来越近时，应该使用更大的距离来判断
//4）这个距离应该在0-160度之间（自己可以改动这个范围）

    private bool CheckInFiledView(Transform player, int fieldView)
    {
        Vector3 playerFoward = player.forward;// 角色正前方的向量
        Vector3 player2TagVec = transform.position - player.position;//角色到目标点的向量
        var cosValue = Vector3.Dot(playerFoward.normalized, player2TagVec.normalized);//向量归一化后求两个向量的点积(标量),即两向量的夹角的余玄值
        if (cosValue < 0) return false;// > 90 为 负值，表示 目标在角色后面
        float rad = Mathf.Acos(cosValue);//反余玄求夹角的弧[-1,1]
        float disOnPlane = player.DistanceToTargetOnHorPlane(transform);//求玩家和目标的水平面上的距离
        float newFiled = fieldView / disOnPlane;
        newFiled = Mathf.Clamp(newFiled, 0f, 60f);
        var deg = rad * Mathf.Rad2Deg;//弧度转度
        bool r = deg <= newFiled * 0.5f;//filedView：player 前方锥形角度
        // if (r)
        //     Debug.Log($"激活的相机：{player.name}  目标： {name}  v: {cosValue}    deg: {deg}  newFiled{newFiled} ");
        return r;
    }

```

### 3.2 怪物看向玩家


> 要点：控制怪物仅围绕Y轴旋转，否则怪物会倾斜

> 如在场景中有一个ui箭头指示操作，此时需要玩家看向箭头时，永远是箭头的正确面

```
private void lookat(Transform self, Transform target)
    {
        //look的方向 起点 - 终点
        Vector3 dir = target .position - self.position;
        //设置y轴上为0，不偏移
        dir.y = 0;
        //四元数插值运算
        self.rotation = Quaternion.Slerp(self.transform.rotation, Quaternion.LookRotation(dir), Time.deltaTime);
    }

```
### 3.3 VR中在玩家面前显示UI

**分析** 
- 一个位置坐标 + 一个向量 = 从这个位置，以向量方向移动向量模的距离后的新的位置点
- ui 始终垂直水平面，不能前后左右倾斜


 **求解** 




```
   Transform player; //玩家对象
    
    public void (Transform ui)
    {
        Vector3 forward = player.forward;
        forward.y = 0;//这样得到的就是一个平行水平面的一个向量
        var vMove = forward.normalized;//归一化
        
        Vector3  pos= player.position - vMove * 2;//正前方2米的位置，我们可以设置这个参数

        ui.SetPositionAndRotation(pos, Quaternion.LookRotation(v));

        //ui.SetPositionAndRotation(pos - Vector3.up * 0.2f, Quaternion.LookRotation(v)); //也可以调整高度      
    }    

```

