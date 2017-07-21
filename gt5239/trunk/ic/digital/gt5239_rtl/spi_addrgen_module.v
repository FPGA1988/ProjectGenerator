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
//File Name      : spi_addr_module.v 
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
module spi_addrgen_module(
    spi_clk_c           ,//01   In
    spi_frm_rst_n       ,//01   In
    sda_in              ,//01   In
    spi_ecc_en          ,//01   In
    spi_addr_keep       ,//01   In
    spi_bitcnt_is_0     ,//
    spi_bitcnt_is_1     ,//
    spi_byte_cnt        ,//
    spi_curr_state      ,//
    spi_curr_addr        //

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
    parameter   SPI_ADDR_HB = 3'b001; 
    parameter   SPI_ADDR_LB = 3'b011; 
    parameter   SPI_BYTE_WR = 3'b010; 
    parameter   SPI_PAGE_WR = 3'b110; 
    parameter   SPI_DAT_RD  = 3'b111;
    parameter   SPI_WAIT    = 3'b101;
    parameter   SPI_ERR     = 3'b100;
    
    //************************************************************************************************
    // 3.Register and wire declaration
    //************************************************************************************************
    //------------------------------------------------------------------------------------------------
    // 3.1 the clk wire signal
    //------------------------------------------------------------------------------------------------   
    reg                     spi_sda_out         ;
    wire    [02:00]         spi_sda_out_bit     ; 
    wire    [03:00]         spi_bit_cnt_minus   ;
    reg     [15:00]         spi_curr_addr       ;
    wire                    spi_addr_p1_flag    ;
    
    //------------------------------------------------------------------------------------------------
    // 3.x the test logic
    //------------------------------------------------------------------------------------------------
    //************************************************************************************************
    // 4.Main code
    //************************************************************************************************

    //------------------------------------------------------------------------------------------------
    // 4.1 the ecc module assignment
    //------------------------------------------------------------------------------------------------    

    assign spi_addr_p1_flag = ((spi_curr_state == SPI_BYTE_WR) | (spi_curr_state == SPI_PAGE_WR) | (spi_curr_state == SPI_DAT_RD)) & spi_bitcnt_is_0 & ((~(&spi_byte_cnt[1:0])) | spi_ecc_en) & (~spi_addr_keep);
    assign spi_load_addr    = (spi_curr_state === SPI_ADDR_HB & spi_curr_state === SPI_ADDR_LB);

    
    always @(posedge  spi_clk_c or negedge spi_frm_rst_n) begin
        if(!spi_frm_rst_n)
            spi_curr_addr   <= 'd0  ;
        else if(spi_curr_addr_load)
            if(spi_curr_state == SPI_ADDR_LB & (spi_bitcnt_is_0 | spi_bitcnt_is_1) & (~spi_ecc_en))
                spi_curr_addr   <= {spi_curr_addr[14:0],1'b0};
            else
                spi_curr_addr   <= {spi_curr_addr[14:0],sda_in};
        else if(spi_addr_plus1_cond)
            if(spi_curr_state == SPI_DAT_RD)
                spi_curr_addr   <= spi_curr_addr + 1'b1;
            else
                spi_curr_addr[6:0]  <= spi_curr_addr[6:0] + 1'b1;
        else
            spi_curr_addr   <= spi_curr_addr    ;
    end

    //assign spi_load_addr = (spi_curr_state == SPI_ADDR_HB | spi_curr_state == SPI_ADDR_LB) & (~spi_bitcnt_is_0);

    //************************************************************************************************
    // 5.Sub module instantiation
    //************************************************************************************************
    //------------------------------------------------------------------------------------------------

endmodule    
//****************************************************************************************************
//End of Module
//****************************************************************************************************
