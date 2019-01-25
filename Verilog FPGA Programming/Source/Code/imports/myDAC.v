`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/07/2016 01:10:43 PM
// Design Name: 
// Module Name: myDAC
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

module myDAC(input CLOCK,input [3:0] frequencyPlaceValue,
input [3:0] dutycycle,
input minOrMax,input [2:0] mode,input [1:0] waveform,
input btnC,input btnD,input btnL, 
input btnR,input btnU,
input load_B,
output [3:0] an, output dp, output [6:0] seg,
output [3:0] JA,output LED,output warning);


//For frequency uses
wire HALF_CLOCK; 
wire DAC_CLOCK;
wire CLOCK_4HZ;
wire CLOCK_7SEG;

//for push button
wire RESET;
wire PULSE_D;
wire PULSE_L;
wire PULSE_R;
wire PUlSE_U;

//manipulate signal for DATA_A
wire [6:0] DUTY_CYCLE;
wire [11:0] MAXIMUM;
wire [11:0] MINIMUM;
wire CLOCK_AMP;
wire [27:0] frequency_selection;

//making signal for DATA_A
wire [11:0] SIN;
wire [11:0] PULSE;
wire [11:0] TRIANGLE;
wire [11:0] SAWTOOTH;
wire [11:0] DATA_A;

//for 7segment signal
wire [16:0] desire_frequency;
wire [11:0] segment7;

//to load a memory into data_B
wire [6:0] duty_B;
wire [11:0] max_B;
wire [11:0] min_B;
wire clk_B;
wire [27:0] freqSelect_B;
wire [16:0] freqDesired_B;
wire [1:0] wave_B;

//create waveform for data_B and 7 segment
wire [11:0] sin_B;
wire [11:0] pulse_B;
wire [11:0] triangle_B;
wire [11:0] saw_B;
wire [11:0] DATA_B;
wire [11:0] B_7segment;

//Generating the required frequencies
create_frequency c1(CLOCK,28'h0000001,HALF_CLOCK);//50 MHz
create_frequency c2(CLOCK,28'h1000000,CLOCK_4HZ);// ~6Hz
create_frequency c3(CLOCK,28'h0000032,DAC_CLOCK);//2Mhz
create_frequency c5(CLOCK,28'h00186A0,CLOCK_7SEG);//1000hz

//Single Pulse debounce
debouncing d1(CLOCK_4HZ,btnC,RESET);
debouncing d2(CLOCK_4HZ,btnD,PULSE_D);
debouncing d3(CLOCK_4HZ,btnL,PULSE_L);
debouncing d4(CLOCK_4HZ,btnR,PULSE_R);
debouncing d5(CLOCK_4HZ,btnU,PULSE_U);

//setting frequency for DATA_A
set_frequency f1(CLOCK_4HZ,frequencyPlaceValue,desire_frequency,frequency_selection);
create_frequency c4(CLOCK,frequency_selection,CLOCK_AMP);

//setting parameters for DATA_A
change_duty_cycle n6(CLOCK_4HZ,dutycycle,PULSE_R,DUTY_CYCLE);
change_minOrMax n1(CLOCK_4HZ,PULSE_U,PULSE_D,minOrMax,MAXIMUM,MINIMUM);

//creating waveform for DATA_A
create_pulse n2(DUTY_CYCLE,CLOCK_AMP,MINIMUM,MAXIMUM,PULSE);
create_sine n3(CLOCK_AMP,MAXIMUM,MINIMUM,SIN);
create_sawtooth n4(CLOCK_AMP,MAXIMUM,MINIMUM,SAWTOOTH);
create_triangle n5(CLOCK_AMP,MAXIMUM,MINIMUM,TRIANGLE);
mux_4x1 m1(SIN,PULSE,TRIANGLE,SAWTOOTH,waveform,DATA_A);

//7segment display for DATA_A
display_7segment s4(CLOCK_7SEG,mode,waveform,MINIMUM,MAXIMUM,DUTY_CYCLE,desire_frequency,segment7);

//creating a module to load the current state of information to DATA_B
load_information b1(CLOCK_4HZ,load_B,PULSE_L,MAXIMUM,MINIMUM,DUTY_CYCLE,
desire_frequency,frequency_selection,waveform,
max_B,min_B,duty_B,freqDesired_B,freqSelect_B,wave_B);

//create frequency for DATA_B
create_frequency b3(CLOCK,freqSelect_B,clk_B);

//creating waveform for DATA_B
create_pulse b4(duty_B,clk_B,min_B,max_B,pulse_B);
create_sine b5(clk_B,max_B,min_B,sin_B);
create_sawtooth b6(clk_B,max_B,min_B,saw_B);
create_triangle b7(clk_B,max_B,min_B,triangle_B);
mux_4x1 b8(sin_B,pulse_B,triangle_B,saw_B,wave_B,DATA_B);

//7segement display for DATA_B
display_7segment b9(CLOCK_7SEG,mode,wave_B,min_B,max_B,duty_B,freqDesired_B,B_7segment);

//output to 7 segment
assign an = (load_B == 1) ? B_7segment[11:8] : segment7[11:8];
assign dp = (load_B == 1) ? B_7segment[7] : segment7[7];
assign seg = (load_B == 1) ? B_7segment[6:0] : segment7[6:0];
assign warning = (load_B == 1) ? 1 : 0;

DA2RefComp MY_BASIC_DAC (
 .CLK(HALF_CLOCK), 
 .START(DAC_CLOCK), 
 .RST(RESET), 
 .D1(JA[1]), 
 .D2(JA[2]), 
 .CLK_OUT(JA[3]), 
 .nSYNC(JA[0]), 
 .DATA1(DATA_A), 
 .DATA2(DATA_B), 
 .DONE(LED)  
);

endmodule
