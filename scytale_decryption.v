`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:24:12 11/27/2020 
// Design Name: 
// Module Name:    scytale_decryption 
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
module scytale_decryption#(
			parameter D_WIDTH = 8, 
			parameter KEY_WIDTH = 8, 
			parameter MAX_NOF_CHARS = 50,
			parameter START_DECRYPTION_TOKEN = 8'hFA
		)(
			// Clock and reset interface
			input clk,
			input rst_n,
			
			// Input interface
			input[D_WIDTH - 1:0] data_i,
			input valid_i,
			
			// Decryption Key
			input[KEY_WIDTH - 1 : 0] key_N,
			input[KEY_WIDTH - 1 : 0] key_M,
			
			// Output interface
			output reg[D_WIDTH - 1:0] data_o,
			output reg valid_o,
			
			output reg busy
    );
  
	
  
	
	
	 reg[D_WIDTH - 1:0] vector [MAX_NOF_CHARS-1:0];
	 
	
	 reg[7:0] state  ;
	 reg[7:0] contor_1 ;
	 reg[7:0]  j  ;
	 reg[7:0]  i;
	
	  initial begin
	 
	      for(i = 0 ; i< MAX_NOF_CHARS; i = i + 1)
	          vector[i] <= 0;
		
	  end
	
	 always@(posedge clk)begin
	  
	      if(rst_n == 0)begin
		    data_o  <= 0; 
		    valid_o <= 0; 
		    busy    <= 0;
		    state   <= 8'h0; 
            j       <=0;
            contor_1<=0;		 
	     end  
		
	
	 
	
	    case(state)
	        8'h0:begin
		         busy <= 0;
			     if(valid_i == 1 && busy ==0  )begin
		           if(data_i!= START_DECRYPTION_TOKEN)begin
		              vector[contor_1]<= data_i;
					  contor_1 <= contor_1 + 1; 						
							
	               end
		           else if(data_i == START_DECRYPTION_TOKEN)begin
					       busy<=1;
		                   state <= 8'h1;
								
			       end  
					
				   end
				   if(valid_i == 0)begin
				      busy<=0;
					  valid_o<=0;
		      	      data_o<=0;
				  end
		    end
			
			  
            8'h1:begin
		        
				 if(j < key_M*key_N && busy == 1)begin
				    data_o <= vector[j];
					valid_o<=1;
				    j<=j+key_N;
				 end
				
				 if(j+key_N>= key_M*key_N)begin
			        j <= 1 + j +key_N - key_M*key_N;	 
				 end 
				
				 else begin 
				    j<= j + key_N;
				 end
				
			     if(j == key_N*key_M-1)begin
			        state<=8'h2;
			     end 
			  
		    end	   
			  
	        8'h2:begin
			
			     busy    <= 0 ;
		         valid_o <= 0;
			     data_o  <=0;
			     contor_1<=0;
			     state   <= 8'h0;
				 j       <=0; 
			end
  
        endcase
		 
		 
    end
		  

endmodule
		