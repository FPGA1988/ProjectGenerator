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
//File Name      : iic_valdet_module.v 
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
module iic_valdet_module(
    iic_clk_s           ,//01   In
    iic_clk_c           ,//01   In
    sda_in_clk          ,//01   In
    iic_rst_n           ,//01   In
    iic_sys_rst_n       ,//01   In
    iic_wbusy_rst_n     ,//01   In
    scl_in_data         ,//01   In
    sda_in              ,//01   In
    iic_prog_en         ,//01   In
    iic_bitcnt_is_0     ,//01   In
    iic_cmd_reg         ,//08   In
    iic_sw_rst_n_dly    ,//01   Out
    iic_start_rising_r  ,//01   In
    iic_start_pulse_clr ,//01   Out
    iic_sw_rst_n_dly    ,//01   In
    iic_start_clr       ,//01   Out
    iic_valid           ,//01   In
    iic_start_pulse     ,//01   In
    iic_test_disable    ,//01
    ee_wbusy_comb       ,//01
    iic_ee_wbusy        ,//01
    iic_sw_rst_n         //01   In
);

    //************************************************************************************************
    // 1.input and output declaration
    //************************************************************************************************
    input                   sclk_iic            ,//01   In
    input                   sclk_spi            ,//01   In
    input                   timer_clk           ,//01   In
    input                   test_en             ,//01   In
    input                   spi_en              ,//01   In
    input                   spi_cs_n            ,//01   In
    input                   por_rst_n           ,//01   In
    output                  timer_en            ,//01   Out
    input                   ee_wbusy_comb       ,//01   In
    input                   ee_wdone            ,//01   In
    input                   por_cfg_done        ,//01   In
    input                   por_cfg_done_r      ,//01   In
    input                   spi_start_n_dly     ,//01   In
    input                   spi_dact_clr        ,//01   In
    input                   spi_data_clr        ,//01   In
    output                  iic_clk_s           ,//01   Out
    output                  por_cfg_clk         ,//01   Out
    output                  mode_cfg_clk        ,//01   Out
    output                  iic_rst_n           ,//01   Out
    output                  spi_rst_n           ,//01   Out
    input                   iic_sw_rst_n        ,//01   In
    input                   iic_valid           ,//01   In
    input                   iic_start_pulse     ,//01   In
    input                   scl_in_data         ,//01   In
    input                   iic_sw_rst_n_dly    ,//01   In
    input                   iic_start_rising_r  ,//01   In
    output                  iic_clk_c           ,//01   Out
    output                  iic_sys_rst_n       ,//01   Out
    output                  iic_frm_rst_n       ,//01   Out
    output                  iic_wbusy_rst_n     ,//01   Out 
    output                  iic_start_pulse_clr ,//01   Out
    output                  iic_sw_rst_clr      ,//01   Out
    output                  iic_start_clr       ,//01   Out
    output                  iic_ext_rst_n       ,//01   Out
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
    reg                     iic_valid           ;
    reg                     iic_start_pulse     ; 
    
    //------------------------------------------------------------------------------------------------
    // 3.x the test logic
    //------------------------------------------------------------------------------------------------
    //************************************************************************************************
    // 4.Main code
    //************************************************************************************************

    //------------------------------------------------------------------------------------------------
    // 4.1 the ecc module assignment
    //------------------------------------------------------------------------------------------------    
    always @(negedge sda_in_clk_dly or negedge iic_start_pulse_clr) begin
        if(!iic_start_pulse_clr)
            iic_start_pulse <= 1'b0;
        else if(~ee_wbusy_comb)
            iic_start_pulse <= 1'b1;
    end

    always @(negedge sda_in_clk_dly or posedge iic_start_pulse or negedge iic_sys_rst_n) begin
        if(!iic_sys_rst_n)
            iic_valid   <= 1'b0;
        else if(iic_start_pulse)
            iic_valid   <= 1'b1;
        else if(scl_in_data)
            iic_valid   <= 1'b0;
        else
            iic_valid   <= iic_valid;
    end

    always @(negedge sda_in_clk_dly or negedge iic_start_clr) begin
        if(!iic_start_clr)
            iic_start   <= 1'b0;
        else if(scl_in_data)
            iic_start   <= 1'b1;
    end


    always @(negedge iic_clk_s or negedge iic_sys_rst_n) begin
        if(!iic_sys_rst_n) begin
            iic_start_r1    <= 1'b0;
            iic_start_r2    <= 1'b0;
        end
        else begin
            iic_start_r1    <= iic_start;
            iic_start_r2    <= iic_start_r1;
        end
    end

    assign iic_start_rising = (~iic_start_r2) & iic_start_r1;
    assign iic_test_disable = iic_start_rising & sda_in;

    always @(negedge iic_clk_s or negedge iic_sys_rst_n) begin
        if(!iic_sys_rst_n) begin
            iic_start_rising_r  <= 1'b0;
        end
        else begin
            iic_start_rising_r  <= iic_start_rising;
        end
    end
    
    always @(negedge iic_clk_c or negedge iic_rst_n) begin
        if(!iic_rst_n) begin
            sw_rst_pre  <= 1'b0;
        end
        else if(sw_rst_pre) begin
            sw_rst_pre  <= 1'b0;
        end
        else if(&iic_cmd_reg) & iic_bitcnt_is_0 & sda_in) begin
            sw_rst_pre  <= 1'b1;
        end
    end
    always @(negedge iic_clk_c or negedge iic_rst_n) begin
        if(!iic_rst_n) begin
            sw_rst_pre_r1  <= 1'b0;
            sw_rst_pre_r2  <= 1'b0;
        end
        else begin
            sw_rst_pre_r1  <= sw_rst_pre;
            sw_rst_pre_r2  <= sw_rst_pre_r1;
        end
    end

    always @(posedge sda_in_clk_dly or negedge iic_sw_rst_clr) begin
        if(!iic_sw_rst_clr)
            iic_sw_rst  <= 1'b0;
        else if(scl_in_data & iic_start_rising_r & sw_rst_pre_r2)
            iic_sw_rst  <= 1'b1;
    end

    assign iic_sw_rst_n = ~iic_sw_rst   ;

    //************************************************************************************************
    // 5.Sub module instantiation
    //************************************************************************************************
    //------------------------------------------------------------------------------------------------
    // 5.1 the ecc module assignment
    delay_module iic_sw_rst_dly_inst(
        .dly_i  (iic_sw_rst_n       ),
        .dly_o  (iic_sw_rst_n_dly   )
    );
    delay_module iic_sda_in_clk_dly_inst(
        .dly_i  (sda_in_clk         ),
        .dly_o  (sda_in_clk_dly     )
    );

endmodule    
//****************************************************************************************************
//End of Module
//****************************************************************************************************
