`timescale 1ns / 1ps

module ConvCtrl # (
    parameter           MAC_IN_NUM              =   9                                    ,
    parameter           MAC_OUT_NUM             =   18                                   ,
    parameter           APM_COL_NUM             =   MAC_OUT_NUM / 2                      ,//9
    parameter           APM_ROW_NUM             =   MAC_IN_NUM                           ,//9
    parameter           DATA_WIDTH              =   8                                    ,
    parameter           WEIGHT_WIDTH            =   8                                    ,
    parameter           BIAS_WIDTH              =   16                                   ,
    parameter           MULT_PIPELINE_STAGE     =   2                                    
)
(
    input   wire                clk                         ,
    input   wire                rstn                        ,
//state_top
    input   wire    [2:0]       current_state               ,
    output  wire                state_rst                   , 
//control_signal_conv     
    output  wire                adder_rst                   ,
    output  reg     [3:0]       scale_in                    
);
    localparam  INIT_state = 3'b000 ;
    localparam  A_state = 3'b001    ;
    localparam  B_state = 3'b010    ;
    localparam  C_state = 3'b011    ;

    localparam  SCALE_INIT = 4'd0   ;
    localparam  SCALE_A = 4'd1      ;
    localparam  SCALE_B = 4'd2      ;
    localparam  SCALE_C = 4'd3      ;

//scale signal generate
    always @(*) begin
        case (current_state)
            INIT_state:begin
                scale_in = SCALE_INIT;
            end
            A_state:begin
                scale_in = SCALE_A;
            end
            B_state:begin
                scale_in = SCALE_B;
            end
            C_state:begin
                scale_in = SCALE_C;
            end
            default:begin
                scale_in = SCALE_INIT;
            end
        endcase
    end

//adder_rst signal generate
    
endmodule