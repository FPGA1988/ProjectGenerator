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
//File Name      : por_cfg_module.v 
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
module por_cfg_module(
    timer_clk           ,//01   In
    por_cfg_clk         ,//01   In
    por_rst_n           ,//01   In
    test_en             ,//01   In
    spi_en_s            ,//01   In
    spi_en_s_val        ,//01   In
    por_rd_en           ,//01   In
    por_vs_en           ,//01   In
    por_ee_addr         ,//16   In
    por_ee_data_e2l     ,//32   In
    por_tc_sel          ,//01   Out
    por_clr_dl          ,//01   Out
    por_cfg_done        ,//01   Out
    por_cfg_done_r      ,//01   Out
    iic_opt_reg_wr      ,//01   In
    iic_opt_reg_wdata   ,//16   In
    por_spi_sr          ,//04   Out
    por_reg_set         ,//01   Out
    spien_bit           ,//01   Out
    trm_op              ,//02   Out
    ee_op                //14   Out
);

    //************************************************************************************************
    // 1.input and output declaration
    //************************************************************************************************
    input                   timer_clk           ;//01   In
    input                   por_cfg_clk         ;//01   In
    input                   por_rst_n           ;//01   In
    input                   test_en             ;//01   In
    input                   spi_en_s            ;//01   In
    input                   spi_en_s_val        ;//01   In
    output                  por_rd_en           ;//01   In
    output                  por_vs_en           ;//01   In
    output  [15:00]         por_ee_addr         ;//16   In
    input   [31:00]         por_ee_data_e2l     ;//32   In
    output                  por_tc_sel          ;//01   Out
    output                  por_clr_dl          ;//01   Out
    output                  por_cfg_done        ;//01   Out
    output                  por_cfg_done_r      ;//01   Out
    input   [01:00]         iic_opt_reg_wr      ;//01   In
    input   [07:00]         iic_opt_reg_wdata   ;//16   In
    output  [03:00]         por_spi_sr          ;//04   Out
    output                  por_reg_set         ;//01   Out
    output                  spien_bit           ;//01   Out
    output  [01:00]         trm_op              ;//02   Out
    output  [10:00]         ee_op               ;//14   Out

    //************************************************************************************************
    // 2.Parameter and constant define
    //************************************************************************************************
    parameter   POR_IDLE        = 4'b0000   ;
    parameter   POR_NUM_CHECK_1 = 4'b0001   ;
    parameter   POR_NUM_CHECK_2 = 4'b0010   ;
    parameter   POR_NUM_CHECK_3 = 4'b0110   ;
    parameter   POR_NUM_CHECK_4 = 4'b0101   ;
    parameter   POR_RD_STATUS_1 = 4'b0111   ;
    parameter   POR_RD_STATUS_2 = 4'b0011   ;
    parameter   POR_RD_STATUS_3 = 4'b1011   ;
    parameter   POR_RD_TCODE_1  = 4'b1010   ;
    parameter   POR_RD_TCODE_2  = 4'b1000   ;
    parameter   POR_RD_TCODE_3  = 4'b1001   ;
    parameter   POR_RD_TCODE_4  = 4'b1101   ;
    parameter   POR_TEST_DET    = 4'b0100   ;
    parameter   POR_MODE_DET    = 4'b1100   ;
    parameter   POR_IF_SETUP    = 4'b1110   ;
    parameter   POR_CONFIG_DONE = 4'b1111   ;
    

    parameter   PRE_DEF_NUM     = 32'h3111_1511 ;
    //************************************************************************************************
    // 3.Register and wire declaration
    //************************************************************************************************
    //------------------------------------------------------------------------------------------------
    // 3.1 the clk wire signal
    //------------------------------------------------------------------------------------------------   
    reg                     spien_bit       ;
    reg                     por_rd_en       ;
    reg                     por_vs_en       ;
    reg                     por_clr_dl      ;
    reg                     por_tc_sel      ;
    reg     [01:00]         por_addr_low    ;
    reg     [01:00]         tmr_op          ;
    reg     [10:00]         ee_op           ;
    reg                     por_cfg_done    ;
    reg                     por_cfg_done_r1 ;
    reg                     por_cfg_done_r2 ;
    reg     [03:00]         por_spi_sr      ;
    reg                     por_reg_set     ;
    reg     [03:00]         por_cfg_state   ;
    reg     [03:00]         por_cfg_cnt     ;
    reg     [01:00]         por_test_en_r   ;
    reg     [01:00]         spi_en_s_r      ;
    reg     [01:00]         spi_en_s_val_r  ;



    //------------------------------------------------------------------------------------------------
    // 3.x the test logic
    //------------------------------------------------------------------------------------------------
    //************************************************************************************************
    // 4.Main code
    //************************************************************************************************

    //------------------------------------------------------------------------------------------------
    // 4.1 the register cross clock domain
    //------------------------------------------------------------------------------------------------    
    
    always @(posedge timer_clk or negedge por_rst_n) begin
        if(!por_rst_n)
            por_test_en_r   <= 2'b00;
        else
            por_test_en_r   <= {por_test_en_r[0],test_en};
    end
    always @(posedge timer_clk or negedge por_rst_n) begin
        if(!por_rst_n)
            spi_en_s_r  <= 2'b00;
        else
            spi_en_s_r  <= {spi_en_s_r[0],spi_en_s};
    end
    always @(posedge timer_clk or negedge por_rst_n) begin
        if(!por_rst_n)
            spi_en_s_val_r  <= 2'b00;
        else
            spi_en_s_val_r  <= {spi_en_s_val_r[0],spi_en_s_val};
    end

    //------------------------------------------------------------------------------------------------
    // 4.2 the por flow state machine logic
    //------------------------------------------------------------------------------------------------    
    always @(posedge timer_clk or negedge por_rst_n) begin
        if(!por_rst_n) begin
            por_vs_en       <= 1'b0;
            por_rd_en       <= 1'b0;
            por_tc_sel      <= 1'b0;
            por_clr_dl      <= 1'b0;
            por_addr_low    <= 2'b00;
            por_cfg_cnt     <=  'd0;
            por_cfg_done    <= 1'b0;
            por_spi_sr      <=  'd0;
            por_reg_set     <= 1'b0;
            por_cfg_state   <= POR_IDLE;
        end
        else case(por_cfg_state)
            POR_IDLE    :   begin
                por_vs_en       <= 1'b0;
                por_rd_en       <= 1'b0;
                por_tc_sel      <= 1'b0;
                por_clr_dl      <= 1'b0;
                por_addr_low    <= 2'b00;
                por_cfg_cnt     <=  'd0;
                por_cfg_done    <= 1'b0;
                por_spi_sr      <=  'd0;
                por_reg_set     <= 1'b0;
                if(&por_cfg_cnt[3:0]) begin
                    por_clr_dl      <= 1'b0;
                    por_cfg_cnt     <=  'd0;
                    por_cfg_state   <= POR_NUM_CHECK_1;
                end
                else begin
                    por_clr_dl      <= 1'b1;
                    por_cfg_cnt     <= por_cfg_cnt + 1'b1;
                    por_cfg_state   <= POR_IDLE;
                end
            end
            POR_NUM_CHECK_1 :   begin
                por_vs_en       <= 1'b1;
                por_tc_sel      <= 1'b1;
                por_clr_dl      <= 1'b0;
                por_addr_low    <= 2'b01;
                por_cfg_state   <= POR_NUM_CHECK_2;
            end
            POR_NUM_CHECK_2 :   begin
                por_rd_en   <= 1'b1;
                if(&por_cfg_cnt[3:0]) begin
                    por_cfg_cnt     <=  'd0;
                    por_cfg_state   <= POR_NUM_CHECK_3;
                end
                else begin
                    por_cfg_cnt     <= por_cfg_cnt + 1'b1;
                    por_cfg_state   <= POR_NUM_CHECK_2;
                end
            end
            POR_NUM_CHECK_3 :   begin
                por_rd_en       <= 1'b0;
                por_cfg_state   <= POR_NUM_CHECK_4;
            end
            POR_NUM_CHECK_4 :   begin
                if(por_ee_data_e2l == PRE_DEF_NUM) begin
                    por_addr_low    <= 2'b10;
                    por_cfg_state   <= POR_RD_STATUS_1;
                end
                else begin
                    por_addr_low    <= 2'b01;
                    por_cfg_state   <= POR_TEST_DET;
                end
            end
            POR_TEST_DET    :   begin
                if(por_test_en_r[1])
                    por_cfg_state   <= POR_MODE_DET;
                else
                    por_cfg_state   <= POR_NUM_CHECK_2;
            end
            POR_MODE_DET    : begin
                if(spi_en_s_val_r[1])
                    por_cfg_state   <= POR_IF_SETUP;
                else
                    por_cfg_state   <= POR_MODE_DET;
            end
            POR_IF_SETUP    :   begin
                por_cfg_state   <= POR_CONFIG_DONE;
            end
            POR_RD_STATUS_1 :   begin
                por_rd_en   <= 1'b1;
                if(&por_cfg_cnt[3:0]) begin
                    por_cfg_cnt     <=  'd0;
                    por_cfg_state   <= POR_RD_STATUS_2;
                end
                else begin
                    por_cfg_cnt     <= por_cfg_cnt + 1'b1;
                    por_cfg_state   <= POR_RD_STATUS_1;
                end
            end
            POR_RD_STATUS_2 : begin
                por_rd_en       <= 1'b0;
                por_cfg_state   <= POR_RD_STATUS_3;
            end
            POR_RD_STATUS_3 :   begin
                por_rd_en       <= 1'b0;
                por_spi_sr      <= {por_ee_data_e2l[7],por_ee_data_e2l[4:2]};
                por_addr_low    <= 2'b11;
                por_cfg_state   <= POR_RD_TCODE_1;
            end
            POR_RD_TCODE_1  :   begin
                por_rd_en   <= 1'b1;
                if(&por_cfg_cnt[3:0]) begin
                    por_cfg_cnt     <=  'd0;
                    por_cfg_state   <= POR_RD_TCODE_2;
                end
                else begin
                    por_cfg_cnt     <= por_cfg_cnt + 1'b1;
                    por_cfg_state   <= POR_RD_TCODE_1;
                end
            end
            POR_RD_TCODE_2  :   begin
                por_rd_en       <= 1'b1;
                por_reg_set     <= 1'b0;
                por_cfg_done    <= 1'b0;
                por_cfg_state   <=POR_RD_TCODE_3;
            end
            POR_RD_TCODE_3  :   begin
                por_rd_en       <= 1'b0;
                por_addr_low    <= 2'b11;
                por_reg_set     <= 1'b0;
                por_cfg_done    <= 1'b1;
                por_cfg_state   <=POR_RD_TCODE_4;
            end
            POR_RD_TCODE_4  :   begin
                por_rd_en       <= 1'b0;
                por_addr_low    <= 2'b11;
                por_reg_set     <= 1'b1;
                por_cfg_done    <= 1'b1;
                por_cfg_state   <= POR_CONFIG_DONE;
            end
            POR_CONFIG_DONE :   begin
                por_rd_en       <= 1'b0;
                por_tc_sel      <= 1'b0;
                por_reg_set     <= 1'b0;
                por_cfg_done    <= 1'b1;
                por_cfg_state   <= POR_CONFIG_DONE;
            end
            default:;
        endcase
    end
            
    always @(posedge timer_clk or negedge por_rst_n) begin
        if(!por_rst_n) begin
            por_cfg_done_r1 <= 1'b0;
            por_cfg_done_r2 <= 1'b0;
        end
        else begin
            por_cfg_done_r1 <= por_cfg_done;
            por_cfg_done_r2 <= por_cfg_done_r1;
        end
    end
    assign por_cfg_done_r   = por_cfg_done_r2;
    assign por_ee_addr      = {12'hfff,por_addr_low,2'b00};

    always @(posedge por_cfg_clk or negedge por_rst_n) begin
        if(!por_rst_n) begin
            tmr_op[1:0] <= 2'h3;
            ee_op[10:0] <= 10'h11f;
        end
        else if(por_cfg_state == POR_RD_TCODE_3) begin
            tmr_op[1:0] <= por_ee_data_e2l[1:0];
            ee_op[10:0] <= por_ee_data_e2l[12:2];
        end
        else if(iic_opt_reg_wr[0]) begin
            tmr_op[1:0] <= iic_opt_reg_wdata[1:0];
            ee_op[5:0]  <= iic_opt_reg_wdata[7:2];
        end
        else if(iic_opt_reg_wr[1])
            ee_op[10:6]  <= iic_opt_reg_wdata[4:0];
        else begin
            tmr_op[1:0] <= tmr_op[1:0];
            ee_op[10:0] <= ee_op[10:0];
        end
    end

    always @(posedge timer_clk or negedge por_rst_n) begin
        if(!por_rst_n)
            spien_bit   <= 1'b0;
        else if(por_cfg_state == POR_IF_SETUP)
            spien_bit   <= spi_en_s_r[1];
        else if(por_cfg_state == POR_RD_TCODE_3)
            spien_bit   <= |por_ee_data_e2l[25:24];
        else
            spien_bit   <= spien_bit;
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
