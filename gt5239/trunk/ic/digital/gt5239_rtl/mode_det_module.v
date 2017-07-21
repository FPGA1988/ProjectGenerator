//****************************************************************************************************  
//*------------------Copyright (c) 2016 C-L-G.FPGA1988.bwang. All rights reserved---------------------
//
//                       --              It to be define                --
//                       --                    ...                      --
//                       --                    ...                      --
//                       --                    ...                      --
//**************************************************************************************************** 
//File Information
//**************************************************************************************************** 
//File Name      : mode_det_module.v 
//Project Name   : gt0000
//Description    : the top module of gt0000
//Github Address : https://github.com/C-L-G/gt0000/trunk/ic/digital/rtl/gt0000_digital_top.v
//License        : CPL
//**************************************************************************************************** 
//Version Information
//**************************************************************************************************** 
//Create Date    : 01-07-2016 17:00(1th Fri,July,2016)
//First Author   : bwang
//Modify Date    : 02-09-2016 14:20(1th Sun,July,2016)
//Last Author    : bwang
//Version Number : 002   
//Last Commit    : 03-09-2016 14:30(1th Sun,July,2016)
//**************************************************************************************************** 
//Change History(latest change first)
//yyyy.mm.dd - Author - Your log of change
//**************************************************************************************************** 
//2017.06.29 - bwang - The initial version.
//*---------------------------------------------------------------------------------------------------
`timescale 1ns/1ps
module mode_det_module(
    mode_cfg_clk        ,//01   In
    por_rst_n           ,//01   In
    a0_csbar            ,//01   In
    a2_wpbar            ,//01   In
    ee_wbusy_comb       ,//01   In
    test_disable        ,//01   In
    test_en             ,//01   In
    spi_en_s            ,//01   In
    spi_en_s_val         //01   In
);

    //************************************************************************************************
    // 1.input and output declaration
    //************************************************************************************************
    input                   mode_cfg_clk        ;//01   In
    input                   por_rst_n           ;//01   In
    input                   a0_csbar            ;//01   In
    input                   a2_wpbar            ;//01   In
    input                   ee_wbusy_comb       ;//01   In
    input                   test_disable        ;//01   In
    output                  test_en             ;//01   In
    output                  spi_en_s            ;//01   In
    output                  spi_en_s_val        ;//01   In

    //************************************************************************************************
    // 2.Parameter and constant define
    //************************************************************************************************
    
    
    
    //************************************************************************************************
    // 3.Register and wire declaration
    //************************************************************************************************
    //------------------------------------------------------------------------------------------------
    // 3.1 the clk wire signal
    //------------------------------------------------------------------------------------------------   
    reg                     test_en             ;
    reg                     spi_en_s            ;
    reg                     spi_en_s_val        ;
    reg     [06:00]         a2_wpbar_reg        ;
    wire                    seq_7bit_match      ;
    wire                    test_en_seq_val     ;
    wire                    iic_seq_val         ;
    wire                    spi_seq_val         ;
    
    //------------------------------------------------------------------------------------------------
    // 3.x the test logic
    //------------------------------------------------------------------------------------------------
    //************************************************************************************************
    // 4.Main code
    //************************************************************************************************

    //------------------------------------------------------------------------------------------------
    // 4.1 the ecc module assignment
    //------------------------------------------------------------------------------------------------    
    
    always @(posedge mode_cfg_clk or negedge por_rst_n) begin
        if(!por_rst_n)
            a2_wpbar_reg    <= 7'd0  ;
        else if(!test_en & ee_wbusy_comb)
            a2_wpbar_reg    <= 7'd0 ;
        else if(!a0_csbar)
            a2_wpbar_reg    <= {a2_wpbar_reg[5:0],a2_wpbar};
        else
            a2_wpbar_reg    <= a2_wpbar_reg;
    end

    assign test_en_seq_val  = ({a2_wpbar_reg[6:0],a2_wpbar} == TEST_EN_SEQ) ;
    assign seq_7bit_match   = (a2_wpbar_reg[6:0] == 7'b1101_001) & test_en  ;
    assign iic_seq_val      = seq_7bit_match & (~a2_wpbar)                  ;
    assign spi_seq_val      = seq_7bit_match & a2_wpbar                     ;

    always @(posedge mode_cfg_clk or negedge por_rst_n) begin
        if(!por_rst_n)
            test_en <= 1'b0     ;
        else if(test_en_seq_val)
            test_en <= 1'b1     ;
        else if(test_disable)
            test_en <= 1'b0     ;
        else
            test_en <= test_en  ;
    end

    always @(posedge mode_cfg_clk or negedge por_rst_n) begin
        if(!por_rst_n) begin
            spi_en_s_val    <= 1'b0     ;
            spi_en_s        <= 1'b0     ;
        end
        else if(!test_en) begin
            spi_en_s_val    <= 1'b0     ;
            spi_en_s        <= 1'b0     ;
        end
        else if(spi_seq_val) begin
            spi_en_s_val    <= 1'b1     ;
            spi_en_s        <= 1'b1     ;
        end
        else if(iic_seq_val) begin
            spi_en_s_val    <= 1'b1     ;
            spi_en_s        <= 1'b0     ;
        end
        else begin
            spi_en_s_val    <= spi_en_s_val ;
            spi_en_s        <= spi_en_s     ;
        end
    end

    //************************************************************************************************
    // 5.Sub module instantiation
    //************************************************************************************************
    //------------------------------------------------------------------------------------------------
    // 5.1 the xxx module assignment
    //------------------------------------------------------------------------------------------------

endmodule    
//****************************************************************************************************
//End of Module
//****************************************************************************************************
