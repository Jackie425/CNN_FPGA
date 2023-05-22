`timescale 1ns / 1ps

module DWRowBuf # (
    parameter   DATA_WIDTH              =       8                           ,
    parameter   IN_CHANNEL_NUM          =       9                           ,
    parameter   OUT_CHANNEL_NUM         =       18                          ,
    parameter   BUFF_LEN                =       320-2                       ,
    parameter   DEPTH                   =       $clog2(BUFF_LEN)             
)   
(   
    input  wire                                     clk             ,
    input  wire                                     rstn            ,
//data path 
    input  wire     [OUT_CHANNEL_NUM*DATA_WIDTH-1:0]    data_in         ,
    output wire     [OUT_CHANNEL_NUM*3*DATA_WIDTH-1:0]  data_out        ,
//buffer control path
    input  wire     [DEPTH-1:0]                     buff_len_ctrl   ,
    input  wire                                     buff_len_rst    
);

    reg     [DEPTH-1:0]     addr_in;
    reg     [DEPTH-1:0]     addr_out;
    wire    [OUT_CHANNEL_NUM*IN_CHANNEL_NUM*DATA_WIDTH-1:0] win_reg;
    
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            addr_in  <= BUFF_LEN - 1'b1;
            addr_out <= 0;
        end else if(buff_len_rst) begin
            addr_in  <= buff_len_ctrl - 1'b1;
            addr_out <= 0;
        end else if(addr_in == DEPTH - 1'b1) begin
            addr_in  <= 0;
            addr_out <= addr_out + 1'b1;
        end else if(addr_out == DEPTH - 1'b1) begin
            addr_in  <= addr_in + 1'b1;
            addr_out <= 0;
        end else begin
            addr_in  <= addr_in  + 1'b1;
            addr_out <= addr_out + 1'b1;
        end
    end

    DWConvWinGen 
    #(
      .OUT_CHANNEL_NUM(OUT_CHANNEL_NUM ),
      .DATA_WIDTH(DATA_WIDTH ),
      .IN_CHANNEL_NUM (IN_CHANNEL_NUM )
    )
    DWConvWinGen_inst (
      .clk (clk ),
      .rstn (rstn ),
      .data_in (data_in ),
      .valid_in (valid_in ),
      .win_out (win_out ),
      .vailid_out  ( vailid_out)
    );
  
endmodule