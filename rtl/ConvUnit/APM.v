`timescale 1ns / 1ps

module APM # (
    parameter           MULT_PIPELINE_STAGE     =   2'd2                        ,
    parameter           Z_INIT                  =   48'd0                       ,
    parameter           ASYNC_RST               =   1'b0
)
(
    input   wire                clk                                             ,
    input   wire                rstn                                            ,

    input   wire    [8:0]       low_x                                           ,
    input   wire    [8:0]       low_y                                           ,
    input   wire    [23:0]      low_z                                           ,

    input   wire    [8:0]       high_x                                          ,
    input   wire    [8:0]       high_y                                          ,
    input   wire    [23:0]      high_z                                          ,

    input   wire                data_valid                                      ,
    
    output  wire    [23:0]      low_p                                           ,
    output  wire    [23:0]      high_p                                          
);

/*
    Acuumulate adder 9 * 9
     Function:
        P = X * Y + Z 
        {p0,p1} = {x0,x1} * {y0,y1} + {z0,z1}
    input signed X,Y

    `enable M,P register
    `pipeline stages 2

    `SYNC_RST
*/
    GTP_APM_E1 #(
        .GRS_EN("TRUE"),
        .ASYNC_RST(ASYNC_RST),
        .X_SIGNED(1'b1), //X 为有符号数
        .Y_SIGNED(1'b1), //Y 为有符号数
        .X_REG(1'b0),
        .Y_REG(1'b0),
        .Z_REG(1'b0),
        .P_REG(1'b1), //使用 P_REG
        .CXO_REG(2'b01),
        .CPO_REG(1'b0),
        .MULT_REG(1'b1),//使用 M_REG
        .PREADD_REG(1'b0),
        .MODEX_REG(1'b0),
        .MODEY_REG(1'b0),
        .MODEZ_REG(1'b0),
        .X_SEL(1'b0),
        .XB_SEL(2'b00),
        .CIN_SEL(1'b0),
        .USE_SIMD(1'b1),
        .USE_ACCLOW(1'b0),
        .USE_PREADD(1'b0),
        .USE_POSTADD(1'b1), //使能累加功能
        .Z_INIT(48'd0)
        )
        u0_GTP_APM_E1 (
        .CPO(),
        .CXBO(),
        .CXO(),
        .P({high_p,low_p}),
        .CPI(),
        .CXBI(),
        .CXI(),
        .MODEY(3'b000),
        .MODEZ(4'b0100),
        .X({high_x,low_x}),
        .Y({high_y,low_y}),
        .Z({high_z,low_z}),
        .COUT(),
        .CEM(1'b1),
        .CEMODEX(1'b0),
        .CEMODEY(1'b0),
        .CEMODEZ(1'b0),
        .CEP(1'b1), //P_REG 时钟使能
        .CEPRE(1'b0),
        .CEX(1'b1),
        .CEY(1'b1),
        .CEZ(1'b1),
        .CIN(),
        .CLK(clk),
        .MODEX(1'b0),
        .RSTM(~rstn),
        .RSTMODEX(~rstn),
        .RSTMODEY(~rstn),
        .RSTMODEZ(~rstn),
        .RSTP(~rstn),
        .RSTPRE(~rstn),
        .RSTX(~rstn),
        .RSTY(~rstn),
        .RSTZ(~rstn)
    );


endmodule