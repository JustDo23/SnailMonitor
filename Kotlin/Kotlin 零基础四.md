## Kotlin 零基础四

![Kotlin](https://raw.githubusercontent.com/JustDo23/SnailMonitor/master/Picture/Cover/Kotlin.png)

> 引言：个别的技术点大杂烩。
>
> 作者：JustDo23
>
> 时间：2020年02月07日
>
> 官网：[https://kotlinlang.org](https://kotlinlang.org)

### 01. 匿名实现

需要对 **`接口`** 匿名实现

```kotlin
public interface OnClickListener {
    
    void onClick(View view);
    
}

// 基本用法
someView.setOnClickListener(object : View.OnClickListener {

    override fun onClick(view: View?) {
        
    }

})
// 只包含一个抽象方法时可以简化
someView.setOnClickListener { }
```

包含参数和返回值

```kotlin
public interface OnTouchListener {

    boolean onTouch(View view, MotionEvent event);
    
}

// 只包含一个抽象方法时可以简化，不用的参数也可以简化
someView.setOnTouchListener { _,event -> false }
```

需要对 **`抽象类`** 匿名实现

```kotlin
abstract class Animal(var species: String) {

    abstract fun eat()

}

// 基本用法
var animal = object : Animal("Pig") {

    override fun eat() {

    }

}
```

技术小结：

* 使用 **`object`** 关键字，有点类似于 **`Java`** 中的 **`new`** 关键字
* 注意两者区别：
  * **`接口`** 并不需要指定主构造
  * **`抽象类`** 需要指定主构造
* 掌握基本使用方法就可以

### 02. reified

1. 关键字 **`reified`** 中文释义 **`具体化`** 。
2. 作为 **`Kotlin`** 的一个方法 **`泛型`** 关键字，它代表了可以在方法体内访问泛型指定的 **`JVM`** 类对象。
3. 必须以 **`inline`** 内联方式声明这个方法才有效果。
4. 泛型在 **`JVM`** 底层采取了 **`类型擦除`** 的实现机制。
5. 关键字 **`reified`** 让泛型更简单安全。
6. [参考技术小黑屋](https://droidyue.com/blog/2019/07/28/kotlin-reified-generics)

```kotlin
/**
 * 跳转界面
 */
fun go2Next() {
    startActivity(Intent(this, TargetActivity::class.java))// 常规操作
    startActivity(Intent(MainActivity@ this, TargetActivity::class.java))// 可简化为上一行
    startActivity(Intent(this@MainActivity, TargetActivity::class.java))
}
```

* 利用泛型封装

```kotlin
fun go2Next() {
    jump2Next<TargetActivity>(this)
}

/**
 * 注意两个必须的关键字
 */
inline fun <reified T : Activity> jump2Next(context: Context) {
    startActivity(Intent(context, T::class.java))
}
```

