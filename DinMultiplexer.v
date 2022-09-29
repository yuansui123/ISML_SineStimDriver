`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/30/2022 10:57:14 AM
// Design Name: 
// Module Name: bit1_8to1Mux
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


module DinMultiplexer(
    input [7:0]data,
    input [2:0]select,
    output reg result
    );
    
    always @( data or select )begin
        case( select )
            1 : result = data[0];
            2 : result = data[1];
            3 : result = data[2];
            4 : result = data[3];
            5 : result = data[4];
            6 : result = data[5];
            7 : result = data[6];
            0 : result = data[7];
        endcase
    end
endmodule
