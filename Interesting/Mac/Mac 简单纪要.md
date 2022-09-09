## Mac 简单纪要

![Mac.png](https://raw.githubusercontent.com/JustDo23/SnailMonitor/master/Picture/Cover/Mac.png)

> 引言：初次见面，请多关照。
>
> 作者：JustDo23
>
> 时间：2016年10月31日

### 01. 触控板

系统 **`触控板`** 教程：

* 点击 **`左上角`** 苹果图标
* 选择 **`系统偏好设置`**
* 选择 **`触控板`**

### 02. 键位符号

* 符号 **`⌘`** 代表 **`command`**
* 符号 **`⌥`** 代表 **`option/alt`**
* 符号 **`⌃`** 代表 **`control`**
* 符号 **`⇧`** 代表 **`shift`**
* 符号 **`⏎`** 代表 **`enter/return`**

### 03. 快捷键

| 组合                   | 功能                 |
| ---------------------- | :------------------- |
| Command + Tab          | 应用的切换           |
| Command + Q            | 退出应用             |
| Command + C            | 复制                 |
| Command + V            | 粘贴                 |
| Command + Z            | 撤销                 |
| Command + Shift + Z    | 重做                 |
| Command + A            | 全选                 |
| Command + M            | 最小化               |
| Command + F            | 搜索               |
| Command + W            | 关闭标签             |
| Command + T            | 打开新的标签         |
| Command+ Shift + T     | 打开刚才关闭的标签   |
| Command ＋ R           | 进行网页刷新         |
| Command + Delete       | 删除放入回收站       |
| Enter                  | 重命名               |
| Command + Control + F  | 全屏                 |
| Command + Control + A  | QQ 截图功能          |
| Command + ,            | 打开当前应用偏好设置 |
| Command + Option + ESC | 强制退出应用         |
| Fn + F3 | 打开调度中心 |
| Fn + F4 | 打开 Launchpad |

### 04. 编辑 hosts 文件

* 打开 **`终端`** 输入命令 **`sudo su`**
* 按提示输入 **`密码`**
* 输入命令 **`vim /etc/hosts`**
* 看到文件内容但无法编辑
* 键盘按下 **`i`** 进入 **`编辑`** 模式
* 方向键控制 **`光标`** 位置
* 键盘按下 **`esc`** 可以 **`退出`** 编辑
* 输入命令 **`:wq`** 可以 **`保存`** 并 **`退出`**

### 05. 系统过大

```shell
# 扫描并显示当前目录各文件大小
$ du -sh *   
```

