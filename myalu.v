`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:07:00 04/11/2020 
// Design Name: 
// Module Name:    myalu 
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
//  Constant definitions 

module myalu # ( parameter NUMBITS = 16 ) (
    input wire clk, 
    input wire reset ,  
    input  wire[NUMBITS-1:0] A, 
    input  wire[NUMBITS-1:0] B, 
    input wire [2:0]opcode, 
    output reg [NUMBITS-1:0] result,  
    output reg carryout ,
    output reg overflow , 
    output reg zero  );

// ------------------------------
// Insert your solution below
// ------------------------------ 
reg [NUMBITS-1:0] myResult ; 
reg myOverflow;
reg myCarryout;

always @(*)begin

myResult = 'd0;

case (opcode)

//unsigned add
3'd0 : begin 
myResult = A + B; 

{myCarryout,myResult} = {1'b0, A} + {1'b0,B};
myOverflow = 'd0;
end

//signed add
3'd1 : begin
myResult = $signed(A) + $signed(B);
myCarryout = 'd0;
			if (($signed(A) >= 0) && ($signed(B) >= 0) && ($signed(myResult) < 0)) 
			begin 
			myOverflow = 1'b1;
			end 
			
			else if (($signed(A) < 0) && ($signed(B) < 0) && ($signed(myResult) >= 0))
			begin 
			myOverflow = 1'b1;
			end 
			
			else 
			begin 
			myOverflow = 1'b0 ;
			end
end

//unsigned sub case
3'd2 : begin 
myResult = A - B; 
{myCarryout,myResult} = {1'b0, A} - {1'b0,B};
myOverflow = 'd0;
end

//signed sub case
3'd3 : begin 
myResult = $signed(A) - $signed(B);
myCarryout = 'd0;
			if (($signed(A) >= 0) && ($signed(A) < 0) && ($signed(A) < 0))
			begin
			myOverflow = 1'b1;
			end 
			
			else if (($signed(A) < 0) && ($signed(B) >= 0) && ($signed(myResult) >= 0)) 
			begin 
			myOverflow = 1'b1;
			end 
			
			else 
			begin
			myOverflow <= 1'b0;
			end
			
end

//AND(&&)
3'd4 : begin
myResult = A & B; 
myOverflow = 'd0;
myCarryout = 'd0;
end

//OR(||)
3'd5 : begin 
myResult = A | B; 
myOverflow = 'd0;
myCarryout = 'd0;
end

//XOR
3'd6 : begin
myResult = A ^ B; 
myOverflow = 'd0;
myCarryout = 'd0;
end

//Divide by 2(shift bits to left)
3'd7 : begin
myResult = A >> 1; 
myOverflow = 'd0;
myCarryout = 'd0;
end

endcase

end

//seq block
always @( posedge clk )begin
			if( reset == 1'b1 )
			begin
			result <= 'd0 ;
			zero <= 'd0;
			overflow <= 'd0;
			carryout <= 'd0;
			end 
			
			else 
			begin
			result <= myResult ;
			overflow <= myOverflow;
			carryout <= myCarryout;
			
			if (myResult == {NUMBITS{1'b0}} ) zero <= 1'b1; // Zero detection
			
				else zero <= 1'b0;
				zero <= ( myResult == {NUMBITS{1'b0}}) ? 1'b1 : 1'b0 ;
			end
end
endmodule
