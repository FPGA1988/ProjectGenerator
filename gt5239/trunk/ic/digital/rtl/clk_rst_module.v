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
//File Name      : clk_rst_module.v 
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
module clk_rst_module(
    //************************************************************************************************
    // 1.input and output declaration
    //************************************************************************************************
    input   wire            sclk_iic            ,//01   In
    input   wire            sclk_spi            ,//01   In
    input   wire            timer_clk           ,//01   In
    input   wire            test_en             ,//01   In
    input   wire            spi_en              ,//01   In
    input   wire            spi_cs_n            ,//01   In
    input   wire            por_rst_n           ,//01   In
    output  wire            timer_en            ,//01   Out
    input   wire            ee_wbusy_comb       ,//01   In
    input   wire            ee_wdone            ,//01   In
    input   wire            por_cfg_done        ,//01   In
    input   wire            por_cfg_done_r      ,//01   In
    input   wire            spi_start_n_dly     ,//01   In
    input   wire            spi_dact_clr        ,//01   In
    input   wire            spi_data_clr        ,//01   In
    output  wire            iic_clk_s           ,//01   Out
    output  wire            por_cfg_clk         ,//01   Out
    output  wire            mode_cfg_clk        ,//01   Out
    output  wire            iic_rst_n           ,//01   Out
    output  wire            spi_rst_n           ,//01   Out
    input   wire            iic_sw_rst_n        ,//01   In
    input   wire            iic_valid           ,//01   In
    input   wire            iic_start_pulse     ,//01   In
    input   wire            scl_in_data         ,//01   In
    input   wire            iic_sw_rst_n_dly    ,//01   In
    input   wire            iic_start_rising_r  ,//01   In
    output  wire            iic_clk_c           ,//01   Out
    output  wire            iic_sys_rst_n       ,//01   Out
    output  wire            iic_frm_rst_n       ,//01   Out
    output  wire            iic_wbusy_rst_n     ,//01   Out 
    output  wire            iic_start_pulse_clr ,//01   Out
    output  wire            iic_sw_rst_clr      ,//01   Out
    output  wire            iic_start_clr       ,//01   Out
    output  wire            iic_ext_rst_n       ,//01   Out
    input   wire            spi_hold_n          ,//01   In
    input   wire            spi_start           ,//01   In
    output  wire            spi_gated_control   ,//01   Out
    output  wire            spi_clk_c           ,//01   Out
    output  wire            spi_sr_clk          ,//01   Out
    output  wire            spi_frm_rst_n       ,//01   Out
    output  wire            spi_wbusy_rst_n     ,//01   Out
    output  wire            spi_start_clr       ,//01   Out
    output  wire            spi_wren_rst_n      ,//01   Out
    output  wire            spi_tx_rst_n        ,//01   Out
    output  wire            spi_data_rst_n      ,//01   Out
    output  wire            spi_dact_rst_n       //01   Out
);
    //************************************************************************************************
    // 2.Parameter and constant define
    //************************************************************************************************
    
    
    
    //************************************************************************************************
    // 3.Register and wire declaration
    //************************************************************************************************
    //------------------------------------------------------------------------------------------------
    // 3.1 the clk wire signal
    //------------------------------------------------------------------------------------------------   
    reg                     spi_gated_control   ;
    wire                    spi_clk_s           ;
    wire                    spi_en_n            ;
    wire                    sclk_spi_c          ;
    
    
    //------------------------------------------------------------------------------------------------
    // 3.x the test logic
    //------------------------------------------------------------------------------------------------
    //************************************************************************************************
    // 4.Main code
    //************************************************************************************************

    //------------------------------------------------------------------------------------------------
    // 4.1 the ecc module assignment
    //------------------------------------------------------------------------------------------------    
    assign spi_en_n             = ~spi_en   ;
    assign timer_en             = por_rst_n & (~por_cfg_done_r | ee_wbusy_comb);
    assign sclk_spi_c           = sclk_spi & (~spi_cs_n);

    assign por_cfg_clk          = por_cfg_done_r ? iic_clk_c : timer_clk    ;
    assign mode_cfg_clk         = spi_en ? sclk_spi_c : sclk_iic            ;
    assign iic_clk_s            = spi_en_n & sclk_iic                       ;
    assign iic_clk_c            = (iic_rst_n & iic_valid & (~ee_wdone)) ? iic_clk_s : 1'b1  ;

    assign iic_rst_n            = por_rst_n & spi_en_n & por_cfg_done       ;
    assign iic_sys_rst_n        = iic_rst_n & iic_sw_rst_n              ;
    assign iic_frm_rst_n        = iic_sys_rst_n & (~ee_wdone) & (~iic_start_pulse)  ;
    assign iic_wbusy_rst_n      = iic_rst_n & (~ee_wdone)               ;
    assign iic_start_pulse_clr  = iic_sys_rst_n & scl_in_data       ;
    assign iic_sw_rst_clr       = iic_rst_n & iic_sw_rst_n_dly      ;
    assign iic_start_clr        = iic_sys_rst_n & (~iic_start_rising_r) ;
    assign iic_ext_rst_n        = iic_wbusy_rst_n & iic_sys_rst_n & test_en ;


    assign spi_clk_s            = spi_en & sclk_spi_c   ;
    
    always @(*) begin : LATCH_SPI_GATED_CLK
        if(~spi_clk_s)
            spi_gated_control   = spi_hold_n        ;
        else
            spi_gated_control   = spi_gated_control ;
    end

    assign spi_clk_c    = spi_gated_control & spi_clk_s ;
    assign spi_sr_clk   = por_cfg_done_r ? spi_cs_n : timer_clk;
    assign spi_rst_n    = por_rst_n & spi_en & por_cfg_done ;
    assign spi_frm_rst_n    = spi_rst_n & (ee_wdone) & (spi_start)  ;
    assign spi_wbusy_rst_n  = spi_rst_n & (ee_wdone);
    assign spi_start_clr    = spi_rst_n & spi_start_n_dly;
    assign spi_wren_rst_n   = spi_rst_n & (ee_wbusy_comb);
    assign spi_tx_rst_n     = spi_frm_rst_n & (~spi_cs_n);
    assign spi_data_rst_n   = (spi_frm_rst_n | ee_wbusy_comb) & (spi_data_clr);
    assign spi_dact_rst_n   = (spi_frm_rst_n | ee_wbusy_comb) & (spi_dact_clr);



    //************************************************************************************************
    // 5.Sub module instantiation
    //************************************************************************************************
    //------------------------------------------------------------------------------------------------
    // 5.1 the ecc module assignment

endmodule    
//****************************************************************************************************
//End of Module
//****************************************************************************************************
