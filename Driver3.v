`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/31/2022 07:39:01 AM
// Design Name: 
// Module Name: Driver3
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


module Driver3(
    input clk_in,
    input bt_res,
    
    input sw_cha0_sel3,
    input sw_cha0_sel2,
    input sw_cha0_sel1,
    input sw_cha0_sel0,
    
    input sw_cha1_sel3,
    input sw_cha1_sel2,
    input sw_cha1_sel1,
    input sw_cha1_sel0,
    
    output resn,
    output enable, 
    output clk_out,
    output serial_din,
    output sel3,
    output sel2,
    output sel1,
    output sel0,
    
    //for testing
    output reg en_sig,
    output reg [31:0] cycleCounter,
    output reg count2,
    
    output reg [3:0] adrSelect,
    output reg [3:0] chaSelect,
    output reg [2:0] dinSelect,
    
    output reg [7:0] cha0Data,
    output reg [7:0] cha1Data,
    output [7:0] dinData,
    
    output reg res_sig,
    output reg res_started,
    output reg res_finished,
    output reg res_second
    );
   
    reg [31:0] cycle = 250;
    reg [7:0] chaNum = 2;
    reg [7:0] resetVal = 8'b11111111;
    reg [7:0] biVal1 = 8'b11111111;
    reg [7:0] biVal2 = 8'b11111110;
    
    assign resn = res_sig;
    assign enable = en_sig;
    assign clk_out = ~clk_in & (en_sig || res_started);
    
    AddrMultiplexer addrMux(.sw_cha0_sel3(sw_cha0_sel3),
                            .sw_cha0_sel2(sw_cha0_sel2),
                            .sw_cha0_sel1(sw_cha0_sel1),
                            .sw_cha0_sel0(sw_cha0_sel0),
                            .sw_cha1_sel3(sw_cha1_sel3),
                            .sw_cha1_sel2(sw_cha1_sel2),
                            .sw_cha1_sel1(sw_cha1_sel1),
                            .sw_cha1_sel0(sw_cha1_sel0),
                            .select(adrSelect),
                            .sel3(sel3),
                            .sel2(sel2),
                            .sel1(sel1),
                            .sel0(sel0)); 
    
    ChaMultiplexer chaMux(.resetVal(resetVal),
                            .data0(cha0Data),
                            .data1(cha1Data),
                            .select(chaSelect),
                            .result(dinData));
    DinMultiplexer dinMux(.data(dinData),
                        .select(dinSelect),
                        .result(serial_din));
                        
    initial begin
        en_sig = 1;
        cycleCounter = 1;
        count2 = 1;
        
        adrSelect = 0;
        dinSelect = 1;
        chaSelect = 1;
        
        cha0Data = biVal1;
        cha1Data = biVal2;
        
        res_sig = 1;
        res_started = 0;
        res_finished = 0;
        res_second = 0;
    end
    
    always@(posedge clk_in) begin
        if(bt_res == 0 && res_started == 0 && res_finished == 0) begin
            res_sig <= 0;
            res_started <= 1;
            res_finished <= 0;
            res_second <= 0;
            
            dinSelect <= 0;
            chaSelect <= 0;
            
            en_sig <= 0;
        end 
        else if(res_sig == 0 && res_started == 1 && res_finished == 0) begin
            res_sig <= 1;
            res_started <= 1;
            res_finished <= 0;
            res_second <= 0;
            
            dinSelect <= dinSelect +1;
        end
        else if(dinSelect != 0 && res_started == 1 && res_finished == 0) begin
            
            dinSelect <= dinSelect +1;
        end
        else if(dinSelect == 0 && res_second == 0 && res_started == 1 && res_finished == 0) begin
            res_sig <= 1;
            res_started <= 1;
            res_finished <= 0;
            res_second <= 1;
            
            dinSelect <= dinSelect +1;
        end
        else if(dinSelect == 0 && res_second == 1 && res_started == 1 && res_finished == 0) begin
            res_sig <= 1;
            res_started <= 1;
            res_finished <= 1;
            res_second <= 0; 
        end
        else if(bt_res == 0 && res_started == 1 && res_finished == 1) begin
            res_sig <= 1;
            res_started <= 1;
            res_finished <= 1;
            res_second <= 0;
        end
        else if(bt_res == 1 && res_started == 1 && res_finished == 1) begin
            en_sig <= 1;
            cycleCounter <= 1;
        
            adrSelect <= 0;
            dinSelect <= 1;
            chaSelect <= 1;
        
            res_sig <= 1;
            res_started <= 0;
            res_finished <= 0;
            res_second <= 0;
        end
        
        
        else if(res_started == 0 && res_finished == 0 && dinSelect == 0 && cycleCounter < chaNum) begin
            adrSelect <= cycleCounter[3:0];
            chaSelect <= cycleCounter[3:0] +1;
           
            cycleCounter <= cycleCounter +1;
            dinSelect <= dinSelect +1;
        end
        else if(res_started == 0 && res_finished == 0 && dinSelect == 0 && cycleCounter != cycle && count2 == 0) begin
            adrSelect <= 0;
            chaSelect <= 1;
            
            cha0Data = biVal1;
            cha1Data = biVal2;
            
            cycleCounter <= cycleCounter +1;
            dinSelect <= dinSelect +1;
        end
        else if(res_started == 0 && res_finished == 0 && dinSelect == 0 && cycleCounter != cycle && count2 == 1) begin
            adrSelect <= 0;
            chaSelect <= 1;
            
            cha0Data = biVal2;
            cha1Data = biVal1;
            
            cycleCounter <= cycleCounter +1;
            dinSelect <= dinSelect +1;
        end
        else if(res_started == 0 && res_finished == 0 && dinSelect == 0 && cycleCounter == cycle) begin
            count2 <= ~count2;
            cycleCounter <= 1;
            dinSelect <= dinSelect +1;
        end
        else if(res_started == 0 && res_finished == 0) begin
            dinSelect <= dinSelect +1;
        end   
    end 

endmodule