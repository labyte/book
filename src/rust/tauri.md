# Tauri

> UI 框架

- [Tauri 官网](https://tauri.app)
- [Vue 官网](https://vuejs.org/)
- [基于VUE的UI框架 Element-UI](https://element-plus.org/zh-CN/guide/installation.html)



## 执行后不出现窗口

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


## 调试

前端的调试可以通过点击链接在浏览器上进行调试。