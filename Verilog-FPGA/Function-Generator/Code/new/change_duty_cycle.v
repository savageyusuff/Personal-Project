`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2016 05:40:48 PM
// Design Name: 
// Module Name: change_duty_cycle
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


module change_duty_cycle(input clock_4hz,input [3:0] limit,input increase,
output reg [6:0] dutyCycle = 50 );

reg [6:0] multiple;
reg [3:0] count;

always@(*) begin
    case(limit)
        4'b0000: multiple = 0;
        4'b0001: multiple = 10;
        4'b0010: multiple = 20;
        4'b0011: multiple = 30;
        4'b0100: multiple = 40;
        4'b0101: multiple = 50;
        4'b0110: multiple = 60;
        4'b0111: multiple = 70;
        4'b1000: multiple = 80;
        4'b1001: multiple = 90;
        default: multiple = 0;
    endcase
end

always@(posedge clock_4hz) begin
    if(increase == 1)begin
        dutyCycle <= ((dutyCycle<multiple)||(dutyCycle>=(multiple+9)))? multiple : (dutyCycle + 1);
    end
    else begin 
        dutyCycle <= dutyCycle;
        count <= count; 
    end
end
endmodule
