## Mac 显示屏 HiDPI

![HiDPI.png](https://raw.githubusercontent.com/JustDo23/SnailMonitor/master/Picture/Cover/HiDPI.png)

> 引言：改善外置显示器显示效果。
>
> 作者：JustDo23
>
> 时间：2019年06月13日
>

### 01. 设备信息

| 品牌 |  型号   |   尺寸    |   分辨率    |
| :--: | :-----: | :-------: | :---------: |
| AOC  | Q2490W1 | 23.8 英寸 | 2560 x 1440 |

### 02. 请先尝试

1. 允许 HiDPI 模式

   ```bash
   $ sudo defaults write /Library/Preferences/com.apple.windowserver.plist DisplayResolutionEnabled -bool true
   ```
   
2. 安装工具

   开源调节软件 [RDM](https://github.com/avibrazil/RDM) 的安装包 [下载地址](http://avi.alkalay.net/software/RDM)

3. 原因

   * 以上操作结束后你是否找到了想要的效果
   * 以下操作结束后并没有实现我想要的效果
   * 我的目标是 **`HiDPI`** 模式下 **`1280 x 720`**

### 03. 官方网站

1. [GitHub](https://github.com/comsysto/Display-Override-PropertyList-File-Parser-and-Generator-with-HiDPI-Support-For-Scaled-Resolutions)

2. [官方网站](https://comsysto.github.io/Display-Override-PropertyList-File-Parser-and-Generator-with-HiDPI-Support-For-Scaled-Resolutions/)

### 04. 操作步骤

1. 允许 HiDPI 模式

   ```bash
   # 命令行执行指令
   $ sudo defaults write /Library/Preferences/com.apple.windowserver.plist DisplayResolutionEnabled -bool true
   ```

2. 查看设备信息

   ```shell
   # 连接显示器
   $ ioreg -lw0 | grep IODisplayPrefsKey
   ```

   输出结果如下：

   ```bash
   > "IODisplayPrefsKey" = "IOService:/AppleACPIPlatformExpert/PCI0@0/AppleACPIPCI/IGPU@2/AppleIntelFramebuffer@0/display0/AppleBacklightDisplay-610-a029"
   > "IODisplayPrefsKey" = "IOService:/AppleACPIPlatformExpert/PCI0@0/AppleACPIPCI/IGPU@2/AppleIntelFramebuffer@2/display0/AppleDisplay-5e3-2490"
   ```

   输出结果含义：

   * 区别在与最后一个 **`斜杠`** 后的内容
   * 标识 **`AppleBacklightDisplay`** 表示 **`内接显示器`**
   * 标识 **`AppleDisplay`** 表示 **`外接接显示器`**
   * 信息格式 **`显示器-DisplayVendorId-DisplayProductID`**

   总结：

   ```shell
   # 十六进制
   "DisplayVendorID" = 5e3
   "DisplayProductID" = 2490
   # 十进制
   "DisplayVendorID" = 1507
   "DisplayProductID" = 9360
   ```

3. 生成 Plist 文件

   * 打开官方网站
   * 填写表格信息
   * 选择所需比例
   * 下载生成文件

![configDisplay.png](https://raw.githubusercontent.com/JustDo23/SnailMonitor/master/Picture/Mac/configDisplay.png)

4. 文件内容

   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
   <plist version="1.0">
   <dict>
     <key>DisplayProductName</key>
     <string>AOC Q2490W1</string>
     <key>DisplayProductID</key>
     <integer>9360</integer>
     <key>DisplayVendorID</key>
     <integer>1507</integer>
     <key>scale-resolutions</key>
     <array>
       <data>AAAFAAAAAtAAAAABACAAAA==</data>
       <data>AAAHgAAABDgAAAABACAAAA==</data>
     </array>
   </dict>
   </plist>
   ```

5. 文件拷贝

   创建目标路径

   ```shell
   # 选填参数用于创建多级文件夹
   $ cd /System/Library/Displays/Contents/Resources/Overrides
   $ sudo mkdir [-p] DisplayVendorID-5e3
   ```

   拷贝指令

   ```shell
   $ sudo cp ~/Downloads/DisplayProductID-2490.plist /System/Library/Displays/Contents/Resources/Overrides/DisplayVendorID-5e3/DisplayProductID-2490
   ```

6. 注意事项

   * 执行命令会提示是否具有 **`操作权限`**
   * 拷贝目标是一个 **`没有后缀名`** 的文件
   * 拷贝源是从网站下载的 **`带后缀`** 文件
   
7. 重启激活

   * 重启电脑进行配置激活
   * 辅助工具 [RDM](https://github.com/avibrazil/RDM)

### 05. 权限问题

1. 产生原因

   系统升级后默认启用了 **`系统完整性保护(System Integrity Protection)`** 模式，增加了 **`Rootless`** 机制，增强了安全性。

   提示：请使用保护机制。

2. 关闭保护

   * 重启电脑
   * 开机过程中长按 **`command+R`** 键
   * 进入恢复模式
   * 点击 **`菜单栏`** 中 **`实用工具`** 选择 **`终端`**
   * 打开终端

   ```shell
   $ csrutil disable
   ```
   * 重启电脑

3. 开启保护

   ```shell
   $ csrutil enable
   ```

