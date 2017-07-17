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
//File Name      : iic_addr_module.v 
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
module iic_addrgen_module(
    iic_clk_c           ,//01   In
    iic_sys_rst_n       ,//01   In
    iic_frm_rst_n       ,//01   In
    sda_in              ,//01   In
    iic_ecc_en          ,//01   In
    iic_addr_keep       ,//01   In
    iic_bitcnt_is_0     ,//
    iic_bitcnt_is_1     ,//
    iic_bitcnt_is_2     ,//
    iic_byte_cnt        ,//
    iic_curr_state      ,//
    iic_rev_addr        ,//
    iic_curr_addr        //

);

    //************************************************************************************************
    // 1.input and output declaration
    //************************************************************************************************
    output                  iic_clk_c           ,//01   Out
    output                  iic_frm_rst_n       ,//01   Out

    //************************************************************************************************
    // 2.Parameter and constant define
    //************************************************************************************************
    parameter   IIC_IDLE    = 3'b000; 
    parameter   IIC_CMD     = 3'b000; 
    parameter   IIC_ADDR_HB = 3'b000; 
    parameter   IIC_ADDR_LB = 3'b000; 
    parameter   IIC_BYTE_WR = 3'b000; 
    parameter   IIC_PAGE_WR = 3'b000; 
    parameter   IIC_DAT_RD  = 3'b100;
    parameter   IIC_WAIT    = 3'b101;
    

    parameter   ACK         = 0     ;
    parameter   NACK        = 1     ;
    
    //************************************************************************************************
    // 3.Register and wire declaration
    //************************************************************************************************
    //------------------------------------------------------------------------------------------------
    // 3.1 the clk wire signal
    //------------------------------------------------------------------------------------------------   
    reg                     iic_sda_out         ;
    wire    [02:00]         iic_sda_out_bit     ; 
    wire    [03:00]         iic_bit_cnt_minus   ;
    
    //------------------------------------------------------------------------------------------------
    // 3.x the test logic
    //------------------------------------------------------------------------------------------------
    //************************************************************************************************
    // 4.Main code
    //************************************************************************************************

    //------------------------------------------------------------------------------------------------
    // 4.1 the ecc module assignment
    //------------------------------------------------------------------------------------------------    

    assign iic_addr_plus1_cond  = ((iic_curr_state == IIC_BYTE_WR) | (iic_curr_state == IIC_PAGE_WR) | (iic_curr_state == IIC_DAT_RD)) & iic_bitcnt_is_0 & ((~(&iic_byte_cnt[1:0])) | iic_ecc_en) & (~iic_addr_keep);
    assign iic_curr_addr_load   = (iic_curr_state === IIC_ADDR_LB & iic_bitcnt_is_0);

    
    always @(posedge  iic_clk_c or negedge iic_sys_rst_n) begin
        if(!iic_sys_rst_n)
            iic_curr_addr   <= 'd0  ;
        else if(iic_curr_addr_load)
            iic_curr_addr   <= iic_rev_addr ;
        else if(iic_addr_plus1_cond)
            if(iic_curr_state == IIC_DAT_RD)
                iic_curr_addr   <= iic_curr_addr + 1'b1;
            else
                iic_curr_addr[6:0]  <= iic_curr_addr[6:0] + 1'b1;
        else
            iic_curr_addr   <= iic_curr_addr    ;
    end

    assign iic_load_addr = (iic_curr_state == IIC_ADDR_HB | iic_curr_state == IIC_ADDR_LB) & (~iic_bitcnt_is_0);

    always @(posedge iic_clk_c or negedge iic_frm_rst_n) begin
        if(!iic_frm_rst_n)
            iic_rev_addr   <= 'd0  ;
        else if(iic_load_addr)
            if(iic_curr_state == IIC_ADDR_LB & (iic_bitcnt_is_1 | iic_bitcnt_is_2) & (~iic_ecc_en))
                iic_rev_addr    <= {iic_rev_addr[14:0],1'b0};
            else
                iic_rev_addr    <= {iic_rev_addr[14:0],sda_in};
        else
            iic_rev_addr   <= iic_rev_addr    ;
    end
    //************************************************************************************************
    // 5.Sub module instantiation
    //************************************************************************************************
    //------------------------------------------------------------------------------------------------

endmodule    
//****************************************************************************************************
//End of Module
//****************************************************************************************************
