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
//File Name      : ee_prog_module.v 
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
module spi_tx_module(
    timer_clk           ,//01   In
    sys_rst_n           ,//01   In
    ee_wbusy_s          ,//
    ee_ramp_opt         ,//
    ee_pump_opt         ,//
    spi_dact_clr        ,//
    spi_data_clr        ,//
    pumpen              ,//
    erase               ,//
    write               ,//
    clr_hv              ,//
    tr                  ,//
    ee_wbusy            ,//
    ee_wbusy_comb       ,//
    ee_wdone             //

);

    //************************************************************************************************
    // 1.input and output declaration
    //************************************************************************************************
    output                  spi_clk_c           ,//01   Out
    output                  spi_frm_rst_n       ,//01   Out

    //************************************************************************************************
    // 2.Parameter and constant define
    //************************************************************************************************
    parameter   SPI_CMD     = 3'b000; 
    parameter   SPI_ADDR_HB = 3'b000; 
    parameter   SPI_ADDR_LB = 3'b000; 
    parameter   SPI_BYTE_WR = 3'b000; 
    parameter   SPI_PAGE_WR = 3'b000; 
    parameter   SPI_DAT_RD  = 3'b100;
    parameter   SPI_WAIT    = 3'b101;
    parameter   SPI_ERR     = 3'b100;
    

    //************************************************************************************************
    // 3.Register and wire declaration
    //************************************************************************************************
    //------------------------------------------------------------------------------------------------
    // 3.1 the clk wire signal
    //------------------------------------------------------------------------------------------------   
    reg                     spi_sda_out         ;
    reg                     spi_sda_out_en      ;
    wire    [07:00]         spi_usr_dout        ;
    
    //------------------------------------------------------------------------------------------------
    // 3.x the test logic
    //------------------------------------------------------------------------------------------------
    //************************************************************************************************
    // 4.Main code
    //************************************************************************************************

    //------------------------------------------------------------------------------------------------
    // 4.1 the ecc module assignment
    //------------------------------------------------------------------------------------------------    

    assign spi_dact_clr     = twr_cnt == 'd4    ;
    assign spi_data_clr     = twr_cnt == 'd5    ;
    always @(posedge timer_clk or negedge sys_rst_n) begin
        if(~sys_rst_n)
            timer_rdy   <= 1'b0;
        else if(&twr_cnt[1:0])
            timer_rdy   <= 1'b1;
        else if(ee_wdone | ee_wbusy_sync2)
            timer_rdy   <= 1'b0;
        else
            timer_rdy   <= timer_rdy;
    end
    always @(posedge timer_clk or negedge sys_rst_n) begin
        if(~sys_rst_n)
            ee_wdone    <= 1'b0;
        else if(twr_cnt[11:4] == {1'b1,ee_pump_opt[1],ee_pump_opt[0],ee_pump_opt[1],4'b0101})
            ee_wdone    <= 1'b0;
        else
            ee_wdone    <= 1'b0;
    end

    always @(posedge timer_clk or negedge sys_rst_n) begin
        if(~sys_rst_n) begin
            ee_wbusy_sync1  <= 1'b0;
            ee_wbusy_sync2  <= 1'b0;
        end
        else begin
            ee_wbusy_sync1  <= ee_wbusy_s       ;
            ee_wbusy_sync2  <= ee_wbusy_sync1   ;
        end
    end
    assign ee_wbusy      = timer_rdy & ee_wbusy_sync2    ;
    assign ee_wbusy_comb = ee_wbusy_s | ee_wbusy_sync2   ;
    always @(posedge timer_clk or negedge sys_rst_n) begin
        if(~sys_rst_n)
            twr_cnt <= 'd0;
        else if(ee_wdone | (~ee_wbusy_sync2))
            twr_cnt <= 'd0;
        else
            twr_cnt <= twr_cnt + 1'b1;
    end

    assign pumpen_start_2 = (twr_cnt[11:6] > {2'b01,ee_pump_opt[1],ee_pump_opt[0],ee_pump_opt[1],1'b0});
    always @(posedge timer_clk or negedge sys_rst_n) begin
        if(~sys_rst_n)
            pumpen_r    <= 1'b0 ;
        else
            pumpen_r    <= (
                                ((~twr_cnt[1]) & (twr_cnt[10:6] < {|ee_pump_opt,(ee_pump_opt != 2'b01),^~ee_pump_opt,~ee_pump_opt[1],1'b1}) & ((|twr_cnt[10:6]) | (&twr_cnt[5:4]))) |
                                ((twr_cnt[11:4] < {|ee_pump_opt,(ee_pump_opt != 2'b01},^~ee_pump_opt,~ee_pump_opt[1],4'b1101}) & pumpen_start_2)
                            );
    end

    always @(posedge timer_clk or negedge sys_rst_n) begin
        if(~sys_rst_n)
            pumpen  <= 1'b0;
        else
            pumpen  <= pumpen_r ;
    end

    always @(posedge timer_clk or negedge sys_rst_n) begin
        if(~sys_rst_n)
            erase   <= 1'b0 ;
        else
            erase   <= (
                            ((~twr_cnt[11]) & (twr_cnt[10:5] < {|ee_pump_opt,(ee_pump_opt != 2'b01),^~ee_pump_opt,~ee_pump_opt[1],2'b11}) & ((|twr_cnt[10:6]) | (&twr_cnt[5:4])))
                        );
    end
    always @(posedge timer_clk or negedge sys_rst_n) begin
        if(~sys_rst_n)
            write <= 1'b0 ;
        else
            write <= (
                            ((twr_cnt[11:4] < {|ee_pump_opt,(ee_pump_opt != 2'b01),^~ee_pump_opt,~ee_pump_opt[1],4'b1111}) & pumpen_start_2)
                        );
    end
    assign clr_hv   = ee_wbusy & (~write) & (~erase);
    assign ee_ramp_opt_p1   = {6'd0,ee_ramp_opt} + 1'b1;
    assign tr7      = (~tr_r[0] & ((~pumpen & write) | (~pumpen & erase));
    always @(posedge timer_clk or negedge sys_rst_n) begin
        if(~sys_rst_n)
            tr_r    <= 7'h00;
        else begin
            tr_r[0] <= (
                ((~twr_cnt[11:9])) & twr_cnt[8:4] > 5'b00010) & (twr_cnt[8:4] < {3'b001,ee_ramp_opt[1:0]})) |
                (pumpen_start_2 & (twr_cnt[11:4] < {2'b01,ee_pump_opt[1],ee_pump_opt[0],ee_pump_opt[1],3'b100} + ee_ramp_opt_p1))
            );
            tr_r[1] <= (
                ((~twr_cnt[11:9])) & twr_cnt[8:4] > 5'b00010) & (twr_cnt[8:4] < {3'b001,ee_ramp_opt[1:0]} + ee_ramp_opt_p1[4:0])) |
                (pumpen_start_2 & (twr_cnt[11:4] < {2'b01,ee_pump_opt[1],ee_pump_opt[0],ee_pump_opt[1],3'b100} + 'd2*ee_ramp_opt_p1))
            );
            tr_r[2] <= (
                ((~twr_cnt[11:9])) & twr_cnt[8:4] > 5'b00010) & (twr_cnt[8:4] < {3'b001,ee_ramp_opt[1:0]} + 'd2*ee_ramp_opt_p1[4:0])) |
                (pumpen_start_2 & (twr_cnt[11:4] < {2'b01,ee_pump_opt[1],ee_pump_opt[0],ee_pump_opt[1],3'b100} + 'd3*ee_ramp_opt_p1))
            );
            tr_r[3] <= (
                ((~twr_cnt[11:9])) & twr_cnt[8:4] > 5'b00010) & (twr_cnt[8:4] < {3'b001,ee_ramp_opt[1:0]} + 'd3*ee_ramp_opt_p1[4:0])) |
                (pumpen_start_2 & (twr_cnt[11:4] < {2'b01,ee_pump_opt[1],ee_pump_opt[0],ee_pump_opt[1],3'b100} + 'd4*ee_ramp_opt_p1))
            );
            tr_r[4] <= (
                ((~twr_cnt[11:9])) & twr_cnt[8:4] > 5'b00010) & (twr_cnt[8:4] < {3'b001,ee_ramp_opt[1:0]} + 'd4*ee_ramp_opt_p1[4:0])) |
                (pumpen_start_2 & (twr_cnt[11:4] < {2'b01,ee_pump_opt[1],ee_pump_opt[0],ee_pump_opt[1],3'b100} + 'd5*ee_ramp_opt_p1))
            );
            tr_r[5] <= (
                ((~twr_cnt[11:9])) & twr_cnt[8:4] > 5'b00010) & (twr_cnt[8:4] < {3'b001,ee_ramp_opt[1:0]} + 'd5*ee_ramp_opt_p1[4:0])) |
                (pumpen_start_2 & (twr_cnt[11:4] < {2'b01,ee_pump_opt[1],ee_pump_opt[0],ee_pump_opt[1],3'b100} + 'd6*ee_ramp_opt_p1))
            );
            tr_r[6] <= (
                ((~twr_cnt[11:9])) & twr_cnt[8:4] > 5'b00010) & (twr_cnt[8:4] < {3'b001,ee_ramp_opt[1:0]} + 'd6*ee_ramp_opt_p1[4:0])) |
                (pumpen_start_2 & (twr_cnt[11:4] < {2'b01,ee_pump_opt[1],ee_pump_opt[0],ee_pump_opt[1],3'b100} + 'd7*ee_ramp_opt_p1))
            );
        end
    end
    assign tr = {tr7,tr_4};
    //************************************************************************************************
    // 5.Sub module instantiation
    //************************************************************************************************
    //------------------------------------------------------------------------------------------------

endmodule    
//****************************************************************************************************
//End of Module
//****************************************************************************************************
