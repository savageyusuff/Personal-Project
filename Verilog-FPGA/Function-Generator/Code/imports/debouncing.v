`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2016 02:32:09 PM
// Design Name: 
// Module Name: debouncing
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module debouncing(input clk_4hz,input button,output pulse);

flipflop u2(button,clk_4hz,Q1);
flipflop u3(Q1,clk_4hz,Q2);
assign pulse = Q1 && ~Q2;

endmodule
