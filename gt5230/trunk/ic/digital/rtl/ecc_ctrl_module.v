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
//File Name      : ecc_ctrl_module.v 
//Project Name   : gt0000
//Description    : the top module of gt0000
//Github Address : https://github.com/C-L-G/gt0000/trunk/ic/digital/rtl/ecc_ctrl_module.v
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
//2017.07.13 - bwang - Change the coding style.
//2017.06.29 - bwang - The initial version.
//*---------------------------------------------------------------------------------------------------
`timescale 1ns/1ps
module ecc_ctrl_module(
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
    output  wire    [31:00]         por_ee_data_e2l      //32
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
    wire    [31:00]         ecc_enc_in  ;//32   Out
    wire    [37:00]         ecc_enc_out ;//38   In
    wire    [37:00]         ecc_dec_in  ;//38   Out
    wire    [37:00]         ecc_dec_out ;//38   In
    
    
    //------------------------------------------------------------------------------------------------
    // 3.x the test logic
    //------------------------------------------------------------------------------------------------
    //************************************************************************************************
    // 4.Main code
    //************************************************************************************************

    //------------------------------------------------------------------------------------------------
    // 4.1 the ecc module assignment
    //------------------------------------------------------------------------------------------------    
    assign por_ee_data_e2l = ecc_dec_out[31:0];

    //************************************************************************************************
    // 5.Sub module instantiation
    //************************************************************************************************
    //------------------------------------------------------------------------------------------------
    // 4.1 the ecc module assignment
    //------------------------------------------------------------------------------------------------    
    ecc_enc_module ecc_enc_inst(
        .i  (ecc_enc_in     ),
        .o  (ecc_enc_out    )      
    );

    ecc_dec_module ecc_dec_inst(
        .r  (ecc_dec_in     ),
        .c  (ecc_dec_out    )      
    );
    ecc_test_module ecc_test_inst(
    
    
    );


endmodule    
//****************************************************************************************************
//End of Module
//****************************************************************************************************
