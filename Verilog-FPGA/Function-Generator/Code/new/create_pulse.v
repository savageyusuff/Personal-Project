`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/25/2016 03:55:48 PM
// Design Name: 
// Module Name: create_pulse
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


module create_pulse(input [6:0] duty,input frequency,
input [11:0] minimum,input [11:0] maximum,
output reg [11:0] waveform = 12'h000);

reg [7:0] limit = 10;
reg [7:0] count = 0;


always@(posedge frequency)begin
    waveform <= (count < duty)? maximum : minimum;
    count <= (count == 99)? 0: (count + 1);//ensure 100 count
end

endmodule
