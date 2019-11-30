## Kotlin 加密算法二

![Encrypted](https://raw.githubusercontent.com/JustDo23/SnailMonitor/master/Picture/Cover/Encrypted.png)

> 引言：简单的加密解密算法入门。
>
> 作者：JustDo23
>
> 时间：2019年11月24日

### 01. 非对称加密

1. 概述：

   [非对称加密算法](https://baike.baidu.com/item/非对称加密算法) 需要一对 **`公开密钥`** 和 **`私有密钥`** 。如果用 **`公钥`** 对数据进行 **`加密`** ，只有用对应的 **`私钥`** 才能 **`解密`** 。因为加密和解密使用的是两个不同的密钥，所以这种算法叫作非对称加密算法。

2. 常见非对称加密算法：

   * **[RSA](https://baike.baidu.com/item/RSA算法/263310)**

3. 注意：

   *  **秘钥对** 必须由 **系统** 生成
   * 加密速度慢

### 02. RSA

1. 系统生成秘钥对

   ```kotlin
   public fun createKey() {
       val keyPairGenerator = KeyPairGenerator.getInstance("RSA")// 秘钥对生成器
       val generateKeyPair = keyPairGenerator.generateKeyPair()// 生成秘钥对
       val publicKey = generateKeyPair.public// 公钥
       val privateKey = generateKeyPair.private// 私钥
       println("公钥：${String(Base64.getEncoder().encode(publicKey.encoded))}")
       println("私钥：${String(Base64.getEncoder().encode(privateKey.encoded))}")
   }
   ```

   * 秘钥 **`成对`** 出现，每次生成都 **`不一样`**
   * 使用 **`Base64`** 解决乱码问题

2. 字符转私钥

   ```kotlin
   public fun getPrivateKey(privateKeyString: String): PrivateKey {
       val keyFactory = KeyFactory.getInstance("RSA")// 秘钥工厂对象
       return keyFactory.generatePrivate(PKCS8EncodedKeySpec(Base64.getDecoder().decode(privateKeyString)))
   }
   ```

   * **`RSAPrivateKeySpec`**
   * **`PKCS8EncodedKeySpec`**

3. 字符转公钥

   ```kotlin
   public fun getPublicKey(publicKeyString: String): PublicKey {
       val keyFactory = KeyFactory.getInstance("RSA")// 秘钥工厂对象
       return keyFactory.generatePublic(X509EncodedKeySpec(Base64.getDecoder().decode(publicKeyString)))
   }
   ```

   * **`RSAPublicKeySpec`**
   * **`X509EncodedKeySpec`**

4. 加密解密

   ```kotlin
   object RsaUtil {

       /**
        * RSA 加密解密
        *
        * @param input 输入明文或密文
        * @param key 公钥或私钥
        * @param mode [0,加密 1,解密]
        * @return 结果
        */
       fun rsa(input: String, key: Key, mode: Int): String {
           val inputByteArray = if (0 == mode) input.toByteArray() else Base64.getDecoder().decode(input)// 明文或密文转字节数组
           val cipher = Cipher.getInstance("RSA/ECB/PKCS1Padding")// 创建实例
           cipher.init(if (0 == mode) Cipher.ENCRYPT_MODE else Cipher.DECRYPT_MODE, key)// 初始化实例
           var offset = 0// 指针
           val maxSize = if (0 == mode) 117 else 128// 加密最大值 117 解密最大值 128
           val byteArrayOutputStream = ByteArrayOutputStream()// 字节流
           var temp: ByteArray
           while (inputByteArray.size - offset > 0) {// 超界
               if (inputByteArray.size - offset > maxSize) {// 整块
                   temp = cipher.doFinal(inputByteArray, offset, maxSize)
                   offset += maxSize
               } else {// 剩余
                   temp = cipher.doFinal(inputByteArray, offset, inputByteArray.size - offset)
                   offset = inputByteArray.size
               }
               byteArrayOutputStream.write(temp)// 写入流
           }
           byteArrayOutputStream.close()// 关闭流
           return if (0 == mode)
               String(Base64.getEncoder().encode(byteArrayOutputStream.toByteArray()))
           else
               String(byteArrayOutputStream.toByteArray())
       }

   }
   ```

5. 分段技术

   * 加密或解密 **`输入文本很长`** 的时候会 **`报错崩溃`**

     ```kotlin
     加密报错：
     javax.crypto.IllegalBlockSizeException:
     Data must not be longer than 117 bytes
     翻译中文：
     数据不能超过 117 字节
     ```

   * **`加密`** 最大值 **`117`**
   * **`解密`** 最大值 **`128`**

6. 测试效果

   ```kotlin
   fun main(args: Array<String>) {
       val input = "非对称加密"
       val miWen = RsaUtil.rsa(input, privateKey, 0)
       val jieMi = RsaUtil.rsa(miWen, publicKey, 1)
       println("密文 = $miWen")// 密文 = BjEfVitVNkQC+WConLUT/ppTMHUETi9YudBZ0tMkGHYnNdXlT8FOEq6MF0OS02kIJjWcMCQOlCR9dnuPZoK96J4L7EjYuJ6ej+6IaYWdCQxdUWJZKGxhgzoB54tvxY0XUCHKRyQZgqglDUUFANP2qkXBL9d7bxQcO+xedkrO5mQ=
       println("解密 = $jieMi")// 解密 = 非对称加密
   }
   ```

### 03. 特点

* 秘钥对：公钥和私钥，必须由系统生成并存储
* 公钥加密，私钥解密；私钥加密，公钥解密
* 公钥互换：两个组织或个人相互交换公钥
* 加密速度慢
* RSA 数字签名

### 04. 消息摘要

1. 概念：

   [数字摘要](https://baike.baidu.com/item/数字摘要/4069118) 是将 **`任意长度`** 的消息变成 **`固定长度`** 的 **`短`** 消息，它类似于一个 **`自变量`** 是消息的 **`函数`** ，也就是 **`Hash`** 函数。它有 **`固定的长度`** ，**`不同`** 明文摘要成密文，其结果总是 **`不同`** 的，而 **`同样`** 的明文其摘要 **`必定一致`** 。

2. 常用算法：

   * **[MD5](https://baike.baidu.com/item/MD5/212708)**
   * **[SHA-1](https://baike.baidu.com/item/SHA-1)**
   * **[SHA-256](https://baike.baidu.com/item/SHA-2/22718180)**

3. 特点：

   * **`不可逆`**

4. 应用场景：

   * 对用户密码进行 **MD5** 加密后保存至数据库
   * 软件下载站使用 **消息摘要** 计算文件指纹，防止被篡改
   * 数字签名

### 05. 算法封装

1. 工具类：

   ```kotlin
   object MessageDigestUtil {

       /**
        * MD5 加密
        *
        * @param input 输入明文
        * @return 消息摘要
        */
       fun md5(input: String): String {
           val messageDigest = MessageDigest.getInstance("MD5")
           val resultByteArray = messageDigest.digest(input.toByteArray())// 加密结果长度 16 字节
           return toHex(resultByteArray)
       }

       /**
        * 字节数组转十六进制文本
        *
        * @param inputByteArray 字节数组
        * @return 十六进制字符串
        */
       private fun toHex(inputByteArray: ByteArray): String {
           return with(StringBuilder()) {
               inputByteArray.forEach {
                   val hex = it.toInt() and (0xFF)// 字节转 Int 之后取值范围固定[0,255]
                   var toHexString = Integer.toHexString(hex)// 转十六进制字符
                   if (toHexString.length == 1) {
                       toHexString = "0$toHexString"// 长度不够则补位
                   }
                   append(toHexString)
               }
               toString()
           }
       }

   }
   ```

   * 加密后的 **`字节数组`** 转为 **`十六进制`** 字符串

2. 测试效果：

   ```kotlin
   fun main(args: Array<String>) {
       val input = "消息摘要算法"
       val result = MessageDigestUtil.md5(input)
       println("密文：$result")// 密文：b7c58f860f1add7de092b1f2931a3eb9
       println("长度：${result.toByteArray().size}")// 长度：32
   }
   ```

3. 切换算法：

   ```
   MD5
   SHA-1
   SHA-256
   ```

4. 密文长度：

   * **`MD5`** 加密后字节数组长度 **`16字节`** ，转十六进制字符串后长度 **`32字节`**
   * **`SHA-1`** 加密后字节数组长度 **`20字节`** ，转十六进制字符串后长度 **`40字节`**
   * **`SHA-256`** 加密后字节数组长度 **`32字节`** ，转十六进制字符串后长度 **`64字节`**

### 06. 数字签名

1. 概念：

   数字签名是 **`非对称加密`** 与 **`消息摘要`** 的组合应用。

   [数字签名算法](https://baike.baidu.com/item/数字签名算法) 是 **`数字签名标准`** 的一个 **`子集`** ，表示了只用作数字签名的一个特定的公钥算法。密钥运行在由 **`SHA-1`** 产生的消息哈希：为了验证一个签名，要重新计算消息的哈希，使用公钥解密签名然后比较结果。缩写为 **`DSA`** 。

2. 应用场景：

   * **`校验用户身份`** ，使用私钥签名，公钥校验，只要公钥能校验通过，则该消息一定是私钥持有者发布的
   * **`校验数据完整性`** ，用解密后的消息摘要跟原文的消息摘要进行对比

3. 代码封装：

   ```kotlin
   object SignatureUtil {

       /**
        * 数字签名
        *
        * @param input 输入明文
        * @param privateKey 私钥
        * @return 签名后密文
        */
       fun sign(input: String, privateKey: PrivateKey): String {
           val signature = Signature.getInstance("SHA256withRSA")// 获取实例
           signature.initSign(privateKey)// 初始化
           signature.update(input.toByteArray())// 指定数据源
           val signResult = signature.sign()// 进行签名
           return String(Base64.getEncoder().encode(signResult))
       }

       /**
        * 校验数字签名
        *
        * @param input 输入明文
        * @param signResult 密文
        * @param publicKey 公钥
        * @return [true,正确]
        */
       fun verify(input: String, signResult: String, publicKey: PublicKey): Boolean {
           val signature = Signature.getInstance("SHA256withRSA")// 获取实例
           signature.initVerify(publicKey)// 初始化
           signature.update(input.toByteArray())// 指定数据源
           return signature.verify(Base64.getDecoder().decode(signResult))
       }

   }
   ```

4. 测试效果：

   ```kotlin
   fun main(args: Array<String>) {
       val input = "数字签名算法"
       val privateKey = RsaUtil.getPrivateKey(RsaUtil.privateKeyString)
       val publicKey = RsaUtil.getPublicKey(RsaUtil.publicKeyString)
       val signResult = SignatureUtil.sign(input, privateKey)// 签名
       println("密文：$signResult")
       println("结果：${SignatureUtil.verify(input, signResult, publicKey)}")// 结果：true
       println("结果：${SignatureUtil.verify("篡改", signResult, publicKey)}")// 结果：false
   }
   ```

### 07. 数字签名流程

![数字签名流程图](https://raw.githubusercontent.com/JustDo23/SnailMonitor/master/Picture/Kotlin/SignatureFlow.jpg)

### 08. 加密算法总结

1. 对称加密
   * **DES**
   * **AES**
2. 非对称加密
   * **RSA**
3. 消息摘要
   * **MD5**
   * **SHA-1**
   * **SHA-256**
4. 数字签名
   * **SHA256withRSA**


