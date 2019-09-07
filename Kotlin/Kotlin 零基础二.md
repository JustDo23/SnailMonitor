## Kotlin 零基础二

![Kotlin](https://raw.githubusercontent.com/JustDo23/SnailMonitor/master/Picture/Cover/Kotlin.png)

> 引言：面向对象。
>
> 作者：JustDo23
>
> 时间：2019年08月25日
>
> 官网：[https://kotlinlang.org](https://kotlinlang.org)

### 01. 类的声明

```kotlin
/**
 * 声明定义矩形类
 */
class Rectangle(var width: Int, var height: Int)

fun main(args: Array<String>) {
    var rectangle = Rectangle(23, 98)// 实例化对象，调用构造方法传参
    println("矩形宽度：${rectangle.width}")
    println("矩形高度：${rectangle.height}")
}
```

* 关键字 **`class`** 声明 **`类`**
* 声明类名之后可以是 **`主构造函数`** 且 主构造函数 不能包含任何的代码
* 创建类的 **`实例`** 只需像普通函数一样调用其 **`构造函数`** 即可
* 注意 **`Kotlin`** 并没有 **`new`** 关键字

### 02. 属性与方法

```kotlin
class Bird {

    var hasWing: Boolean = true// 静态属性

    fun fly() {// 动态行为
        println("I can fly.")
    }

}

fun main(args: Array<String>) {
    var bird = Bird()// 实例化
    bird.hasWing = true// 修改属性
    bird.fly()// 调用方法
}
```

### 03. 封装

* 社会分工的出现，标志着人类进入文明时代
* 简单讲 **`封装`** 其实就是隐藏内部实现细节
* 关键字 **`private`** 描述了对外隐藏

### 04. 继承

```kotlin
open class Father {

    var hasEducation: Boolean = true

    open fun action() {
        println("从小学到高中。")
    }

}
```

* 关键字 **`open`** 修饰 **`类`** 标志该类可以被 **`继承`**
* 关键字 **`open`** 修饰 **`方法`** 标志该方法可以被 **`重写`**

```kotlin
class Son : Father() {

    override fun action() {
        super.action()
        println("继续上到大学。")
    }

}
```

* 显示继承即在类头中把 **`父类`** 放到操作符 **`:`** 之后，同时跟上 **`主构造`**
* 关键字 **`super`** 调用父类的属性和行为
* 关键字 **`override`** 修饰子类 **`覆盖`** 父类的 **`方法`** 或者 **`属性`**

```kotlin
fun main(args: Array<String>) {
    var son = Son()
    println("孩子是否受教育：${son.hasEducation}")
    son.action()
}
```

* 继承，子类继承父类的属性和行为
* 在 **`Kotlin`** 中所有类都有一个共同的超类 **`Any`**

### 05. 抽象

```kotlin
abstract class Animal(var species: String) {

    abstract fun eat()

}
```

* 关键字 **`abstract`** 修饰 **`抽象类`** 和 **`抽象方法`**

### 06. 多态

```kotlin
class Dog(species: String) : Animal(species) {

    override fun eat() {
        println("$species 用嘴咀嚼。")
    }

}
```

* 抽象类不需要被关键字 **`open`** 修饰

```kotlin
class Chicken(species: String) : Animal(species) {

    override fun eat() {
        println("$species 用嘴啄。")
    }

}
```

* 继承时需要注意子类与父类的构造函数

```kotlin
fun main(args: Array<String>) {
    var dog = Dog("狗")
    var chicken = Chicken("鸡")
    dog.eat()
    chicken.eat()
}
```

* 多态就是同种功能，不同表现形态

### 07. 接口

```kotlin
interface IFly {

    fun fly()

    fun different(): Unit {
        println("这个接口可以有非抽象函数。")
    }

}
```

* 接口泛指实体把自己提供给外界的一种抽象化物（可以为另一实体），用以由内部操作分离出外部沟通方法，使其能被内部修改而不影响外界其他实体与其交互的方式。
* 关键字 **`interface`** 声明定义一个接口
* 在 **`Kotlin`** 中的接口可以既包含抽象方法的声明也包含实现。

```kotlin
class Chicken(species: String) : Animal(species), IFly {

    override fun eat() {
        println("$species 用嘴啄。")
    }

    override fun fly() {
        println("$species 会低空滑行。")
    }

}
```

* 实现接口，复写接口中的抽象方法
* 实现接口与继承抽象类略有不同

```kotlin
fun main(args: Array<String>) {
    var chicken = Chicken("鸡")
    if (chicken is IFly) {
        chicken.fly()
    }
}
```

* 关键字 **`is`** 判断 **`一个对象`** 是否是 **`某个类`** 的 **`实例化`**

### 08. 区别

* 接口是事物的 **`能力`**
* 抽象类是事物的 **`本质`**

### 09. 委托和代理

```kotlin
interface IDrive {
    fun driveCar()
}

class Boss : IDrive {
    override fun driveCar() {
        println("公司老板 开车。")
    }
}

class Driver : IDrive {
    override fun driveCar() {
        println("专职司机 开车。")
    }
}

fun main(args: Array<String>) {
    var boss = Boss()
    var driver = Driver()
    boss.driveCar()// 公司老板 开车。
    driver.driveCar()// 专职司机 开车。
}
```

* 委托是把事情托付给别人或别的机构办理
* 代理是指以他人的名义，在授权范围内进行对被代理人直接发生法律效力的法律行为。代理的产生，可以是受他人委托。

```kotlin
class Boss : IDrive by Driver()// 关键

fun main(args: Array<String>) {
    var boss = Boss()
    boss.driveCar()// 专职司机 开车。
}
```

* 关键字 **`by`** 简化实现 委托|代理 模式
* 如上 **`Boss`** 类可以通过将其所有公有成员都委托给 **`Driver`** 的对象来实现接口 **`IDrive`**

```kotlin
class Boss : IDrive by Driver() {
    
    override fun driveCar() {
        println("公司老板 上车。")
        Driver().driveCar()
        println("公司老板 看风景。")
    }

}
```

* 覆盖由委托实现的接口成员，因为覆盖符合接口实现的预期，编译器会使用 **`override`** 覆盖的实现，而不是委托对象中的。

### 10. 单例

```kotlin
object Singleton {

    fun action() {
        println("单例简单实现与使用。")
    }

}

fun main(args: Array<String>) {
    Singleton.action()// 单例直接调用函数
}
```

* 关键字 **`object`** 修饰的类快速实现 **`单例模式`**
* 调用时直接使用类名调用函数

### 11.  枚举

```kotlin
enum class Direction {
    NORTH, SOUTH, WEST, EAST
}

fun main(args: Array<String>) {
    println(Direction.EAST.ordinal)// 3
}
```

* 枚举类使用关键字 **`enum`** 修饰
* 每个枚举常量都是一个 **`对象`** ，枚举常量用 **`,`** 分隔。

```kotlin
enum class RoomColor(val rgb: Int) {
    RED(0xFF0000),
    GREEN(0x00FF00),
    BLUE(0x0000FF)
}

fun main(args: Array<String>) {
    println(RoomColor.BLUE.rgb)// 255
}
```

* 因为每一个枚举都是枚举的实例，所以可以进行初始化

### 12. 密封类

```kotlin
/**
 * 后代-马与驴-驴与驴
 */
sealed class Generation {

    class Donkey : Generation()// 驴
    class Mule : Generation()// 骡

    fun action() {
        println("后代只用两种情况。")
    }

}
```

* 关键字 **`sealed`** 释义为 **`密封`**
* 密封类是 **`子类类型有限`** 的类

```kotlin
fun main(args: Array<String>) {
    var donkey = Generation.Donkey()
    donkey.action()
    var mule = Generation.Mule()
    mule.action()
}
```

* 密封类更在意 **`类型`**
* 枚举更在意 **`数据`**

### 13. 密封类

* 密封类用来表示 **`受限的类继承结构`** ：当一个值为 **`有限集中`** 的类型、而不能有任何其他类型时。
* 在某种意义上，他们是枚举类的扩展：枚举类型的值集合也是受限的，但每个枚举常量 **`只存在一个`** 实例，而密封类的一个子类可以有可包含状态的 **`多个`** 实例。
* 一个密封类是自身 **`抽象的`** ，它 **`不能直接实例化`** 并可以有 **`抽象成员`** 。
* 密封类构造函数 **`默认`** 为 **`私有`** ，它不能有 **`非私有的`** 构造函数。

### 14. 视频

1. [Kotlin 视频教程](https://www.jianshu.com/p/c69d63b70650)
2. [Kotlin 零基础](https://www.bilibili.com/video/av13235884)
3. [Kotlin 零基础到进阶](https://www.bilibili.com/video/av64426522)

