# 动画


#### 录制动画

在Unity里面制作动画，使用录制模式录制的动画默认为`Legacy` ，无法使用到  `Animator Controllers`，提示如下警告:

```Ada
The legacy Animation Clip "KeShiDoor-close" cannot be used in the State "close:0". Legacy AnimationClips are not allowed in Animator Controllers.
```

**解决方案**：选中动画片段，在属性面板打开Debug模式，取消勾选`legacy` 。

