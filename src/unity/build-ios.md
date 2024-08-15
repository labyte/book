# 发布 IOS 平台

[Unity官方文档 - iOS 构建过程详解](https://docs.unity.cn/cn/2021.1/Manual/iphone-BuildProcess.html)

## 上架说明

1. 注册一个苹果开发者账号，可以个人注册，或者公司注册，公司比较复杂，个人比较简单，个人的年费为688

2. 需要一个Mac，主要用于申请一些证书和使用Xcode软件（上架必备）

3. 请求证书，以及制作配置文件

3. Unity Build IOS, 此过程在 windows上和mac上都可以进行，结果是得到一个 Xcode项目工程

4. 在 mac 上使用xcode 打开 上一步的项目设置分发

5. 测试分发：发布测试版本，就是不用上架审核，但是有限制

6. 上架分发，需要审核，终极目标。

## 苹果开发者账号

### 注册

首先需要开发者账号，且按年付费，具体注册流程如下：


1. 手机下载 developer app 进行注册申请，在手机上下载app安装

1. 注意填写信息时，完全按照身份证上的填写，按照英文的格式填写，最好就是找个已经注册好的看下格式来填写（我还是失败了，最后是人工客服完成的，使用电话的方式，她帮你解决；使用邮件会来回折腾，还是不行）

1. 客户帮你解决后，回到app,退出再登录，才能继续注册流程，选择个人注册，直到付完费用688，订阅后，马上取消订阅，避免到时候忘了（若上架的账号没有继续订阅，未安装过此app的无法在商店找到此应用，安装过的还是可以找打）

1. 此时，在app上显示一个灰色的注册，说是我即将收到一个邮件

1. 收到邮件，上传身份证，正反面都要上传，完成激活，此时应该才是注册完成（给的邮件说是带有照片的，我就只上传照片的，最后人工后，说两面都要上传）

1. 总结：注册很狗屎，每次错也不晓得哪里错，不停的试，最后都是人工处理。
 

>**注意事项（坑）**：
>
>1. 看siki学院的视频，以为付费完就注册完了，实际上还要上传身份证
>
>1. 我也的确收到邮件了，叫我上传身份证，但是我以为是之前注册失败，叫我上传，有几次失败就是叫上传，结果还是不行，所以我也没理
>
>1. 我就还在等其他的邮件，在网页端登录，叫我继续注册流程，很郁闷。


### 续费

订阅续费在手机上操作：设置/账号头像（名称）/订阅。即可看到已经停用的 **Apple Developer** ，点击续订即可。

网上（ChatGpt）说的在开发者官网上的会员详情里面续订不行，就没有续订按钮。


## 操作流程

### 一、钥匙串创建证书

> 先创建好后面步骤要使用。

1. 在 mac 上 打开钥匙串app
   
2. 在屏幕左上角：钥匙串访问-》证书助理-》从证书颁发机构请求证书

    ![证书助理](image/build-ios/image.png)

3. 请求是：选择“存储到磁盘”，点击继续，保存即可

4. 注意这个证书，只能在本设备上使用，若其他电脑要使用这个证书，需要转换，方法待补充


### 二、证书

1. 登录开发者网站，进入[Developer-账户](https://developer.apple.com/account)。
2. 选择证书（注意：如果官网存在协议更新，需要重新查看协议，并同意后，才能出现证书的相关操作，否者证书下没有可选操作）。
    ![证书](image/build-ios/developer-证书.png)
3. 点击 `+`。
    ![alt text](image/build-ios/certificates-add.png)
   
4. 在 `Software` 下选择证书类型，在 `Services` 下选择需要的服务，点击继续。
   -  `Apple Development`: 苹果所有终端的开发测试证书，包含 mac ios
   -  `Apple Distribution`: 苹果所有终端的上架发布测试证书，包含 mac ios
   -  `IOS App Development`：仅 ios 端的开发测试证书
   -  `IOS Distribution (App Store and Ad Hoc)`：ios 端 的 上架商店证书
   -  其他同理
5. 上传之前使用钥匙串申请的证书，点击继续。
6. 下载申请好的证书，然后**双击**后安装到钥匙串中。
7. 最后我们在证书列表里面可以看到当前生气的证书，注：钥匙串申请的证书可以创建测试证书和分发证书。
8. 证书会过期（当开发者账号订阅过期时，证书也会过期）


### 三、Identifiers（标识符）

1. 在证书、标识符和描述文件页面，左侧选择 Identifers ,点击 `Identifiers +`
2. 选择 `App IDs`
3. 选择 APP
4. Regieste an App ID, 输入 bundle identifier，这个需要记住，后面在Unity工程设置中需要使用
6. 设置 App Services，这个根据需要选择，比如推送、支付等，点击 continue
7. 点击 register，注册完成
8. 在 Identifers 列表里面可以看到当前注册的 App ID，注：这个 App ID 会在后面的描述文件中使用到



### 四、Devices（设备）

作用，收集需要参加测试手机的UDID号，添加到这里，在打包测试的时候，只有添加了的设备才能安装测试
上架商店就不需要这个

获取设备UDID
通过下面的地址，在浏览器打开后，提示下载配置文件，然后安装，获取，发送给指定邮箱
[https://www.pgyer.com/tools/udid](https://www.pgyer.com/tools/udid)


### 五、Profiles（描述文件）

1. 点击 + 。
2. Register a New Provisioning Profile：选择类型，根据当前的测试设备和类型（测试/分发）来选择。
3. Generate a Provisioning Profile：选择 App ID，Provisioning Profile Configuration 默认 选择 No,点击 continue. 
4. 选择一个证书，点击继续。
5. 选择测试的设备，点击继续。
6. 填写描述文件名称，点击生成。
7. 下载描述文件，备用。
8. 在 Profiles 列表里面可以看到当前生成的描述文件，注：这个描述文件会在后面的打包中使用到。

### 六、Unity项目设置

此处的设置可以在xcode里面修改，所以如果填写错误，不用再重新发布。

1. 可以在window上或者mac上进行
2. 设置公司名称
3. 设置product name：上架审核时，这个名称必须 app store connect上创建的app 名称相同，否审核不过
4. 设置version：只能包含"数字"和“.”，其他都是非法的，可以在xcode里面修改。
5. 设置bundle identifier： 这个必须和后面创建的证书时一致，可以在xcode里面修改。
6. 设置 Target device: 根据你的实际需求来，如果仅在iphone上运行，那么就选 iPhone only，否则在上架审核时，需要你上传其他设备的分辨率截图，多出很多事情，可以在xcode里面修改。
7. 目标最小ios版本，这个根据情况设置，可以在xcode里面修改。



### 七、Xcode项目设置

1. 将Unity工程打包成Xcode工程，可以在Windows打包，也可以在mac上打包（未知原因：在mac上无法打开工程，一致卡在fbx的导入）
1. 双击Xcode文件，打开工程
1. 选中TARGETS 下的 第一个


#### （1）Geneeral

1. `Suported Destinations`：设置支持的设备，这里删除掉ipad的设备，如果这里支持iPad,上架审核的时候，会叫你整ipad的截图，很多事情。
2. `Minimum Deployments`：设置最小的IOS版本。
3. `Identity`：主要设置下面两个选项
   - `Bundle Identifier`：证书里面填写的id，unity 中配置的一致。
   - `Version`：设置版本号，一种方式就是在unity里面设置好，另外一种方式就是在xcode 里面设置，这个只能包含 “数字”、“.”, 如 “1.0.1”， 不能有字母或者空格，如果发布的是测试版本，版本号可以不变，如果是上架审核，版本号增加比较好，不增加不会报错。

4. 设置 `app icon` ,这个在上架的时候必须有


#### （2）Signing&Capabilities

Bundle Identifiers: 同创建证书时的一致

在 all 标签下，选择profile，这里如果是构建测试的就import 测试的 配置，就是前面下载下来的，同理选择分发上架类型的，如果找不到文件，重启下xcode.


#### （3）Resources Tages

暂无配置

#### （4）Info

**Custom iOS Target Properties:**

- `App Transport Securiy Settings`：
  - `Allow Arbitrary Loads`：`Yes`,（这样就允许了http 未加密的方式访问网站，否则会报错）

- 【新版xcode 没有这个】设置不使用出口合规证明 (仅在上架审核的时候需要)  `<key>ITSAppUsesNonExemptEncryption</key><false/>`

#### （5）Build Settings


- User-Defined

  - Eenable Bitcode : 设置为 false (打包的时候说是不赞成这个，不让通过)


### 构建

#### 直接手机测试
需要手机和电脑连接，直接将app安装到手机上，适用于调试方式。

#### 生成ipa包
ipa文件不能直接通过苹果手机安装，需要通过分发平台进行分发安装。

1. Product->Archive，等待编译完成
2. 编译完成后，Xcode会自动打开“Organizer”窗口
3. 你可以选择导出的配置文件和导出选项，然后点击“Export”按钮，选择“Save for Ad Hoc Deployment”或“Save for Enterprise Deployment”
4. 最后选择保存路径和文件名，完成IPA文件的生成。

若提示需要钥匙串的密码，输入开机密码。并非用户账户密码。

#### 上架商店

1. Product->Archive
2. 在 App Store Connect 上创建 App
3. 上传 IPA 文件到 App Store Connect
4. 提交审核


**Product->Archive**

此操作将构建ipa包，可以将ipa包上传到商店，也可以通过分发平台来分发ipa包给测试人员（ipa文件不能直接通过苹果手机安装，和安卓的apk不同）。





**构建失败汇总**

- 提示禁用 bitcode
  
  [参考](https://www.likecs.com/show-203846296.html),:在 Xcode中 选择 buildsettings, 搜索 bitcode,设置为 `false`。


### 八、分发测试包

[https://www.pgyer.com/](https://www.pgyer.com/)

将ipa通过蒲公英分发平台分发app
注意 ipa 文件不同于安卓的 apk ，不可以直接安装，必须借助于其他方式，软件或者分发平台，这里使用蒲公英分发平台
打开蒲公英分发平台网站
注册账号
上传ipa（名字最短那个文件） 



## 上架商店

该章节讲介绍目从开发到上架到苹果商店的过程，让用户能够自由下载使用。
上传的主要过程就是使用xcode将 ipa 上传到 app store connect 上，然后经过审核，上传到 商店。

### 流程说明

在app store connect 上创建app-》项目开发导出xcode工程-〉上传到connect上-》提交审核

### APP stroe connect 上创建app

1. 进入 app store connect平台创建app

![1718095065040](image/build-ios/1718095065040.png)

2. 填写app信息，注意这里的名称和unity里面的名称最好一样，两个名称不同或者相差很大，导致审核不通过，这里写的名称是商店里软件显示的名称，unity里面的名称，是安装后在手机桌面显示的名称，提交后，苹果会提示里两个名称不一样，会导致用户找不到下载的软件。

![1718095073433](image/build-ios/1718095073433.png)

3. 创建完成后显示

![1718095081823](image/build-ios/1718095081823.png)

### 上传ipa

1. 在 xcode 里面调整好项目 Archive,然后上传
2. 上传完成后，在 App store connect 里的TestFlight 标签页查看，这个时候还不能在app store 页查看，因为还没提交

### 分发类型

若是企业定制版本的软件，不需要上架商店，而是希望通过内部分发的方式，参考：[分发类型](https://support.apple.com/zh-cn/guide/deployment/depe1553f932/web)


### 提交审核

1. 提交构建版本，多个版本的时候选择最新的版本

2. 除了可选填的，都是必须填写的

3. 隐私项填写完成后需要发布

4. 各种网址（技术网址，隐私网址），填写公司网址，或者个人网址即可

5. 截图这里，用一个手机截图后，ps处理成对应方便率的，上传失败会提示里，应该上传什么分辨率

6. 只要你有登录界面，那么再需要在testflight -》 测试信息中，勾选 “需要登录”，且输入 供登录审核的账号信息，及时你的设计是输入任何账号和密码，就可以，也需要勾选需求要登录，否者审核不过。 


[使用非公开发方式发布](https://developer.apple.com/contact/request/unlisted-app/)