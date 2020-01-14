## WebPack 零基础一

![WebPack.png](https://raw.githubusercontent.com/JustDo23/SnailMonitor/master/Picture/Cover/WebPack.png)

> 引言：Bundle your **`assets`**  **`scripts`**  **`images`**  **`styles`** .
>
> 作者：JustDo23
>
> 时间：2019年12月23日
>
> 官网：[https://webpack.js.org](https://webpack.js.org)
>
> 中文：[https://www.webpackjs.com](https://www.webpackjs.com)

### 01. 基础知识

1. 入门概念

   本质上 **`webpack`** 是一个现代 **`JavaScript`**  应用程序的 **`静态模块打包器`** 。当 **`webpack`** 处理应用程序时，它会 **`递归`** 地构建一个 **`依赖关系图`** ，其中包含应用程序需要的 **`每个`** 模块，然后将所有这些模块打包成一个或多个 **`bundle`** 。

2. 便捷功能

   **`代码转换`**    **`文件优化`**    **`代码分割`**     **`模块合并`**     **`自动刷新`**     **`代码校验`**     **`自动发布`**
   
3. 项目配置

   * 支持 **`零`** 配置
   * 支持 **`自定义`** 配置

### 02. 安装指南

1. 前提条件

   ```shell
   # 查看安装列表
   $ brew list
   # 安装 Node.js
   $ brew install node
   # 查看版本
   $ npm -v
   $ node -v
   ```

2. 本地安装

   * 建议采用 **`本地安装`** 即在当前项目下安装

   ```shell
   # 切换至项目根路径
   $ cd ProjectRootPath
   # 初始化操作
   $ npm init
   $ npm init -y
   # 安装并添加
   $ npm install --save-dev webpack
   $ npm install --save-dev webpack-cli
   ```

   * 推荐用 **`yarn`** 安装

   ```shell
   # 初始化操作
   $ yarn init -y
   # 安装并添加
   $ yarn add webpack webpack-cli -D
   ```

   注意事项：

   * 操作 **`初始化`** 后会在根目录生成 **`package.json`** 配置文件
   * 安装后会在本地 **`node_modules`** 目录找到所有安装的
   
3. 初试打包

   ```shell
   # 打包指令
   $ npx webpack
   ```

   * 采用 **`默认配置`** 进行打包
   * 在根目录生成 **`dist`** 结果输出目录

### 03. 添加配置

1. 创建文件

   ```shell
   # 项目根路径创建
   $ touch webpack.config.js
   ```

   * 这里的文件名称即为默认配置文件名称

2. 添加配置

   ```js
   /**
    * 自定义配置文件
    *
    * @Author: JustDo23
    * @Date: 2019-12-21
    * @Email: JustDo23@126.com
    */
   
   let nodePath = require("path")
   
   module.exports = {
       entry: "./src/index.js", // 指定入口
       output: { // 指定出口
           filename: "bundle.js", // 指定文件名称
           path: nodePath.resolve(__dirname, "dist") // 指定输入目录且相对路径转绝对路径
       }
   }
   ```

3. 执行打包

   ```shell
   $ npx webpack --config webpack.config.js
   ```

   * 命令指定了 **`参数`**
   * 若使用默认配置文件名称则可以省略

4. NPM Scripts

   * 在 **`package.json`** 中添加配置

     ```json
     {
         "version": "1.0.0",
         "scripts": {
             "build": "webpack --config webpack.config.js"
         },
         "devDependencies": {
             "webpack": "^4.41.4",
             "webpack-cli": "^3.3.10"
         }
     }
     ```

   * 执行便捷指令打包

     ```shell
     # 简化了指令
     $ npm run build
     # 如果需要添加其他参数
     $ npm run build -- --colors
     ```

### 04. 管理资源

1. 动态打包

   每个模块都可以明确表述它自身的依赖，将避免打包未使用的模块。

2. 安装指令

   * 为了从 **`JavaScript`** 模块中 **`import`** 一个 **`CSS`** 文件

   ```shell
   $ yarn add css-loader style-loader -D
   ```

3. 修改配置

   ```js
   module.exports = {
       entry: "./src/index.js", // 指定入口
       module: { // 模块配置
           rules: [ // 规则数组
               {
                   test: /\.css/, // 正则匹配文件后缀
                   use: [ // 使用加载器且默认从右向左从下到上执行
                       {
                           loader: "style-loader"
                       },
                       "css-loader"
                   ]
               }
           ]
       }
   }
   ```

   * **`css-loader`** 处理 **`@import`** 这类语法
   * **`style-loader`** 可以将 **`css`** 插入到 **`head`**  标签中

4. 其他资源

   * 加载 **`图片`**
   * 加载 **`字体`**
   * 加载 **`数据`**

5. 方式优点

   * 以更直观的方式将模块和资源组合在一起。无需要依赖全部资源。
   * 降低耦合，代码更具备可移植性。
   
6. 其他说明

   * 明显是遵循 **`单一`** 原则
   * 用法可以是 **`字符串`** 形式，也可以是 **`对象`** 形式
   * 具有 **`执行顺序`** ，默认是 **`从右向左`**   **`从下到上`** 执行

### 05. Loader

1. 基础概念
   * **`webpack`** 自身只能理解 **`JavaScript`** 。
   * **`loader`** 用于对 **`模块`** 的 **`源代码`** 进行 **`转换`** 。
   * **`loader`** 将所有类型的文件**` 转换`** 为应用程序的依赖图可以 **`直接引用`** 的 **`模块`** 。
2. 配置属性
   * **`test`** 标识出应该 **`被转换的文件`**
   * **`use`** 表示进行 **`转换时使用的加载器`**
3. 特性
   * 支持 **`链式传递`** ，且默认按照 **`相反`** 的顺序执行。
   * 可以是 **`同步`** 的，可以是 **`异步`** 的。

### 06. 管理输出

1. 多个入口

   ```js
   let nodePath = require("path")
   module.exports = {
       entry: { // 配置入口
           app: "./src/index.js",
           print: "./src/print.js",
       },
       output: { // 配置出口
           filename: "[name].bundle.js", // 指定文件名称
           path: nodePath.resolve(__dirname, "dist") // 指定输入目录且相对路径转绝对路径
       }
   }
   ```

   * 使用 **`键值对`** 指定 **`入口名称`** 以及 **`入口路径`**

2. 模板插件

   * 添加插件

     ```shell
     $ yarn add html-webpack-plugin -D
     ```

   * 配置插件

     ```js
     let HtmlWebpackPlugin = require("html-webpack-plugin") // 导入 Html 插件
     module.exports = {
         plugins: [ // 插件数组
             new HtmlWebpackPlugin({
                 template: "index.html", // 指定模板路径
                 filename: "home.html", // 指定打包后名称
                 minify: {
                     removeAttributeQuotes: true, // 删除双引号
                     collapseWhitespace: true // 删除回车
                 },
                 hash: true // 添加哈希码
             })
         ]
     }
     ```

3. 清理文件插件

   * 添加插件

     ```shell
     $ yarn add clean-webpack-plugin -D
     ```

   * 配置插件

     ```javascript
     let { CleanWebpackPlugin } = require("clean-webpack-plugin") // 导入清除文件插件
     module.exports = {
         plugins: [ // 插件数组
             new CleanWebpackPlugin({
                 cleanOnceBeforeBuildPatterns: "out" // 构建前删除一次指定目录
             })
         ]
     }
     ```



