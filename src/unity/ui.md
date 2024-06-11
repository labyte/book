## UI边缘锯齿严重

1.没有开启canvas上的抗锯齿选项，project setting里也要开启抗锯齿，选择2x，4x，8x 

2.图片在导入的时候质量被压缩或者应用的时候被缩放。重新设置图片的格式，使图片的质量更高。 

3.美术出图的时候，每张图的边缘最好都要留几个空白的像素单位。边缘是产生锯齿的源头，这样被锯齿的部分就是透明的。


## UI

### Toggle

需求：
第一次不选中任何选项，当点击任一个选项后，自动只选中一个

- 默认将ToggleGroup allowSwiechOff 勾选

- 调用 toggleGroup.SetAllTogglesOff(false);