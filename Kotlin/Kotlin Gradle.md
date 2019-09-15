## Kotlin Gradle

![KotlinGradle.png](https://raw.githubusercontent.com/JustDo23/SnailMonitor/master/Picture/Cover/KotlinGradle.png)

> 引言：Accelerate developer productivity.
>
> 作者：JustDo23
>
> 时间：2019年09月14日
>
> 官网：[https://gradle.org](https://gradle.org)

### 01. 自动构建

|   Ant    |  Maven   |       Gradle       |
| :------: | :------: | :----------------: |
| 2000 年  | 2007 年  |      2012 年       |
| 编译测试 | 编译测试 |      编译测试      |
|    -     | 依赖管理 |      依赖管理      |
|    -     |    -     | DSL 自定义扩展任务 |

### 02. 语言类型

* 动态类型语言：在 **`运行期间`** 才去做 **`数据类型检查`** 的语言。
  * 例如： **`Python`**  **`Groove`**  **`JavaScript`**
* 静态类型语言：在 **`编译期间`** 就会做 **`数据类型检查`** 的语言。
  * 例如： **`Kotlin`**  **`Java`**

### 03. 脚本初识

文件名 **`build.gradle.kts`**

```kotlin
plugins {
    java// Java
    kotlin("jvm") version "1.3.50"// Kotlin
}

group = "com.just.gradle"// 项目名称
version = "1.0.0"// 项目版本号

repositories {
    mavenCentral()// Maven
}

dependencies {
    testCompile("junit", "junit", "4.12")// 测试依赖库
    implementation(kotlin("stdlib-jdk8"))// Kotlin 依赖库
}

configure<JavaPluginConvention> {
    sourceCompatibility = JavaVersion.VERSION_1_8// 指定编译版本
}
```

### 04. 构建灵魂

* Gradle 本身的领域对象主要有 **`Project`** 和 **`Task`**
* Project 为 Task 提供了执行的 **`容器`** 和 **`上下文`**

```kotlin
group = "com.just.gradle"// 项目名称
version = "1.0.0"// 项目版本号

task("oneTask") {// 声明定义任务
    println("This is a gradle task.")
    println("The name of this task is oneTask.")
}
```

在开发工具右侧 **`Gradle`** 菜单进行 **`同步`** 后可在 **`Tasks`** 目录下 **`other`** 目录内找到 **`oneTask`**

![oneTask.png](https://raw.githubusercontent.com/JustDo23/SnailMonitor/master/Picture/Kotlin/oneTask.png)

在命令行执行

```shell
# 指定被执行任务名称
$ ./gradlew oneTask
```

### 05. 任务依赖

* 大象装冰箱

```kotlin
task("openDoor") {
    println("Open the door.")
}
task("putElephant") {
    println("Put the elephant.")
}.dependsOn("openDoor")
task("closeDoor") {
    println("Close the door.")
}.dependsOn("putElephant")
```

* 函数 **`dependsOn()`** 指定了 **`依赖`** 关系，执行 **`当前`** 任务时 **`先执行被指定`** 任务

### 06. 生命周期

在 **`Gradle`** 脚本执行任务时：

* 先进行 **`扫描`** 操作
* 再进行 **`执行`** 操作

```kotlin
task("lifeCycle") {
    val important = "扫描时执行"
    println(important)// 扫描时输出
    doLast {
        println("运行时执行-后")
    }
    doFirst {
        println("运行时执行-先")
    }
}
```

### 07. 任务相关

* 多个任务的合集就是任务集

```kotlin
tasks {
    register("doNet") {
        doFirst {
            println("进行网络请求")
        }
    }
    register("showData") {
        dependsOn("doNet")
        doFirst {
            println("进行数据展示")
        }
    }
}
```

* 默认任务

```shell
# 执行指令查看所有任务
$ ./gradlew tasks
```

* 属性配置

```kotlin
task("showProperties") {
    project.properties.forEach { (t, any) ->
        println("$t = $any")// 循环打印属性配置
    }
}
```

* 设置默认

```kotlin
defaultTasks("showProperties")// 设置为默认任务
```

### 08. 增量更新

* 在构建 **`速度`** 上 **`Gradle`** 要比 **`Maven`** 快 100 倍
* 其中一个原因就是 **`Gradle`** 支持了 **`增量更新`**

```kotlin
// 增量更新
task("saveFileName") {
    inputs.dir("src")// 指定当前任务输入源
    outputs.file("name.txt")// 指定当前任务输出目标
    doFirst {
        val srcDir = fileTree("src")// 目录路径
        val nameFile = file("name.txt")// 存储文件
        nameFile.writeText("")// 文件置空
        srcDir.forEach {
            if (it.isFile) {
                Thread.sleep(1000)// 休眠一下
                nameFile.appendText(it.absolutePath)// 写入绝对路径
                nameFile.appendText("\r\n")
            }
        }
    }
}
```

* 重点是指定了任务的 **`输入源`** 和 **`输出目标`** ，在任务执行前会 **`检测`** 是否有 **`变化`**
* 若是 **`没有`** 变化则不会重复执行，控制台会提示

```
> Task :saveFileName UP-TO-DATE
```

### 09. 常用插件

* 插件是包含一个或者多个任务的合集

```kotlin
plugins {
    application// 应用程序
    java// Java
    kotlin("jvm") version "1.3.50"// Kotlin
    war// War
}
```

* [官方网站](https://gradle.org) 有教程 Using Gradle Plugins
* [Search Gradle plugins](https://plugins.gradle.org)

### 10. 依赖管理

* 自动依赖管理，添加所需依赖，自动网络下载并导入。
* 释放双手。比手动管理效率高太多。

```kotlin
repositories {
    mavenCentral()// 仓库 Maven
    jcenter()// 仓库 Jcenter
}

dependencies {
    testCompile("junit", "junit", "4.12")// 依赖库 测试
    implementation(kotlin("stdlib-jdk8"))// 依赖库 Kotlin
    implementation("com.google.code.gson", "gson", "2.8.5")// [group][name][version]
}
```

### 11. 依赖冲突

* 当有 **`两个及以上`** 的 **`直接或间接`** 的 **`相同`** 依赖时就会出现依赖的 **`冲突`**
* 默认情况下 **`Gradle`** 会 **`自动`** 选择 **`高版本`** 进行添加

```kotlin
dependencies {
    implementation("group", "name", "version"){
        exclude("group", "module")// 移除内部某个依赖模块
    }
}
```

### 12. 任务扩展

* 扩展已经定义好的任务

```kotlin
// 任务扩展
task("saveCode", Copy::class) {
    from("src")
    into("build")
}
task("deleteBuild", Delete::class) {
    setDelete("build")
}
```

### 13. 外部扩展

* 自定义 Java 类

```java
package com.just;

public class OutExtend {

    public static void main(String[] args) {
        System.out.println("在 Gradle 脚本中调用外部的 Java 代码。");
    }

}
```

* 构建脚本调用生成的字节码

```kotlin
// 调用外部扩展
task("callJava", JavaExec::class) {
    main = "com.just.OutExtend"// 指定类名
    classpath(sourceSets["main"].runtimeClasspath)// 指定字节码路径
}
```

### 14. 学习方法

* [Gradle 官网](https://gradle.org)
* [Kotlin 中文](https://www.kotlincn.net)
* [GitHub kotlin-dsl-samples](https://github.com/gradle/kotlin-dsl-samples)
* [全网首套, 手把手教你学会gradle](https://www.jianshu.com/p/000eaf104c09)

