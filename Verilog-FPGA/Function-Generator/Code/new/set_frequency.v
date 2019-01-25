`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2016 11:38:57 AM
// Design Name: 
// Module Name: set_frequency
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


module set_frequency(input clk_4hz,input [4:0] placeValue,
output reg [16:0] frequency = 1000,output reg [27:0] frequency_selection = 500);

integer one = 0,ten = 0,hundred = 0,thousand = 1;

always@(posedge clk_4hz) begin
    case(placeValue)
    4'b0001: one = (one==9)?0:(one+1);
    4'b0010: ten = (ten==9)?0:(ten+1);
    4'b0100: hundred = (hundred==9)?0:(hundred+1);
    4'b1000: thousand = (thousand==8)?0:(thousand+1);
    default;
    endcase
end

always@(*) begin
    
    frequency = (thousand*1000) + (hundred*100) + (ten*10) + one;
    frequency_selection = 100000000/(200*frequency);
    
//    case(frequency)
//        1: frequency_selection = 476190;//~1Hz
//        2: frequency_selection = 238095;//~2hz
//        3: frequency_selection = 158730;//~3Hz
//        4: frequency_selection = 119047;//~4Hz
//        5: frequency_selection = 95238;//~5Hz
//        6: frequency_selection = 79365;//~6Hz
//        7: frequency_selection = 68027;//~7Hz
//        8: frequency_selection = 59523;//~8Hz
//        9: frequency_selection = 52910;//~9Hz
//        10: frequency_selection = 47619;//~10Hz
//        20: frequency_selection = 23809;//~20Hz
//        30: frequency_selection = 15873;//~30Hz
//        40: frequency_selection = 11904;//~40Hz
//        50: frequency_selection = 9523;//~50Hz
//        60: frequency_selection = 7937;//~60Hz
//        70: frequency_selection = 6802;//~70Hz
//        80: frequency_selection = 5952;//~80Hz
//        90: frequency_selection = 5291;//~90Hz
//        100: frequency_selection = 4762;//~100Hz
//        200: frequency_selection = 2380;//~200Hz
//        300: frequency_selection = 1587;//~300Hz
//        400: frequency_selection = 1190;//~400Hz
//        500: frequency_selection = 952;//~500Hz
//        600: frequency_selection = 794;//~600Hz
//        700: frequency_selection = 680;//~700Hz
//        800: frequency_selection = 592;//~800Hz
//        900: frequency_selection = 529;//~900Hz
//        1000: frequency_selection = 476;//~1kHz
//        2000: frequency_selection = 238;//~2kHz
//        3000: frequency_selection = 159;//~3kHz
//        4000: frequency_selection = 119;//~4kHz
//        5000: frequency_selection = 95;//~5kHz
//        6000: frequency_selection = 79;//~6kHz
//        7000: frequency_selection = 68;//~7kHz
//        8000: frequency_selection = 60;//~8kHz
//        9000: frequency_selection = 53;//~9kHz
//        default: frequency_selection = 50; //9.5kHz

//    endcase
end

endmodule
