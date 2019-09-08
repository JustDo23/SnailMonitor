## Kotlin 零基础三

![Kotlin](https://raw.githubusercontent.com/JustDo23/SnailMonitor/master/Picture/Cover/Kotlin.png)

> 引言：函数式编程。
>
> 作者：JustDo23
>
> 时间：2019年09月08日
>
> 官网：[https://kotlinlang.org](https://kotlinlang.org)

### 01. 闭包

*  **`闭包`** 即  **`Closure`**

```java
/**
 * Java 不支持闭包
 */
public class Limit {

    public void feature() {
        System.out.println("方法内部不能再定义方法");
    }

}
```

* 闭包让 **`函数`** 成为编程语言中的 **`一等`** 公民
* 闭包让 **`函数`** 具有 **`对象`** 所有具有的能力（封装）
* 闭包让 **`函数`** 具有 **`状态`**

```kotlin
/**
 * Kotlin 支持闭包
 */
fun main(args: Array<String>) {
    // 在函数内部声明函数
    fun inside() {
        println("此函数声明在主函数内部。")
    }
    inside()// 调用内部声明的函数
    var indoor = inside()// 返回值赋值

    // 函数赋值给变量
    val magical = fun() {
        println("给变量赋值匿名内部函数。")
    }
    magical()// 调用变量函数

    // 函数返回值是函数
    fun nesting(): () -> Unit {
        println("此函数返回值仍是个函数。")
        return fun() {
            println("无参数无返回值的函数。")
        }
    }

    var circle = nesting()// 调用函数并将返回的函数赋值给变量
    circle()// 调用返回的函数
}
```

### 02. 函数式编程

* 函数可以像定义变量一样定义在函数的内部
* 函数既可以做为 **`参数`** ，也可以作为 **`返回值`**
* 方便程序修改和扩展

```kotlin
@kotlin.internal.HidesMembers
public inline fun <T> Iterable<T>.forEach(action: (T) -> Unit): Unit {
    for (element in this) action(element)
}
```

* 函数 **`forEach`** 需要一个函数作为其 **`参数`**

```kotlin
fun main(args: Array<String>) {
    val languageList = listOf<String>("Java", "Kotlin", "PHP")
    languageList.forEach(logCat)// 自定义函数做为参数传递给循环函数
    // 高级函数升级
    languageList.forEach { println(it) }
}

/**
 * 函数赋值给变量，以便此函数作为其他函数的参数
 */
var logCat = fun(content: String): Unit {
    println(content)
}
```

* 注意：闭包中的默认参数有个 **`it`** 的名字，方便简化代码

### 03. 位图

位图 **`BitMap`** 简称 **`BMP`** 也称为  **`DIB`** 即 **`与设备无关`** 的位图。是一种与显示器无关的  **`位图数字图像`** 文件格式，文件以  **`.bmp`** 为扩展名。是  **`Windows`** 系统中广泛使用的图像文件格式。

**`BMP`** 文件通常是 **`不压缩`** 的。

```kotlin
fun main(args: Array<String>) {
    var image = BufferedImage(100, 100, BufferedImage.TYPE_INT_RGB)// [创建]图片宽高及模式
    var width = 10..88// 闭区间
    var height = 10 until 89// 开区间
    image.apply {// 高阶函数
        for (x in width)
            for (y in height)
                setRGB(x, y, 0xE5E5E5)
    }
    image.setRGB(50, 50, 0xFF0000)// 绘制指定点的颜色
    ImageIO.write(image, "bmp", File("redDot.bmp"))// 文件输出
}
```

![redDot](https://raw.githubusercontent.com/JustDo23/SnailMonitor/master/Picture/Kotlin/redDot.bmp)

### 04. apply

```kotlin
/**
 * 调用者调用自己的函数
 */
@kotlin.internal.InlineOnly
public inline fun <T> T.apply(block: T.() -> Unit): T {
    contract {
        callsInPlace(block, InvocationKind.EXACTLY_ONCE)
    }
    block()
    return this
}
```

### 05. 行为参数化

* 把筛选的行为（函数）作为参数传递到过滤器里面
* 简洁代码，提高效率

```kotlin
/**
 * 女孩实体类
 */
data class Girl(var name: String, var age: Int, var height: Int, var address: String)

/**
 * 实体类集合
 */
var girlList = listOf<Girl>(
    Girl("伊伊", 23, 168, "北京"),
    Girl("小爱", 28, 155, "湖南"),
    Girl("三顺", 22, 153, "杭州"),
    Girl("四凤", 34, 148, "厦门"),
    Girl("吴静", 27, 172, "北京"),
    Girl("六宝", 30, 150, "江西")
)
```

* 高阶函数

```kotlin
fun main(args: Array<String>) {
    // 找到年龄最大的妹纸
    var maxAge = girlList.maxBy { it.age }
    println(maxAge)// Girl(name=四凤, age=34, height=148, address=厦门)
    // 找到年龄最小的妹纸
    var minAge = girlList.minBy { it.age }
    println(minAge)// Girl(name=三顺, age=22, height=153, address=杭州)
    // 过滤指定条件(参数布尔)
    var filterList = girlList.filter { (it.age > 25) and (it.height > 158) }
    println(filterList)// [Girl(name=吴静, age=27, height=172, address=北京)]

    // 属性映射(参数是一个变形函数)
    var simpleList = girlList.map { "${it.name}:${it.address}" }
    println(simpleList)// [伊伊:北京, 小爱:湖南, 三顺:杭州, 四凤:厦门, 吴静:北京, 六宝:江西]
    // 是否具有满足条件的对象
    var hasGirl = girlList.any { it.age == 18 }
    println(hasGirl)// false
    // 计数，统计满足条件的对象个数
    var girlCount = girlList.count { it.address == "北京" }
    println(girlCount)// 2
    
    // 查找并返回第一个符号条件的对象
    var girlFirst = girlList.find { it.address == "北京" }
    println(girlFirst)// Girl(name=伊伊, age=23, height=168, address=北京)
    // 查找并返回最后一个符号条件的对象
    var girlLast = girlList.findLast { it.address == "北京" }
    println(girlLast)// Girl(name=吴静, age=27, height=172, address=北京)
    
    // 集合分组
    var girlGroup = girlList.groupBy { it.address }
    println(girlGroup)// {北京=[Girl(name=伊伊, age=23, height=168, address=北京), Girl(name=吴静, age=27, height=172, address=北京)], 湖南=[Girl(name=小爱, age=28, height=155, address=湖南)], 杭州=[Girl(name=三顺, age=22, height=153, address=杭州)], 厦门=[Girl(name=四凤, age=34, height=148, address=厦门)], 江西=[Girl(name=六宝, age=30, height=150, address=江西)]}
}
```

* 思考：在 **`Java`** 中的实现方式。

### 06. DSL

* 领域特定语言  **`Domain Specific Language`**
* 扩展函数

```kotlin
/**
 * 自定义扩展函数
 */
fun List<Girl>.findPretty(age: Int) {
    filter { it.age <= age }.forEach(::println)
}

fun main(args: Array<String>) {
    girlList.findPretty(25)// 调用扩展函数
}
```

* 中缀表达式

```kotlin
/**
 * 扩展函数升级领域特定语言
 */
infix fun List<Girl>.findArea(address: String) {
    filter { it.address == address }.forEach(::println)
}

fun main(args: Array<String>) {
    girlList findArea "北京"// 调用使用空格分隔
}
```

* 关键字 **`infix`** 修饰的函数可以使用 **`中缀表示法`** 调用，即忽略 **`点`** 和 **`圆括号`**

### 07. 扩展函数

Kotlin 能够扩展一个类的新功能而无需继承该类或者使用像装饰者这样的设计模式。这通过叫做扩展的特殊声明完成。

### 08. 中缀函数

* 使用关键字 **`infix`** 修饰
* 必须是 **`成员函数`** 或  **`扩展函数`**
* 必须  **`只有一个参数`**
* 其参数 **`不得`** 接受 **`可变数量`** 的参数且 **`不能有默认值`**

