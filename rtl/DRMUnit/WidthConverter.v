`timescale 1ns / 1ps

module WidthConverter # (
    parameter   WIDTH_IN    =   256                 ,
    parameter   WIDTH_OUT   =   324                 ,
    parameter   NUM_IN      =   81                  ,
    parameter   NUM_OUT     =   64                  ,
    parameter   CNT_WIDTH   =   $clog2(NUM_IN)
)
(
    input   wire                    clk         ,
    input   wire                    rstn        ,
    input   wire    [WIDTH_IN-1:0]  data_in     ,
    input   wire                    valid_in    ,
    
    output  reg     [WIDTH_OUT-1:0] data_out    ,
    output  reg                     valid_out   
);
    reg     [CNT_WIDTH-1:0]     cnt         ;
    reg     [WIDTH_OUT-1:0]     data_buffer ;//Only 320 bits are actually needed for concat 

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            cnt <= 0;
        end else if(cnt == NUM_IN - 1) begin
            cnt <= valid_in ? 0 : cnt;
        end else begin
            cnt <= valid_in ? (cnt + 1) : cnt; 
        end
    end

    always@(posedge clk or negedge rstn) begin
        if(!rstn) begin
            data_buffer <= 0;
        end else begin
            data_buffer <= valid_in? {data_buffer[WIDTH_OUT-WIDTH_IN-1:0], data_in}: data_buffer;
        end
    end
    
    always@(posedge clk or negedge rstn) begin
        if(!rstn) begin
            data_out <= 0;
        end else if(cnt==1) begin
            data_out <= valid_in? {data_buffer[255:0], data_in[255:188]}: data_out;
        end else if(cnt==2) begin
            data_out <= valid_in? {data_buffer[187:0], data_in[255:120]}: data_out;
        end else if(cnt==3) begin 
            data_out <= valid_in? {data_buffer[119:0], data_in[255:52]}: data_out;
        end else if(cnt==5) begin
            data_out <= valid_in? {data_buffer[307:0], data_in[255:240]}: data_out;
        end else if(cnt==6) begin
            data_out <= valid_in? {data_buffer[239:0], data_in[255:172]}: data_out;  
        end else if(cnt==7) begin
            data_out <= valid_in? {data_buffer[171:0], data_in[255:104]}: data_out;
        end else if(cnt==8) begin
            data_out <= valid_in? {data_buffer[103:0], data_in[255:36]}: data_out;
        end else if(cnt==10) begin
            data_out <= valid_in? {data_buffer[291:0], data_in[255:224]}: data_out;  
        end else if(cnt==11) begin
            data_out <= valid_in? {data_buffer[223:0], data_in[255:156]}: data_out;  
        end else if(cnt==12) begin
            data_out <= valid_in? {data_buffer[155:0], data_in[255:88]}: data_out;
        end else if(cnt==13) begin
            data_out <= valid_in? {data_buffer[87:0], data_in[255:20]}: data_out;
        end else if(cnt==15) begin
            data_out <= valid_in? {data_buffer[275:0], data_in[255:208]}: data_out;
        end else if(cnt==16) begin
            data_out <= valid_in? {data_buffer[207:0], data_in[255:140]}: data_out;
        end else if(cnt==17) begin
            data_out <= valid_in? {data_buffer[139:0], data_in[255:72]}: data_out;
        end else if(cnt==18) begin
            data_out <= valid_in? {data_buffer[71:0], data_in[255:4]}: data_out;
        end else if(cnt==20) begin
            data_out <= valid_in? {data_buffer[259:0], data_in[255:192]}: data_out;
        end else if(cnt==21) begin
            data_out <= valid_in? {data_buffer[191:0], data_in[255:124]}: data_out;
        end else if(cnt==22) begin
            data_out <= valid_in? {data_buffer[123:0], data_in[255:56]}: data_out;
        end else if(cnt==24) begin
            data_out <= valid_in? {data_buffer[311:0], data_in[255:244]}: data_out;
        end else if(cnt==25) begin
            data_out <= valid_in? {data_buffer[243:0], data_in[255:176]}: data_out;
        end else if(cnt==26) begin
            data_out <= valid_in? {data_buffer[175:0], data_in[255:108]}: data_out;
        end else if(cnt==27) begin
            data_out <= valid_in? {data_buffer[107:0], data_in[255:40]}: data_out; 
        end else if(cnt==29) begin
            data_out <= valid_in? {data_buffer[295:0], data_in[255:228]}: data_out;
        end else if(cnt==30) begin
            data_out <= valid_in? {data_buffer[227:0], data_in[255:160]}: data_out;  
        end else if(cnt==31) begin
            data_out <= valid_in? {data_buffer[159:0], data_in[255:92]}: data_out;  
        end else if(cnt==32) begin
            data_out <= valid_in? {data_buffer[91:0], data_in[255:24]}: data_out;  
        end else if(cnt==34) begin
            data_out <= valid_in? {data_buffer[279:0], data_in[255:212]}: data_out;  
        end else if(cnt==35) begin
            data_out <= valid_in? {data_buffer[211:0], data_in[255:144]}: data_out;  
        end else if(cnt==36) begin
            data_out <= valid_in? {data_buffer[143:0], data_in[255:76]}: data_out;  
        end else if(cnt==37) begin
            data_out <= valid_in? {data_buffer[75:0], data_in[255:8]}: data_out;  
        end else if(cnt==39) begin
            data_out <= valid_in? {data_buffer[263:0], data_in[255:196]}: data_out;  
        end else if(cnt==40) begin
            data_out <= valid_in? {data_buffer[195:0], data_in[255:128]}: data_out;  
        end else if(cnt==41) begin
            data_out <= valid_in? {data_buffer[127:0], data_in[255:60]}: data_out;  
        end else if(cnt==43) begin
            data_out <= valid_in? {data_buffer[315:0], data_in[255:248]}: data_out;  
        end else if(cnt==44) begin
            data_out <= valid_in? {data_buffer[247:0], data_in[255:180]}: data_out;  
        end else if(cnt==45) begin
            data_out <= valid_in? {data_buffer[179:0], data_in[255:112]}: data_out;  
        end else if(cnt==46) begin
            data_out <= valid_in? {data_buffer[111:0], data_in[255:44]}: data_out;  
        end else if(cnt==48) begin
            data_out <= valid_in? {data_buffer[299:0], data_in[255:232]}: data_out;  
        end else if(cnt==49) begin
            data_out <= valid_in? {data_buffer[231:0], data_in[255:164]}: data_out;  
        end else if(cnt==50) begin
            data_out <= valid_in? {data_buffer[163:0], data_in[255:96]}: data_out;  
        end else if(cnt==51) begin
            data_out <= valid_in? {data_buffer[95:0], data_in[255:28]}: data_out;  
        end else if(cnt==53) begin
            data_out <= valid_in? {data_buffer[283:0], data_in[255:216]}: data_out;  
        end else if(cnt==54) begin
            data_out <= valid_in? {data_buffer[215:0], data_in[255:148]}: data_out;  
        end else if(cnt==55) begin
            data_out <= valid_in? {data_buffer[147:0], data_in[255:80]}: data_out;  
        end else if(cnt==56) begin
            data_out <= valid_in? {data_buffer[79:0], data_in[255:12]}: data_out;  
        end else if(cnt==58) begin
            data_out <= valid_in? {data_buffer[267:0], data_in[255:200]}: data_out;  
        end else if(cnt==59) begin
            data_out <= valid_in? {data_buffer[199:0], data_in[255:132]}: data_out;  
        end else if(cnt==60) begin
            data_out <= valid_in? {data_buffer[131:0], data_in[255:64]}: data_out;  
        end else if(cnt==62) begin
            data_out <= valid_in? {data_buffer[319:0], data_in[255:252]}: data_out; 
        end else if(cnt==63) begin
            data_out <= valid_in? {data_buffer[251:0], data_in[255:184]}: data_out;   
        end else if(cnt==64) begin
            data_out <= valid_in? {data_buffer[183:0], data_in[255:116]}: data_out;  
        end else if(cnt==65) begin
            data_out <= valid_in? {data_buffer[115:0], data_in[255:48]}: data_out;  
        end else if(cnt==67) begin
            data_out <= valid_in? {data_buffer[303:0], data_in[255:236]}: data_out;  
        end else if(cnt==68) begin
            data_out <= valid_in? {data_buffer[235:0], data_in[255:168]}: data_out;  
        end else if(cnt==69) begin
            data_out <= valid_in? {data_buffer[167:0], data_in[255:100]}: data_out;  
        end else if(cnt==70) begin
            data_out <= valid_in? {data_buffer[99:0], data_in[255:32]}: data_out; 
        end else if(cnt==72) begin
            data_out <= valid_in? {data_buffer[287:0], data_in[255:220]}: data_out;  
        end else if(cnt==73) begin
            data_out <= valid_in? {data_buffer[219:0], data_in[255:152]}: data_out;  
        end else if(cnt==74) begin
            data_out <= valid_in? {data_buffer[151:0], data_in[255:84]}: data_out; 
        end else if(cnt==75) begin
            data_out <= valid_in? {data_buffer[83:0], data_in[255:16]}: data_out;   
        end else if(cnt==77) begin
            data_out <= valid_in? {data_buffer[15:0], data_in[255:204]}: data_out;  
        end else if(cnt==78) begin
            data_out <= valid_in? {data_buffer[203:0], data_in[255:136]}: data_out;
        end else if(cnt==79) begin
            data_out <= valid_in? {data_buffer[135:0], data_in[255:68]}: data_out;  
        end else if(cnt==80) begin
            data_out <= valid_in? {data_buffer[67:0], data_in[255:0]}: data_out;     
        end else
            data_out <= data_out;
    end

     always@(posedge clk or negedge rstn) begin
        if(!rstn) begin
            valid_out <= 0;
        end else begin
            valid_out <= (cnt!=0&&cnt!=4&&cnt!=9&&cnt!=14&&cnt!=19&&cnt!=23&&cnt!=28&&
            cnt!=33&&cnt!=38&&cnt!=42&&cnt!=47&&cnt!=52&&cnt!=57&&cnt!=61&&cnt!=66&&
            cnt!=71&&cnt!=76)&&valid_in;
        end
    end 
endmodule