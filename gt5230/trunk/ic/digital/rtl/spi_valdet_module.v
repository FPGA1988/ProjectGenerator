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
//File Name      : spi_valdet_module.v 
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
module spi_valdet_module(
    spi_wbusy_rst_n     ,//01   In
    spi_start_clr       ,//01   Out
    spi_cs_n            ,//01   Out
    spi_prog_en         ,//01   In
    spi_valid           ,//01   In
    spi_start_n_dly     ,//01   In
    spi_ee_wbusy         //01
);

    //************************************************************************************************
    // 1.input and output declaration
    //************************************************************************************************
    input                   spi_cs_n            ,//01   In
    input                   spi_start_n_dly     ,//01   In
    input                   spi_dact_clr        ,//01   In
    input                   spi_data_clr        ,//01   In
    output                  spi_clk_s           ,//01   Out
    output                  por_cfg_clk         ,//01   Out
    output                  mode_cfg_clk        ,//01   Out
    output                  spi_rst_n           ,//01   Out
    output                  spi_rst_n           ,//01   Out
    input                   spi_sw_rst_n        ,//01   In
    input                   spi_valid           ,//01   In
    input                   spi_start_pulse     ,//01   In
    input                   scl_in_data         ,//01   In
    input                   spi_sw_rst_n_dly    ,//01   In
    input                   spi_start_rising_r  ,//01   In
    output                  spi_clk_c           ,//01   Out
    output                  spi_sys_rst_n       ,//01   Out
    output                  spi_frm_rst_n       ,//01   Out
    output                  spi_wbusy_rst_n     ,//01   Out 
    output                  spi_start_pulse_clr ,//01   Out
    output                  spi_sw_rst_clr      ,//01   Out
    output                  spi_start_clr       ,//01   Out
    output                  spi_ext_rst_n       ,//01   Out
    input                   spi_hold_n          ,//01   In
    input                   spi_start           ,//01   In
    output                  spi_gated_control   ,//01   Out
    output                  spi_clk_c           ,//01   Out
    output                  spi_sr_clk          ,//01   Out
    output                  spi_frm_rst_n       ,//01   Out
    output                  spi_wbusy_rst_n     ,//01   Out
    output                  spi_start_clr       ,//01   Out
    output                  spi_wren_rst_n      ,//01   Out
    output                  spi_tx_rst_n        ,//01   Out
    output                  spi_data_rst_n      ,//01   Out
    output                  spi_dact_rst_n       //01   Out

    //************************************************************************************************
    // 2.Parameter and constant define
    //************************************************************************************************
    
    
    
    //************************************************************************************************
    // 3.Register and wire declaration
    //************************************************************************************************
    //------------------------------------------------------------------------------------------------
    // 3.1 the clk wire signal
    //------------------------------------------------------------------------------------------------   
    reg                     spi_valid           ;
    reg                     spi_start_pulse     ; 
    
    //------------------------------------------------------------------------------------------------
    // 3.x the test logic
    //------------------------------------------------------------------------------------------------
    //************************************************************************************************
    // 4.Main code
    //************************************************************************************************

    //------------------------------------------------------------------------------------------------
    // 4.1 the ecc module assignment
    //------------------------------------------------------------------------------------------------    
    always @(negedge sda_in_clk_dly or negedge spi_start_pulse_clr) begin
        if(!spi_start_pulse_clr)
            spi_start_pulse <= 1'b0;
        else if(~ee_wbusy_comb)
            spi_start_pulse <= 1'b1;
    end

    always @(negedge spi_cs_n or negedge spi_start_clr) begin
        if(!spi_start_clr)
            spi_start   <= 1'b0;
        else
            spi_start   <= 1'b1;
    end

    assign spi_start_n = ~spi_start;
    assign spi_valid   = ~spi_cs_n;


    always @(posedge spi_cs_n or negedge spi_wbusy_rst_n) begin
        if(!spi_wbusy_rst_n)
            spi_ee_wbusy    <= 1'b0;
        else if(spi_prog_en)
            spi_ee_wbusy    <= 1'b1;
        else
            spi_ee_wbusy    <= spi_ee_wbusy;
    end


    //************************************************************************************************
    // 5.Sub module instantiation
    //************************************************************************************************
    //------------------------------------------------------------------------------------------------
    // 5.1 the ecc module assignment
    delay_module spi_start_n_dly_inst(
        .dly_i  (spi_start_n        ),
        .dly_o  (spi_start_n_dly    )
    );

endmodule    
//****************************************************************************************************
//End of Module
//****************************************************************************************************
