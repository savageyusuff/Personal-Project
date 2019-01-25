`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2016 08:55:37 AM
// Design Name: 
// Module Name: load_information
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


module load_information(input clk_4hz,input data_B,input load,
input [11:0] maximum,input [11:0] minimum,input [6:0] dutyCycle,
input [16:0] desired_frequency,input [27:0] frequency_setting,
input [1:0] waveform,
output reg [11:0] max_B,output reg [11:0] min_B,output reg [6:0] duty_B,
output reg [16:0] freqDesired_B,output reg [27:0] freqSet_B,
output reg [1:0] wave_B);

always@(posedge clk_4hz) begin
    if((data_B == 1)&&(load==1))begin
        max_B <= maximum;
        min_B <= minimum;
        duty_B <= dutyCycle;
        freqDesired_B <= desired_frequency;
        freqSet_B <= frequency_setting;
        wave_B <= waveform;
    end
    else begin 
        max_B <= max_B;
        min_B <= min_B; 
        duty_B <= duty_B;
        freqDesired_B <= freqDesired_B;
        freqSet_B <=  freqSet_B;
        wave_B <= wave_B;
    end
end

endmodule
