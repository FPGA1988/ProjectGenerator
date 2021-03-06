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
//File Name      : ecc_test_module.v 
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
module ecc_test_module(
    //************************************************************************************************
    // 1.input and output declaration
    //************************************************************************************************
    input   wire                    ecc_enable          ,//01   In
    input   wire                    wr_roll_over        ,//01   In
    input   wire                    ecc_bist3           ,//01   In
    input   wire    [31:00]         ee_data_e2l         ,//32   In
    input   wire    [05:00]         ee_ecc_e2l          ,//06   In
    output  wire    [31:00]         ee_data_l2e         ,//32   Out
    output  wire    [05:00]         ee_ecc_l2e          ,//06   Out
    output  wire    [37:00]         if_data_in          ,//38   Out
    input   wire    [37:00]         if_data_out         ,//38   In
    output  wire    [31:00]         ecc_enc_in          ,//32   Out
    input   wire    [37:00]         ecc_enc_out         ,//38   In
    output  wire    [37:00]         ecc_dec_in          ,//38   Out
    input   wire    [37:00]         ecc_dec_out          //38   In
);


    //************************************************************************************************
    // 2.Parameter and constant define
    //************************************************************************************************
    localparam TEST_CODE_ORG    = 32'h55aa_55aa ; 
    
    
    
    //************************************************************************************************
    // 3.Register and wire declaration
    //************************************************************************************************
    //------------------------------------------------------------------------------------------------
    // 3.1 the clk wire signal
    //------------------------------------------------------------------------------------------------   
    wire                    ecc_test_ok ;
    wire    [37:00]         ee_data_out ; 
    
    
    //------------------------------------------------------------------------------------------------
    // 3.x the test logic
    //------------------------------------------------------------------------------------------------
    //************************************************************************************************
    // 4.Main code
    //************************************************************************************************

    //------------------------------------------------------------------------------------------------
    // 4.1 the ecc module assignment
    //------------------------------------------------------------------------------------------------    
    assign ecc_enc_in   = ecc_bist3 ? TEST_CODE_ORG : if_data_out[31:00]; 
    assign ecc_dec_in   = ecc_bist3 ? {ecc_enc_out[37:32,ecc_enc_out[31:1],~ecc_enc_out[0]} : {ee_ecc_e2l,ee_data_e2l};
    assign if_data_in   = ecc_bist3 ? (ecc_test_ok ? 38'd0 : {34'd0,4'hf}) : (wr_roll_over ? {ee_ecc_e2l,ee_data_e2l} : (ecc_enable ? ecc_dec_out : {ee_ecc_e2l,ee_data_e2l}));
    assign ee_data_out  = ecc_enable ? ecc_enc_out : if_data_out[37:0];
    assign ee_data_l2e  = ee_data_out[31:0];
    assign ee_ecc_l2e   = ee_data_out[37:32];
    assign ecc_test_ok = (ecc_dec_out[31:0] == TEST_CODE_ORG);

    //************************************************************************************************
    // 5.Sub module instantiation
    //************************************************************************************************
endmodule    
//****************************************************************************************************
//End of Module
//****************************************************************************************************
