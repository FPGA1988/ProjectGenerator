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
module spi_rx_module(
    spi_clk_c           ,//01   In
    spi_sr_clk          ,//01   In
    spi_rst_n           ,//01   In
    spi_frm_rst_n       ,//01   In
    spi_wren_rst_n      ,//01   In
    spi_wpn             ,//01   In
    sda_in              ,//01   In
    test_en             ,//01   In
    spi_valid           ,//
    spi_cmd_user_val    ,//
    spi_tcmd_val        ,//
    spi_ecc_en          ,//
    spi_curr_addr       ,//
    spi_curr_state      ,//
    spi_bit_cnt         ,//
    spi_bitcnt_is_0     ,//
    spi_bitcnt_is_1     ,//
    spi_bitcnt_is_2     ,//
    spi_bitcnt_is_456   ,//
    spi_bitcnt_is_7     ,//
    spi_bitcnt_is_8     ,//
    spi_hwp_val         ,//
    spi_prog_en         ,//
    spi_byte_cnt        ,//
    spi_addr_keep       ,//
    spi_cmd_reg         ,//


);

    //************************************************************************************************
    // 1.input and output declaration
    //************************************************************************************************
    input                   sclk_spi            ,//01   In
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
    always @(posedge  spi_clk_c or negedge spi_frm_rst_n) begin
        if(!spi_frm_rst_n)
            spi_curr_state  <= SPI_IDLE ;
        else
            spi_curr_state  <= spi_next_state;
    end
    
    always @(*) begin : COMB_SPI_NEXT_STATE
        case(spi_curr_state)
            SPI_IDLE        :   begin
                
            end
            SPI_CMD         :   begin
                if(~spi_bitcnt_is_0)
                    spi_next_state = SPI_CMD    ;
                else if(spi_ee_wbusy)
                    if(spi_cmd_rdsr_w)
                        spi_next_state = SPI_DAT_RD ;
                    else
                        spi_next_state = SPI_ERR    ;
                else if(spi_cmd_wren_w | spi_cmd_wrdi_w | spi_tm_direct_sp)
                    spi_next_state = SPI_WAIT;
                else if(spi_cmd_wrsr_w)
                    spi_next_state = SPI_BYTE_WR    ;
                else if(spi_cmd_rdsr_w | spi_tm_ecc_bist_w)
                    spi_next_state = SPI_DAT_RD ;
                else if(spi_cmd_write_w | spi_cmd_read_w | spi_tcmd_with_addr_w)
                    spi_next_state = SPI_ADDR_HB;
                else
                    spi_next_state = SPI_ERR;
            end
            SPI_ADDR_HB     :   begin
                if(~spi_bitcnt_is_0)
                    spi_next_state = SPI_ADDR_HB    ;
                else if(spi_cmd_write | spi_tcmd_write)
                    spi_next_state = SPI_BYTE_WR    ;
                else if(spi_cmd_read | spi_tcmd_read)
                    spi_next_state = SPI_DAT_RD     ;
                else
                    spi_next_state = SPI_ERR        ;
            end
            SPI_ADDR_LB     :   begin
                if(~spi_bitcnt_is_0)
                    spi_next_state = SPI_ADDR_LB    ;
                else
                    spi_next_state = SPI_BYTE_WR    ;
            end
            SPI_BYTE_WR     :   begin
                if(~spi_bitcnt_is_0)
                    spi_next_state = SPI_BYTE_WR    ;
                else
                    spi_next_state = SPI_PAGE_WR    ;
            end
            SPI_PAGE_WR     :   begin
                spi_next_state = SPI_PAGE_WR    ;
            end
            SPI_DAT_RD      :   begin
                spi_next_state = SPI_DAT_RD ;
            end
            SPI_WAIT        :   begin
                spi_next_state = SPI_WAIT   ;
            end
            SPI_ERR         :   begin
                spi_next_state = SPI_ERR    ;
            end
        endcase
    end

    always @(posedge spi_clk_c or negedge spi_frm_rst_n) begin
        if(!spi_frm_rst_n)
            spi_cmd_reg <= 8'd0;
        else if(spi_curr_state == SPI_CMD)
            spi_cmd_reg <= {spi_cmd_reg[6:0],sda_in};
        else
            spi_cmd_reg <= spi_cmd_reg;
    end

    assign spi_cmd_reg_w    = {spi_cmd_reg[6:0],sda_in};

    always @(posedge spi_clk_c or negedge spi_frm_rst_n) begin
        if(!spi_frm_rst_n)
            spi_test_disable    <= 1'b0;
        else if((~|spi_cmd_reg_w[3:0] & (spi_curr_state == SPI_CMD) & spi_bitcnt_is_4)
            spi_test_disable    <= 1'b1;
        else
            spi_test_disable    <= 1'b0;
    end

    always @(posedge spi_clk_c or negedge spi_frm_rst_n) begin
        if(!spi_frm_rst_n)
            spi_cmd_val <= 1'b0;
        else if(spi_curr_state == SPI_CMD & spi_bitcnt_is_0)
            spi_cmd_val   <= 1'b1;
        else
            spi_cmd_val   <= spi_cmd_val;
    end

    always @(posedge spi_clk_c or negedge spi_frm_rst_n) begin
        if(!spi_frm_rst_n)
            spi_bit_cnt <= 'h7;
        else if(~spi_bitcnt_is_0)
            spi_bit_cnt <= spi_bit_cnt - 1'b1;
        else
            spi_bit_cnt <= 'd7;
    end

    wire    spi_byte_cnt_clr_flag   ;
    assign spi_byte_cnt_p1_flag  = spi_curr_state == SPI_DAT_RD  & spi_bitcnt_is_0;
    assign spi_byte_cnt_clr_flag = spi_curr_state == SPI_PAGE_WR & spi_bitcnt_is_6;
    always @(posedge spi_clk_c or negedge spi_frm_rst_n) begin
        if(!spi_frm_rst_n)
            spi_byte_cnt    <= 'd0;
        else if(spi_ecc_en) begin
            if(spi_curr_state == SPI_BYTE_WR | spi_curr_state == SPI_CMD)
                spi_byte_cnt    <= spi_curr_addr[1:0];
            else if(spi_curr_state == SPI_CMD)
                spi_byte_cnt    <= 'd0;
            else if(spi_byte_cnt_p1_flag)
                spi_byte_cnt    <= spi_byte_cnt + 1'b1;
            else if(spi_byte_cnt_clr_flag)
                if(&spi_byte_cnt[1:0])
                    spi_byte_cnt    <= 'd0;
                else
                    spi_byte_cnt    <= spi_byte_cnt + 1'b1;
        end
        else begin
            if(spi_curr_state == SPI_BYTE_WR | spi_curr_state ==  SPI_CMD)
                spi_byte_cnt    <= 'd0;
            else if(spi_byte_cnt_p1_flag | spi_byte_cnt_clr_flag)
                if(&spi_byte_cnt[2])
                    spi_byte_cnt    <= 'd0;
                else
                    spi_byte_cnt    <= spi_byte_cnt + 1'b1;
            else
                spi_byte_cnt        <= spi_byte_cnt;
        end
    end


    always @(negedge spi_clk_c or negedge spi_sys_rst_n) begin
        if(!spi_sys_rst_n) begin
            spi_test_en_r   <= 1'b0;
            spi_test_en_rr  <= 1'b0;
        end
        else begin
            spi_test_en_r   <= test_en;
            spi_test_en_rr  <= spi_test_en_r;
        end
    end


    assign spi_cmd_opcode   = spi_cmd_reg[7:4];
    assign spi_normal_cmd_w = spi_cmd_reg_w[7:4] == 4'b0000;
    assign spi_normal_cmd   = spi_cmd_reg[7:4] == 4'b0000;

    assign spi_cmd_wren_w   = (spi_normal_cmd_w & spi_cmd_reg_w[2:0] == 3'b110) ;
    assign spi_cmd_wrdi_w   = (spi_normal_cmd_w & spi_cmd_reg_w[2:0] == 3'b100) ;
    assign spi_cmd_rdsr_w   = (spi_normal_cmd_w & spi_cmd_reg_w[2:0] == 3'b101) ;
    assign spi_cmd_wrsr_w   = (spi_normal_cmd_w & spi_cmd_reg_w[2:0] == 3'b001) & spi_wren_reg ;
    assign spi_cmd_read_w   = (spi_normal_cmd_w & spi_cmd_reg_w[2:0] == 3'b011) ;
    assign spi_cmd_write_w  = (spi_normal_cmd_w & spi_cmd_reg_w[2:0] == 3'b010) & spi_wren_reg ;


    assign spi_cmd_wren     = (spi_normal_cmd   & spi_cmd_reg[2:0] == 3'b110) & (~spi_cmd_wren_inval);
    assign spi_cmd_wrdi     = (spi_normal_cmd   & spi_cmd_reg[2:0] == 3'b100) & (~spi_cmd_wren_inval);
    assign spi_cmd_rdsr     = (spi_normal_cmd   & spi_cmd_reg[2:0] == 3'b101) ;
    assign spi_cmd_wrsr     = (spi_normal_cmd   & spi_cmd_reg[2:0] == 3'b001) & spi_wren_reg & spi_cmd_val;
    assign spi_cmd_read     = (spi_normal_cmd   & spi_cmd_reg[2:0] == 3'b011) & spi_cmd_val;
    assign spi_cmd_write    = (spi_normal_cmd   & spi_cmd_reg[2:0] == 3'b010) & spi_wren_reg ;

    assign spi_tcmd_with_addr_w = spi_tcmd_write_w | spi_tcmd_read_w    ;

    assign spi_tcmd_write_w = spi_tcmd_one_byte_w   |
                              spi_tcmd_hv_one_byte_w|
                              spi_tcnd_even_w       |
                              spi_tcnd_odd_w        |
                              spi_tcmd_ti_we_w      |
                              spi_tcmd_test_write_w ;

    assign spi_tcmd_write = spi_tcmd_one_byte   |
                              spi_tcmd_hv_one_byte|
                              spi_tcnd_even       |
                              spi_tcnd_odd        |
                              spi_tcmd_ti_we      |
                              spi_tcmd_test_write ;

    assign spi_tcmd_read_w  = spi_tcmd_ti_rd_w  |
                              spi_tcmd_test_read_w  ;

    assign spi_tcmd_read_w  = spi_tcmd_ti_rd  |
                              spi_tcmd_test_read  ;



    assign spi_tcmd_en      = spi_test_en_rr & spi_cmd_val;


    //test mode command

    assign tm_test_cmd1     = spi_tcmd_en & (spi_cmd_opcode == 4'b1000);
    assign tm_test_cmd2     = spi_tcmd_en & (spi_cmd_opcode == 4'b1001);
    assign tm_test_cmd3     = spi_tcmd_en & (spi_cmd_opcode == 4'b1011);
    assign tm_test_cmd1_w   = spi_test_en_rr & (spi_cmd_reg_w[7:4] == 4'b1000);
    assign tm_test_cmd2_w   = spi_test_en_rr & (spi_cmd_reg_w[7:4] == 4'b1001);
    assign tm_test_cmd3_w   = spi_test_en_rr & (spi_cmd_reg_w[7:4] == 4'b1011);

    assign spi_tcmd_one_byte    = tm_test_cmd2 & (spi_cmd_reg[3:0] == 8'b1000);
    assign spi_tcmd_one_byte_w  = tm_test_cmd2_w & (spi_cmd_reg_w[3:0] == 8'b1000);
    assign spi_tcmd_hv_one_byte = tm_test_cmd2 & (spi_cmd_reg[3:0] == 8'b1001);
    assign spi_tcmd_hv_one_byte_w = tm_test_cmd2_w & (spi_cmd_reg_w[3:0] == 8'b1001);

    assign spi_tcmd_even        = tm_test_cmd1 & (spi_cmd_reg[3:0] == 4'b1000);
    assign spi_tcmd_odd         = tm_test_cmd1 & (spi_cmd_reg[3:0] == 4'b1010);
    assign spi_tcmd_even_w      = tm_test_cmd1_w & (spi_cmd_reg_w[3:0] == 4'b1000);
    assign spi_tcmd_odd_w       = tm_test_cmd1_w & (spi_cmd_reg_w[3:0] == 4'b1010);

    assign spi_tcmd_current     = spi_tcmd_en & ({spi_cmd_reg[6:0],sda_in} == 8'b0110_0011 | spi_cmd_reg[7:0] == 8'b0110_0011);
    assign spi_tcmd_current     = spi_tcmd_en & ({spi_cmd_reg[6:0],sda_in} == 8'b0110_1111 | spi_cmd_reg[7:0] == 8'b0110_1111);
    assign spi_tcmd_current     = spi_tcmd_en & ({spi_cmd_reg[6:0],sda_in} == 8'b0110_0111 | spi_cmd_reg[7:0] == 8'b0110_0111);
    assign spi_tcmd_extref_current  = tm_test_cmd1 & (spi_cmd_reg[3:0] == 4'b1011);

    assign spi_tm_current_test  = spi_tcmd_current | spi_tcmd_ti_current | spi_tcmd_ref_current | spi_tcmd_extref_current   ;

    assign spi_tcmd_ti_wr       = spi_tcmd_en & ((spi_cmd_reg[5:0] == 6'b010111 & spi_bitcnt_is_2) | (spi_cmd_reg[6:1] == 6'b010111 & spi_bitcnt_is_1) | spi_cmd_reg[7:2] == 7'b010111);
    assign spi_tcmd_ti_we       = spi_tcmd_en & spi_cmd_reg[7:1] == 7'b0101111;
    assign spi_tcmd_ti_rd       = spi_tcmd_en & spi_cmd_reg[7:1] == 7'b0101110;

    assign spi_tcmd_optcode_we = spi_tcmd_en & spi_cmd_reg[7:0] == 8'b0100_0010;
    assign spi_tcmd_optcode_rd = spi_tcmd_en & (({spi_cmd_reg[6:0],sda_in} == 8'b0100_0101 & spi_bitcnt_is_1) | spi_cmd_reg[7:0] == 8'b0100_0101);
    
    assign spi_tcmd_ecc_disable = tm_test_cmd2 & (spi_cmd_reg[3:0] == 4'b0000);
    assign spi_tcmd_ecc_enable  = tm_test_cmd2 & (spi_cmd_reg[3:0] == 4'b0001);



    assign spi_tcmd_test_write  = tm_test_cmd3 & (spi_cmd_reg[3:0] == 4'b0010);
    assign spi_tcmd_test_read   = tm_test_cmd3 & (spi_cmd_reg[3:0] == 4'b0011);
    assign spi_tm_test          = spi_tcmd_test_write | spi_tcmd_test_read;
    assign spi_tcmd_ecc_bist3   = tm_test_cmd2 & (spi_cmd_reg[3:0] == 4'b1000);
    assign spi_tm_ecc_en        = spi_tcmd_ecc_disable | spi_tcmd_ecc_enable;
    assign spi_tm_ecc_bist      = spi_tcmd_ecc_bist3;

    assign spi_tcmd_extclk      = spi_tcmd_en & spi_cmd_reg[7:0] == 8'b0100_1010;
    assign spi_tcmd_extvpp      = spi_tcmd_en & spi_cmd_reg[7:0] == 8'b0100_1110;


    assign spi_tcmd_direct_wr   = spi_tcmd_optcode_we;
    assign spi_tm_direct_sp     = spi_tcmd_ecc_disable_w | spi_tcmd_ecc_enable_w;
    assign spi_tm_wr_wl         = spi_tcmd_even | spi_tcmd_odd;
    assign spi_tm_onepage       = spi_tcmd_one_byte | spi_tcmd_hv_one_byte;

    assign spi_addr_keep        = spi_tm_ecc_bist;

    always @(posedge spi_clk_c or negedge spi_frm_rst_n) begin
        if(!spi_frm_rst_n)
            spi_ecc_dc  <= 1'b0;
        else if(spi_tm_wr_wl | spi_tm_ecc_bist)
            spi_ecc_dc  <= 1'b1;
        else
            spi_ecc_dc  <= spi_ecc_dc   ;
    end

    always @(posedge spi_clk_c or negedge spi_sys_rst_n) begin
        if(!spi_sys_rst_n)
            spi_ecc_en_r    <= 1'b1;
        else if(~spi_test_en_rr)
            spi_ecc_en_r    <= 1'b1;
        else if(spi_tcmd_ecc_enable_w)
            spi_ecc_en_r    <= 1'b1;
        else if(spi_tcmd_ecc_disable_w)
            spi_ecc_en_r    <= 1'b0;
        else
            spi_ecc_en_r    <= spi_ecc_en_r;
    end
    assign spi_ecc_en = spi_ecc_en_r & (~spi_ecc_dc);

    always @(posedge spi_clk_c or negedge spi_frm_rst_n) begin
        if(!spi_frm_rst_n)
            spi_wp_n_r <= 1'b0;
        else if(~spi_wp_n)
            spi_wp_n_r <= 1'b1;
        else
            spi_wp_n_r <= spi_hwp_val;
    end

    assign spi_hwp_val = (~spi_wp_n)  | spi_wp_n_r  ;

    always @(posedge spi_clk_c or negedge spi_frm_rst_n) begin
        if(!spi_frm_rst_n)
            spi_mem_wp  <= 1'b0;
        else case(spi_status_reg_w[3:2])
            2'b00   :   begin
                spi_mem_wp  <= 1'b0;
            end
            2'b01   :   begin
                spi_mem_wp  <= &spi_rev_addr[1:0];
            end
            2'b10   :   begin
                spi_mem_wp  <= spi_rev_addr[1];
            end
            2'b11   :   begin
                spi_mem_wp  <= 1'b1;
            end
        endcase
    end

    always @(posedge spi_clk_c or negedge spi_frm_rst_n) begin
        if(!spi_frm_rst_n)
            spi_dat_wr_flag <= 1'b0;
        else if((spi_curr_state == SPI_BYTE_WR | spi_curr_state == SPI_PAGE_WR) & (~spi_bitcnt_is_7))
            spi_dat_wr_flag <= 1'b1;
        else
            spi_dat_wr_flag <= spi_dat_wr_flag;
    end
    assign spi_wrsr_enable = (spi_curr_state ==  SPI_BYTE_WR & spi_cmd_wrsr & spi_bitcnt_is_0);
    always @(posedge spi_clk_c or negedge spi_frm_rst_n) begin
        if(!spi_frm_rst_n)
            spi_wrsr_enable_r   <= 1'b0;
        else
            spi_wrsr_enable_r   <= spi_wrsr_enable;
    end

    always @(posedge spi_clk_c or negedge spi_frm_rst_n) begin
        if(!spi_frm_rst_n)
            spi_prog_en <= 1'b0;
        else if(spi_dat_wr_flag) begin
            if(spi_cmd_write)
                spi_prog_en <= spi_bitcnt_is_0 & (~spi_mem_wp);
            else if(spi_cmd_wrsr & spi_wrsr_enable)
                spi_prog_en <= ~(spi_status_reg_w[7] & spi_hwp_val  ;
            else if(spi_tcmd_write)
                spi_prog_en <= 1'b1;
            else
                spi_prog_en <= 1'b0;
        else
            spi_prog_en <= spi_prog_en;
    end

    always @(posedge spi_clk_c or negedge spi_ext_rst_n) begin
        if(!spi_ext_rst_n)
            spi_cmd_wren_inval  <= 1'b0;
        else if(spi_curr_state == SPI_WAIT)
            spi_cmd_wren_inval  <= 1'b1;
        else
            spi_cmd_wren_inval  <= 1'b0;
    end

    always @(posedge spi_cs_n or negedge spi_wren_rst_n) begin
        if(!spi_wren_rst_n)
            spi_wren_reg    <= 1'b0;
        else if(spi_cmd_wren)
            spi_wren_reg    <= 1'b1;
        else if(spi_cmd_wrdi)
            spi_wren_reg    <= 1'b0;
        else
            spi_wren_reg    <= spi_wren_reg;
    end

    always @(posedge spi_sr_clk or negedge spi_rst_n) begin
        if(!spi_rst_n)
            spi_status_reg_r    <=  'd0;
        else if(por_reg_set)
            spi_status_reg_r    <=  por_spi_sr[3:0];
        else if(spi_wrsr_enable_r)
            if(spi_status_reg_w[7] & spi_hwp_val)
                spi_status_reg_r    <=  spi_status_reg_r;
            else
                spi_status_reg_r    <= spi_usr_din[3:0];
        else
            spi_status_reg_r    <=  spi_status_reg_r  ;
    end

    assign spi_status_reg_w = {spi_status_reg_r[3],2'b00,spi_status_reg_r[2:0],spi_wren_reg,spi_ee_wbusy};
    assign spi_status_reg   = spi_ee_wbusy ? 8'b1111_1111 : spi_status_reg_w;

    //************************************************************************************************
    // 5.Sub module instantiation
    //************************************************************************************************
    //------------------------------------------------------------------------------------------------

endmodule    
//****************************************************************************************************
//End of Module
//****************************************************************************************************
