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
module if_sel_module(
    input   wire                    spi_en              ,//
    input   wire                    por_cfg_done        ,//
    output  wire                    test_disable        ,//
    output  wire                    padout              ,//
    output  wire                    out_en              ,//
    output  wire    [15:00]         ee_addr             ,//
    output  wire    [05:00]         bit_sel             ,//
    output  wire                    rd_en               ,//
    output  wire                    vs_en               ,//
    output  wire                    rdbuf_en            ,//
    output  wire                    d_active            ,//
    output  wire                    cin                 ,//
    output  wire                    clr_dl              ,//
    output  wire                    alleven             ,//
    output  wire                    allodd              ,//
    output  wire                    tcode_sel           ,//
    output  wire                    tm_wall             ,//
    output  wire                    tm_icell            ,//
    output  wire                    tm_iref             ,//
    output  wire                    tm_extiref          ,//
    output  wire                    tm_hv               ,//
    output  wire                    extclk_en           ,//
    output  wire                    extvpp_en           ,//
    output  wire                    ecc_enable          ,//
    output  wire                    wr_roll_over        ,//
    output  wire                    ecc_bist3           ,//
    output  wire    [37:00]         if_data_out         ,//
    output  wire                    ee_wbusy_s          ,//
    //2.the por interface
    input   wire                    por_rd_en           ,//
    input   wire                    por_vs_en           ,//
    input   wire    [15:00]         por_ee_addr         ,//
    input   wire                    por_tc_sel          ,//
    input   wire                    por_clr_dl          ,//
    //3.the iic interface
    input   wire                    iic_ecc_en          ,//
    input   wire                    iic_wr_roll_over    ,//
    input   wire                    iic_tcmd_ecc_bist3  ,//
    input   wire    [37:00]         iic_data_out        ,//
    input   wire                    iic_test_disable    ,//
    input   wire                    iic_sda_out         ,//
    input   wire    [15:00]         iic_ee_addr         ,//
    input   wire                    iic_rd_en           ,//
    input   wire                    iic_vs_en           ,//
    input   wire                    iic_rdbuf_en        ,//
    input   wire                    iic_d_active        ,//
    input   wire                    iic_cin             ,//
    input   wire                    iic_clr_dl          ,//
    input   wire                    iic_allaven         ,//
    input   wire                    iic_allodd          ,//
    input   wire                    iic_tc_sel          ,//
    input   wire    [05:00]         iic_bit_sel         ,//
    input   wire                    iic_tm_wall         ,//
    input   wire                    iic_tm_icell        ,//
    input   wire                    iic_tm_iref         ,//
    input   wire                    iic_tm_extiref      ,//
    input   wire                    iic_tm_hv           ,//
    input   wire                    iic_extclk_en       ,//
    input   wire                    iic_extvpp_en       ,//
    input   wire                    iic_ee_wbusy        ,//
    //4.the spi interface
    input   wire                    spi_gated_control   ,//
    input   wire                    spi_ecc_en          ,//
    input   wire                    spi_wr_roll_over    ,//
    input   wire                    spi_tcmd_ecc_bist3  ,//
    input   wire    [37:00]         spi_data_out        ,//
    input   wire                    spi_test_disable    ,//
    input   wire                    spi_sda_out         ,//
    input   wire                    spi_sda_out_en      ,//
    input   wire    [15:00]         spi_ee_addr         ,//
    input   wire                    spi_rd_en           ,//
    input   wire                    spi_vs_en           ,//
    input   wire                    spi_rdbuf_en        ,//
    input   wire                    spi_d_active        ,//
    input   wire                    spi_cin             ,//
    input   wire                    spi_clr_dl          ,//
    input   wire                    spi_allaven         ,//
    input   wire                    spi_allodd          ,//
    input   wire                    spi_tc_sel          ,//
    input   wire                    spi_tm_wall         ,//
    input   wire                    spi_tm_hv           ,//
    input   wire                    spi_ee_wbusy         //

);

    //************************************************************************************************
    // 1.Parameter and constant define
    //************************************************************************************************
    //None 
    
    //************************************************************************************************
    // 2.Register and wire declaration
    //************************************************************************************************
    //------------------------------------------------------------------------------------------------
    // 2.1 the xxx
    //------------------------------------------------------------------------------------------------   
    //None 

    //************************************************************************************************
    // 3.Main code
    //************************************************************************************************
    //------------------------------------------------------------------------------------------------
    // 3.1 the ecc module assignment
    //------------------------------------------------------------------------------------------------    
    assign if_data_out      = spi_en ? spi_data_out : iic_data_out;
    assign ee_wbusy_s       = iic_ee_wbusy | spi_ee_wbusy;
    assign bit_sel          = iic_bit_sel;
    assign rd_en            = por_cfg_done ? (spi_rd_en | iic_rd_en) : por_rd_en;
    assign vs_en            = por_cfg_done ? (spi_en ? spi_vs_en : iic_vs_en) : por_vs_en;
    assign rdbuf_en         = spi_rdbuf_en | iic_rdbuf_en;
    assign tcode_sel        = por_cfg_done ? (spi_tc_sel | iic_tc_sel) : por_tc_sel;
    assign clr_dl           = por_cfg_done ? (spi_en ? spi_clr_dl : iic_clr_dl) : por_clr_dl;
    assign d_active         = iic_d_active | spi_d_active;
    assign cin              = iic_cin & spi_cin;
    assign alleven          = iic_allaven | spi_allaven;
    assign allodd           = iic_allodd | spi_allodd;
    assign tm_wall          = iic_tm_wall | spi_tm_wall;
    assign tm_icell         = iic_tm_icell;
    assign tm_iref          = iic_tm_iref;
    assign tm_extiref       = iic_tm_extiref;
    assign tm_hv            = iic_tm_hv | spi_tm_hv;
    assign extclk_en        = iic_extclk_en;
    assign extvpp_en        = iic_extvpp_en;
    assign ee_addr          = por_cfg_done ? (iic_ee_addr | spi_ee_addr) : por_ee_addr;
    assign padout           = spien ? spi_sda_out : iic_sda_out;
    assign out_en           = spi_sda_out_en & spi_gated_control;
    assign ecc_bist3        = iic_tcmd_ecc_bist3 | spi_tcmd_ecc_bist3;
    assign ecc_enable       = spi_en ? spi_ecc_en : iic_ecc_en;
    assign wr_roll_over     = spi_en ? spi_wr_roll_over : iic_wr_roll_over;
    assign test_disable     = iic_test_disable | spi_test_disable;

    //************************************************************************************************
    // 4.Sub module instantiation
    //************************************************************************************************
    //------------------------------------------------------------------------------------------------

endmodule    
//****************************************************************************************************
//End of Module
//****************************************************************************************************
