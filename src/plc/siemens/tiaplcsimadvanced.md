# 西门子PLC

## 软件介绍

### TIA Portal（博图）
西门子全集成自动化门户（Totally Integrated Automation Portal），是主要的编程和配置软件平台，用于SIMATIC S7系列PLC（包括S7-1200、S7-1500等）的硬件配置、程序编写（LAD、FBD、SCL等）、HMI设计、诊断等。它本身不是仿真器，但集成了基本的PLC仿真功能（通过S7-PLCSIM）。
S7-PLCSIM（也称为PLCSIM或标准PLCSIM）：
TIA Portal内置或随附的PLC仿真器（随TIA Portal许可证免费提供）。主要用于测试PLC程序逻辑、I/O操作、监视变量等。
支持模拟S7-1200、S7-1500、甚至旧的S7-300/400。
限制：仅通过TIA Portal内部Softbus通信，无法与外部软件（如HMI、OPC UA、第三方工具）进行TCP/IP通信；不能模拟真实网络行为；实例数量有限（通常1-2个）。
适合纯逻辑测试和调试程序。

### S7-PLCSIM Advanced（高级版PLCSIM）
独立的仿真软件（需单独下载和购买许可证），专为更高级的虚拟调试设计。
主要支持S7-1500和ET 200SP（较新版本可能扩展到部分S7-1200）。
优势：支持真实TCP/IP通信（通过虚拟以太网适配器）、多实例（最多16个虚拟PLC）、与外部设备/软件交互（如HMI、OPC UA服务器、第三方模拟工具）、API接口用于自定义集成、模拟Web服务器、PROFINET等网络功能。
适合虚拟调试（Virtual Commissioning）、测试网络通信、连接真实HMI或模拟整个系统。


### 总结对比表

特性|TIA Portal|S7-PLCSIM (标准)|S7-PLCSIM Advanced
---|---|---|---
主要作用|编程/配置平台|基本PLC程序仿真|高级PLC仿真与外部交互
许可证|TIA Portal许可证|包含在TIA Portal中|单独购买
支持CPU|所有S7系列|S7-1200/1500/300/400|主要S7-1500/ET200SP
通信方式|-|仅内部Softbus（限TIA Portal）|TCP/IP、虚拟网络适配器
外部交互（如HMI/OPC）|支持真实硬件或集成HMI仿真|不支持|支持
多实例支持|-|有限|多达16个
适用场景|完整项目开发|简单逻辑测试|复杂系统仿真、网络测试


**如果没有硬件，需要仿真环境，应该怎么配置**

没有真实PLC硬件时，完全可以使用仿真环境测试程序。推荐根据需求选择：

1. 基本需求（仅测试PLC逻辑、I/O变量、程序监视）：使用S7-PLCSIM（最简单，无额外成本）。
- 配置步骤：
    - 安装TIA Portal（最新版本如V19推荐）。
    - 在TIA Portal中创建项目，添加CPU（如S7-1500或S7-1200）。
    - 在“在线访问”中，选择接口为“PLCSIM”（如果未出现，启动PLCSIM软件）。
    - 启动仿真：点击工具栏的“启动PLCSIM”按钮，或直接下载程序到PLCSIM。
    - 下载硬件配置和程序块到仿真PLC。
    - 使用监视表（Watch Table）或SIM Table手动修改输入变量，观察输出。
    - PLC置于RUN模式，即可实时运行程序。


2. 高级需求（测试网络通信、连接HMI、OPC UA、多PLC交互、虚拟调试）：使用S7-PLCSIM Advanced。
- 前提：需单独下载S7-PLCSIM Advanced（从Siemens支持网站SIOS下载），并有许可证（有Trial版可试用）。
- 配置步骤：
    - 安装S7-PLCSIM Advanced（兼容你的TIA Portal版本）。
    - 启动PLCSIM Advanced控制面板。
    - 创建实例：指定实例名称、选择CPU家族（S7-1500）、设置通信接口为“PLCSIM Virtual Ethernet Adapter”（启用   - TCP/IP），分配IP地址（与项目中CPU IP一致）。
    - 在TIA Portal项目中：激活“支持仿真”选项（CPU属性中启用PLCSIM Advanced）。
    - 下载程序到虚拟实例（在线访问选择对应实例）。
    - 可连接外部工具：如WinCC HMI、浏览器访问PLC Web服务器、OPC UA客户端等。
    - 支持多实例分布式仿真。

## 标准三步骤（才能进行仿真）

- 配置IP，选择设备网孔，在下方常规->以太网网址填写IP，次IP和 PLC SIM Advanced 上配置的IP一样
- 选择设备的CPU，常规->防护与安全->连接机制，勾选“允许来自远程对象的PUTGET通信访问”
- 右键项目树的项目根节点，属性->切换到保护->勾选块编译时支持仿真