`timescale 1ns / 1ps

module maxp # (
    parameter   Length  = 32
)
(
    input       wire           clk            ,
    input       wire           rst_n          ,
    input       wire   [15:0]  data_in        ,
    input       wire           in_valid       ,
    output      wire   [15:0]  data_out       ,
    output      wire           out_valid
);
    

    wire   [15:0]   fifo_out                ;
    reg    [15:0]   win_maxp     [3:0]      ;
    reg    [9:0]    count                   ;   //30 * 30
    reg    [5:0]    cyc_count               ;   //2 * 30
    wire   [15:0]   max_col_1               ;
    wire   [15:0]   max_col_2               ;
    reg             maxp_begin              ;
    reg             maxp_rst                ;
    reg             cyc_count_stall         ;
    wire            clk_maxp                ;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n | maxp_rst) begin
            count <= 10'b0;
            maxp_rst <= 1'b0;
            maxp_begin <= 1'b0;
        end else if(count == Length * Length) begin
            maxp_rst <= 1'b1;
        end else if(count == Length) begin
            count <= count + 10'b1;
            maxp_begin <= 1'b1;
        end else if (in_valid) begin
            count <= count + 10'b1;
        end else begin
            count <= count;
            maxp_begin <= maxp_begin;
            maxp_rst <= maxp_rst;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n | maxp_rst) begin
            cyc_count <= 6'b0;
            cyc_count_stall <= 1'b0;
        end else if (cyc_count == 2 * Length -1) begin
            cyc_count <= 6'b0;
        end else if (in_valid) begin
            cyc_count <= cyc_count + 6'b1;
            cyc_count_stall <= 1'b0;
        end else begin
            cyc_count <= cyc_count;
            cyc_count_stall <= 1'b1;
        end
    end

    




//循环计数器实现
    assign out_valid = ((cyc_count[0] == 1'b0) &
                        (cyc_count >= Length + 2 | cyc_count == 6'd0)) & (maxp_begin | maxp_rst) & !cyc_count_stall;


    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            win_maxp[0] <= 16'b0;
            win_maxp[1] <= 16'b0;

            win_maxp[2] <= 16'b0;
            win_maxp[3] <= 16'b0;
        end else if ((maxp_begin | maxp_rst) & in_valid) begin
            win_maxp[0] <= fifo_out;
            win_maxp[1] <= data_in;

            win_maxp[2] <= win_maxp[0];
            win_maxp[3] <= win_maxp[1];
        end else begin
            win_maxp[0] <= win_maxp[0];
            win_maxp[1] <= win_maxp[1];

            win_maxp[2] <= win_maxp[2];
            win_maxp[3] <= win_maxp[3];
        end
    end





    assign max_col_1 = (win_maxp[0] > win_maxp[1]) ? win_maxp[0] : win_maxp[1];
    assign max_col_2 = (win_maxp[2] > win_maxp[3]) ? win_maxp[2] : win_maxp[3];
    assign data_out = out_valid == 1'b0 ? 16'b0 : (max_col_1 > max_col_2 ? max_col_1 : max_col_2);


    assign clk_maxp = clk & in_valid;
    shift_ram_16_32 maxp_fifo (
        .din(data_in),      // input [15:0]
        .clk(clk_maxp),      // input
        .rst(~rst_n),      // input
        .dout(fifo_out)     // output [15:0]
    );



endmodule