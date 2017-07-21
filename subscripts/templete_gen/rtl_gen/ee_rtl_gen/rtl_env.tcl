#****************************************************************************************************   
#-------------------Copyright (c) 2016 C-L-G.FPGA1988.bwang. All rights reserved---------------------
#
#                   --              It to be define                --
#                   --                    ...                      --
#                   --                    ...                      --
#                   --                    ...                      --
#**************************************************************************************************** 
#File Information
#**************************************************************************************************** 
#File Name      : Project Run Strart
#Project Name   : scripts
#Description    : The main scripts of the bench.
#Github Address : https://github.com/C-L-G/scripts/Main.tcl
#License        : CPL
#**************************************************************************************************** 
#Version Information
#**************************************************************************************************** 
#Create Date    : 2016-07-13 17:00
#First Author   : bwang
#Modify Date    : 2016-07-13 17:20
#Last Author    : bwang
#Version Number : 002   
#Last Commit    : 2016-07-13 14:30
#**************************************************************************************************** 
#Revison History
#**************************************************************************************************** 
#2016.07.18 - bwang - Add the digital header generator.
#2016.07.13 - bwang - The initial version.
#---------------------------------------------------------------------------------------------------- 
set project_name gt0000
set env(prj_root) E:/ProjectGenerator-master/$project_name
set digital_dir $env(prj_root)/trunk/ic/digital
set rtl_dir $digital_dir/rtl
set verif_dir $digital_dir/verif
set flist_dir $digital_dir/flist


set ee_if iic
set ee_size 256

#****************************************************************************************************
#1. The flist creat
#****************************************************************************************************
cd $flist_dir
set flist [open rtl.f w+]
puts $flist "../rtl/digital_top.v" 
puts $flist "../rtl/clk_rst_module.v" 
puts $flist "../rtl/por_cfg_module.v" 
puts $flist "../rtl/mode_det_module.v" 
puts $flist "../rtl/ee_ctrl_module.v" 
if {$ee_if == "iic"} {
    puts $flist "../rtl/iic_det_module.v" 
    puts $flist "../rtl/iic_rx_module.v" 
    puts $flist "../rtl/iic_tx_module.v" 
    puts $flist "../rtl/iic_addr_module.v" 
}
if {$ee_if == "spi"} {
    puts $flist "../rtl/spi_det_module.v" 
    puts $flist "../rtl/spi_rx_module.v" 
    puts $flist "../rtl/spi_tx_module.v" 
    puts $flist "../rtl/spi_addr_module.v" 
}
close $flist

#****************************************************************************************************
#2 rtl gen
#****************************************************************************************************



set date [clock format [clock seconds] -format "%Y.%m.%d"] 




#----------------------------------------------------------------------------------------------------
#2.1 The variable define
#----------------------------------------------------------------------------------------------------
proc file_header {project_name date f} {
set header "
//****************************************************************************************************  
//*------------------Copyright (c) 2016 C-L-G.FPGA1988.bwang. All rights reserved---------------------
//
//                   --              It to be define                --
//                   --                    ...                      --
//                   --                    ...                      --
//                   --                    ...                      --
//**************************************************************************************************** 
//File Information
//**************************************************************************************************** 
//File Name      : digital_top.v 
//Project Name   : $project_name
//Description    : the top module of $project_name
//Github Address : https://github.com/C-L-G/$project_name/trunk/ic/digital/rtl/digital_top.v
//License        : CPL
//**************************************************************************************************** 
//Version Information
//**************************************************************************************************** 
//Create Date    : $date
//First Author   : bwang
//Modify Date    : $date
//Last Author    : bwang
//Version Number : 002   
//Last Commit    : $date
//**************************************************************************************************** 
//Change History(latest change first)
//yyyy.mm.dd - Author - Your log of change
//**************************************************************************************************** 
//$date - bwang - Add the clock switch test logic,rename the clk gen module to clk gen top.
//$date - bwang - Add the system auxiliary module,add the test logic.
//$date - bwang - The initial version.
//*---------------------------------------------------------------------------------------------------
"
puts $f $header
}



#****************************************************************************************************
#3 The frame setup up
#****************************************************************************************************

set flist [open rtl.f r]
while { [gets $flist line] >= 0 } {
    if {[regexp -- "digital_top" $line]} {
        set f [open $rtl_dir/digital_top.v w+] 
        file_header $project_name $date $f
    }

}

#----------------------------------------------------------------------------------------------------
#3.2 Pack the compoents
#----------------------------------------------------------------------------------------------------

#****************************************************************************************************
#4 The process
#****************************************************************************************************
#pack .pw
#
#
