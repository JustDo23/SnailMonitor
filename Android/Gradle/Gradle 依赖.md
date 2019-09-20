## Gradle 依赖

![Gradle.png](https://raw.githubusercontent.com/JustDo23/SnailMonitor/master/Picture/Cover/Gradle.png)

> 引言：Gradle 中的知识点。
>
> 作者：JustDo23
>
> 时间：2019年09月20日
>
> 官网：[https://gradle.org](https://gradle.org)

### 01. 声明依赖

平时最常见的关键修饰符：

* 修饰符 **`api`**
* 修饰符 **`implementation`**

在官网 [The Java Library Plugin](https://docs.gradle.org/current/userguide/java_library_plugin.html) 中对两者区别描述如下：

> The **`api`** configuration should be used to declare dependencies which are **`exported`** by the library API, whereas the **`implementation`** configuration should be used to declare dependencies which are **`internal`** to the component.

* 配置  **`api`** 则将依赖关系 **`暴露`** 给使用者。
* 配置  **`implementation`** 则依赖关系将对使用者 **`隐藏`** 。

### 02. 传递关系

```groovy
apply plugin: 'com.android.application'// 主项目 Module APP

dependencies {// 本地依赖
    implementation project(path: ':A')
    api project(path: ':B')
}
```

* 对于 **`同一个 Module`** 而言，两个修饰符是 **`没有区别`** 的。

```groovy
apply plugin: 'com.android.library'// 库 Module A

dependencies {// 本地依赖
    implementation project(path: ':P')
    api project(path: ':Q')
}
```

* 两者的区别主要体现在具有 **`多层级`** 依赖关系情况。

```groovy
apply plugin: 'com.android.library'// 库 Module A

dependencies {// 本地依赖
    implementation project(path: ':P')
    api project(path: ':Q')
}
```

结果表现如下：

![dependencyTransitive.png](https://raw.githubusercontent.com/JustDo23/SnailMonitor/master/Picture/Android/Gradle/dependencyTransitive.png)

* 其中 **`绿色`** 代表 **`APP`** 可直接调用，而 **`红色`** 代表 **`APP`** 无法调用。

### 03. 值得注意

* 如上依赖传递层级足以体现两个修饰符之间区别的重要原因是：
  * 模块 **`A`** 和 **`B`** 是建立在本地的依赖库
* 模块 **`P`** 和 **`X`** 只是在 **`调用`** 层面对 **`APP`** 隐藏了，其代码仍会被打进 **`APK`** 文件
* 模块 **`P`** 和 **`Q`** 这一层是 **`本地或远程`** 依赖库都可以

**`Tips:`** 假设模块 **`A`** 是远程依赖，则模块 **`P`** 和 **`Q`** 也是远程依赖，模块 **`APP`** 添加 **`A`** 之后是否会自动下载导入 **`P`** 和 **`Q`** 是由 **`A`** 在远程 **`Maven`** 仓库的配置文件 **`.pom`** 决定的。

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0">
    <modelVersion>4.0.0</modelVersion>
    <groupId>com.just.library</groupId>
    <artifactId>utils</artifactId>
    <version>3.2.1</version>
    <packaging>aar</packaging>
    <dependencies>
        <dependency>
          <groupId>com.nineoldandroids</groupId>
          <artifactId>library</artifactId>
          <version>2.4.0</version>
        </dependency>
    </dependencies>
</project>
```

### 04. 查看传递

* 执行指令来检查依赖关系

```shell
# 只查看 release 的依赖关系
$ ./gradlew app:dependencies --configuration releaseCompileClasspath
```

节选输出关系列表

```
+--- project :B
|    \--- project :Y
+--- project :A
|    \--- project :Q
```

### 05. 拓展阅读

* [Gradle 的依赖关系处理不当，可能导致你编译异常](https://www.cnblogs.com/plokmju/p/gradle_res.html)

