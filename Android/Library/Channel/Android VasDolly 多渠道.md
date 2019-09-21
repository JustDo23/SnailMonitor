## Android VasDolly 多渠道

![Channel.png](https://raw.githubusercontent.com/JustDo23/SnailMonitor/master/Picture/Cover/Channel.png)

> 引言：企鹅电竞开源的快速多渠道打包工具。
>
> 时间：2018年06月27日
>
> 作者：JustDo23
>
> Github：[https://github.com/Tencent/VasDolly](https://github.com/Tencent/VasDolly)

### 01. 简介

> Android V1 and V2 Signature Channel Package Plugin.

支持 **`v1`** 和 **`v2`** 签名方案的 **`多渠道`** 打包插件。

### 02. 配置签名

```groovy
android {
    signingConfigs {
        release {
            storeFile file("../JustDo.jks")
            storePassword "123456"
            keyAlias "just"
            keyPassword "123456"
            v1SigningEnabled true
            v2SigningEnabled true
        }
        debug {
            storeFile file("../JustDo.jks")
            storePassword "123456"
            keyAlias "just"
            keyPassword "123456"
            v1SigningEnabled true
            v2SigningEnabled true
        }
    }
    buildTypes {
        release {
            minifyEnabled false
            signingConfig signingConfigs.release
        }
        debug {
            minifyEnabled false
            signingConfig signingConfigs.debug
        }
    }
}
```

* 指定 **`签名文件`**
* 指定 **`签名方案`**
* 代码可以进行精简

### 03. 添加插件

* 根目录

```groovy
buildscript {
    dependencies {
        classpath 'com.leon.channel:plugin:2.0.1'// VasDolly
    }
}
```

### 04. 引用插件

* App 目录

```groovy
apply plugin: 'com.android.application'
apply plugin: 'channel'// VasDolly
```

### 05. 添加依赖库

* App 目录

```groovy
dependencies {
    api 'com.leon.channel:helper:2.0.1'// VasDolly
}
```

### 06. 渠道信息

* 两种配置方式。
* 最终为两者的累加之和。

### 07. 配置渠道

1. 方式一

   * 根目录

     此方式必须在 **`根目录`** 下创建渠道文件 **`channel.txt`** 一行一个渠道

     ```
     BaiDu
     HuaWei
     ```

   * 在 **`gradle.properties`** 文件配置

     ```
     # VasDolly
     channel_file=channel.txt
     ```

2. 方式二

   * 创建渠道文件 **`multiChannel.txt`** 一行一个渠道

   * 在脚本 **`rebuildChannel`** 中指定 **`channelFile`**

     ```groovy
     rebuildChannel {
         channelFile = file("../script/multiChannel.txt")// 指定渠道列表文件
     }
     ```

### 08. 直接打包任务

1. 在根目录创建 **`multiChannel.gradle`** 文件

   ```groovy
   /**
    * 直接编译多渠道
    */
   channel {
       // 指定渠道列表文件
       channelFile = file("../channel.txt")
       // 多渠道包的输出目录，默认为 new File(project.buildDir,"channel")
       baseOutputDir = new File(project.buildDir, "MultiChannelOutput")
       // 多渠道包的命名规则，默认为：${appName}-${versionName}-${versionCode}-${flavorName}-${buildType}
       apkNameFormat = '${appName}-${versionName}-${buildTime}-${flavorName}-${buildType}'
       // 快速模式：生成渠道包时不进行校验（速度可以提升10倍以上，默认为false）
       isFastMode = false
       // buildTime的时间格式，默认格式：yyyyMMdd-HHmmss
       buildTimeDateFormat = 'yyyyMMdd-HH:mm:ss'
       // 低内存模式（仅针对V2签名，默认为false）：只把签名块、中央目录和EOCD读取到内存，不把最大头的内容块读取到内存，在手机上合成APK时，可以使用该模式
       lowMemory = false
   }
   ```

2. 在 App 目录进行引用

   ```groovy
   apply from: '../multiChannel.gradle'// 多渠道
   ```

### 09. 直接编译

1. 进行项目 **`同步`**
2. 点击右侧 **`Gradle projects`** 视图选择 **`Tasks`** 选择 **`channel`** 选择  **`channelRelease`** 进行编译打包
3. 输出目录 **`app/build/MultiChannelOutput/release`**

### 10. 读取渠道

```java
String channel = ChannelReaderUtil.getChannel(getApplicationContext());// 读取渠道信息
if (!TextUtils.isEmpty(channel)) {
    tv_channel.setText(channel);
}
```

### 11. 踩坑加固

1. 踩坑
   * 使用 **`360加固`** 之后发现渠道信息被删除
2. 解决
   * 打出一个 **`基础包`** 并进行 **`加固`**
   * 基于加固后的基础包进行多渠道包生成

### 12. 基础包

1. 正常手动打包流程
2. 点击右侧 **`Gradle projects`** 视图选择 **`Tasks`** 选择 **`build`** 选择  **`assembleRelease`** 进行编译打包
3. 使用 **`360加固`**

### 13. 基础包生成渠道包

1. 根目录 **`multiChannel.gradle`** 添加

   ```groovy
   /**
    * 根据已有基础包重新生成多渠道包
    */
   rebuildChannel {
     channelFile = file("../channel.txt")
     baseDebugApk = file("../baseDebug.apk")// 已有 Debug
     baseReleaseApk = file("../baseRelease.apk")// 已有 release
     // 默认为new File(project.buildDir, "rebuildChannel/debug")
     debugOutputDir = Debug渠道包输出目录
     // 默认为new File(project.buildDir, "rebuildChannel/release")
     releaseOutputDir = Release渠道包输出目录
     isFastMode = false
     lowMemory = false
   }
   ```

2. 进行项目 **`同步`**

3. 点击右侧 **`Gradle projects`** 视图选择 **`Tasks`** 选择 **`channel`** 选择  **`rebuildChannel`** 进行编译打包

4. 输出目录 **`app/build/rebuildChannel/release`**

### 14. 命令行

1. 利用 **`VasDolly.jar`** 执行命令行 **`检查`** 渠道信息

   ```shell
   java -jar VasDolly.jar get -c channel.apk
   ```

### 15. 脚本

* 编写 **`shell`** 脚本检查所有渠道包信息

* 源文件 **`channelScript.sh`**

  ```shell
  #!/bin/sh
  echo -e "请输入 VasDolly 工具路径："
  read toolDir
  echo -e "请输入 源 路径："
  read currentDir
  #currentDir=${PWD}
  outputFile=${currentDir}/channelList.txt
  echo -e "      ------> 路径 <------      "
  echo -e "工具路径：${toolDir}"
  echo -e "源  路径：${currentDir}"
  echo -e "输出文件：${outputFile}"
  #清空OutputFile
  : > $outputFile
  echo `date` >> $outputFile
  echo '      ------> [开始] <------      ' >> $outputFile
  # 设置用换行符做分隔
  IFS=$'\n'
  # 循环读取文件夹下APK
  for fileItem in ${currentDir}/*.apk;
  do
      echo `basename ${fileItem}` >> $outputFile
  for resultItem in `java -jar ${toolDir} get -c ${fileItem}`;
      do
      if [[ ${resultItem} == 'try'* ]]
      then
      echo -e "\t${resultItem}" >> $outputFile
      fi
      if [[ ${resultItem} == 'Channel'* ]]
      then
      echo -e "\t${resultItem}" >> $outputFile
      fi
      done
  done
  echo -e '      ------> [结束] <------      \n' >> $outputFile
  open $outputFile
  ```

* 执行命令

  ```shell
  bash channelScript.sh
  ```

### 16. 拓展阅读

1. [VasDolly 实现原理](https://github.com/Tencent/VasDolly/wiki/VasDolly实现原理)
2. [带你了解腾讯开源的多渠道打包技术 VasDolly 源码解析](https://blog.csdn.net/lmj623565791/article/details/79998048)