## Kotlin 零基础一

![Kotlin](https://raw.githubusercontent.com/JustDo23/SnailMonitor/master/Picture/Cover/Kotlin.png)

> 引言：Android 开发的首选语言。
>
> 作者：JustDo23
>
> 时间：2019年08月23日
>
> 官网：[https://kotlinlang.org](https://kotlinlang.org)

### 01. 前言

**Kotlin** 是一种在 **Java 虚拟机** 上运行的 **静态类型** 编程语言。主要由 **[JetBrains](https://www.jetbrains.com)** 开发团队设计并开源。在 **2017 ** 年的 **Google I/O** 大会上，**Google** 宣布 **Kotlin** 成为 **Android** 开发的一级语言。

**Kotlin** 可以用于 **服务器端** 开发；可以用于 **Android** 开发；可以用于 **iOS** 开发；可以用于 **JavaScript** 开发；可以用于 **原生** 开发。

在 **所有平台** 上都能用是 **Kotlin** 的一个明确目标。

### 02. 面世

```kotlin
/**
 * 定义函数-入口函数
 *
 * @param args 参数-字符串数组
 */
fun main(args: Array<String>) {
    println("Hello Kotlin.")// 打印数据
}
```

* 关键字 **`fun`** 声明定义一个 **`函数`**
* 参数名 **`args`** 参数类型 **`字符串数组`**

### 03. 变量

```kotlin
fun main(args: Array<String>) {
    var language = "Java"// 变量声明及赋值
    language = "Kotlin"// 修改变量值
    println(language)
}
```

* 关键字 **`var`** 声明一个 **`变量`**
* 关键字 **`var`** 全拼 **`variable`**

### 04. 数据类型

|  类型   |     类型     |           范围           | 占位  |
| :-----: | :----------: | :----------------------: | :---: |
|  Byte   |     整型     |        [-128,127]        | 8 位  |
|  Short  |     整型     |      [-32768,32767]      | 16 位 |
|   Int   |     整型     | [-2147483648,2147483647] | 32 位 |
|  Long   |    长整型    |            -             | 64 位 |
|  Float  | 单精度浮点型 |    精确到小数点 6 位     | 32 位 |
| Double  | 双精度浮点型 |  精确到小数点 15~16 位   | 64 位 |
| String  |   字符串型   |          双引号          |   -   |
| Boolean |    逻辑型    |      [true\|flase]       |   -   |

* 不同的数据放在不同的容器里，方便管理，数据也不易损坏。
* 容器有大小，数据有不同。

### 05. 类型推断

```kotlin
fun main(args: Array<String>) {
    var autoType = "String"// 自动类型推断
    var defineType: String = "String"// 显示定义类型
    var errorType// 报错，因为没有类型
    var userAge: Int// 显示声明
    userAge = 23// 变量赋值
}
```

### 06. 只读数据

```kotlin
fun main(args: Array<String>) {
    val readOnly = "Can not be modified."// 只读的数据
    val readNumber: Int
    readNumber = 996// 只能一次赋值
}
```

* 关键字 **`val`** 声明一个 **`只读数据`**
* 关键字 **`val`** 全拼 **`value`**

### 07. 函数


```kotlin
/**
 * 定义函数-无参数无返回值
 */
fun simple() {
    // 函数体
}

/**
 * 无参数无返回值
 */
fun young(): Unit {

}

/**
 * 有参数有返回值
 */
fun naive(name: String): Boolean {
    return true// 函数体
}
```

* 关键字 **`fun`** 声明定义一个 **`函数`**
* 关键字 **`fun`** 全拼 **`function`**
* 关键字 **`Unit`** 表示 **`无返回可省略`**
* 函数名
* 参数及参数类型
* 返回值类型

### 08. 字符串模板

```kotlin
fun main(args: Array<String>) {
    println(temple("Kotlin"))
}

fun temple(placeHolder: String): String {
    var sentence = "字符：${placeHolder}；内容：$placeHolder；长度：${placeHolder.length}。"
    return sentence
}

输出结果为：
字符：Kotlin；内容：Kotlin；长度：6。
```

* 关键点 **`$`** 与 **`${}`** 动态替换
* 花括号里可以是某个函数

### 09.  字符串比较

```kotlin
fun main(args: Array<String>) {
    var languageX = "Kotlin"
    var languageY = "Java"
    var languageZ = "Kotlin"
    var languageM = "java"
    println(languageX == languageY)// false
    println(languageX == languageZ)// true
    println(languageX.equals(languageZ))// true
    println(languageY.equals(languageM))// false
    println(languageY.equals(languageM, true))// true
}
```

* 字符串比较 **`==`** 等价于 **`equals()`** 方法
* 字符串比较  **`equals()`** 方法可以设置 **`是否忽略大小写`**

### 10. 空值处理

```kotlin
fun main(args: Array<String>) {
    // 不能为空值
    var parameter: String
    println(parameter)// 报错，数据未赋值
    parameter = null// 报错，数据不能赋空值
    parameter = "编译时检查是否为空值"
    println(parameter)// 正确输出
    // 可以为空
    var empty: String?
    empty = null
    println(empty)// 输出：null
}
```

* 变量声明默认是不能为空值，编译时会检查是否为空值
* 类型后面的 **`?`** 声明变量可以为空值

### 11. When

```kotlin
fun changeNumber(number: Int): String {
    var result = when (number) {
        1 -> "壹"
        2 -> "贰"
        3 -> "叁"
        else -> "未知"
    }
    return result
}
```

* 分支 **`else`** 不能省略

### 12. Loop Range

```kotlin
/**
 * 区间和循环
 */
fun loopAndRange() {
    // 闭区间
    var closeArray = 1..100 // 闭区间[1,100]
    for (close in closeArray) {// 循环
        println(close)
    }

    // 开区间
    var openArray = 22 until 55 // 开区间[22,55)
    for (open in openArray step (2)) {// 循环且设置步长
        println(open)
    }

    // 翻转
    var reverseArray = openArray.reversed()
    println("总长度：" + reverseArray.count())
}
```

* 区间有 **`开区间`** 和 **`闭区间`**
* 区间的循环可以设置 **`步长`**

### 13. List

```kotlin
fun main(args: Array<String>) {
    var languageList = listOf("Java", "Kotlin", "PHP")// 声明并初始化一个 List
    for ((position, language) in languageList.withIndex()) {
        println("$position -> $language")// 循环带有索引
    }
}
```

### 14. Map

```kotlin
import java.util.TreeMap

fun main(args: Array<String>) {
    var dictionaryMap = TreeMap<String, String>()// 声明一个 Map
    dictionaryMap["banana"] = "香蕉"// 键值对
    dictionaryMap[""] = "空"// 键值对
    println(dictionaryMap[""])// 输出：空
}
```

### 15. 函数式表达式

```kotlin
fun main(args: Array<String>) {
    println(desk(3, 5))// 方式一
    println(table(3, 5))// 方式二

    // 方式三
    var chair = { x: Int, y: Int -> x + y }
    println(chair(3, 5))

    // 方式四
    var bench: (Int, Int) -> Int = { x, y -> x + y }
    println(bench(3, 5))
}

/**
 * 方式一
 */
fun desk(x: Int, y: Int): Int {
    return x + y
}

/**
 * 方式二
 */
fun table(x: Int, y: Int): Int = x + y
```

* 函数体 **`只有一行`** 且 **`有返回值`**

### 16. 默认参数和具名参数

```kotlin
val PI = 3.1415f// 声明只读数据

fun main(args: Array<String>) {
    println("圆周长：" + circumference(3.1415f, 2.0f))// 常规
    println("圆面积：" + circleArea(3.1415f, 3.0f))// 常规
    println("圆面积：" + circleArea(radius = 3.0f))// 具有默认参数则使用具名参数
    println("圆柱体积：" + volume(3.1415f, 4.0f, 5.0f))// 常规
    println("圆柱体积：" + volume(radius = 4.0f, height = 5.0f))// 具有默认参数则使用具名参数
}

fun circumference(pi: Float, radius: Float): Float {
    return 2 * pi * radius
}

fun circleArea(pi: Float = PI, radius: Float): Float {
    return pi * radius * radius
}

fun volume(pi: Float = PI, radius: Float, height: Float): Float {
    return pi * radius * radius * height
}
```

* 函数的参数指定了默认值即 **`默认参数`**
* 调用具有 **`默认参数`** 的函数可以 **`省略相应参数`** 而剩余参数需要使用 **`具名参数`**

### 17. 字符串转数字

```kotlin
fun main(args: Array<String>) {
    var score = "23"// 字符串
    var number = 89// 数字
    var change = score.toInt()// 字符串转整型
    var temp = number.toString()// 整型转字符串
}
```

* 注意转换的 **`条件`** ，否则会报错

### 18. 异常处理

```kotlin
fun main(args: Array<String>) {
    try {
        var notNumber = "ABC"
        notNumber.toInt()
    } catch (e: Exception) {
        println("捕获到了异常")
    }
}
```

### 19. 递归

```kotlin
import java.math.BigInteger

fun main(args: Array<String>) {
    println(factorial(BigInteger("23")))
}

/***
 * 求出某个数的阶乘
 */
fun factorial(number: BigInteger): BigInteger {
    if (number == BigInteger.ONE) {
        return number
    } else {
        return number * factorial(number - BigInteger.ONE)
    }
}
```

* 递归：函数自己调用自己
* 类 **`BigInteger`** 可以存放无限大的数

### 20. 尾递归优化

```kotlin
fun main(args: Array<String>) {
    println(addition(100000))// 运算次数太多而造成崩溃
}

/**
 * 递归累加
 */
fun addition(number: Long): Long {
    if (number == 1L) {
        return number
    } else {
        return number + addition(number - 1)
    }
}
```

* 递归运算 **`次数太多`** 会造成 **`崩溃`** 抛出异常 **`java.lang.StackOverflowError`**
* 在 **`Java`** 中没有太好的解决方式
* 在 **`Kotlin`** 中使用 **`尾递归优化`**

```kotlin
fun main(args: Array<String>) {
    var result = 0L
    println(optimization(5, result))
}

/**
 * 递归累加
 */
tailrec fun optimization(number: Long, result: Long): Long {
    if (number == 0L) {
        return result
    } else {
        return optimization(number - 1, result + number)
    }
}
```

* 关键字 **`tailrec`** 即为  **`tail recursive`** 翻译为 **`尾递归优化`**

