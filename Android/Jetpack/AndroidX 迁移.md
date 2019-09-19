## AndroidX 迁移

![AndroidX.png](https://raw.githubusercontent.com/JustDo23/SnailMonitor/master/Picture/Cover/AndroidX.png)

> 引言：Android Support Library Exit History.
>
> 作者：JustDo23
>
> 时间：2019年09月18日
>
> 官网：[https://developer.android.google.cn/jetpack/androidx](https://developer.android.google.cn/jetpack/androidx)

### 01. 简单概览

* **`AndroidX`** 是 **`JetPack`** 中与操作系统 **`解除捆绑`** 并且 **`向后兼容`** 的开源项目。
* **`AndroidX`** 完全取代 **`Support`** 并提供新的功能及特性。
* 所有 **`Support`** 有关旧类 **`完整映射`** 到 **`AndroidX`** 中。
* **`AndroidX`** 使用严格的 **`语义版本控制`** 并可以进行 **`单独更新`** 。
* [语义版本控制](https://semver.org/lang/zh-CN/)

### 02. 初步使用

* 需要设置 **`compileSdkVersion`** 为 **`28`** 及以上
* 在 **`gradle.properties`** 文件中进行配置

```shell
# 是否指定使用 AndroidX
android.useAndroidX=true
# 是否将第三方依赖转换为 AndroidX
android.enableJetifier=true
```

* 若 **`useAndroidX`** 为 **`true`** 则 Android **`插件`** 会自动使用相应的 **`AndroidX`** 而非 **`Support`**
* 若 **`enableJetifier`** 为 **`true`** 则 Android **`插件`** 会重写第三方库的 **`二进制`** 文件，自动迁移 **`现有的第三方库`** 以使用 **`AndroidX`**

### 03. 项目迁移

* 使用 **`Android Studio 3.2`** 及更高版本
* 菜单栏依次选择 **Refactor > Migrate to AndroidX**
* 弹窗提示是否进行 **`项目备份`**
* 指定备份路径或者跳过备份
* 自动进行 **`项目扫描`** 并在 **`Find`** 中提示 **`所有引用`**
* 点击 **`Do Refactor`** 进行迁移
* 注意：这里并不是结束，有可能还有很多包名替换是错误的，需要手动调整

### 04. Glide

```groovy
dependencies {
    implementation 'com.github.bumptech.glide:glide:4.9.0'// Glide
    annotationProcessor 'com.github.bumptech.glide:compiler:4.9.0'// Glide
}
```

如上配置，在 **`编译时`** 仍旧会报错，自动生成的文件总是引用 **`android.support.annotation.CheckResult`** 等 **`Support`** 注解包内的类。

```groovy
apply plugin: 'kotlin-android'
apply plugin: 'kotlin-android-extensions'
apply plugin: 'kotlin-kapt'

classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:1.3.50"// Kotlin

dependencies {
    implementation 'com.github.bumptech.glide:glide:4.9.0'// Glide
    kapt 'com.github.bumptech.glide:compiler:4.9.0'// Glide
}
```

如上解决，项目原本没有引入 **`Kotlin`** 在引入之后使用 **`kapt`** 替换注解编译器，问题解决。

### 05. FileProvider

```xml
<provider
    android:name="androidx.core.content.FileProvider"
    android:authorities="${applicationId}.fileProvider"
    android:exported="false"
    android:grantUriPermissions="true">
    <meta-data
        android:name="android.support.FILE_PROVIDER_PATHS"
        android:resource="@xml/file_paths" />
</provider>
```

如上结果，迁移 **`AndroidX`** 只需要修改 **`provider`** 节点下的 **`android:name`** 其余配置不变。

### 06. 迁移检查

* 执行指令来检查依赖关系

```shell
# 只查看 release 的依赖关系
$ ./gradlew app:dependencies --configuration releaseCompileClasspath
```

* 快捷键 **`Command + Shift + F`** 全局搜索 **`android.support`**
* 运行程序隐藏的编译错误

### 07. 个人经验

* 第一个项目本身引入了 **`Kotlin`** 在自动迁移之后需要手动修改很多错误的包名
* 第二个项目没有引入过 **`Kotlin`** 在自动迁移之后包名基本全部正确替换
* 可以尝试多次进行自动迁移操作以达到正确替换包名的目的

### 08. 包名替换

* 快捷键 **`Command + Shift + R`** 进行全局搜索替换

| 问题包名                                      | 新版包名                                          |
| --------------------------------------------- | ------------------------------------------------- |
| android.support.annotation.NonNull            | androidx.annotation.NonNull                       |
| android.support.annotation.Nullable           | androidx.annotation.Nullable                      |
| android.support.constraint.ConstraintLayout   | androidx.constraintlayout.widget.ConstraintLayout |
| android.support.v4.widget.NestedScrollView    | androidx.core.widget.NestedScrollView             |
| android.support.v7.widget.RecyclerView        | androidx.recyclerview.widget.RecyclerView         |
| android.support.v7.widget.LinearLayoutManager | androidx.recyclerview.widget.LinearLayoutManager  |
| android.support.constraint.Guideline          | androidx.constraintlayout.widget.Guideline        |
| android.support.v7.widget.CardView            | androidx.cardview.widget.CardView                 |
| androidx.core.view.ViewPager                  | androidx.viewpager.widget.ViewPager               |
| android.support.v4.view.PagerAdapter          | androidx.viewpager.widget.PagerAdapter            |
| android.support.v4.app.FragmentManager        | androidx.fragment.app.FragmentManager             |
| android.support.v4.app.FragmentTransaction    | androidx.fragment.app.FragmentTransaction         |
| android.support.v7.app.AppCompatDialog        | androidx.appcompat.app.AppCompatDialog            |

### 09. 拓展阅读

* [Android Developers](https://developer.android.com/index.html)
* [Android 开发者](https://developer.android.google.cn)
* [Android:你好,androidX！再见,android.support](https://www.jianshu.com/p/41de8689615d)

