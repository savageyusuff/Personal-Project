`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2016 09:49:26 AM
// Design Name: 
// Module Name: change_minOrMax
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


module change_minOrMax(input clock_4hz,input increase,input decrease,
input minOrMax,
output reg [11:0] maximum = 4092,output reg [11:0] minimum = 0);
    
always @(posedge clock_4hz)begin
    if (minOrMax == 0) begin
        if ((increase==1)&&(decrease==0)) begin//add
           minimum <= ((maximum-minimum) <= 124)? minimum: ((minimum==4092) ? minimum : (minimum + 124)) ;
        end
        else if ((increase==0)&&(decrease==1)) begin//minum
           minimum <= ((minimum == 0) ? minimum: (minimum - 124));
        end
        else begin
           minimum <= minimum ;
        end
    end
    
    else begin
         if ((increase==1)&&(decrease==0)) begin//add
          maximum <= ((maximum >=4092) ? maximum: (maximum+ 124)) ;
       end
       else if ((increase==0)&&(decrease==1)) begin//minus
          maximum <= ((maximum-minimum ) <= 124)? maximum: ((maximum==0)? maximum: (maximum- 124));
       end
       else begin
          maximum <= maximum ;
       end
    end
    end

endmodule
