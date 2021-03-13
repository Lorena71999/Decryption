`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:13:49 11/23/2020 
// Design Name: 
// Module Name:    decryption_regfile 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module decryption_regfile #(
			parameter addr_witdth = 8,
			parameter reg_width   = 16
		)(
			// Clock and reset interface
			input clk, 
			input rst_n,
			
			// Register access interface
			input[addr_witdth - 1:0] addr,
			input read,
			input write,
			input [reg_width -1 : 0] wdata,
			output reg [reg_width -1 : 0] rdata,
			output reg done,
			output reg error,
			
			// Output wires
			output reg[reg_width - 1 : 0] select,
			output reg[reg_width - 1 : 0] caesar_key,
			output reg[reg_width - 1 : 0] scytale_key,
			output reg[reg_width - 1 : 0] zigzag_key
    );
           `define SELECT_REGISTER       8'h00
	       `define CAESAR_KEY_REGISTER   8'h10
	       `define SCYTALE_KEY_REGISTER  8'h12
	       `define ZIGZAG_KEY_REGISTER   8'h14
	 
	 
    always @(posedge clk) begin

       if(rst_n == 0)begin
	 
	      select      <= 16'h0;
		  caesar_key  <= 16'h0;
		  scytale_key <= 16'hFFFF;
		  zigzag_key  <= 16'h02;
		 
	   end  
		 
	   else if(write == 1) begin
					 
		    case(addr)
		   
			`SELECT_REGISTER:begin
			
				    select <= {14'b0,wdata[1:0]};
				   
					end
					
			`CAESAR_KEY_REGISTER:begin
			 
				   caesar_key <= wdata;
				   
				   end
				   
			`SCYTALE_KEY_REGISTER:begin
			
				  scytale_key <= wdata;
				  
				   end
				   
			`ZIGZAG_KEY_REGISTER:begin	
			
				  zigzag_key <= wdata;
				  
				  end
		  
		    endcase
	 
		    if((addr != `SELECT_REGISTER) && (addr != `CAESAR_KEY_REGISTER) && (addr != `SCYTALE_KEY_REGISTER) && (addr != `ZIGZAG_KEY_REGISTER)) begin
			
			  error <= 1;
			  
		    end
			
		    else begin
		  
			  error <= 0;
			  
		    end
		  
		  done <= 1;
		  
      end		 
  
	  else if(read == 1)begin
			    
			case(addr)
			
		     `SELECT_REGISTER:begin
			 
		             rdata <= select;
					 
			          end
		     `CAESAR_KEY_REGISTER :begin
					
		              rdata <= caesar_key;
						  
		             end
					 
	 	     `SCYTALE_KEY_REGISTER:begin
					
		              rdata <= scytale_key;
						  
			          end
					  
		      `ZIGZAG_KEY_REGISTER:begin	
					
                      rdata <= zigzag_key;
						  
                      end
			  
            endcase
				  
		    if((addr != `SELECT_REGISTER) && (addr !=  `CAESAR_KEY_REGISTER) && (addr != `SCYTALE_KEY_REGISTER) && (addr != `ZIGZAG_KEY_REGISTER))begin
			   
		         error <= 1;
				   
		    end 
				 
		    else begin
					
			      error <= 0;
					  
			end
				   
				   done <= 1;
	
			 
            end
			
            else begin
			
			     done  <= 0;
			     error <= 0;
			 
			end 
			
	  
    end


	

endmodule
