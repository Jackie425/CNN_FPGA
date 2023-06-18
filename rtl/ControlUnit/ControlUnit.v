module top (
    input   wire                            clk                 ,
    input   wire                            rstn                ,
//control path  
    output  wire    [143:0]                 Conv_data_out       ,
    output  wire                            Conv_data_valid_out ,
    //********************************************************
    input   wire                            Conv_data_valid_in  ,
    input   wire                            adder_rst           ,
    input   wire    [4-1:0]                 Conv_scale_in       ,
    input   wire    [9-1:0]                 buff_len_ctrl       ,
    input   wire                            buff_len_rst        ,
    input   wire                            PW_mode             ,
    //********************************************************
    input   wire    [13-1:0]                fm_wr_addr          ,
    input   wire    [13-1:0]                fm_rd_addr          ,
    input   wire                            fm_DDR_wr           ,
    //********************************************************
    input   wire    [10-1:0]                wm_addr_wr          ,
    input   wire    [8-1:0]                 wm_addr_rd          ,
    input   wire                            wm_cvt_rstn         ,
    //********************************************************
    input   wire    [9-1:0]                 bm_addr_rd          ,
    input   wire                            bias_out_valid      ,
    //*********************************************************
    input   wire    [2:0]                   current_state       ,
    output  wire                            state_rst
);


endmodule