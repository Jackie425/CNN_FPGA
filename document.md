# Pango FPGA CNN Accelerator Hardware Architechture

单层网络实现——多层网络片上缓存实现——整个网络调用ddr实现单张图片推理——视频推理

### rtl文件总树形结构
- source
  - rtl
    - top.v
      - StateMachine.v
      - BiasMemUnit
        - BiasDRM.v
        - BiasCtrl.v
          - BiasAGU.v  
      - FeatureMapMemUnit 
        - FeatureMapDRM.v
        - FeatureMapCtrl.v
          - FeatureMapAGU.v
      - WeightMemUnit
        - WeightDRM.v
        - WeightCtrl.v
          - WeightAGU.v
      - DRMCtrlTop.v       
      - ConvUnit.v
        - ConvCtrl.v
        - NPUCore.v
          - align_reg_in.v
          - APM.v
      - Maxp.v
      - ReLU.v
  - sim
    - testbench.v
    - fmap.txt
    - param.txt

## 硬件架构特点：
#### 集成的硬件架构：
##### - 为DW和PW定制的乘加矩阵
##### - 可自由配置通道的片上缓存矩阵（未完成）
##### - 分布式块控制器
##### - 模型状态总控制器
![Top](\images\TopArchitechture.jpg "Top")
## 量化分析计算吞吐和内存带宽

$$
Attainable\  Perf.=min\begin{cases} Computational\ Roof\\ \  CTC\  Ratio\times BW
\end{cases}
$$

## 1.NPUCore卷积乘加核心单元


**由以下部件组成：**
- *权重输入拓展位宽处理* weight wire in
- *输入FeatureMap流水处理* aligns inputs with registers
- *Zin&Pout连线* Z in wire
- *乘加脉动阵列* APM systolic array
- *循环累加器* MAC_out accumulating
- *输出移位截断* MAC out scaling shift
- *输出拼接* output concat
## 2.DRM片上存储单元
