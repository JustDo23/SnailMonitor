## Android Bugly 初体验

![Bugly.png](https://raw.githubusercontent.com/JustDo23/SnailMonitor/master/Picture/Cover/Bugly.png)

> 引言：腾讯 Bugly 集 `异常上报` `运营统计` `应用升级` `热更新` 等功能。
>
> 时间：2018年06月29日
>
> 作者：JustDo23
>
> 官网：[https://bugly.qq.com](https://bugly.qq.com)

### 01. 多分包

1. 工程 **`App 目录`** 修改 **`build.gradle`**

   ```groovy
   android {
       defaultConfig {
           multiDexEnabled true// 支持多分包
       }
   }

   dependencies {
       implementation 'com.android.support:multidex:1.0.3'// 多分包
   }
   ```

2. 继承方式

   ```java
   public class JustApplication extends MultiDexApplication {
       // 继承多分包
   }
   ```

3. 重写方式

   ```java
   public class JustApplication extends Application {

       @Override
       protected void attachBaseContext(Context base) {
           super.attachBaseContext(base);
           MultiDex.install(base);// 支持多分包
       }

   }
   ```

### 02. 添加插件

* 根目录

  ```groovy
  buildscript {
      dependencies {
          classpath "com.tencent.bugly:tinker-support:1.1.2"// TinkerSupport
      }
  }
  ```

### 03. 添加依赖

* 使用 **`Gradle`** 集成

  ```groovy
  android {
      defaultConfig {
          ndk {// 设置支持的SO库架构
              abiFilters 'armeabi' //, 'x86', 'armeabi-v7a', 'x86_64', 'arm64-v8a'
          }
      }
  }

  dependencies {
      implementation 'com.tencent.bugly:crashreport_upgrade:1.3.5'// [异常上报][应用更新]
      implementation 'com.tencent.tinker:tinker-android-lib:1.9.6'// Tinker
      implementation 'com.tencent.bugly:nativecrashreport:3.3.1'// NDK 不用可删除
  }
  ```

### 04. 插件脚本

* 工程 **`App 目录`** 创建 **`tinker-support.gradle`**

  ```groovy
  apply plugin: 'com.tencent.bugly.tinker-support'

  def bakPath = file("${buildDir}/bakApk/")

  /**
   * 此处填写每次构建生成的基准包目录
   */
  def baseApkDir = "app-0208-15-10-00"

  /**
   * 对于插件各参数的详细解析请参考
   */
  tinkerSupport {

      // 开启tinker-support插件，默认值true
      enable = true

      // 指定归档目录，默认值当前module的子目录tinker
      autoBackupApkDir = "${bakPath}"

      // 是否启用覆盖tinkerPatch配置功能，默认值false
      // 开启后tinkerPatch配置不生效，即无需添加tinkerPatch
      overrideTinkerPatchConfiguration = true

      // 编译补丁包时，必需指定基线版本的apk，默认值为空
      // 如果为空，则表示不是进行补丁包的编译
      // @{link tinkerPatch.oldApk }
      baseApk = "${bakPath}/${baseApkDir}/app-release.apk"

      // 对应tinker插件applyMapping
      baseApkProguardMapping = "${bakPath}/${baseApkDir}/app-release-mapping.txt"

      // 对应tinker插件applyResourceMapping
      baseApkResourceMapping = "${bakPath}/${baseApkDir}/app-release-R.txt"

      // 构建基准包和补丁包都要指定不同的tinkerId，并且必须保证唯一性
      tinkerId = "base-1.5"

      // 构建多渠道补丁时使用
      buildAllFlavorsDir = "${bakPath}/${baseApkDir}"

      // 是否启用加固模式，默认为false.(tinker-spport 1.0.7起支持）
      isProtectedApp = true

      // 是否开启反射Application模式
      enableProxyApplication = false

      // 是否支持新增非export的Activity（注意：设置为true才能修改AndroidManifest文件）
      supportHotplugComponent = true

  }
  ```

### 05. 引用脚本

* 工程 **`App 目录`** 修改 **`build.gradle`**

  ```groovy
  apply from: 'tinker-support.gradle'// Tinker
  ```

### 06. 初始化

* 使用推荐方式设置 **`enableProxyApplication = false`** 后进行初始化

1. 自定义的 **`Application`** 继承 **`DefaultApplicationLike`**

   ```java
   public class JustApplication extends DefaultApplicationLike {

       public JustApplication(Application application, int tinkerFlags, boolean tinkerLoadVerifyFlag, long applicationStartElapsedTime, long applicationStartMillisTime, Intent tinkerResultIntent) {
           super(application, tinkerFlags, tinkerLoadVerifyFlag, applicationStartElapsedTime, applicationStartMillisTime, tinkerResultIntent);
       }

       @TargetApi(Build.VERSION_CODES.ICE_CREAM_SANDWICH)
       @Override
       public void onBaseContextAttached(Context base) {
           super.onBaseContextAttached(base);
           MultiDex.install(base);// 必须支持多分包
           Beta.installTinker(this);// 安装初始化 Tinker
       }

       @TargetApi(Build.VERSION_CODES.ICE_CREAM_SANDWICH)
       public void registerActivityLifecycleCallback(Application.ActivityLifecycleCallbacks callbacks) {
           getApplication().registerActivityLifecycleCallbacks(callbacks);
       }

       @Override
       public void onCreate() {
           super.onCreate();
           Bugly.init(getApplication(), "AppID", true);// 最简单初始化 Bugly 异常上报 [true]测试阶段 [false]发布阶段
       }

   }
   ```

2. 新建 **`HotFixApplication`** 继承 **`TinkerApplication`**

   ```java
   /**
    * [Bugly][Tinker][全局入口]
    *
    * @author JustDo23
    */
   public class HotFixApplication extends TinkerApplication {

       /**
        * [Bugly][Tinker][全局入口]
        *
        * @params tinkerFlags 热更新类型
        * @params delegateClassName 自定义 Application 继承 ApplicationLike
        * @params loaderClassName 加载器
        * @params tinkerLoadVerifyFlag 是否验证 MD5
        */
       public HotFixApplication() {
           super(ShareConstants.TINKER_ENABLE_ALL, "com.just.channel.application.JustApplication", "com.tencent.tinker.loader.TinkerLoader", false);
       }

   }
   ```

3. 在 **`AndroidManifest.xml`** 中注册 **`HotFixApplication`**

   ```xml
   <application
       android:name=".application.HotFixApplication"
       android:allowBackup="true">
   </application>
   ```

### 07. 功能清单

1. 添加权限

  ```xml
  <uses-permission android:name="android.permission.READ_PHONE_STATE" />
  <uses-permission android:name="android.permission.INTERNET" />
  <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
  <uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
  <uses-permission android:name="android.permission.READ_LOGS" />
  ```

2. 注册 **`Activity`**

   ```xml
   <!-- Bugly -->
   <activity
       android:name="com.tencent.bugly.beta.ui.BetaActivity"
       android:configChanges="keyboardHidden|orientation|screenSize|locale"
       android:theme="@android:style/Theme.Translucent" />
   ```

3. 配置 **`FileProvider`**

   ```xml
   <!-- 兼容 Android N -->
   <provider
       android:name="android.support.v4.content.FileProvider"
       android:authorities="${applicationId}.fileProvider"
       android:exported="false"
       android:grantUriPermissions="true">
       <meta-data
           android:name="android.support.FILE_PROVIDER_PATHS"
           android:resource="@xml/provider_paths" />
   </provider>
   ```

4. 在 **`res`** 目录创建  **`xml`** 目录并在其下创建  **`provider_paths.xml`** 文件

   ```xml
   <?xml version="1.0" encoding="utf-8"?>
   <paths>
       <!-- /storage/emulated/0/Download/${applicationId}/.beta/apk-->
       <external-path
           name="beta_external_path"
           path="Download/com.just.channel/.beta/apk" />
       <!--/storage/emulated/0/Android/data/${applicationId}/files/apk/-->
       <external-path
           name="beta_external_files_path"
           path="Android/data/com.just.channel/files/apk/" />
   </paths>
   ```

5. 解决 **`FileProvider`** 冲突

   * 自定义 **`BuglyFileProvider`** 继承 **`FileProvider`**

   * 修改功能清单注册

     ```xml
     <provider
         android:name=".utils.BuglyFileProvider"
         android:authorities="${applicationId}.fileProvider"
         android:exported="false"
         android:grantUriPermissions="true"
         tools:replace="name,authorities,exported,grantUriPermissions">
         <meta-data
             android:name="android.support.FILE_PROVIDER_PATHS"
             android:resource="@xml/provider_paths"
             tools:replace="name,resource"/>
     </provider>
     ```

### 08. 代码混淆

* 配置避免混淆

  ```
  ### Bugly
  -dontwarn com.tencent.bugly.**
  -keep public class com.tencent.bugly.**{*;}
  ### Tinker
  -dontwarn com.tencent.tinker.**
  -keep class com.tencent.tinker.** { *; }
  ### Support
  -keep class android.support.**{*;}
  ```

