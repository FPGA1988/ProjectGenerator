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
#2016.07.13 - bwang - The initial version.
#---------------------------------------------------------------------------------------------------- 

#****************************************************************************************************
#1. The package use
#****************************************************************************************************

set env(prj_root) ../gt0000/trunk/ic/digital

#****************************************************************************************************
#2 The variable define
#****************************************************************************************************

#----------------------------------------------------------------------------------------------------
#2.1 The variable define
#----------------------------------------------------------------------------------------------------
set product {EEPROM MOTOR_DRIVER SMART_CARD}

#****************************************************************************************************
#3 The frame setup up
#****************************************************************************************************
option add *Menu.tearoff 0
menu .mbar
. configure -menu .mbar -width 500
.mbar add cascade -label Nlint -menu .mbar.nlint -underline 1
.mbar add cascade -label Library -menu .mbar.lib -underline 1
.mbar add cascade -label Synthesis -menu .mbar.syn -underline 1
.mbar add cascade -label Simulation -menu .mbar.sim -underline 1
.mbar add cascade -label Formal -menu .mbar.formal -underline 1
.mbar add cascade -label STA -menu .mbar.sta -underline 1
.mbar add cascade -label APR -menu .mbar.apr -underline 1
.mbar add cascade -label FPGA -menu .mbar.apr -underline 1





#----------------------------------------------------------------------------------------------------
#3.1 The nlint
#----------------------------------------------------------------------------------------------------
menu .mbar.nlint
.mbar.nlint add cascade -label EditScript -menu .mbar.nlint.editscript -underline 0
.mbar.nlint add separator
#.mbar.nlint add cascade -button NlintStart -menu .mbar.nlint.nlintstart
.mbar.nlint add command -label NlintStart -command {nlintrun}
.mbar.nlint add command -label "Nlint GUI" -command {nlintgui}




#****************************************************************************************************
#4 The process
#****************************************************************************************************
#pack .pw

proc nlintrun {} {
    if {[tk_messageBox -type yesno -icon question \
    -message "Do you want to run nLint?" -parent .] == "yes"} {
        exit
    } 
}
    
proc nlintgui {} {
    exit
}
