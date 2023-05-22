`timescale 1ns / 1ps

module NPUTestbench();

    parameter   IMG_ROW = 32;
    parameter   IMG_COL = 32;
    parameter   IN_CHANNEL = 40;
    parameter   OUT_CHANNEL = 80;
    parameter   PIPELINE_FILL_DELAY = 10;// clk to get one mac cycle


    reg clk;
    reg rstn;
    reg [7:0]  data_mem      [40960-1:0];            // [0:31][0:31][0:3][0:9];
    reg [7:0]  param_mem     [3200-1:0];             // [0:4][0:3][0:15][0:9];
    reg [79:0] data_in;
    reg [79:0] param_in [0:15];
    wire [127:0] data_out;
    reg in_valid;
    reg pipeline_filled;
    integer outputfile;
    integer l,n,o,p,q;
    reg [4:0] filled_count;
    reg [1:0] count;
    reg [15:0] data_cnt;
    reg [15:0] repeat_cnt;
    reg [15:0] group_cnt;
    reg [15:0] param_cnt;
    reg adder_rst;
    reg out_valid;

    GTP_GRS GRS_INST (
        .GRS_N(1'b1)
      );

    initial begin
        outputfile = $fopen("fmapout.txt","w");
        $readmemh("E:/2023IC/rtl_workspace/cnn_fpga/source/sim/fmap.txt",data_mem);
        $readmemh("E:/2023IC/rtl_workspace/cnn_fpga/source/sim/param.txt",param_mem);
        rstn = 1'b0;
        clk = 1'b0;
        #210
        rstn = 1'b1;
    end

    always begin
        clk <= 1'b1;
        #10;
        clk <= 1'b0;
        #10;
    end

    always @(posedge clk or negedge rstn)
    begin
        if(!rstn)
        begin
            group_cnt <= 16'd0;
        end 
        else if(group_cnt == (16'd1024-16'd1) && repeat_cnt == (16'd5-16'd1) && data_cnt == (16'd4-16'd1))
        begin
            group_cnt <= 16'd0;
            #280
            $fclose(outputfile);
            $stop;
        end
        else if(repeat_cnt == (16'd5-16'd1) && data_cnt == (16'd4-16'd1))
        begin
            group_cnt <= group_cnt + 1'b1;
        end
    end

    always @(posedge clk or negedge rstn)
    begin
        if(!rstn)
        begin
            repeat_cnt <= 16'd0;
        end 
        else if(repeat_cnt == (16'd5-16'd1) && data_cnt == (16'd4-16'd1))
        begin
            repeat_cnt <= 16'd0;
        end
        else if(data_cnt == (16'd4-16'd1))
        begin
            repeat_cnt <= repeat_cnt + 1'b1;
        end
    end
    
    always @(posedge clk or negedge rstn)
    begin
        if(!rstn)
        begin
            data_cnt <= 16'd0;
        end 
        else if(data_cnt == (16'd4-16'd1))
        begin
            data_cnt <= 16'd0;
        end
        else
        begin
            data_cnt <= data_cnt + 1'b1;
        end
    end

    always @(posedge clk or negedge rstn)
    begin
        if(!rstn)
        begin
            param_cnt <= 16'd0;
        end 
        else if(param_cnt == (16'd20-16'd1))
        begin
            param_cnt <= 16'd0;
        end
        else
        begin
            param_cnt <= param_cnt + 1'b1;
        end
    end

    always @(posedge clk or negedge rstn)
    begin
        if(!rstn) begin
            data_in <= 80'b0;
            param_in[0] <= 80'b0;
            param_in[1] <= 80'b0;
            param_in[2] <= 80'b0;
            param_in[3] <= 80'b0;
            param_in[4] <= 80'b0;
            param_in[5] <= 80'b0;
            param_in[6] <= 80'b0;
            param_in[7] <= 80'b0;
            param_in[8] <= 80'b0;
            param_in[9] <= 80'b0;
            param_in[10] <= 80'b0;
            param_in[11] <= 80'b0;
            param_in[12] <= 80'b0;
            param_in[13] <= 80'b0;
            param_in[14] <= 80'b0;
            param_in[15] <= 80'b0;
        end 
        else
        begin
            for(l = 0 ;l < 10 ; l = l + 1)begin
                data_in[(l*8)+:8] <= data_mem[group_cnt*40+data_cnt*10+l];
            end

            for(n = 0 ; n < 16 ; n = n + 1)begin
                for(o = 0 ; o < 10 ; o = o + 1) begin
                    param_in[n][o*8+:8] <= param_mem[param_cnt*160 + n*10 + o];
                end
            end

        end
    end
    
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            filled_count <= 16'b0;
            pipeline_filled <= 1'b0;
            count <= 2'd3;
            out_valid <= 1'b0;
            in_valid <= 1'b0;
        end else if(pipeline_filled) begin
            count <= count + 1'b1;
            if(count == 2'd2) begin
                out_valid <= 1'b1;
            end else if(count == 2'd3) begin
                out_valid <= 1'b0;
            end
        end else if(in_valid) begin
            filled_count <= filled_count + 1'b1;
            if(filled_count == PIPELINE_FILL_DELAY)begin
                pipeline_filled <= 1'b1;
            end
        end else begin
            in_valid <= 1'b1;
        end
    end

    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            adder_rst <= 1'b0;
        end
        else
        begin
            if(count == 2'd2 || filled_count == PIPELINE_FILL_DELAY)
            begin
                adder_rst <= 1'b1;
            end
            else if(count == 2'd3) begin
                adder_rst <= 1'b0;
            end
        end
    end
    

    NPUCore NPUCore_dut (
        .clk (clk ),
        .rstn (rstn ),
        .NPU_data_in (data_in),
        .NPU_data_valid_in (in_valid),
        .NPU_weight_in (NPU_weight_in ),
        .NPU_weight_valid_in (in_valid),
        .NPU_bias_in (NPU_bias_in ),
        .NPU_bias_valid_in (NPU_bias_valid_in ),
        .NPU_scale_in (NPU_scale_in ),
        .NPU_data_out (data_out ),
        .NPU_data_valid_out (NPU_data_valid_out ),
        .adder_rst  ( adder_rst)
    );
      
    always @(posedge clk or negedge rstn) begin
        if(out_valid) begin
            for(q = 0 ; q < 16 ; q = q + 1)begin
                $fwrite(outputfile,"%x\n",data_out[(q*8)+:8]);
            end
        end
    end


endmodule