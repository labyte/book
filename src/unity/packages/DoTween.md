
# Dotween

官网：http://dotween.demigiant.com/

## Tween （Tweener）

### 属性


### 回调（事件监听）

- 在补间完成时调用（包括循环）,每到达终点一次调用一次
```
public TweenCallback onComplete;
```

- 暂停事件，若  autoKill set to FALSE，播放完成后触发
```
public TweenCallback onPause;
```

- 播放时调用
```
public TweenCallback onPlay;
```

- onUpdate
```
public TweenCallback onUpdate;
```

- onStepComplete
```
public TweenCallback onStepComplete;
```


- onKill

```
public TweenCallback onKill;
```


- 倒播到起始位置的回调，监听，注意，若 Tween 已经是倒播到起始位置，再调用倒播接口，不会触发此事件
```
public TweenCallback onRewind;
```


### 扩展

补间的播放等是通过扩展里面的方法来实现的

- Play()

播放：首次播放时使用

- Restart()

重新启动：再次播放时使用

- PlayBackwards()

倒播：回退补间时使用


## 案例

**实现一个侧边目录窗口，点击按钮，从左侧往右出现，并停住，点击关闭按钮，回退回去**

代码

```
         [SerializeField] GameObject flowBtnGameobject; //打开面板的按钮

         [SerializeField] RectTransform showStopPos;// 面板目标位置
        
         Tweener teachFlowTweener;//流程面板动画
         /// <summary>
         /// 打开教学目录
         /// </summary>
         public void OnClickTeachCatalogue()   
         {
             if (teachFlowTweener == null)//为空，首次播放
             {                                
                 //teachFlowPlane.ShowUpdateStep(gameModel.timelineStepId.Value);//TODO:面板显示逻辑处理,替换为自己的
                 teachFlowTweener = teachFlowPlane.transform.DOMoveX(showStopPos.position.x, 0.5f).SetAutoKill(false).SetEase(Ease.InOutFlash).Pause(); //首次播放
                 teachFlowTweener.Play();
                 teachFlowTweener.onRewind += onRewindHandler; //监听倒播结束事件，为了显示打开面板的按钮
             }
             else
             {
                 if (teachFlowTweener.IsPlaying()) return;
                //teachFlowPlane.ShowUpdateStep(gameModel.timelineStepId.Value);//TODO:面板显示逻辑处理,替换为自己的
                 teachFlowTweener.Restart();//重新启动 和 play 同效果
             }
             flowBtnGameobject.SetActive(false); //隐藏按钮
        
         }
        //关闭面板的方法
        public void OnCloseFlowPanel()
        {
            if (teachFlowTweener.IsPlaying()) return;
            teachFlowTweener.PlayBackwards();//倒播关闭

        }
   

        //面板回到初始位置后调用
        private void onRewindHandler()
        {
            flowBtnGameobject.SetActive(true);//显示打开按钮
        }

        private void OnDestroy()
        {
            teachFlowTweener.onComplete -= onRewindHandler; //删除监听

        }
```

















