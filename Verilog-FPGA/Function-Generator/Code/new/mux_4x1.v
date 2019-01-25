`timescale 1ns / 1ps

module mux_4x1(input [11:0] sine,input [11:0] pulse,input [11:0] triangle,
input [11:0] saw,input [1:0] sel,output  reg  [11:0] waveform);

always @(*) begin
    case(sel)
        2'b00: waveform = sine;
        2'b01: waveform = pulse;
        2'b10: waveform = triangle;
        2'b11: waveform = saw;
    endcase
end
endmodule
