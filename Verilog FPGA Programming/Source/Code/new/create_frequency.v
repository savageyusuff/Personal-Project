`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2016 09:44:26 AM
// Design Name: 
// Module Name: create_frequency
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


module create_frequency(input clock,input [27:0] limit,output reg new_frequency = 0);
reg [27:0] count = 0;
always @(posedge clock) begin
    count <= count + 1;
    if(count == limit)begin
        count <= 0;
        new_frequency <= ~new_frequency;
    end
    else begin
        new_frequency <= new_frequency;
    end 
end
endmodule
