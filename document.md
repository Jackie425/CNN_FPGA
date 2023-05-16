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

## 1.NPUCore卷积乘加核心单元
![NPUCore](\images\NPUCore(PWconv).jpg "NPUCore")
**输入输出端口：**
- data path
  - data_in
  - data_valid_in
  - weight_in
  - weight_valid_in
  - bias_in
  - scale_in
  - data_out
  - data_valid_out
- control path
  - adder_rst

**由以下部件组成：**
- *权重输入拓展位宽处理* weight wire in
- *输入FeatureMap流水处理* aligns inputs with registers
- *Zin&Pout连线* Z in wire
- *乘加脉动阵列* APM systolic array
- *循环累加器* MAC_out accumulating
- *输出移位截断* MAC out scaling shift
- *输出拼接* output concat
## 2.DRM片上存储单元
