## Kotlin 加密算法一

![Encrypted](https://raw.githubusercontent.com/JustDo23/SnailMonitor/master/Picture/Cover/Encrypted.png)

> 引言：简单的加密解密算法入门。
>
> 作者：JustDo23
>
> 时间：2019年11月17日

### 01. ASCII

1. 概念：**`ASCII`** 全称 **`American Standard Code for Information Interchange`** 即 **`美国信息交换标准代码`**。它是基于 **`拉丁字母`** 的一套 **`电脑编码系统`** ，主要用于显示现代英语和其他西欧语言。
2. 数量：到目前为止共定义了 **`128`** 个字符。

### 02. 凯撒加密

1. 概念：**`凯撒加密`** 是 **`古罗马恺撒大帝`** 用来保护重要军情的加密系统。
2. 算法：它是一种 **`替代密码`** ，通过将字母按顺序推后3位起到加密作用，如将字母A换作字母D。

   ```kotlin
   object CaesarUtil {

       /**
        * 凯撒加密解密
        *
        * @param input 输入
        * @param key 秘钥
        * @param mode [1,加密 -1,解密]
        * @return 结果
        */
       fun caesar(input: String, key: Int, mode: Int): String {
           return with(StringBuilder()) {
               input.toCharArray().forEach {
                   append((it.toInt() + key * mode).toChar())
               }
               toString()
           }
       }

   }
   ```

3. 测试效果：

    ```kotlin
    fun main(args: Array<String>) {
        val input = "Let us do it."
        val key = 3
        println(CaesarUtil.caesar(input, key, 1))// 打印：Ohw#xv#gr#lw1
    }
    ```

### 03. 频度分析法

1. 概念：[频度分析法](https://baike.baidu.com/item/频率分析法/6428804)将明文字母的出现频率与密文字母的频率相比较的过程。通过分析每个符号出现的频率而轻易地 **`破译代换式密码`** 。在每种语言中，冗长的文章中的字母表现出一种可对之进行分辨的频率。
2. 应用：破译代换式密码。包含凯撒加密。
3. 注意：字母 **`e`** 是英语中 **`最常用`** 的字母，其出现的频率为 **`八分之一`** 。

    ```
    1. 密文：Ohw#xv#gr#lw1
    2. 统计次数：
            # -> 3
            w -> 2
            h -> 1
            O -> 1
            x -> 1
            v -> 1
            g -> 1
            r -> 1
            l -> 1
            1 -> 1
    3. 假设定长密文中出现次数最多的符号代表 e
    4. 利用 ASCII 码计算秘钥
            # => 101-35=66
            w => 101-119=-8
            h => 101-104=-3
    5. 多次尝试利用秘钥进行解密并进行验证
    6. 最终破解凯撒加密
    ```

### 04. 基础单位

* 字节 **`Byte`** 是计算机信息技术用于计量存储容量的一种 **`计量单位`** ，作为一个单位来处理的一个二进制数字串，是构成信息的一个小单位。
* 位 **`bit`** 是 **`数据存储`** 的 **`最小单位`** 。也称为 **`比特`** 。0 或 1。
* 8 位 = 1 字节

### 05. 对称加密

1. 概念：

   采用 **`单钥密码系统`** 的加密方法， **`同一个密钥`** 可以同时用作信息的 **`加密`** 和 **`解密`** ，这种加密方法称为 **`对称加密`** ，也称为 **`单密钥加密`** 。

2. 常见对称加密算法：

   * **DES** : Data Encryption Standard  **`数据加密标准`**
   * **AES** : Advanced Encryption Standard  **`高级加密标准`**

3. 特点：

   可自己 **`指定秘钥`** ， **`可逆`** ，有秘钥即可破解

4. 底层机制：

   操作 **`二进制`**

### 06. DES

1. 加密解密：

    ```kotlin
    思路框架结构：
    1. 创建 Cipher 对象
    2. 初始化
    3. 加密或解密
    ```

2. 基础封装：

    ```kotlin
    object DesUtil {

        /**
         * DES 加密解密
         *
         * @param input 输入明文或密文
         * @param key 秘钥且长度是8字节
         * @param mode [0,加密 1,解密]
         * @return 结果
         */
        fun des(input: String, key: String, mode: Int): String {
            val cipher = Cipher.getInstance("DES")// 创建实例
            val secretKeyFactory = SecretKeyFactory.getInstance("DES")// 秘钥工厂模式
            val desKeySpec = DESKeySpec(key.toByteArray())
            val generateSecret = secretKeyFactory.generateSecret(desKeySpec)// 生成秘钥
            cipher.init(if (0 == mode) Cipher.ENCRYPT_MODE else Cipher.DECRYPT_MODE, generateSecret)// 初始化实例
            return if (0 == mode)
                String(Base64.getEncoder().encode(cipher.doFinal(input.toByteArray())))
            else
                String(cipher.doFinal(Base64.getDecoder().decode(input)))
        }

    }
    ```

3. 测试效果：

    ```kotlin
    fun main(args: Array<String>) {
        val input = "Let us do it."
        val key = "12345678"
        val desEn = DesUtil.des(input, key, 0)
        val desDe = DesUtil.des(desEn, key, 1)
        println("加密：$desEn")// 加密：8fHmY5GjI6d8MWE2nWPqnA==
        println("解密：$desDe")// 解密：Let us do it.
    }
    ```

### 07. 乱码解决

1. 现象描述：

   * 加密后的字节数组转字符串后出现 **`乱码`** 。
   * 将乱码转字节数组再进行 **`解密`** 会 **`报错崩溃`** 。

     ```kotlin
     报错信息：
     javax.crypto.IllegalBlockSizeException:
     Input length must be multiple of 8 when decrypting with padded cipher
     翻译中文：
     使用填充密码解密时，输入长度必须是8的倍数
     ```

2. 现象分析：

   * 一个 **`英文`** 占用 **`一个`** 字节。
   * 一个 **`中文`** 占用 **`三个`** 字节。
   * 明文加密后的字节长度是 **`8的倍数`** ，编码表中找不到对应字符，所以转字符串会出现乱码。

3. 解决方法：

   * 使用 **`Base64`** 编解码过渡

### 08. AES

1. 基础封装：

   ```kotlin
   object AesUtil {

       /**
        * AES 加密解密
        *
        * @param input 输入明文或密文
        * @param key 秘钥且长度是16字节
        * @param mode [0,加密 1,解密]
        * @return 结果
        */
       fun aes(input: String, key: String, mode: Int): String {
           val cipher = Cipher.getInstance("AES")// 创建对象
           val secretKeySpec = SecretKeySpec(key.toByteArray(), "AES")
           cipher.init(if (0 == mode) Cipher.ENCRYPT_MODE else Cipher.DECRYPT_MODE, secretKeySpec) // 初始化
           return if (0 == mode)
               String(Base64.getEncoder().encode(cipher.doFinal(input.toByteArray())))
           else
               String(cipher.doFinal(Base64.getDecoder().decode(input)))
       }

   }
   ```

2. 测试效果：

   ```kotlin
   fun main(args: Array<String>) {
       val input = "Just do it."
       val key = "1234567890123456"
       val aesEn = AesUtil.aes(input, key, 0)
       val aesDe = AesUtil.aes(aesEn, key, 1)
       println("加密：$aesEn")// 加密：3RSp+Ix7iR0Wbn3if1ftPg==
       println("解密：$aesDe")// 解密：Just do it.
   }
   ```

### 09. Transformation

1. 概念：

   > In order to create a Cipher object, the application calls the Cipher's `getInstance` method, and passes the name of the requested **`transformation`** to it.
   >
   > 是指在创建对象时传入的参数。

2. 格式：

   > A transformation always includes the name of a cryptographic algorithm (e.g., *DES*), and may be followed by a feedback mode and padding scheme.
   >
   > 必须指定加密算法，也可包含 `工作模式` 和 `填充方案`

   示例如下

   ```
   "algorithm/mode/padding"
   "algorithm"
   ```

3. 支持：

   > Every implementation of the Java platform is required to support the following standard `Cipher` transformations with the keysizes in parentheses.
   >
   > 每个 Java 平台的实现，都需要支持如下的标准。

   标准如下

   ```
   AES/CBC/NoPadding (128)
   AES/CBC/PKCS5Padding (128)
   AES/ECB/NoPadding (128)
   AES/ECB/PKCS5Padding (128)
   DES/CBC/NoPadding (56)
   DES/CBC/PKCS5Padding (56)
   DES/ECB/NoPadding (56)
   DES/ECB/PKCS5Padding (56)
   DESede/CBC/NoPadding (168)
   DESede/CBC/PKCS5Padding (168)
   DESede/ECB/NoPadding (168)
   DESede/ECB/PKCS5Padding (168)
   RSA/ECB/PKCS1Padding (1024, 2048)
   RSA/ECB/OAEPWithSHA-1AndMGF1Padding (1024, 2048)
   RSA/ECB/OAEPWithSHA-256AndMGF1Padding (1024, 2048)
   ```

### 10. 秘钥长度

1. **DES** ：
   * 秘钥长度 **`8字节`** 占位 **8 * 8 = 64位**
   * 秘钥 **`前 7 字节`** 参与加密计算 **`后 1 字节`** 作为校验码
   * 因此秘钥 **7 * 8 = 56位**
2. **AES** ：
   * 秘钥长度 **`16字节`** 占位 **16 * 8 = 128位**

### 11. 工作模式

1. 两种：
   * **[ECB](https://baike.baidu.com/item/ECB模式)** 全称 **`Electronic Codebook`** 即 **`电码本`** 是分组密码的一种最基本的工作模式。
     * 在该模式下，待处理信息被分为大小合适的 **`分组`** ，然后分别对每一分组 **`独立`** 进行加密或解密处理。
   * **[CBC](https://baike.baidu.com/item/CBC/22320875)** 全称 **`Cipher-block chaining`** 即 **`密码分组链接`** 是 IBM 发明的工作模式。
     * 在该模式下，每个明文块先与前一个密文块进行异或后，再进行加密。
     * 在这种方法中，每个密文块都依赖于它前面的所有明文块。
2. 对比：

| 名称 | 方法                       | 优点                                                     | 缺点                                   |
| ---- | -------------------------- | -------------------------------------------------------- | -------------------------------------- |
| ECB  | 每块独立加密               | 分块可以并行处理                                         | 同样的原文得到相同的密文，容易被攻击。 |
| CBC  | 每块加密依赖于前一块的密文 | 同样的原文得到不同的密文。原文微小改动影响后面全部密文。 | 加密需要串行处理。误差会传递。         |

### 12. 填充规则

1. 概念：是对需要 **`按块处理`** 的数据，当数据长度不符合块处理需求时，按照一定方法填充满块长的一种规则。
2. 使用：参考官方 API 即可。

