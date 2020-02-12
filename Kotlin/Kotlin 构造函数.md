## Kotlin 构造函数

![Kotlin](https://raw.githubusercontent.com/JustDo23/SnailMonitor/master/Picture/Cover/Kotlin.png)

> 引言：面对对象中的基础知识点。
>
> 作者：JustDo23
>
> 时间：2020年02月11日
>
> 官网：[https://kotlinlang.org](https://kotlinlang.org)

### 01. 构造函数

1. 在 **`Kotlin`** 中一个类可以有 **`一个`**  **`主构造函数`** 以及 **`一个或多个`**  **`次构造函数`** 。
2. 关键字 **`constructor`** 声明 **`构造函数`** 。

### 02. 主构造函数

1. **`主构造函数`** 是 **`类头`** 的一部分：它跟在类名（与可选的类型参数）后。

   ```kotlin
   // 声明一个类
   class Person { }
   // 无参主构造
   class Person constructor() { }
   // 含参主构造
   class Person constructor(firstName: String) { }
   // 主构造无注解或修饰符时可进行省略
   class Person(firstName: String) { }
   // 主构造被修饰并被注解
   class Person public @Inject constructor(firstName: String)
   // 主构造参数可以声明只读或可变
   class Person(val firstName: String, var lastName: String)
   ```

    * 主构造函数中的参数被声明只读或可变后，就会成为成员属性，可以被实例访问或赋值。

2. **`主构造函数`** 不能包含任何的代码。

3. 如果一个 **`非抽象类`** 没有声明任何构造函数，它会有一个默认生成的 **`不带参数`** 的 **`主构造函数`** 。

4. **`初始化`** 的代码可以放到以 **`init`** 关键字作为前缀的 **`初始化块`** 中。

   ```kotlin
   /**
    * 初始化顺序
    *
    * @since 2020年02月11日
    */
   class InitOrder(name: String) {
   
       var firstProperty = "成员属性 一 ：$name".also { println(it) }
   
       init {
           println("初始化块 一 : $name")
       }
   
       val secondProperty = "成员属性 二 ：$name".also(::println)
   
       init {
           println("初始化块 二 : $name")
       }
   
   }
   
   fun main(args: Array<String>) {
       InitOrder("JustDo23")
   }
   ```

   * 输出结果：

   ```
   成员属性 一 ：JustDo23
   初始化块 一 : JustDo23
   成员属性 二 ：JustDo23
   初始化块 二 : JustDo23
   ```

   * 在实例初始化期间，**`初始化块`** 按照它们 **`出现`** 在类体中的 **`顺序执行`** ，与属性初始化器 **`交织`** 在一起。
   * **`主构造函数`** 中的参数的 **`作用域范围`** 比 **`次构造函数`** 中的参数 **`大`** 很多。

### 03. 次构造函数

1. 类体内声明的构造即为 **`次构造函数`** 。

   ```kotlin
   /**
    * 次构造函数
    *
    * @since 2020年02月11日
    */
   class Person {
   
       constructor()
   
       constructor(firstName: String) { }
   
   }
   ```

2. 如果类 **有** 主构造函数，**`每个次构造函数`** 都需要 **`直接或间接委托`** 给主构造函数。

3. 构造函数使用 **`this`** 关键字进行委托。

   ```kotlin
   /**
    * 次构造函数委托给主构造函数
    *
    * @since 2020年02月11日
    */
   class Person(var name: String) {
   
       // 直接委托且参数默认值
       constructor() : this(name = "郭靖")
   
       // 直接委托
       constructor(firstName: String, lastName: String) : this(lastName + firstName)
   
       // 间接委托
       constructor(firstName: String, lastName: String, age: Int) : this(firstName, lastName)
   
   }
   
   fun main(args: Array<String>) {
       Person().name.also(::println) // 郭靖
       Person("张飞").name.also(::println) // 张飞
       Person("蓉", "黄").name.also(::println) // 黄蓉
   }
   ```

4. 注意，**`委托`** 给主构造函数会作为 **`次构造函数`** 的 **`第一条语句`** 。

5. 注意，**`初始化块`** 中的代码实际上会成为 **`主构造函数`** 的 **`一部分`** 。

6. 因此，所有 **`初始化块与属性初始化器`** 中的代码都会在 **`次构造函数体`** 之 **`前`** 执行。

   ```kotlin
   /**
    * 次构造函数执行顺序靠后
    *
    * @since 2020年02月11日
    */
   class ExecuteOrder {
   
       init {
           println("初始化块 一")
       }
   
       constructor() {
           println("次构造函数")
       }
   
       init {
           println("初始化块 二")
       }
   
   }
   
   fun main(args: Array<String>) {
       ExecuteOrder()
   }
   ```

   * 输出结果：

   ```kotlin
   初始化块 一
   初始化块 二
   次构造函数
   ```


### 04. 继承构造

1. 无参默认构造

   ```kotlin
   open class Animal { }
   
   class Pig : Animal() { }
   ```

2. 含参主构造

   ```kotlin
   open class Animal(name: String) { }
   
   class Pig(name: String) : Animal(name) { }
   ```

3. 含参次构造

   ```kotlin
   open class Animal {
   
       constructor(name: String) {}
   
   }
   
   class Pig : Animal {
   
       constructor(name: String) : super(name)
   
   }
   ```


* 关键字 **`super`** 实现了 **`子类`** 中的 **`次构造函数`** 调用 **`父类`** 中的 **`次构造函数`**


