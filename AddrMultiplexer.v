`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/31/2022 07:52:39 AM
// Design Name: 
// Module Name: AddrMultiplexer
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

//bit4 16to1 Mux

module AddrMultiplexer(
    input sw_cha0_sel3,
    input sw_cha0_sel2,
    input sw_cha0_sel1,
    input sw_cha0_sel0,
    
    input sw_cha1_sel3,
    input sw_cha1_sel2,
    input sw_cha1_sel1,
    input sw_cha1_sel0,
    
    input [3:0]select,
    
    output reg sel3,
    output reg sel2,
    output reg sel1,
    output reg sel0
    );
    
    always @( sw_cha0_sel3 or sw_cha0_sel2 or sw_cha0_sel1 or sw_cha0_sel0 or sw_cha1_sel3 or sw_cha1_sel2 or sw_cha1_sel1 or sw_cha1_sel0 or select )begin
        case( select )
            0 : begin
                sel3 = sw_cha0_sel3;
                sel2 = sw_cha0_sel2;
                sel1 = sw_cha0_sel1;
                sel0 = sw_cha0_sel0;
            end
            1 : begin
                sel3 = sw_cha1_sel3;
                sel2 = sw_cha1_sel2;
                sel1 = sw_cha1_sel1;
                sel0 = sw_cha1_sel0;
            end
        endcase
    end
endmodule