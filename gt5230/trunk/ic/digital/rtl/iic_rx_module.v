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
module iic_rx_module(
    iic_clk_c           ,//01   In
    iic_sys_rst_n       ,//01   In
    iic_frm_rst_n       ,//01   In
    iic_ext_rst_n       ,//01   In
    wp                  ,//01   In
    a0                  ,//01   In
    a1                  ,//01   In
    a2                  ,//01   In
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
    always @(posedge  iic_clk_c or negedge iic_frm_rst_n) begin
        if(!iic_frm_rst_n)
            iic_curr_state  <= IIC_IDLE ;
        else
            iic_curr_state  <= iic_next_state;
    end
    
    always @(*) begin : COMB_IIC_NEXT_STATE
        case(iic_curr_state)
            IIC_IDLE        :   begin
                
            end
            IIC_CMD         :   begin
                if(~iic_bitcnt_is_0)
                    iic_next_state = IIC_CMD    ;
                else if(iic_tcmd_direct_wr)
                    iic_next_state = IIC_BYTE_WR    ;
                else if(iic_tcmd_direct_sp | ((~iic_cmd_user_val) & (~iic_tcmd_val)))
                    iic_next_state = IIC_WAIT;
                else if(iic_tcmd_ti_we)
                    iic_next_state = IIC_ADDR_HB;
                else if(iic_cmd_reg[0] | iic_tcmd_ti_rd | iic_tcmd_ecc_bist3)
                    iic_next_state = IIC_DAT_RD ;
                else
                    iic_next_state = IIC_ADDR_HB    ;
            end
            IIC_ADDR_HB     :   begin
                if(~iic_bitcnt_is_0)
                    iic_next_state = IIC_ADDR_HB    ;
                else
                    iic_next_state = IIC_ADDR_LB    ;
            end
            IIC_ADDR_LB     :   begin
                if(~iic_bitcnt_is_0)
                    iic_next_state = IIC_ADDR_LB    ;
                else
                    iic_next_state = IIC_BYTE_WR    ;
            end
            IIC_BYTE_WR     :   begin
                if(~iic_bitcnt_is_0)
                    iic_next_state = IIC_BYTE_WR    ;
                else
                    iic_next_state = IIC_PAGE_WR    ;
            end
            IIC_PAGE_WR     :   begin
                iic_next_state = IIC_PAGE_WR    ;
            end
            IIC_DAT_RD      :   begin
                if(~iic_bitcnt_is_0 | (iic_bitcnt_is_0 & (~sda_in)))
                    iic_next_state = IIC_DAT_RD ;
                else
                    iic_next_state = IIC_WAIT   ;
            end
            IIC_WAIT        :   begin
                iic_next_state = IIC_WAIT   ;
            end
        endcase
    end
    assign iic_load_cmd = (iic_next_state == IIC_CMD & (~iic_bitcnt_is_0));

    always @(posedge iic_clk_c or negedge iic_frm_rst_n) begin
        if(!iic_frm_rst_n)
            iic_cmd_reg <= 8'd0;
        else if(iic_load_cmd)
            iic_cmd_reg <= {iic_cmd_reg[6:0],sda_in};
        else
            iic_cmd_reg <= iic_cmd_reg;
    end
    always @(posedge iic_clk_c or negedge iic_frm_rst_n) begin
        if(!iic_frm_rst_n)
            iic_cmd_valid <= 1'b0;
        else if(iic_curr_state == IIC_CMD & iic_bitcnt_is_4)
            iic_cmd_valid   <= 1'b1;
        else
            iic_cmd_valid   <= iic_cmd_valid;
    end

    always @(posedge iic_clk_c or negedge iic_frm_rst_n) begin
        if(!iic_frm_rst_n)
            iic_bit_cnt <= 4'h8;
        else if(iic_valid)
            if(|iic_bit_cnt)
                iic_bit_cnt <= iic_bit_cnt - 1'b1;
            else
                iic_bit_cnt <= 4'd8;
    end
    wire    iic_byte_cnt_clr_flag   ;
    assign iic_byte_cnt_clr_flag = iic_curr_state == IIC_DAT_RD & iic_bitcnt_is_1;
    always @(posedge iic_clk_c or negedge iic_frm_rst_n) begin
        if(!iic_frm_rst_n)
            iic_byte_cnt    <= 'd0;
        else if(iic_ecc_en) begin
            if(iic_curr_state == IIC_BYTE_WR | iic_curr_state == IIC_CMD)
                if(iic_tcmd_optcode_rd | iic_tm_ecc_bist)
                    iic_byte_cnt    <= 'd0;
                else
                    iic_byte_cnt    <= iic_curr_addr[1:0];
            else if(iic_byte_cnt_clr_flag)
                if(&iic_byte_cnt[1:0])
                    iic_byte_cnt    <= 'd0;
                else
                    iic_byte_cnt    <= iic_byte_cnt + 1'b1;
            else if(iic_curr_state == IIC_PAGE WRITE & iic_bitcnt_is_8)
                if(&iic_byte_cnt[1:0])
                    iic_byte_cnt    <= 'd0;
                else
                    iic_byte_cnt    <= iic_byte_cnt + 1'b1;
            else
                iic_byte_cnt        <= iic_byte_cnt;
        end


    always @(posedge iic_clk_c or negedge iic_sys_rst_n) begin
        if(!iic_sys_rst_n) begin
            iic_slave_addr  <= 3'b000;
        end
        else begin
            iic_slave_addr  <= {a2,a1,a0};
        end
    end

    always @(negedge iic_clk_c or negedge iic_sys_rst_n) begin
        if(!iic_sys_rst_n) begin
            iic_test_en_r   <= 1'b0;
            iic_test_en_rr  <= 1'b0;
        end
        else begin
            iic_test_en_r   <= test_en;
            iic_test_en_rr  <= iic_test_en_r;
        end
    end
    assign iic_addr_match = (iic_slave_addr == iic_cmd_reg[3:1] & (~iic_test_en_rr);
    assign iic_cmd_opcode = iic_cmd_reg[7:4];
    

    assign iic_cmd_user_val = iic_cmd_valid & (iic_cmd_opcode == 4'b1010) & iic_addr_match  ;
    assign iic_tcmd_val     = iic_tcmd_one_byte     |
                              iic_tcmd_hv_one_byte  |
                              iic_tcmd_ti_wr        |
                              iic_tm_wr_wl          |
                              iic_tm_current_test   |
                              iic_tm_ecc_en         |
                              iic_tm_ecc_bist       |
                              iic_tcmd_optcode_we   |
                              iic_tcmd_optcode_rd   |
                              iic_tcmd_extclk       |
                              iic_tcmd_extvpp       |
                              iic_tm_test           ;
    assign iic_tcmd_en      = iic_test_en_rr & iic_cmd_valid    ;
    assign tm_test_cmd1     = iic_tcmd_en & (iic_cmd_opcode == 4'b0110);
    assign tm_test_cmd1     = iic_tcmd_en & (iic_cmd_opcode == 4'b0111);

    assign iic_tcmd_one_byte    = iic_tcmd_en & (iic_cmd_reg[7:0] == 8'b0001_0000);
    assign iic_tcmd_hv_one_byte = iic_tcmd_en & (iic_cmd_reg[7:0] == 8'b0011_0000);

    assign iic_tcmd_array       = tm_test_cmd1 & (iic_cmd_reg[3:0] == 4'b1100);
    assign iic_tcmd_even        = tm_test_cmd1 & (iic_cmd_reg[3:0] == 4'b1000);
    assign iic_tcmd_odd         = tm_test_cmd1 & (iic_cmd_reg[3:0] == 4'b0100);

    assign iic_tcmd_current     = iic_tcmd_en & ({iic_cmd_reg[6:0],sda_in} == 8'b0110_0011 | iic_cmd_reg[7:0] == 8'b0110_0011);
    assign iic_tcmd_current     = iic_tcmd_en & ({iic_cmd_reg[6:0],sda_in} == 8'b0110_1111 | iic_cmd_reg[7:0] == 8'b0110_1111);
    assign iic_tcmd_current     = iic_tcmd_en & ({iic_cmd_reg[6:0],sda_in} == 8'b0110_0111 | iic_cmd_reg[7:0] == 8'b0110_0111);
    assign iic_tcmd_extref_current  = tm_test_cmd1 & (iic_cmd_reg[3:0] == 4'b1011);

    assign iic_tm_current_test  = iic_tcmd_current | iic_tcmd_ti_current | iic_tcmd_ref_current | iic_tcmd_extref_current   ;

    assign iic_tcmd_ti_wr       = iic_tcmd_en & ((iic_cmd_reg[5:0] == 6'b010111 & iic_bitcnt_is_2) | (iic_cmd_reg[6:1] == 6'b010111 & iic_bitcnt_is_1) | iic_cmd_reg[7:2] == 7'b010111);
    assign iic_tcmd_ti_we       = iic_tcmd_en & iic_cmd_reg[7:1] == 7'b0101111;
    assign iic_tcmd_ti_rd       = iic_tcmd_en & iic_cmd_reg[7:1] == 7'b0101110;

    assign iic_tcmd_optcode_we = iic_tcmd_en & iic_cmd_reg[7:0] == 8'b0100_0010;
    assign iic_tcmd_optcode_rd = iic_tcmd_en & (({iic_cmd_reg[6:0],sda_in} == 8'b0100_0101 & iic_bitcnt_is_1) | iic_cmd_reg[7:0] == 8'b0100_0101);
    
    assign iic_tcmd_ecc_disable = tm_test_cmd2 & (iic_cmd_reg[3:0] == 4'b0000);
    assign iic_tcmd_ecc_enable  = tm_test_cmd2 & (iic_cmd_reg[3:0] == 4'b0001);
    assign iic_tcmd_test_write  = tm_test_cmd2 & (iic_cmd_reg[3:0] == 4'b0010);
    assign iic_tcmd_test_read   = tm_test_cmd2 & (iic_cmd_reg[3:0] == 4'b0011);
    assign iic_tm_test          = iic_tcmd_test_write | iic_tcmd_test_read;
    assign iic_tcmd_ecc_bist3   = tm_test_cmd2 & (iic_cmd_reg[3:0] == 4'b1000);
    assign iic_tm_ecc_en        = iic_tcmd_ecc_disable | iic_tcmd_ecc_enable;
    assign iic_tm_ecc_bist      = iic_tcmd_ecc_bist3;

    assign iic_tcmd_extclk      = iic_tcmd_en & iic_cmd_reg[7:0] == 8'b0100_1010;
    assign iic_tcmd_extvpp      = iic_tcmd_en & iic_cmd_reg[7:0] == 8'b0100_1110;


    assign iic_tcmd_direct_wr   = iic_tcmd_optcode_we;
    assign iic_tcmd_direct_sp   = iic_tcmd_ecc_disable | iic_tcmd_ecc_enable | iic_tcmd_extclk | iic_tcmd_extvpp;
    assign iic_tm_wr_wl         = iic_tcmd_array | iic_tcmd_even | iic_tcmd_odd;
    assign iic_tm_onepage       = iic_tcmd_one_byte | iic_tcmd_hv_one_byte;

    assign iic_addr_keep        = iic_tcmd_optcode_we | iic_tcmd_optcode_rd | iic_tm_ecc_bist | (iic_hwp_val | iic_cmd_user_val & (~iic_cmd_reg[0]));

    always @(posedge iic_clk_c or negedge iic_frm_rst_n) begin
        if(!iic_frm_rst_n)
            iic_ecc_dc  <= 1'b0;
        else
            iic_ecc_dc  <= iic_tcmd_current | iic_tcmd_ti_current | iic_tcmd_ref_current | iic_tm_wr_wl | iic_tm_ecc_bist   ;
    end

    always @(posedge iic_clk_c or negedge iic_sys_rst_n) begin
        if(!iic_sys_rst_n)
            iic_ecc_en_r    <= 1'b1;
        else if(~iic_test_en_rr)
            iic_ecc_en_r    <= 1'b1;
        else if(iic_tcmd_ecc_enable)
            iic_ecc_en_r    <= 1'b1;
        else if(iic_tcmd_ecc_disable)
            iic_ecc_en_r    <= 1'b0;
        else
            iic_ecc_en_r    <= iic_ecc_en_r;
    end
    assign iic_ecc_en = iic_ecc_en_r & (~iic_ecc_dc);

    always @(posedge iic_clk_c or negedge iic_frm_rst_n) begin
        if(!iic_frm_rst_n)
            iic_hwp_val <= 1'b0;
        else if(wp)
            iic_hwp_val <= 1'b1;
        else
            iic_hwp_val <= iic_hwp_val;
    end

    always @(posedge iic_clk_c or negedge iic_frm_rst_n) begin
        if(!iic_frm_rst_n)
            iic_prog_en <= 1'b0;
        else if(wp | iic_hwp_val) & (~iic_test_en_rr))
            iic_prog_en <= 1'b0;
        else if(~iic_bit_cnt[3])
            iic_prog_en <= 1'b0;
        else if(iic_curr_state == IIC_PAGE_WR & (~iic_tcmd_direct_wr))
            iic_prog_en <= 1'b1;
        else
            iic_prog_en <= 1'b0;
    end

    always @(posedge iic_clk_c or negedge iic_ext_rst_n) begin
        if(!iic_ext_rst_n)
            iic_extclk_en   <= 1'b0;
        else if(iic_tcmd_extclk)
            iic_extclk_en   <= 1'b1;
        else
            iic_extclk_en   <= iic_extclk_en;
    end

    always @(posedge iic_clk_c or negedge iic_ext_rst_n) begin
        if(!iic_ext_rst_n)
            iic_extvpp_en   <= 1'b0;
        else if(iic_tcmd_extvpp)
            iic_extvpp_en   <= 1'b1;
        else
            iic_extvpp_en   <= iic_extvpp_en;
    end


    //************************************************************************************************
    // 5.Sub module instantiation
    //************************************************************************************************
    //------------------------------------------------------------------------------------------------

endmodule    
//****************************************************************************************************
//End of Module
//****************************************************************************************************
