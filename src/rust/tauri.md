# Tauri

> UI 框架

- [Tauri 官网](https://tauri.app)
- [Vue 官网](https://vuejs.org/)
- [基于VUE的UI框架 Element-UI](https://element-plus.org/zh-CN/guide/installation.html)




## 调试

### 前端调试

**第一种方式**：通过 `Ctr+shift+I` 来打开 `DevTools` 调试工具，和浏览器的 `F12` 调试浏览器相同

**第二种方式**：前端的调试可以通过点击链接在浏览器上进行渲染，按下 `F12` 来调试。

### 后端调试

根据 [Tauri 官网文档进行配置 ](https://tauri.app/zh-cn/develop/debug/vscode/)

## Vue

- 路由

## Element-plus

- 国际化


## 异常汇总
### 执行后不出现窗口

可能的原因是还没编译完，编译完会出现 `Finished`

```bash
> rttve@0.1.0 tauri
> tauri dev

    Running BeforeDevCommand (`npm run dev`)

> rttve@0.1.0 dev
> vite


  VITE v5.4.8  ready in 589 ms

  ➜  Local:   http://localhost:1420/
    Info Watching F:\000-Labyte\Rust\tauri\rttve\src-tauri for changes...
    Blocking waiting for file lock on package cache
    Blocking waiting for file lock on package cache
    Blocking waiting for file lock on package cache
    Blocking waiting for file lock on package cache
    Finished `dev` profile [unoptimized + debuginfo] target(s) in 1m 36s
```

### failed to read plugin permissions: failed to read file: 系统找不到指定

执行 `npm run tauri dev` 后 提示如下错误：

```
failed to read plugin permissions: failed to read file: 系统找不到指定
```

删掉 `target` 文件夹，重新运行


## 相关开源项目

- [Pake：网页打包工具](https://github.com/tw93/Pake)