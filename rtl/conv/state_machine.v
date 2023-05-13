`timescale 1ns / 1ps

module state_ctrl(
    input           wire            clk             ,
    input           wire            rstn            ,

    input           wire            state_end       ,
    output          reg     [2:0]   current_state   ,
    output          wire            state_update    

);

    localparam  INIT_state = 3'b000 ;
    localparam  A_state = 3'b001    ;
    localparam  B_state = 3'b010    ;
    localparam  C_state = 3'b011    ;

	reg	  [2:0]		next_state;
	wire			sclk;

	always @(posedge clk or negedge rstn) begin
		if(!rstn) begin
			current_state <= INIT_state;//default state
		end else begin
			current_state <= next_state;
		end
	end

	always @(*) begin
	    next_state = INIT_state;
	    case(current_state)
	        INIT_state:begin
	            if(state_end) begin
	                next_state = A_state;
				end else
	                next_state = current_state;
	        end

	        A_state:begin
	            if(state_end) begin
	                next_state = B_state;
				end else
	                next_state =current_state;
	        end
		
	        B_state:begin
	            if(state_end) begin
	                next_state = C_state;
				end else
	                next_state = current_state;
	        end
		
			C_state:begin
	            if(state_end) begin
	                next_state = A_state;
				end else
	                next_state = current_state;
	        end

	        default:begin
	            next_state = INIT_state;
	        end
	    endcase
	end

endmodule