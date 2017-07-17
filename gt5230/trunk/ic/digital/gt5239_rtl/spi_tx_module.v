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
//File Name      : spi_tx_module.v 
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
    spi_clk_c           ,//01   In
    spi_frm_rst_n       ,//01   In
    spi_tx_rst_n        ,//
    spi_ecc_en          ,//
    spi_bit_cnt         ,//
    spi_bitcnt_is_7     ,//
    spi_curr_addr       ,//
    spi_curr_state      ,//
    spi_data_in         ,//
    spi_status_reg      ,//
    spi_sda_out         ,//
    spi_sda_out_en      ,//
    spi_cmd_rdsr        ,//
    spi_byte_cnt        ,//
    spi_tcmd_ecc_bist3   //

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

    assign spi_bit_cnt_minus = spi_bit_cnt - 1'b1;
    assign spi_sda_out_bit   = spi_bit_cnt_minus[2:0];

    always @(posedge spi_clk_c or negedge spi_frm_rst_n) begin
        if(!spi_frm_rst_n)
            spi_usr_dout    <= 'd0;
        else if(spi_tcmd_ecc_bist3)
            spi_usr_dout    <= spi_data_in[7:0];
        else if(spi_ecc_en) begin
            if(spi_curr_state == SPI_DAT_RD & spi_bitcnt_is_7)
                case(spi_curr_addr[1:0])
                    'd0 :   begin
                        spi_usr_dout    <= spi_data_in[7:0];
                    end
                    'd1 :   begin
                        spi_usr_dout    <= spi_data_in[15:0];
                    end
                    'd2 :   begin
                        spi_usr_dout    <= spi_data_in[23:16];
                    end
                    'd3 :   begin
                        spi_usr_dout    <= spi_data_in[31:24];
                    end
                    default: begin
                        spi_usr_dout    <= spi_data_in[7:0];
                    end
                endcase
        end
        else begin
            if(spi_curr_state == SPI_DAT_RD & spi_bitcnt_is_7)
                case(spi_curr_addr[1:0])
                    'd0 :   begin
                        spi_usr_dout    <= spi_data_in[7:0];
                    end
                    'd1 :   begin
                        spi_usr_dout    <= spi_data_in[15:0];
                    end
                    'd2 :   begin
                        spi_usr_dout    <= spi_data_in[23:16];
                    end
                    'd3 :   begin
                        spi_usr_dout    <= spi_data_in[31:24];
                    end
                    'd4 :   begin
                        spi_usr_dout    <= {2'b00,spi_data_in[37:32]};
                    end
                    default: begin
                        spi_usr_dout    <= spi_data_in[7:0];
                    end
                endcase
        end

    end

            spi_curr_state  <= spi_IDLE ;
        else
            spi_curr_state  <= spi_next_state;
    end
    
    always @(posedge  spi_clk_c or negedge spi_frm_rst_n) begin
        if(!spi_frm_rst_n) begin
            spi_sda_out     <= 1'b1;
            spi_sda_out_en  <= 1'b0;
        end
        else case(spi_curr_state)
            SPI_DAT_RD      :   begin
                if(spi_cmd_rdsr) begin
                    spi_sda_out     <= spi_status_reg[spi_bit_cnt];
                    spi_sda_out_en  <= 1'b1;
                end
                else begin
                    if(spi_bitcnt_is_7) begin
                        if(spi_ecc_en) begin
                            case(spi_curr_addr[1:0])
                                'd0 :   begin
                                    spi_sda_out     <= spi_data_in[7];
                                    spi_sda_out_en  <= 1'b1;
                                end
                                'd1 :   begin
                                    spi_sda_out     <= spi_data_in[15];
                                    spi_sda_out_en  <= 1'b1;
                                end
                                'd2 :   begin
                                    spi_sda_out     <= spi_data_in[23];
                                    spi_sda_out_en  <= 1'b1;
                                end
                                'd3 :   begin
                                    spi_sda_out     <= spi_data_in[31];
                                    spi_sda_out_en  <= 1'b1;
                                end
                                default : begin
                                    spi_sda_out     <= spi_data_in[7];
                                    spi_sda_out_en  <= 1'b0;
                                end
                            endcase
                        end
                        else begin
                            case(spi_byte_cnt)
                                'd0 :   begin
                                    spi_sda_out     <= spi_data_in[7];
                                    spi_sda_out_en  <= 1'b1;
                                end
                                'd1 :   begin
                                    spi_sda_out     <= spi_data_in[15];
                                    spi_sda_out_en  <= 1'b1;
                                end
                                'd2 :   begin
                                    spi_sda_out     <= spi_data_in[23];
                                    spi_sda_out_en  <= 1'b1;
                                end
                                'd3 :   begin
                                    spi_sda_out     <= spi_data_in[31];
                                    spi_sda_out_en  <= 1'b1;
                                end
                                'd3 :   begin
                                    spi_sda_out     <= 1'b0;
                                    spi_sda_out_en  <= 1'b1;
                                end
                                default : begin
                                    spi_sda_out     <= spi_data_in[7];
                                    spi_sda_out_en  <= 1'b0;
                                end
                            endcase
                        end
                    end
                else begin
                    spi_sda_out     <= spi_status_reg[spi_bit_cnt];
                    spi_sda_out_en  <= 1'b1;
                end
            end
            default :   begin
                spi_sda_out     <= 1'b0;
                spi_sda_out_en  <= 1'b0;
            end
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
