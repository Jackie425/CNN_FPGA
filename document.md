# Pango FPGA CNN Accelerator Hardware Architechture
## 1.markdown语言学习
### 1.1.正文
这是正文部分，两次换行渲染输出会创建新的段落

这样实现了两段。

若要实现换行，则通过在一行末尾加两个或多个空格后回车即可  
这样就实现了段内换行
### 1.2.代码块
代码块这样实现：

```verilog
reg sign;
reg signed [5:0] exponent; //fifth bit is sign
reg [9:0] mantissa;
reg [4:0] exponentA, exponentB;
reg [10:0] fractionA, fractionB, fraction;	//fraction = {1,mantissa}
reg [7:0] shiftAmount;
reg cout;
```

嵌入正文中的代码部分，``print("helloworld")``
### 1.3.列表
有序列表
1. 123
2. 456
3. 789
   1. 11
   2. sds
4. 1
      1. wewe
      2. we
   1. we
5. end

无序列表
- 123
- 123
  - 123
  - 22
  - 2
    - 23
  - 123
- end

### 1.4.强调语法
**这是加粗的用法**  
*这是斜体的用法*  
***这是加粗斜体的用法***

### 1.5.引用语法
> 这是块引用的用法
>
> 中间空行可以实现换行，但要记得加>符号
> 同时引用块内可以使用其他markdown元素
>
> 例如：
> > #### The quarterly results look great!
>
> - Revenue was off the chart.
> - Profits were higher than ever.
>
>  *Everything* is going according to **plan**.

下面是分割线

-------

### 1.6.链接语法
这是markdown官方教程链接[Markdown语法](https://markdown.com.cn "最好的markdown教程")

<https://www.baidu.com>
<2388570764@qq.com>

### 1.7.图片
![这是图片](\images\2023-01-29%20094635.jpg "screen print")

## 2.NPUCore卷积乘加核心模块
![NPUCore](\images\NPUCore(PWconv).jpg "NPUCore")
**输入输出端口：**
- data path
- control path
**由以下部件组成：**
  