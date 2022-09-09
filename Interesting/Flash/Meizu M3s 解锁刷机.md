## Meizu M3s 解锁刷机

![Flash.png](https://raw.githubusercontent.com/JustDo23/SnailMonitor/master/Picture/Cover/Flash.png)

> 概述：手机吃灰太久，在不折腾就老了。
>
> 时间：2019年11月07日
>
> 作者：JustDo23

### 01. 机型信息

| 科目     | 参数                |
| -------- | ------------------- |
| 型号     | 魅蓝 3s             |
| Android  | 5.1                 |
| UI       | Flyme 7.8.7.24 beta |
| CPU      | 联发科 MT6750       |
| 上市日期 | 2016 年 05 月       |
| 分辨率   | 1280 x 720          |
| 内存     | 2G + 32G            |

### 02. 开发者选项

1. 进入 **`手机设置`** 打开 **`关于手机`** 找到 **`Android 版本`** 狂点击
2. 进入 **`手机设置`** 打开 **`辅助功能`** 点击 **`开发者选项`**
3. 勾选 **`开启开发者选项`** 和 **`USB 调试`**

### 03. 解锁 Bootloader

1. [魅族](https://www.flyme.cn)官网[刷机教程](https://www.flyme.cn/tutorial)刷机至[体验版](https://www.flyme.cn/firmwarelist-58.html#3)
5. 进入 **`手机设置`** 点击 **`魅族账号`** 进行 **`注册登录`**
6. 进入 **`手机设置`** 点击 **`指纹和安全`** 找到 **`ROOT 权限`**
7. 打开 **`应用商店`** 下载安装 **`SuperSU`**
8. 下载安装 [MultiTool.apk](https://github.com/JustDo23/SnailMonitor/blob/master/Resource/Flash/Meizu/MultiTool.apk) 解锁软件
9. 打开解锁软件并授予 **`Root 权限`**
10. 点击界面上解锁按钮并观察结果反馈
11. 进入 **`fastboot mode`**
    * 方式一：关机后同时按下 **`音量减+电源键`**
    * 方式二：执行 **`adb`** 命令
12. 操作命令进行解锁
13. 仔细查看提示信息并用音量键操作确认解锁
14. 解锁之后请重启手机确认正常

```shell
# 重启并进入
$ adb reboot bootloader
# 查看状态信息
$ fastboot getvar all
# 解锁命令
$ fastboot oem unlock
```

特别注意：

* 魅族官方并不支持进行解锁，民间方法注意有风险。
* 解锁之后手机数据会被清空，操作之前注意数据备份。
* 解锁之后必须要重启手机以确保系统正常。

### 04. 刷入 TWRP

1. 在 [TWRP](https://twrp.me) 官方网站上寻找找到 M3s 型号。可惜并不能找到。
2. 在 TWRP 官网 [下载](https://dl.twrp.me/twrpapp) 最新版本 **`APK`** 并安装。
3. 玩家 [ElXreno](https://github.com/ElXreno) 在其 [GitHub](https://github.com/ElXreno/twrp_device_meizu_m3s) 上发布了针对 M3s 的 **`recovery.img`**
4. 下载并导入手机存储卡，打开 TWRP 选择本地文件刷入。
5. 进入 **`recovery mode`**
    * 方式一：关机后同时按下 **`音量加+电源键`**
    * 方式二：执行 **`adb`** 命令
6. 进入后选择菜单进行相应的操作。

```shell
# 重启并进入
$ adb reboot recovery
```

### 05. 寻找 ROM

1. [LineageOS](https://lineageos.org)
2. [Resurrection Remix OS](https://www.resurrectionremix.com)
3. [xda-developers](https://forum.xda-developers.com)

### 06. FlashFire

1. [FlashFire](https://flashfire.chainfire.eu)

### 07. 拓展阅读

1. [带你玩转安卓刷机](https://post.smzdm.com/p/724098)
2. [玩机指南汇总](https://www.imooc.com/article/70725)
3. [M3s MultiTool](https://forum.xda-developers.com/android/apps-games/app-m3s-multitool-t3919095)

