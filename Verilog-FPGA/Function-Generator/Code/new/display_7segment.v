`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2016 10:03:59 PM
// Design Name: 
// Module Name: display_7segment
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


module display_7segment(input sevenSegClk,input [2:0] mode,
input [1:0] waveform,
input [11:0] minimum,input [11:0] maximum,
input [6:0] duty,input [16:0] frequency,output reg [11:0] segSeven);
    
    reg [1:0] count;
    integer first;
    integer second;
    integer third;
    integer forth;
    
    reg [11:0] value7segment [0:63];
    
    //fill up the ROM with the respective values that will be pulled out
   //during the memory
   //please do some hardcoding of all the valuereg [11:0] MAXIMUM = 12'hFFC; //4092s you might 
   //need for your 7segment
   
   integer amplitude_ones,maxCase_ones,minCase_ones;
   integer amplitude_tens,maxCase_tens,minCase_tens;
   integer frequency_one,frequency_ten,frequency_hundred,frequency_thousand;
   integer dutyCycle_one,dutyCycle_ten;
   
    initial begin
    value7segment[0] = 12'hEF7;// ***_
    value7segment[1] = 12'hDF7;// **_*
    value7segment[2] = 12'hBF7;// *_**
    value7segment[3] = 12'h7F7;// _***
    value7segment[4] = 12'hFFF;// **** (off any segment)
    value7segment[5] = 12'hEC0;//***0
    value7segment[6] = 12'hEF9;//***1
    value7segment[7] = 12'hEA4;//***2
    value7segment[8] = 12'hEB0;//***3
    value7segment[9] = 12'hE99;//***4
    value7segment[10] = 12'hE92;//***5
    value7segment[11] = 12'hE82;//***6
    value7segment[12] = 12'hEF8;//***7
    value7segment[13] = 12'hE80;//***8
    value7segment[14] = 12'hE98;//***9
    value7segment[15] = 12'hDC0;//**0*
    value7segment[16] = 12'hDF9;//**1*
    value7segment[17] = 12'hDA4;//**2*
    value7segment[18] = 12'hDB0;//**3*
    value7segment[19] = 12'hD99;//**4*
    value7segment[20] = 12'hD92;//**5*
    value7segment[21] = 12'hD82;//**6*
    value7segment[22] = 12'hDF8;//**7*
    value7segment[23] = 12'hD80;//**8*
    value7segment[24] = 12'hD98;//**9*
    value7segment[25] = 12'hBC0;//*0**
    value7segment[26] = 12'hBF9;//*1**
    value7segment[27] = 12'hBA4;//*2**
    value7segment[28] = 12'hBB0;//*3**
    value7segment[29] = 12'hB99;//*4**
    value7segment[30] = 12'hB92;//*5**
    value7segment[31] = 12'hB82;//*6**
    value7segment[32] = 12'hBF8;//*7**
    value7segment[33] = 12'hB80;//*8**
    value7segment[34] = 12'hB98;//*9**
    value7segment[35] = 12'hB40;//*0.**
    value7segment[36] = 12'hB79;//*1.**
    value7segment[37] = 12'hB24;//*2.**
    value7segment[38] = 12'hB30;//*3.**
    value7segment[39] = 12'hEC1;//***V
    value7segment[40] = 12'h788;//A***
    value7segment[41] = 12'hE88;//***A
    value7segment[42] = 12'h789;//H***
    value7segment[43] = 12'h7C7;//L***
    value7segment[44] = 12'h78E ;//F***
    value7segment[45] = 12'h79C;//o***
    value7segment[46] = 12'h7A1;//d*** 
    value7segment[47] = 12'hBA7;//*c** 
    value7segment[48] = 12'hB19;//*4.**
    value7segment[49] = 12'hB12;//*5.**
    value7segment[50] = 12'hB02;//*6.**
    value7segment[51] = 12'hB78;//*7.**
    value7segment[52] = 12'hB00;//*8.**
    value7segment[53] = 12'hB18;//*9.**
    value7segment[54] = 12'h7C0;//0***
    value7segment[55] = 12'h7F9;//1***
    value7segment[56] = 12'h7A4;//2***
    value7segment[57] = 12'h7B0;//3***
    value7segment[58] = 12'h799;//4***
    value7segment[59] = 12'h792;//5***
    value7segment[60] = 12'h782;//6***
    value7segment[61] = 12'h7F8;//7***
    value7segment[62] = 12'h780;//8***
    value7segment[63] = 12'h798;//9***
    end
    
    always @(*) begin
        amplitude_ones = ((maximum-minimum)/124)%10;
        minCase_ones = ((minimum)/124)%10;
        maxCase_ones = ((maximum)/124)%10;
        amplitude_tens = ((maximum-minimum)/124)/10;
        minCase_tens = ((minimum)/124)/10;
        maxCase_tens = ((maximum)/124)/10;
        frequency_one = frequency%10;
        frequency_ten = (frequency/10)%10;
        frequency_hundred = (frequency/100)%10;
        frequency_thousand = frequency/1000;
        dutyCycle_one = duty%10;
        dutyCycle_ten = duty/10;
    end
    

    //have a switch case with the first layer being the mode, then use the
    //mode to find the values(state,frequency) needed and output them 
    //into the 7 segment
    always @(*) begin
        case(mode)
            3'b000:begin//Amplitude
                first = 39;
                forth = 40;
                case(amplitude_ones)
                    0: second = 15;
                    1: second = 16;
                    2: second = 17;
                    3: second = 18;
                    4: second = 19;
                    5: second = 20;
                    6: second = 21;
                    7: second = 22;
                    8: second = 23;
                    9: second = 24;
                   default: second = 1;
                endcase
                case(amplitude_tens)
                    0: third = 35;
                    1: third = 36;
                    2: third = 37;
                    3: third = 38;
                    default: third = 2;
                endcase
            end
            3'b001:begin//Minimum
                first = 39;
                forth = 43;
                case(minCase_ones)
                    0: second = 15;
                    1: second = 16;
                    2: second = 17;
                    3: second = 18;
                    4: second = 19;
                    5: second = 20;
                    6: second = 21;
                    7: second = 22;
                    8: second = 23;
                    9: second = 24;
                   default: second = 1;
                endcase
                case(minCase_tens)
                    0: third = 35;
                    1: third = 36;
                    2: third = 37;
                    3: third = 38;
                    default: third = 2;
                endcase
            end
            3'b010:begin//Maximum
                first = 39;
                forth = 42;
                case(maxCase_ones)
                    0: second = 15;
                    1: second = 16;
                    2: second = 17;
                    3: second = 18;
                    4: second = 19;
                    5: second = 20;
                    6: second = 21;
                    7: second = 22;
                    8: second = 23;
                    9: second = 24;
                   default: second = 1;
                endcase
                case(maxCase_tens)
                    0: third = 35;
                    1: third = 36;
                    2: third = 37;
                    3: third = 38;
                    default: third = 2;
                endcase
            end
            3'b011:begin//Frequency
              case(frequency_thousand)
                    0:forth= 54;
                    1:forth= 55;
                    2:forth= 56;
                    3:forth= 57;
                    4:forth= 58;
                    5:forth= 59;
                    6:forth= 60;
                    7:forth= 61;
                    8:forth= 62;
                    default: forth = 4; 
              endcase
              case(frequency_hundred)
                  0: third= 25;
                  1: third= 26;
                  2: third= 27;
                  3: third= 28;
                  4: third= 29;
                  5: third= 30;
                  6: third= 31;
                  7: third= 32;
                  8: third= 33;
                  9: third= 34;
                  default: third= 4;
              endcase
              case(frequency_ten)
                  0: second = 15;
                  1: second = 16;
                  2: second = 17;
                  3: second = 18;
                  4: second = 19;
                  5: second = 20;
                  6: second = 21;
                  7: second = 22;
                  8: second = 23;
                  9: second = 24;
                  default: second = 4;
              endcase
              case(frequency_one)
                  0:first = 5;
                  1:first = 6;
                  2:first = 7;
                  3:first = 8;
                  4:first = 9;
                  5:first = 10;
                  6:first = 11;
                  7:first = 12;
                  8:first = 13;
                  9:first = 14;
                  default: first = 4;
              endcase
                            
            end
            3'b100:begin//Not used
                    first = 0;
                    second = 1;
                    third = 2;
                    forth = 3;                
            end
            3'b101:begin//Not used
                    first = 0;
                    second = 1;
                    third = 2;
                    forth = 3;                
            end
            3'b110:begin//Duty Cycle
             if(waveform == 1) begin
                
                forth = 47;
                third = 46;
                 case(dutyCycle_ten)
                     0: second = 15;
                     1: second = 16;
                     2: second = 17;
                     3: second = 18;
                     4: second = 19;
                     5: second = 20;
                     6: second = 21;
                     7: second = 22;
                     8: second = 23;
                     9: second = 24;
                     default: second = 4;
                 endcase
                 case(dutyCycle_one)
                     0:first = 5;
                     1:first = 6;
                     2:first = 7;
                     3:first = 8;
                     4:first = 9;
                     5:first = 10;
                     6:first = 11;
                     7:first = 12;
                     8:first = 13;
                     9:first = 14;
                     default: first = 4;
                 endcase                          
              end
              
              else begin
                  first = 0;
                  second = 1;
                  third = 2;
                  forth = 3;   
              end
            end
            3'b111:begin//Offset
                    first = 39;
                    forth = 45;
                    case(minCase_ones)
                        0: second = 15;
                        1: second = 16;
                        2: second = 17;
                        3: second = 18;
                        4: second = 19;
                        5: second = 20;
                        6: second = 21;
                        7: second = 22;
                        8: second = 23;
                        9: second = 24;
                       default: second = 1;
                    endcase
                 
                    case(minCase_tens)
                        0: third = 35;
                        1: third = 36;
                        2: third = 37;
                        3: third = 38;
                        default: third = 2;
                    endcase
            end
            default:begin
                    first = 0;
                    second = 1;
                    third = 2;
                    forth = 3;                    
            end
        endcase
    end
    
    always@(posedge sevenSegClk)begin
        count <= count +1;
    end
    
    always@(count)begin
        case(count)
            2'b00: segSeven  = value7segment[first];
            2'b01: segSeven  = value7segment[second];
            2'b10: segSeven  = value7segment[third];
            2'b11: segSeven  = value7segment[forth];
        endcase
    end
endmodule
