`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/25/2016 02:34:51 PM
// Design Name: 
// Module Name: sim_convert_clk
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


module sim_convert_clk();

reg clk;
reg [27:0] selection;
wire new_clk;

CONVERT_CLOCK dut(clk,selection,new_clk);

initial begin
    clk=0;
    selection=28'h0000001;
end

always begin
    clk = ~clk; #05;
end

endmodule
