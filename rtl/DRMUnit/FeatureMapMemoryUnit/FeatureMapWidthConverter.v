`timescale 1ns / 1ps

module FeatureMapWidthConverter # (
    parameter   WIDTH_IN            =   256                 ,
    parameter   WIDTH_CONVERT       =   288                 ,
    parameter   WIDTH_OUT           =   144                 ,
    parameter   NUM_IN              =   9                   ,
    parameter   NUM_OUT             =   8                   ,
    parameter   CNT_WIDTH           =   $clog2(NUM_IN)
)
(
    input   wire                    sys_clk     ,
    input   wire                    calc_clk    ,
    input   wire                    rstn        ,
    input   wire    [WIDTH_IN-1:0]  data_in     ,
    input   wire                    valid_in    ,
    
    output  reg     [WIDTH_OUT-1:0] data_out    ,
    output  reg                     valid_out   
);

    reg     [CNT_WIDTH-1:0]         cnt         ;
    reg                             cnt_pp      ;
    reg     [WIDTH_CONVERT-1:0]     data_buffer ;
    reg     [WIDTH_CONVERT-1:0]     convert_out ;

    always @(posedge sys_clk or negedge rstn) begin
        if (!rstn) begin
            cnt <= 0;
        end else if(cnt == NUM_IN - 1) begin
            cnt <= valid_in ? 0 : cnt;
        end else begin
            cnt <= valid_in ? (cnt + 1) : cnt; 
        end
    end

    always @(posedge calc_clk or negedge rstn) begin
        if(!rstn) begin
            cnt_pp <= 1'b0;
        end else begin
            cnt_pp <= ~cnt_pp;
        end
    end
    always@(posedge sys_clk or negedge rstn) begin
        if(!rstn) begin
            data_buffer <= 288'b0;
        end else begin
            data_buffer <= valid_in? {data_buffer[WIDTH_CONVERT-WIDTH_IN-1:0], data_in}: data_buffer;
        end
    end

    always@(posedge sys_clk or negedge rstn) begin
        if(!rstn) begin
            convert_out <= 288'b0;
        end else if(cnt==1) begin
            convert_out <= valid_in? {data_buffer[255:0], data_in[255:224]}: convert_out;
        end else if(cnt==2) begin
            convert_out <= valid_in? {data_buffer[223:0], data_in[255:192]}: convert_out;
        end else if(cnt==3) begin
            convert_out <= valid_in? {data_buffer[191:0], data_in[255:160]}: convert_out;
        end else if(cnt==4) begin
            convert_out <= valid_in? {data_buffer[159:0], data_in[255:128]}: convert_out;
        end else if(cnt==5) begin
            convert_out <= valid_in? {data_buffer[127:0], data_in[255:96]}: convert_out;
        end else if(cnt==6) begin
            convert_out <= valid_in? {data_buffer[95:0], data_in[255:64]}: convert_out;
        end else if(cnt==7) begin
            convert_out <= valid_in? {data_buffer[63:0], data_in[255:32]}: convert_out;
        end else if(cnt==8) begin
            convert_out <= valid_in? {data_buffer[31:0], data_in[255:0]}: convert_out;
        end
    end
        
    always@(posedge sys_clk or negedge rstn) begin
        if(!rstn) begin
            valid_out <= 1'b0;
        end else begin
            valid_out <= cnt!=0 && valid_in;
        end
    end 

    always @(posedge calc_clk or negedge rstn) begin
        if(!rstn) begin
            data_out <= 144'b0;
        end else if(cnt_pp) begin
            data_out <= convert_out[143:0];
        end else begin
            data_out <= convert_out[287:144];
        end
    end
endmodule