## Kotlin 协程入门

![KotlinCoroutine.png](https://raw.githubusercontent.com/JustDo23/SnailMonitor/master/Picture/Cover/KotlinCoroutine.png)

> 概述：Kotlin 中处理并发的新技能。
>
> 时间：2022年01月10日
>
> 作者：JustDo23

### 01. 协程是什么

1. **协程** 英文 **Coroutine** 是计算机程序的一类**组件**。

2. Kotlin 在 **JVM** 上的协程其实就是一个**线程框架**。

3. Android 上的 Kotlin 协程是一种**并发设计模式**，**简化异步执行**的代码。

4. **协程**是一种在程序中**处理并发任务**的**方案**，也是这种方案的一个**组件**。

5. 广义上来说协程和线程属于**一个层级**的概念。一个系统可以选择**不同的方案**解决并发任务。

6. 协程是**没有**线程的概念，也是没有**并行**的概念。

7. 线程的难点在于**线程安全**问题，存在线程安全问题的本质**原因**就是多个线程是可以**并行**的。并行是线程灵活的地方，也是容易出问题的地方。

8. **并发** 英文 **Concurrency** 指在同一时刻，只能有一条指令在执行但多个指令被快速的轮换执行，使得宏观上具有多个任务同时执行的效果，但在微观上非同时执行而只是把时间分成若干段，多个任务快速交替执行。

   ![concurrency.png](https://raw.githubusercontent.com/JustDo23/SnailMonitor/master/Picture/Kotlin/concurrency.png)

9. **并行** 英文 **Parallellism** 指在同一时刻，有多条指令在多个处理器上同时运行。所以，无论从微观还是从宏观来看，多条任务都是一起在执行的。

   ![parallellism.png](https://raw.githubusercontent.com/JustDo23/SnailMonitor/master/Picture/Kotlin/parallellism.png)

10. 并发是在同一个实体上的多个事件，并行是在不同实体上的多个事件。

11. 协程是**协作式**多任务，线程是**抢占式**多任务。

11. 协程以同步的方式去编写异步执行的代码。

### 02. 简单代码

Kotlin 协程的导包：

```groovy
implementation "org.jetbrains.kotlin:kotlin-stdlib:1.5.31" // Kotlin    
implementation "org.jetbrains.kotlinx:kotlinx-coroutines-core:1.4.3" // 协程核心库    
implementation "org.jetbrains.kotlinx:kotlinx-coroutines-android:1.4.3" // 协程Android支持库
```

Kotlin 协程的简单示例：

```kotlin
override fun onCreate(savedInstanceState: Bundle?) {
    GlobalScope.launch { // 这个协程就是在后台执行的
        println("^_^ A. ${Thread.currentThread().name}")
    }
    GlobalScope.launch {
        println("^_^ B. ${Thread.currentThread().name}")
    }
    println("^_^ C. ${Thread.currentThread().name}")
}
```

输出结果：

```
System.out: ^_^ C. main
System.out: ^_^ A. DefaultDispatcher-worker-1
System.out: ^_^ B. DefaultDispatcher-worker-2
```

小结：

* 用 launch() 来开启一段协程。
* 当 launch() 无参数时，被创建的这个协程默认就是在后台执行的。
* 实际上每一个协程都会提供一个线程池，这个线程池可能是后台也可能是主线程，但都是创建了一个专属这个协程的线程环境。
* 使用 **CoroutineScope** 协程作用域来结构化管理协程。
* 注意：一个线程中可以创建多个协程，协程挂起时不会阻塞线程。

Kotlin 协程的线程切换：

```kotlin
override fun onCreate(savedInstanceState: Bundle?) {
    GlobalScope.launch(Dispatchers.Main) { // 设置为主线程的环境
        ioMethod() // 切入后台
        uiMethod() // 回到前台
    }
}

private suspend fun ioMethod() {
    withContext(Dispatchers.IO) {
        println("^_^ ioMethod ${Thread.currentThread().name}")
    }
}

private fun uiMethod() {
    println("^_^ uiMethod ${Thread.currentThread().name}")
}
```

输出结果：

```
System.out: ^_^ ioMethod DefaultDispatcher-worker-1
System.out: ^_^ uiMethod main
```

小结：

* 关键字 **suspend** 只是一个标记作用，它本身是不会切线程的。
* 使用 **`withContext()`** 进行线程的切换。
* 被 suspend 修饰的函数，**只能**在一个协程或者另一个被 suspend 修饰的函数中进行调用。
* 按照一条线写下来，线程会**自动切换**。注意是自动切换，且最终会回到创建时的那个专属线程环境。

### 03. 协程的优势

* **轻量**：可在单个线程上运行多个协程，因协程支持挂起，不会使正在运行协程的线程阻塞。挂起比阻塞节省内存，且支持多个并行操作。
* **内存泄露更少**：使用**`结构化并发`**机制在一个作用域内执行多项操作。
* **内置取消支持**：取消操作会自动在运行中的整个协程层次结构内传播。
* **JetPack 集成**
* 协程的额外天然优势：**性能**

### 04. 回顾协程

* 线程框架
* 可以用看起来同步的代码写出实质上异步的操作
  * 关键亮点一：耗时函数自动后台，从而提高性能
  * 关键亮点二：线程的自动切回
* 修饰符 **suspend**
  * 并不是用来切线程的。
  * 关键作用：标记和提醒。
  * 标记函数是一个挂起函数。
  * 运行在协程里边或者是另个一挂起函数中。否则编译时会报错。
  * 协程上下文环境以便于切出去后再切回来。

### 05. 简单实践

1. 网络请求 **Retrofit** 支持协程
2. 响应编程 **RxJava** 对比协程
   * 并发任务的处理，通过管理线程来管理并发。
   * 管理事件流。
3. 协程更加的简单方便。
4. 处理复杂网络请求情景：多个网络请求的结果合并后再继续。
   * 基础方案回调嵌套
   * 使用 RxJava 中的 zip 方法
   * 使用协程中 async 函数
5. Java 并发编程 **Future** 和 **FutureTask** 实现获取线程执行结果。

### 06. 协程泄露

当界面销毁的时候如果存在活跃的正在执行的线程在运行，则会内存泄露。该活跃线程不会被回收，它是一个 GC Root 是不会被回收的。

* 本质上是内存泄露
* 本质上是线程的泄露

协程的取消方法是调用 **CoroutineScope** 或者 **Job** 的 **cancel()** 函数。结构化并发机制。

```kotlin
private val customScope = MainScope() // 主线程环境的协程作用域

override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    // 自定义
    customScope.launch {
        Log.e("^_^", " customScope ${Thread.currentThread().name}")
    }
    // 生命周期扩展可自动取消
    lifecycleScope.launch {
        Log.e("^_^", " lifecycleScope ${Thread.currentThread().name}")
    }
}

override fun onDestroy() {
    super.onDestroy()
    customScope.cancel() // 协程取消
}
```

### 07. 简单深入

1. 协程往主线程上切，核心也是使用了 Handler 进行的。

   ```kotlin
   public sealed class HandlerDispatcher : MainCoroutineDispatcher(), Delay {
       override fun dispatch(context: CoroutineContext, block: Runnable) {
           handler.post(block)
       }
   }
   ```

2. 协程作用域代码块中的逻辑代码被编译为 switch case 分块执行。

3. 为什么协程挂起却不会阻塞主线程。其主要原因还是依赖于 Handler 实现的，代码 `handler.post() ` 其参数待执行的代码，在界面下一帧到来时进行执行，在主线程中执行。

4. 协程的 `delay()` 和 `Tread.sleep()`

   * 用协程的 `delay()` 即能定时又能延时，更方便。
   
5. 基础很重要。
