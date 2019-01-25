`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2016 10:04:54 AM
// Design Name: 
// Module Name: create_sine
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


module create_sine(input clock,input [11:0] maximum,input [11:0] minimum,
output reg [11:0] waveform);

reg [11:0] sine [0:99];
integer i;
integer amplitude;

initial begin
    i = 0;
//    sine[0] = 2046;
//    sine[1] = 2174;
//    sine[2] = 2302;
//    sine[3] = 2429;
//    sine[4] = 2555;
//    sine[5] = 2678;
//    sine[6] = 2799;
//    sine[7] = 2917;
//    sine[8] = 3032;
//    sine[9] = 3142;
//    sine[10] = 3249;
//    sine[11] = 3350;
//    sine[12] = 3447;
//    sine[13] = 3537;
//    sine[14] = 3622;
//    sine[15] = 3701;
//    sine[16] = 3773;
//    sine[17] = 3839;
//    sine[18] = 3897;
//    sine[19] = 3948;
//    sine[20] = 3992;
//    sine[21] = 4028;
//    sine[22] = 4056;
//    sine[23] = 4076;
//    sine[24] = 4088;
//    sine[25] = 4092;
//    sine[26] = 4088;
//    sine[27] = 4076;
//    sine[28] = 4056;
//    sine[29] = 4028;
//    sine[30] = 3992;
//    sine[31] = 3948;
//    sine[32] = 3897;
//    sine[33] = 3839;
//    sine[34] = 3773;
//    sine[35] = 3701;
//    sine[36] = 3622;
//    sine[37] = 3537;
//    sine[38] = 3447;
//    sine[39] = 3350;
//    sine[40] = 3249;
//    sine[41] = 3142;
//    sine[42] = 3032;
//    sine[43] = 2917;
//    sine[44] = 2799;
//    sine[45] = 2678;
//    sine[46] = 2555;
//    sine[47] = 2429;
//    sine[48] = 2302;
//    sine[49] = 2174;
//    sine[50] = 2046;
//    sine[51] = 1918;
//    sine[52] = 1790;
//    sine[53] = 1663;
//    sine[54] = 1537;
//    sine[55] = 1414;
//    sine[56] = 1293;
//    sine[57] = 1175;
//    sine[58] = 1060;
//    sine[59] = 950;
//    sine[60] = 843;
//    sine[61] = 742;
//    sine[62] = 645;
//    sine[63] = 555;
//    sine[64] = 470;
//    sine[65] = 391;
//    sine[66] = 319;
//    sine[67] = 253;
//    sine[68] = 195;
//    sine[69] = 144;
//    sine[70] = 100;
//    sine[71] = 64;
//    sine[72] = 36;
//    sine[73] = 16;
//    sine[74] = 4;
//    sine[75] = 0;
//    sine[76] = 4;
//    sine[77] = 16;
//    sine[78] = 36;
//    sine[79] = 64;
//    sine[80] = 100;
//    sine[81] = 144;
//    sine[82] = 195;
//    sine[83] = 253;
//    sine[84] = 319;
//    sine[85] = 391;
//    sine[86] = 470;
//    sine[87] = 555;
//    sine[88] = 645;
//    sine[89] = 742;
//    sine[90] = 843;
//    sine[91] = 950;
//    sine[92] = 1060;
//    sine[93] = 1175;
//    sine[94] = 1293;
//    sine[95] = 1414;
//    sine[96] = 1537;
//    sine[97] = 1663;
//    sine[98] = 1790;
//    sine[99] = 1918;
    
    sine[0] = 62;
    sine[1] = 66;
    sine[2] = 70;
    sine[3] = 74;
    sine[4] = 77;
    sine[5] = 81;
    sine[6] = 85;
    sine[7] = 88;
    sine[8] = 92;
    sine[9] = 95;
    sine[10] = 98;
    sine[11] = 102;
    sine[12] = 104;
    sine[13] = 107;
    sine[14] = 110;
    sine[15] = 112;
    sine[16] = 114;
    sine[17] = 116;
    sine[18] = 118;
    sine[19] = 120;
    sine[20] = 121;
    sine[21] = 122;
    sine[22] = 123;
    sine[23] = 124;
    sine[24] = 124;
    sine[25] = 124;
    sine[26] = 124;
    sine[27] = 124;
    sine[28] = 123;
    sine[29] = 122;
    sine[30] = 121;
    sine[31] = 120;
    sine[32] = 118;
    sine[33] = 116;
    sine[34] = 114;
    sine[35] = 112;
    sine[36] = 110;
    sine[37] = 107;
    sine[38] = 104;
    sine[39] = 102;
    sine[40] = 98;
    sine[41] = 95;
    sine[42] = 92;
    sine[43] = 88;
    sine[44] = 85;
    sine[45] = 81;
    sine[46] = 77;
    sine[47] = 74;
    sine[48] = 70;
    sine[49] = 66;
    sine[50] = 62;
    sine[51] = 58;
    sine[52] = 54;
    sine[53] = 50;
    sine[54] = 47;
    sine[55] = 43;
    sine[56] = 39;
    sine[57] = 36;
    sine[58] = 32;
    sine[59] = 29;
    sine[60] = 26;
    sine[61] = 22;
    sine[62] = 20;
    sine[63] = 17;
    sine[64] = 14;
    sine[65] = 12;
    sine[66] = 10;
    sine[67] = 8;
    sine[68] = 6;
    sine[69] = 4;
    sine[70] = 3;
    sine[71] = 2;
    sine[72] = 1;
    sine[73] = 0;
    sine[74] = 0;
    sine[75] = 0;
    sine[76] = 0;
    sine[77] = 0;
    sine[78] = 1;
    sine[79] = 2;
    sine[80] = 3;
    sine[81] = 4;
    sine[82] = 6;
    sine[83] = 8;
    sine[84] = 10;
    sine[85] = 12;
    sine[86] = 14;
    sine[87] = 17;
    sine[88] = 20;
    sine[89] = 22;
    sine[90] = 26;
    sine[91] = 29;
    sine[92] = 32;
    sine[93] = 36;
    sine[94] = 39;
    sine[95] = 43;
    sine[96] = 47;
    sine[97] = 50;
    sine[98] = 54;
    sine[99] = 58;
end

always @(*) begin
    amplitude = (maximum-minimum)/124; 
end

always @(posedge clock) begin
    waveform <= (sine[i]*amplitude) + minimum;
    i <= (i == 99) ? 0 : (i+ 1);   
end

endmodule
