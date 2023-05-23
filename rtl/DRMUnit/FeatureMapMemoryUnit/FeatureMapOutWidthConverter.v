`timescale 1ns / 1ps

module FeatureMapOutWidthConverter # (
    parameter   WIDTH_IN            =   144                 ,
    parameter   WIDTH_OUT           =   256                 ,
    parameter   NUM_IN              =   16                   ,
    parameter   NUM_OUT             =   9                   ,
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
    reg     [WIDTH_OUT-1:0]         data_buffer ;


    always @(posedge sys_clk or negedge rstn) begin
        if (!rstn) begin
            cnt <= 0;
        end else if(cnt == NUM_IN - 1) begin
            cnt <= valid_in ? 0 : cnt;
        end else begin
            cnt <= valid_in ? (cnt + 1) : cnt; 
        end
    end

    always @(posedge sys_clk or negedge rstn) begin
        if(!rstn) begin
            data_buffer <= 0;
        end else begin
            data_buffer <= valid_in? {data_buffer[WIDTH_OUT-WIDTH_IN-1:0], data_in}: data_buffer;
        end
    end

    always@(posedge sys_clk or negedge rstn) begin
        if(!rstn) begin
            data_out <= 288'b0;
        end else if(cnt==1) begin
            data_out <= valid_in? {data_buffer[143:0], data_in[143:32]}: data_out;
        end else if(cnt==3) begin
            data_out <= valid_in? {data_buffer[175:0], data_in[143:64]}: data_out;
        end else if(cnt==5) begin
            data_out <= valid_in? {data_buffer[207:0], data_in[143:96]}: data_out;
        end else if(cnt==7) begin
            data_out <= valid_in? {data_buffer[239:0], data_in[143:128]}: data_out;
        end else if(cnt==8) begin
            data_out <= valid_in? {data_buffer[127:0], data_in[143:16]}: data_out;
        end else if(cnt==10) begin
            data_out <= valid_in? {data_buffer[159:0], data_in[143:48]}: data_out;
        end else if(cnt==12) begin
            data_out <= valid_in? {data_buffer[191:0], data_in[143:80]}: data_out;
        end else if(cnt==14) begin
            data_out <= valid_in? {data_buffer[223:0], data_in[143:112]}: data_out;
        end else if(cnt==15) begin
            data_out <= valid_in? {data_buffer[111:0],data_in[143:0]}: data_out;
        end
    end
    always@(posedge sys_clk or negedge rstn) begin
        if(!rstn) begin
            valid_out <= 0;
        end else begin
            valid_out <= (cnt!=0&&cnt!=2&&cnt!=4&&cnt!=6&&cnt!=9&&cnt!=11&&cnt!=13)&&valid_in;
        end
    end 
endmodule