`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/30/2022 07:45:51 PM
// Design Name: 
// Module Name: channelMultiplexer
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


module ChaMultiplexer(
    input [7:0]resetVal,
    input [7:0]data0,
    input [7:0]data1,
    input [3:0]select,
    output reg [7:0] result
    );
    
    always @( resetVal or data0 or data1 or select )begin
        case( select )
            0 : result = resetVal;
            1 : result = data0;
            2 : result = data1;
        endcase
    end
endmodule