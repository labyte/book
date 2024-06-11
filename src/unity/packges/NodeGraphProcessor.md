## NodeGraphProcessor
-  **功能** 
节点编辑器插件，用于配置任务流程，需要自己编写逻辑节点和处理流程。这是github上一个外国人基于Unity UIElement编写的。
-  **安装** 
● 通过 UPM 安装插件
● 更新指定版本

-  **样式扩展** 
在Resources目录下创建 PortViewTypes.uss，这个文件的名称是固定的，在这里面添加自己的样式

```
outflow 更改无效，不知原因
.Port_FlowLink {
    --port-color: #FFFF30;
}

.Port_ActionLink {
    --port-color: #FFFF30;
}
#contents #top .inflow #connector,
#contents #top .outflow #connector {
    border-radius: 0px;
}
```




-  **插件存在问题** 
● 1.3.0 版本：图形界面很卡，回退到了1.2.0
● 大半年没更新了，不过基本满足自己的需求了