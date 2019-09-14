## Android Bugly 集成优化

![Bugly.png](https://raw.githubusercontent.com/JustDo23/SnailMonitor/master/Picture/Cover/Bugly.png)

> 引言：`多渠道` `异常上报` `热更新`
>
> 时间：2018年10月12日
>
> 作者：JustDo23
>
> 官网：[https://bugly.qq.com](https://bugly.qq.com)

### 01. 工具类

```java
/**
 * 腾讯 Bugly 工具类
 *
 * @since 2018年06月29日
 */
public class BuglyUtil {

    private static BuglyUtil instance;

    private BuglyUtil() {

    }

    public static BuglyUtil getInstance() {
        if (instance == null) {
            synchronized (BuglyUtil.class) {
                if (instance == null) {
                    instance = new BuglyUtil();
                }
            }
        }
        return instance;
    }

    private static final String BUGLY_APP_ID = "AppId";

    /**
     * 初始化 Bugly
     *
     * @param context 上下文
     */
    public void initBugly(Context context) {
        Context applicationContext = context.getApplicationContext();
        String packageName = applicationContext.getPackageName();// 获取当前包名
        String processName = getProcessName(android.os.Process.myPid());// 获取当前进程名
        CrashReport.UserStrategy strategy = new CrashReport.UserStrategy(applicationContext);// 高级设置
        strategy.setUploadProcess(processName == null || processName.equals(packageName));// 设置是否为上报进程
        strategy.setAppChannel(ChannelUtil.getInstance().getChannel(context));// 设置渠道
        Bugly.init(applicationContext, BUGLY_APP_ID, BuildConfig.DEBUG, strategy);// 初始化Bugly [true]测试阶段 [false]发布阶段 [新增了升级功能]
    }

    /**
     * 获取进程号对应的进程名
     *
     * @param pid 进程号
     * @return 进程名
     */
    public String getProcessName(int pid) {
        BufferedReader reader = null;
        try {
            reader = new BufferedReader(new FileReader("/proc/" + pid + "/cmdline"));
            String processName = reader.readLine();
            if (!TextUtils.isEmpty(processName)) {
                processName = processName.trim();
            }
            return processName;
        } catch (Throwable throwable) {
            throwable.printStackTrace();
        } finally {
            try {
                if (reader != null) {
                    reader.close();
                }
            } catch (IOException exception) {
                exception.printStackTrace();
            }
        }
        return null;
    }


    /**
     * 设置场景标签
     *
     * @param context 上下文
     * @param tag     标签值[后台配置][进入场景调用]
     */
    public void setSceneTag(Context context, int tag) {
        CrashReport.setUserSceneTag(context, tag); // 上报后的Crash会显示该标签
    }

    /**
     * 设置是否是测试机器
     *
     * @param context   上下文
     * @param isDevelop 是否是测试机器
     */
    public void setIsDevelopDevice(Context context, boolean isDevelop) {
        CrashReport.setIsDevelopmentDevice(context, isDevelop); // 是测试机器
    }

    /**
     * 设置用户 ID
     *
     * @param userId 用户标识[用户登录后传递]
     */
    public void setUserId(String userId) {
        CrashReport.setUserId(userId);
    }

    /**
     * 主动上传异常
     *
     * @param throwable 异常
     */
    public void postCrash(Throwable throwable) {
        CrashReport.postCatchedException(throwable);
    }

    /**
     * 热修复弹窗提示重启
     *
     * @param isShow [true,弹窗提示]
     */
    public void showHotFixDialog(boolean isShow) {
        Beta.canNotifyUserRestart = isShow;
    }

}
```

### 02. 构建脚本

* 两个脚本合并在一个 **`bugly.gradle`** 文件中

```groovy
apply plugin: 'com.tencent.bugly.tinker-support'// 引用插件

def rootPath = "/Users/JustDo/Desktop/Sign/Bugly"// 文件根目录
def projectName = "JustChannel"// 项目名称

def versionCode = "20181012"// 时间
def versionName = "1.2.3"// 版本号
def TinkerID = "1.2.3-base"// 唯一TinkerID
def baseSafeApkName = "just_123_20181012.apk"// 加固后包名

def basePath = "${rootPath}/${projectName}/${versionCode}"// 根目录
def baseApkPath = "${basePath}" + "/" + "base"// 基准包目录
def baseSafePath = "${basePath}" + "/" + "360"// 加固后基准包目录
def channelPath = "${basePath}" + "/" + "channel"// 渠道包目录
def hotFixPath = "${basePath}" + "/" + "patch"// 热更新插件目录


tinkerSupport {

    enable = true// [默认true]是否开启插件

    autoBackupApkDir = "${basePath}"// [默认tinker目录]指定归档目录

    overrideTinkerPatchConfiguration = true// [默认false]是否覆盖tinkerPatch配置

    baseApk = "${baseApkPath}/app-release.apk"// 指定基准包[默认空]为空不编译补丁[等同tinkerPatch.oldApk]

    baseApkProguardMapping = "${baseApkPath}/app-release-mapping.txt"// 混淆文件[等同tinkerPatch.applyMapping]

    baseApkResourceMapping = "${baseApkPath}/app-release-R.txt"// R文件[等同tinkerPatch.applyResourceMapping]


    tinkerId = "${TinkerID}"// 构建基准包和补丁包都要指定不同的tinkerId，并且必须保证唯一性


    buildAllFlavorsDir = "${baseApkPath}"// 构建多渠道补丁时使用

    isProtectedApp = true// [默认false]是否启用加固模式

    enableProxyApplication = false// 是否开启反射Application模式

    supportHotplugComponent = true// 是否支持新增非export的Activity[为true可修改AndroidManifest]

}

/**
 * 根据已有基础包重新生成多渠道包[先加固后多渠道]
 */
rebuildChannel {
    channelFile = file("../script/multiChannel.txt")// 指定渠道列表文件
    baseReleaseApk = file("${baseSafePath}/${baseSafeApkName}")// 已有 release 且已加固
    releaseOutputDir = new File("${channelPath}")// 输出 release
    isFastMode = false// 快速模式
    lowMemory = false// 低内存模式
}
```

* 多渠道构建脚本
* 热更新构建脚本

### 03. 操作流程

1. 在 **`app`** 目录下 **`bulid.gradle`** 引用脚本文件

   ```groovy
   apply from: '../script/bugly.gradle'// [多渠道][热更新]
   ```

2. 指定基础包 **`TinkerID`**

   ```groovy
   def TinkerID = "1.2.3-base"// 基础包 TinkerID
   ```

3. 编译基础包

   * 右侧 **`Gradle projects`** 视图

   * 点击 **`assembleRelease`**

     ![编译基础包](https://raw.githubusercontent.com/JustDo23/SnailMonitor/master/Picture/Android/Library/Bugly/assembleRelease.png)

4. 加固基础包

   * 使用 **`360加固助手`** 加固

5. 生成渠道包

   - 点击 **`reBuildChannel`**

     ![生成渠道包](https://raw.githubusercontent.com/JustDo23/SnailMonitor/master/Picture/Android/Library/Bugly/reBuildChannel.png)

6. 上线

   * 渠道包上传对应的应用市场

7. 修复 BUG

   * 用户反馈的崩溃等异常及时处理

8. 指定补丁包 **`TinkerID`**

   ```groovy
   def TinkerID = "1.0.0-patch-01"// 补丁包 TinkerID
   ```

9. 生成补丁

   * 点击 **`buildTinkerPatchRelease`**

     ![生成补丁](https://raw.githubusercontent.com/JustDo23/SnailMonitor/master/Picture/Android/Library/Bugly/buildTinkerPatchRelease.png)

10. 上传补丁

    * 补丁包位置 **`build/outputs/patch`**

    * 上传文件 **`patch_signed_7zip.apk`**

      ![上传补丁](https://raw.githubusercontent.com/JustDo23/SnailMonitor/master/Picture/Android/Library/Bugly/deployPatch.png)

**Tips：** 注意操作过程中文件及文件夹的名称修改。

