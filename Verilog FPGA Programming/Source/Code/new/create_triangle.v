`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2016 10:09:22 AM
// Design Name: 
// Module Name: create_sawtooth
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


module create_triangle(input clock,input [11:0] maximum,input [11:0] minimum,
output reg [11:0] waveform);

parameter n=100;//interval
reg [11:0] h;//value per interval
reg d = 0 ;//direction
reg [6:0] count = 0;

always @(*) begin
    h = (maximum-minimum)/( (n/2) - 1);
end

always @(posedge clock) begin
    count <= (count == ((n/2) - 1))? 0: (count+1);
    d <= (count == ((n/2) - 1))? ~d:d;
    waveform <= (d==0)?(minimum + (h*count)):(maximum - (h*count));
end

endmodule