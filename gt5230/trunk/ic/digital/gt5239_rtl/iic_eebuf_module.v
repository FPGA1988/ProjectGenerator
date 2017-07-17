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
//File Name      : iic_rx_module.v 
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
module iic_eebuf_module(
    iic_clk_c           ,//01   In
    iic_sys_rst_n       ,//01   In
    iic_frm_rst_n       ,//01   In
    iic_ext_rst_n       ,//01   In
    wp                  ,//01   In
    sda_in              ,//01   In
    test_en             ,//01   In
    iic_valid           ,//
    iic_cmd_user_val    ,//
    iic_tcmd_val        ,//
    iic_ecc_en          ,//
    iic_curr_addr       ,//
    iic_curr_state      ,//
    iic_bit_cnt         ,//
    iic_bitcnt_is_0     ,//
    iic_bitcnt_is_1     ,//
    iic_bitcnt_is_2     ,//
    iic_bitcnt_is_456   ,//
    iic_bitcnt_is_7     ,//
    iic_bitcnt_is_8     ,//
    iic_hwp_val         ,//
    iic_prog_en         ,//
    iic_byte_cnt        ,//
    iic_addr_keep       ,//
    iic_cmd_reg         ,//
    //
    iic_rd_en           ,//
    iic_vs_en           ,//
    iic_rdbuf_en        ,//
    iic_cin             ,//
    iic_d_active        ,//
    iic_clr_dl          ,//
    iic_alleven         ,//
    iic_allodd          ,//
    iic_tm_wall         ,//
    iic_tm_icell        ,//
    iic_tm_iref         ,//
    iic_tm_extiref      ,//
    iic_tm_hv           ,//
    iic_bit_sel         ,//
    iic_tc_sel          ,//
    iic_usr_dout        ,//
    iic_usr_dout        ,//
    iic_ee_addr          //




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
    parameter   IIC_IDLE    = 3'b000; 
    parameter   IIC_CMD     = 3'b000; 
    parameter   IIC_ADDR_HB = 3'b000; 
    parameter   IIC_ADDR_LB    = 3'b000; 
    parameter   IIC_BYTE_WR    = 3'b000; 
    parameter   IIC_PAGE_WR    = 3'b000; 
    parameter   IIC_DAT_RD  = 3'b100;
    parameter   IIC_WAIT    = 3'b101
    
    
    //************************************************************************************************
    // 3.Register and wire declaration
    //************************************************************************************************
    //------------------------------------------------------------------------------------------------
    // 3.1 the clk wire signal
    //------------------------------------------------------------------------------------------------   
    reg                     iic_rd_en_r         ;//
    reg                     iic_d_active        ;//
    reg                     iic_cin             ;
    reg                     iic_clr_dl          ;
    
    reg     [07:00]         iic_usr_din         ;
    reg                     iic_preread_state   ;
    wire    [31:00]         iic_preread_data    ;
    wire                    iic_wr_state        ;
    wire                    iic_pre_read_n      ;
    reg     [07:00]         iic_wr_cnt          ;
    reg                     iic_wr_roll_over    ;
    wire                    iic_tm_write_reg    ;
    
    //------------------------------------------------------------------------------------------------
    // 3.x the test logic
    //------------------------------------------------------------------------------------------------
    //************************************************************************************************
    // 4.Main code
    //************************************************************************************************



    //------------------------------------------------------------------------------------------------
    // 4.1 the ecc module assignment
    //------------------------------------------------------------------------------------------------    
    always @(posedge iic_clk_c or negedge iic_frm_rst_n) begin
        if(!iic_frm_rst_n)
            iic_clr_dl  <= 1'b1 ;
        else if(iic_curr_state == IIC_IDLE)
            iic_clr_dl  <= 1'b1 ;
        else
            iic_clr_dl  <= 1'b0 ;
    end
    assign iic_vs_en        = iic_valid ;
    assign iic_pre_read_n   = iic_tm_wr_wl | (~iic_ecc_en & iic_wr_state) | iic_tm_ecc_bist | iic_tm_onepage;

    always @(posedge iic_clk_c or negedge iic_frm_rst_n) begin
        if(!iic_frm_rst_n)
            iic_rd_en_r <= 1'b0;
        else if(iic_pre_read_n)
            iic_rd_en_r <= 1'b0;
        else if(((iic_bitcnt_is_456 | (iic_bitcnt_is_2 & iic_tc_sel)) & iic_curr_state == IIC_CMD) | (((iic_curr_state == IIC_DAT_RD & ((iic_ecc_en & (&iic_curr_addr[1:0])) | ((~iic_ecc_en) & iic_byte_cnt == 4))) | iic_curr_state == IIC_BYTE_WR | ((~(|iic_curr_addr[1:0])) & iic_curr_state == IIC_PAGE_WR)) & iic_bitcnt_is_456))
            iic_rd_en_r <= 1'b1;
        else
            iic_rd_en_r <= 1'b0;
    end
    assign iic_rd_en    = iic_wr_roll_over ? 1'b0 : iic_rd_en_r ;
    assign iic_rdbuf_en = iic_wr_roll_over ? iic_rd_en_r : 1'b0 ;

    always @(posedge iic_clk_c or negedge iic_sys_rst_n) begin
        if(!iic_sys_rst_n)
            iic_ee_addr <= 'd0;
        else if(iic_wr_state)
            if(iic_curr_state[2])
                iic_ee_addr <= iic_rev_addr ;
            else if(iic_bitcnt_is_7)
                iic_ee_addr <= iic_curr_addr    ;
            else
                iic_ee_addr <= iic_ee_addr  ;
        else if(iic_curr_state ==  IIC_CMD)
            iic_ee_addr <= iic_curr_addr    ;
        else if(iic_curr_state == IIC_DAT_RD) begin
            if(iic_ecc_en & (&iic_curr_addr[1:0]))
                iic_ee_addr <= iic_curr_addr + 1'b1;
            else if(~iic_ecc_en & iic_byte_cnt[2])
                if(iic_tcmd_current | iic_tcmd_ti_current)
                    if(iic_bitcnt_is_1)
                        iic_ee_addr[15:2] <= iic_ee_addr[15:2] + 1'b1;
                    else
                        iic_ee_addr[15:2] <= iic_ee_addr[15:2];
                else if(iic_bitcnt_is_7)
                    iic_ee_addr[15:2] <= iic_ee_addr[15:2] + 1'b1;
                else
                    iic_ee_addr[15:2] <= iic_ee_addr[15:2];
            else
                iic_ee_addr <= iic_ee_addr  ;
        end
        else
            iic_ee_addr <= iic_ee_addr  ;
    end
    
    assign iic_wr_state = (iic_curr_state == IIC_BYTE_WR | iic_curr_state == IIC_PAGE_WR);

    always @(posedge iic_clk_c or negedge iic_frm_rst_n) begin
        if(!iic_frm_rst_n)
            iic_cin <= 1'b1;
        else if(iic_wr_state & (iic_bitcnt_is_0 | iic_bitcnt_is_1 | iic_bitcnt_is_2) & (~iic_tm_write_reg))  
            iic_cin <= 1'b0;
        else
            iic_cin <= 1'b1;
    end

    always @(posedge iic_clk_c or negedge iic_frm_rst_n) begin
        if(!iic_frm_rst_n)
            iic_tc_sel  <= 1'b0;
        else if(iic_tcmd_ti_wr | iic_tcmd_ti_current)
            iic_tc_sel  <= 1'b1;
        else
            iic_tc_sel  <= 1'b0;
    end

    always @(posedge iic_clk_c or negedge iic_frm_rst_n) begin
        if(!iic_frm_rst_n)
            iic_bit_sel <= 'd0;
        else if(iic_tm_icell & iic_curr_state ==  IIC_DAT_RD & (~iic_bitcnt_is_0))
            if(iic_bit_sel == 'd39)
                iic_bit_sel <= 'd0;
            else
                iic_bit_sel <= iic_bit_sel + 1'b1;
        else
            iic_bit_sel <= iic_bit_sel ;
    end

    always @(posedge iic_clk_c or negedge iic_frm_rst_n) begin
        if(!iic_frm_rst_n)
            iic_usr_din <= 'hff;
        else if(iic_wr_state & (~iic_bitcnt_is_0))
            iic_usr_din <= {iic_usr_din[6:0],sda_in};
        else
            iic_usr_din <= iic_usr_din  ;
    end

    assign iic_tm_write_reg = iic_tcmd_optcode_we | iic_tm_ecc_bist ;
    always @(posedge iic_clk_c or negedge iic_frm_rst_n) begin
        if(!iic_frm_rst_n)
            iic_d_active    <= 1'b0;
        else if(iic_wr_state & (iic_bitcnt_is_1) & (~iic_tm_write_reg))
            iic_d_active    <= 1'b1;
        else
            iic_d_active    <= 1'b0;
    end

    always @(posedge iic_clk_c or negedge iic_frm_rst_n) begin
        if(!iic_frm_rst_n)
            iic_wr_cnt  <= 'd0;
        else if(iic_d_active)
            if(~iic_wr_cnt[7])
                iic_wr_cnt  <= iic_wr_cnt + 1'b1;
            else if(~iic_wr_cnt[5])
                iic_wr_cnt  <= iic_wr_cnt + 1'b1;
            else
                iic_wr_cnt  <= iic_wr_cnt;
        else
            iic_wr_cnt <= iic_wr_cnt;
    end

    always @(posedge iic_clk_c or negedge iic_frm_rst_n) begin
        if(!iic_frm_rst_n)
            iic_wr_roll_over    <= 1'b0;
        else if(iic_ecc_en)
            case(iic_rev_addr[1:0])
                2'b00   :   iic_wr_roll_over    <= (iic_wr_cnt >= 'd128)    ;
                2'b01   :   iic_wr_roll_over    <= (iic_wr_cnt >= 'd127)    ;
                2'b10   :   iic_wr_roll_over    <= (iic_wr_cnt >= 'd126)    ;
                2'b11   :   iic_wr_roll_over    <= (iic_wr_cnt >= 'd125)    ;
            endcase
        else
            2'b11   :   iic_wr_roll_over    <= (iic_wr_cnt >= 'd160)    ;
    end
    always @(posedge iic_clk_c or negedge iic_frm_rst_n) begin
        if(!iic_frm_rst_n)
            iic_preread_state   <= 1'b0;
        else if(iic_bitcnt_is_8)
            iic_preread_state   <= 1'b0;
        else if(iic_rd_en_r & iic_wr_state)
            iic_preread_state   <= 1'b1;
        else
            iic_preread_state   <= 1'b1;
    end
    always @(posedge iic_clk_c or negedge iic_frm_rst_n) begin
        if(!iic_frm_rst_n)
            iic_data_out    <= 38'h3f_ffff_ffff ;
        else if(iic_wr_state & (iic_bitcnt_is_1) & (~iic_tm_write_reg) & iic_tm_onepage)
            iic_data_out    <= {{iic_usr_din[4:0],sda_in},{4{iic_usr_din[6:0],sda_in}}};
        else if(iic_wr_state & (iic_bitcnt_is_1 & (~iic_tm_write_reg))
            case(iic_byte_cnt)
                'd0 :   begin
                    if(iic_preread_state)
                        iic_data_out <= {6'd0,iic_preread_data[31:8],iic_usr_din[6:0],sda_in};
                    else
                        iic_data_out <= {6'd0,iic_data_out[31:8],iic_usr_din[6:0],sda_in};
                end
                'd1 :   begin
                    if(iic_preread_state)
                        iic_data_out <= {6'd0,iic_preread_data[31:16],iic_usr_din[6:0],sda_in,iic_preread_data[7:0]};
                    else
                        iic_data_out <= {6'd0,iic_data_out[31:16],iic_usr_din[6:0],sda_in,iic_data_out[7:0]};
                end
                'd2 :   begin
                    if(iic_preread_state)
                        iic_data_out <= {6'd0,iic_preread_data[31:24],iic_usr_din[6:0],sda_in,iic_preread_data[15:0]};
                    else
                        iic_data_out <= {6'd0,iic_data_out[31:24],iic_usr_din[6:0],sda_in,iic_data_out[15:0]};
                end
                'd3 :   begin
                    if(iic_preread_state)
                        iic_data_out <= {6'd0,iic_usr_din[6:0],sda_in,iic_preread_data[23:0]};
                    else
                        iic_data_out <= {6'd0,iic_usr_din[6:0],sda_in,iic_data_out[23:0]};
                end
                'd4 :   begin
                    iic_data_out <= {iic_usr_din[4:0],sda_in,iic_data_out[31:0]};
                end
                default:;
            endcase
        else
            iic_data_out <= iic_data_out    ;
    end

    assign iic_opt_reg_wr[1]    = iic_tcmd_optcode_we & iic_curr_state == IIC_BYTE_WR & iic_bitcnt_is_0 ;
    assign iic_opt_reg_wr[0]    = iic_tcmd_optcode_we & iic_curr_state == IIC_PAGE_WR & iic_bitcnt_is_0 ;
    assign iic_opt_reg_wdata    = iic_usr_dinp17:0];


    always @(posedge iic_clk_c or negedge iic_frm_rst_n) begin
        if(!iic_frm_rst_n)
            iic_usr_dout    <= 'd0  ;
        else if(iic_tcmd_optcode_rd)
            case(iic_byte_cnt)
                'd0 :   iic_usr_dout <= {3'h7,iic_opt_reg_rdata[12:8]};
                'd1 :   iic_usr_dout <= iic_opt_reg_rdata[7:0];
                default : iic_usr_dout <= iic_opt_reg_rdata[7:0];
            endcase
        else if(iic_tcmd_ecc_bist3)
            iic_usr_dout <= iic_data_in[7:0];
        else if(iic_bitcnt_is_0)
            case(iic_byte_cnt)
                'd0 :   iic_usr_dout <= iic_data_in[7:0];
                'd1 :   iic_usr_dout <= iic_data_in[15:8];
                'd2 :   iic_usr_dout <= iic_data_in[23:16];
                'd3 :   iic_usr_dout <= iic_data_in[31:24];
                'd4 :   iic_usr_dout <= {2'b00,iic_data_in[37:32]};
                default :   iic_usr_dout <= iic_data_in[7:0];
            endcase
        else
            iic_usr_dout <= iic_usr_dout;
    end

    assign iic_alleven  = iic_tcmd_array | iic_tcmd_even    ;
    assign iic_allodd   = iic_tcmd_array | iic_tcmd_odd     ;
    assign iic_tm_wall  = iic_tcmd_one_byte | iic_tcmd_hv_one_byte  ;
    assign iic_tm_hv    = iic_tcmd_hv_one_byte;

    assign iic_tm_icell = (iic_tcmd_current | iic_tcmd_ti_current) & iic_valid;
    assign iic_tm_iref  = iic_tcmd_ref_current & iic_valid;
    assign iic_tm_extiref = iic_tcmd_extref_current & iic_valid ;


    //************************************************************************************************
    // 5.Sub module instantiation
    //************************************************************************************************
    //------------------------------------------------------------------------------------------------

endmodule    
//****************************************************************************************************
//End of Module
//****************************************************************************************************
