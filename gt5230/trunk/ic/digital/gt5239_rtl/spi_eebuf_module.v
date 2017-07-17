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
//File Name      : spi_rx_module.v 
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
module spi_eebuf_module(
    spi_clk_c           ,//01   In
    spi_rst_n           ,//01   In
    spi_frm_rst_n       ,//01   In
    spi_wbusy_rst_n     ,//01   In
    spi_data_rst_n      ,//01   In
    spi_dact_rst_n      ,//01   In
    sda_in              ,//01   In
    spi_ecc_en          ,//01   In
    spi_valid           ,//
    spi_ee_wbusy        ,//01   In
    spi_curr_state      ,//
    spi_bitcnt_is_0     ,//
    spi_bitcnt_is_1     ,//
    spi_bitcnt_is_2     ,//
    spi_bitcnt_is_3     ,//
    spi_bitcnt_is_4     ,//
    spi_bitcnt_is_5     ,//
    spi_bitcnt_is_6     ,//
    spi_bitcnt_is_67    ,//
    spi_bitcnt_is_7     ,//
    spi_byte_cnt        ,//
    spi_curr_addr       ,//
    spi_cmd_wrsr        ,//
    spi_cmd_read        ,//
    spi_tcmd_one_byte   ,//
    spi_tcmd_hv_one_byte,//
    spi_tcmd_even       ,//
    spi_tcmd_odd        ,//
    spi_tcmd_ti_wr      ,//
    spi_tcmd_ti_rd      ,//
    spi_tcmd_test_read  ,//
    spi_tm_wr_wl        ,//
    spi_tm_ecc_bist     ,//
    spi_wr_roll_over    ,//
    spi_rd_en           ,//
    spi_vs_en           ,//
    spi_rdbuf_en        ,//
    spi_cin             ,//
    spi_d_active        ,//
    spi_clr_dl          ,//
    spi_alleven         ,//
    spi_allodd          ,//
    spi_tm_wall         ,//
    spi_tm_hv           ,//
    spi_tc_sel          ,//
    spi_usr_din_o       ,//
    spi_data_in         ,//
    spi_data_out        ,//
    spi_ee_addr          //
);

    //************************************************************************************************
    // 1.input and output declaration
    //************************************************************************************************
    input                   spi_clk_c           ;//01   In
    input                   spi_rst_n           ;//01   In
    input                   spi_frm_rst_n       ;//01   In
    input                   spi_wbusy_rst_n     ;//01   In
    input                   spi_data_rst_n      ;//01   In
    input                   spi_dact_rst_n      ;//01   In
    input                   sda_in              ;//01   In
    input                   spi_ecc_en          ;//01   In
    input                   spi_valid           ;//
    input                   spi_ee_wbusy        ;//01   In
    input    [02:00]        spi_curr_state      ;//
    input                   spi_bitcnt_is_0     ;//
    input                   spi_bitcnt_is_1     ;//
    input                   spi_bitcnt_is_2     ;//
    input                   spi_bitcnt_is_3     ;//
    input                   spi_bitcnt_is_4     ;//
    input                   spi_bitcnt_is_5     ;//
    input                   spi_bitcnt_is_6     ;//
    input                   spi_bitcnt_is_67    ;//
    input                   spi_bitcnt_is_7     ;//
    input    [02:00]        spi_byte_cnt        ;//
    input    [15:00]        spi_curr_addr       ;//
    input                   spi_cmd_wrsr        ;//
    input                   spi_cmd_read        ;//
    input                   spi_tcmd_one_byte   ;//
    input                   spi_tcmd_hv_one_byte;//
    input                   spi_tcmd_even       ;//
    input                   spi_tcmd_odd        ;//
    input                   spi_tcmd_ti_wr      ;//
    input                   spi_tcmd_ti_rd      ;//
    input                   spi_tcmd_test_read  ;//
    input                   spi_tm_wr_wl        ;//
    input                   spi_tm_ecc_bist     ;//
    input                   spi_wr_roll_over    ;//
    input                   spi_rd_en           ;//
    input                   spi_vs_en           ;//
    input                   spi_rdbuf_en        ;//
    input                   spi_cin             ;//
    input                   spi_d_active        ;//
    input                   spi_clr_dl          ;//
    input                   spi_alleven         ;//
    input                   spi_allodd          ;//
    input                   spi_tm_wall         ;//
    input                   spi_tm_hv           ;//
    input                   spi_tc_sel          ;//
    input    [03:00]        spi_usr_din_o       ;// 
    input    [31:00]        spi_data_in         ;//
    input    [31:00]        spi_data_out        ;//
    input    [15:00]        spi_ee_addr         ;//
    //************************************************************************************************
    // 2.Parameter and constant define
    //************************************************************************************************
    parameter   SPI_CMD         = 3'b000; 
    parameter   SPI_ADDR_HB     = 3'b001; 
    parameter   SPI_ADDR_LB     = 3'b011; 
    parameter   SPI_BYTE_WR     = 3'b010; 
    parameter   SPI_PAGE_WR     = 3'b110; 
    parameter   SPI_DAT_RD      = 3'b111;
    parameter   SPI_WAIT        = 3'b101;
    parameter   SPI_ERR         = 3'b100;
    
    
    //************************************************************************************************
    // 3.Register and wire declaration
    //************************************************************************************************
    //------------------------------------------------------------------------------------------------
    // 3.1 the clk wire signal
    //------------------------------------------------------------------------------------------------   
    reg                     spi_rd_en_r         ;//
    reg                     spi_d_active        ;//
    reg                     spi_clr_dl          ;
    reg                     spi_cin             ;
    wire    [31:00]         spi_preread_data    ;
    reg     [37:00]         spi_data_out        ;
    reg     [07:00]         spi_usr_din         ;
    reg     [15:00]         spi_ee_addr         ;
    reg                     spi_alleven         ;
    reg                     spi_allodd          ;
    reg                     spi_tm_wall         ;
    reg                     spi_tm_hv           ;
    reg                     spi_tc_sel          ;
    wire                    spi_wr_state        ;
    reg     [01:00]         spi_byte_addr       ;
    reg     [07:00]         spi_wr_cnt          ;
    reg                     spi_wr_roll_over    ;
    wire                    spi_tcmd_onepage    ;
    wire                    spi_pre_read_n      ;
    wire                    spi_read_cmd        ;
    reg                     sda_in_r            ;
    wire    [07:00]         spi_usr_din_pre     ;
    reg                     spi_preread_state   ;
    
    //------------------------------------------------------------------------------------------------
    // 3.x the test logic
    //------------------------------------------------------------------------------------------------
    //************************************************************************************************
    // 4.Main code
    //************************************************************************************************



    //------------------------------------------------------------------------------------------------
    // 4.1 the ecc module assignment
    //------------------------------------------------------------------------------------------------    
    always @(posedge spi_clk_c or negedge spi_frm_rst_n) begin
        if(!spi_frm_rst_n)
            spi_clr_dl  <= 1'b1 ;
        else if(spi_curr_state == SPI_CMD & (spi_bitcnt_is_5 | spi_bitcnt_is_6) & (~spi_ee_wbusy))
            spi_clr_dl  <= 1'b1 ;
        else
            spi_clr_dl  <= 1'b0 ;
    end
    assign spi_vs_en        = spi_valid & (~spi_clr_dl) & (~spi_ee_wbusy);
    assign spi_tcmd_onepage = spi_tcmd_one_byte | spi_tcmd_hv_one_byte;
    assign spi_pre_read_n   = spi_tm_wr_wl | (~spi_ecc_en & spi_wr_state) | spi_tm_ecc_bist | spi_tcmd_onepage;
    assign spi_read_cmd     = spi_cmd_read | spi_tcmd_ti_rd | spi_tcmd_test_read;

    always @(posedge spi_clk_c or negedge spi_frm_rst_n) begin
        if(!spi_frm_rst_n)
            spi_rd_en_r <= 1'b0;
        else if(spi_pre_read_n)
            spi_rd_en_r <= 1'b0;
        //else if(((spi_bitcnt_is_456 | (spi_bitcnt_is_2 & spi_tc_sel)) & spi_curr_state == spi_CMD) | (((spi_curr_state == spi_DAT_RD & ((spi_ecc_en & (&spi_curr_addr[1:0])) | ((~spi_ecc_en) & spi_byte_cnt == 4))) | spi_curr_state == spi_BYTE_WR | ((~(|spi_curr_addr[1:0])) & spi_curr_state == spi_PAGE_WR)) & spi_bitcnt_is_456))
        else if(((spi_bitcnt_is_1 | spi_bitcnt_is_2) & spi_curr_state == SPI_ADDR_LB & spi_read_cmd) | \
            ((spi_bitcnt_is_3 | spi_bitcnt_is_4) & ((spi_curr_state == SPI_DAT_RD) & ((spi_ecc_en & (&spi_curr_addr[1:0])) | ((~spi_ecc_en) & spi_byte_cnt == 4)))) | \
            ((spi_curr_state == SPI_PAGE_WR & (~(|spi_curr_addr[1:0])) | spi_curr_state == SPI_BYTE_WR) & (spi_bitcnt_is_4 | spi_bitcnt_is_3))) 
            spi_rd_en_r <= 1'b1;
        else
            spi_rd_en_r <= 1'b0;
    end
    assign spi_rd_en    = spi_wr_roll_over ? 1'b0 : spi_rd_en_r ;
    assign spi_rdbuf_en = spi_wr_roll_over ? spi_rd_en_r : 1'b0 ;

    always @(posedge spi_clk_c or negedge spi_sys_rst_n) begin
        if(!spi_sys_rst_n)
            spi_ee_addr <= 'd0;
        else if(spi_cmd_wrsr)
            spi_ee_addr <= {8'hff,8'hf8};
        else if(spi_wr_state & spi_bitcnt_is_5)
            spi_ee_addr <= spi_curr_addr    ;
        else if(spi_curr_state == SPI_ADDR_HB & spi_bitcnt_is_0)
            spi_ee_addr <= {spi_curr_addr[6:0],sda_in,8'd0};
        else if(spi_curr_state == SPI_ADDR_LB & spi_bitcnt_is_0)
            spi_ee_addr <= {spi_curr_addr[12:0],sda_in,2'd0};
        else if(spi_curr_state == SPI_DAT_RD & (&spi_curr_addr[1:0]) & (~spi_ee_wbusy))
                spi_ee_addr <= spi_curr_addr + 1'b1;
        else
            spi_ee_addr <= spi_ee_addr  ;
    end
    
    assign spi_wr_state = (spi_curr_state[1:0] == 2'b10);

    always @(posedge spi_clk_c or negedge spi_frm_rst_n) begin
        if(!spi_frm_rst_n)
            spi_cin <= 1'b1;
        else if((spi_curr_state == SPI_BYTE_WR & spi_bitcnt_is_0) | (spi_curr_state == SPI_PAGE_WR & (spi_bitcnt_is_0 | spi_bitcnt_is_67)) | \
            (spi_curr_state == SPI_CMD & spi_bitcnt_is_7))
            spi_cin <= 1'b0;
        else
            spi_cin <= 1'b1;
    end

    always @(posedge spi_clk_c or negedge spi_frm_rst_n) begin
        if(!spi_frm_rst_n)
            spi_d_active    <= 1'b0;
        else if((spi_curr_state == SPI_BYTE_WR & spi_bitcnt_is_0) | (spi_curr_state == SPI_PAGE_WR & (spi_bitcnt_is_0 | spi_bitcnt_is_7)))
            spi_d_active    <= 1'b1;
        else
            spi_d_active    <= 1'b0;
    end

    always @(posedge spi_clk_c or negedge spi_frm_rst_n) begin
        if(!spi_frm_rst_n)
            spi_wr_cnt  <= 'd0;
        else if(spi_wr_state & spi_bitcnt_is_0)
            if(~spi_wr_cnt[7])
                spi_wr_cnt  <= spi_wr_cnt + 1'b1;
            else if(~spi_wr_cnt[5])
                spi_wr_cnt  <= spi_wr_cnt + 1'b1;
            else
                spi_wr_cnt  <= spi_wr_cnt;
        else
            spi_wr_cnt <= spi_wr_cnt;
    end
    always @(posedge spi_clk_c or negedge spi_frm_rst_n) begin
        if(!spi_frm_rst_n)
            spi_byte_addr  <= 2'b00;
        else if(spi_ecc_en & spi_curr_state == SPI_BYTE_WR & spi_bitcnt_is_6)
            spi_byte_addr  <= spi_curr_addr[1:0];
        else
            spi_byte_addr  <= spi_byte_addr;
    end

    always @(posedge spi_clk_c or negedge spi_frm_rst_n) begin
        if(!spi_frm_rst_n)
            spi_wr_roll_over    <= 1'b0;
        else if(spi_ecc_en)
            case(spi_rev_addr[1:0])
                2'b00   :   spi_wr_roll_over    <= (spi_wr_cnt >= 'd127)    ;
                2'b01   :   spi_wr_roll_over    <= (spi_wr_cnt >= 'd126)    ;
                2'b10   :   spi_wr_roll_over    <= (spi_wr_cnt >= 'd125)    ;
                2'b11   :   spi_wr_roll_over    <= (spi_wr_cnt >= 'd124)    ;
            endcase
        else
            2'b11   :   spi_wr_roll_over    <= (spi_wr_cnt == 'd160)    ;
    end

    always @(posedge spi_clk_c or negedge spi_frm_rst_n) begin
        if(!spi_frm_rst_n)
            spi_preread_state   <= 1'b0;
        else if(spi_bitcnt_is_0)
            spi_preread_state   <= 1'b0;
        else if(spi_rd_en_r & (spi_wr_state | spi_curr_state == SPI_ADDR_LB))
            spi_preread_state   <= 1'b1;
        else
            spi_preread_state   <= spi_preread_state;
    end

    assign spi_preread_data = spi_data_in[31:0];

    always @(posedge spi_clk_c or negedge spi_frm_rst_n) begin
        if(!spi_frm_rst_n)
            sda_in_r    <= 1'b0;
        else
            sda_in_r    <= sda_in;
    end

    always @(posedge spi_clk_c or negedge spi_frm_rst_n) begin
        if(!spi_frm_rst_n)
            spi_usr_din <= 'hff;
        else if(spi_curr_state == SPI_BYTE_WR)
            spi_usr_din <= {spi_usr_din[6:0],sda_in};
        else if(spi_curr_state == SPI_PAGE_WR)
            if(spi_bitcnt_is_7)
                spi_usr_din <= spi_usr_din  ;
            else if(spi_bitcnt_is_6)
                spi_usr_din <= {spi_usr_din[5:0],sda_in_r,sda_in};
            else
                spi_usr_din <= {spi_usr_din[6:0],sda_in};
        else
            spi_usr_din <= spi_usr_din  ;
    end

    assign spi_usr_din_pre = {spi_usr_din[6:0],sda_in};
    assign spi_usr_din_o   = {spi_usr_din_o[7],spi_usr_din[4:2]};

    always @(posedge spi_clk_c or negedge spi_frm_rst_n) begin
        if(!spi_frm_rst_n)
            spi_data_out    <= 38'h3f_ffff_ffff ;
        else if(spi_cmd_wrsr)
            spi_data_out    <= {6'd0,24'hffffff,spi_usr_din_pre};
        else if((spi_tcmd_one_byte | spi_tcmd_hv_one_byte) & spi_wr_state & spi_bitcnt_is_0)
            spi_data_out    <= {spi_usr_din_pre[5:0],{4{spi_usr_din_pre[7:0]}}};
        else if(spi_wr_state & spi_bitcnt_is_0)
            case(spi_byte_cnt)
                'd0 :   begin
                    if(spi_preread_state)
                        spi_data_out <= {6'd0,spi_preread_data[31:8],spi_usr_din_pre[7:0]};
                    else
                        spi_data_out <= {6'd0,spi_data_out[31:8],spi_usr_din_pre[7:0]};
                end
                'd1 :   begin
                    if(spi_preread_state)
                        spi_data_out <= {6'd0,spi_preread_data[31:16],spi_usr_din_pre[7:0],spi_preread_data[7:0]};
                    else
                        spi_data_out <= {6'd0,spi_data_out[31:16],spi_usr_din_pre[7:0],spi_data_out[7:0]};
                end
                'd2 :   begin
                    if(spi_preread_state)
                        spi_data_out <= {6'd0,spi_preread_data[31:24],spi_usr_din_pre[7:0],spi_preread_data[15:0]};
                    else
                        spi_data_out <= {6'd0,spi_data_out[31:24],spi_usr_din_pre[7:0],spi_data_out[15:0]};
                end
                'd3 :   begin
                    if(spi_preread_state)
                        spi_data_out <= {6'd0,spi_usr_din_pre[7:0],spi_preread_data[23:0]};
                    else
                        spi_data_out <= {6'd0,spi_usr_din_pre[7:0],spi_data_out[23:0]};
                end
                'd4 :   begin
                    spi_data_out <= {spi_usr_din_pre[5:0],spi_data_out[31:0]};
                end
                default:;
            endcase
        else
            spi_data_out <= spi_data_out    ;
    end


    always @(posedge spi_clk_c or negedge spi_wbusy_rst_n) begin
        if(!spi_wbusy_rst_n) begin
            spi_alleven     <= 1'b0;
            spi_allodd      <= 1'b0;
            spi_tm_wall     <= 1'b0;
            spi_tm_hv       <= 1'b0;
            spi_tc_sel      <= 1'b0;
        end
        else if(~spi_ee_wbusy) begin
            spi_alleven     <= spi_tcmd_even;
            spi_allodd      <= spi_tcmd_odd;
            spi_tm_wall     <= spi_tcmd_one_byte | spi_tcmd_hv_one_byte;
            spi_tm_hv       <= spi_tcmd_hv_one_byte;
            spi_tc_sel      <= spi_cmd_wrsr | spi_tcmd_ti_wr;
        end
        else begin
            spi_alleven     <= spi_alleven;
            spi_allodd      <= spi_allodd ;
            spi_tm_wall     <= spi_tm_wall;
            spi_tm_hv       <= spi_tm_hv  ;
            spi_tc_sel      <= spi_tc_sel ;
        end
    end

    //************************************************************************************************
    // 5.Sub module instantiation
    //************************************************************************************************
    //------------------------------------------------------------------------------------------------

endmodule    
//****************************************************************************************************
//End of Module
//****************************************************************************************************
