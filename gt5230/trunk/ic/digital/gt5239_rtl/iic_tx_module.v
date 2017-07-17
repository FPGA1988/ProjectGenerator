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
//File Name      : iic_tx_module.v 
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
module iic_tx_module(
    iic_clk_c           ,//01   In
    iic_frm_rst_n       ,//01   In
    iic_hwp_val         ,//
    iic_cmd_user_val    ,//
    iic_tcmd_val        ,//
    iic_curr_state      ,//
    iic_bitcnt_is_0     ,//
    iic_usr_dout        ,//
    iic_sda_out          //

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

    assign iic_bit_cnt_minus = iic_bit_cnt - 1'b1;
    assign iic_sda_out_bit   = iic_bit_cnt_minus[2:0];


            iic_curr_state  <= IIC_IDLE ;
        else
            iic_curr_state  <= iic_next_state;
    end
    
    always @(posedge  iic_clk_c or negedge iic_frm_rst_n) begin
        if(!iic_frm_rst_n)
            iic_sda_out <= 1'b1;
        else case(iic_curr_state)
            IIC_CMD         :   begin
                if(iic_bitcnt_is_0) begin
                    if(iic_cmd_user_val | iic_tcmd_val)
                        iic_sda_out <= ACK  ;
                    else
                        iic_sda_out <= NACK ;
            IIC_ADDR_HB     :   begin
                if(iic_bitcnt_is_0)
                    iic_sda_out <= ACK;
                else
                    iic_sda_out <= 1'b1;
            end
            IIC_ADDR_LB     :   begin
                if(iic_bitcnt_is_0)
                    iic_sda_out <= ACK;
                else
                    iic_sda_out <= 1'b1;
            end
            IIC_BYTE_WR,IIC_PAGE_WR :   begin
                if(iic_bitcnt_is_0)
                    if(iic_hwp_val)
                        iic_sda_out <= NACK;
                    else
                        iic_sda_out <= ACK;
                else
                    iic_sda_out <= 1'b1;
            end
            IIC_DAT_RD      :   begin
                if(~iic_bitcnt_is_0)
                    iic_sda_out <= iic_usr_dout[iic_sda_out_bit];
                else
                    iic_sda_out <= ACK;
            end
            default :   
                iic_sda_out <= 1'b1;
        endcase
    end

    //************************************************************************************************
    // 5.Sub module instantiation
    //************************************************************************************************
    //------------------------------------------------------------------------------------------------

endmodule    
//****************************************************************************************************
//End of Module
//****************************************************************************************************
