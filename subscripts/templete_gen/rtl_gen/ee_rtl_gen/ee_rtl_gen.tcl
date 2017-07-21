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



ttk::frame .f1
ttk::frame .f2
ttk::frame .f3
#label .f1.l -height 10 -text "1.Templete Create" -bg black
label .f1.l1 -text "1.接口选择" -bg white
radiobutton .f1.i1 -text iic -variable ee_if -value iic -anchor w
radiobutton .f1.i2 -text spi -variable ee_if -value spi -anchor w
radiobutton .f1.i3 -text iic+spi -variable ee_if -value iic_spi -anchor w


#label .f1.l -height 10 -text "1.Templete Create" -bg black
label .f2.l1 -text "2.容量选择" -bg white
radiobutton .f2.i1 -text 16k    -variable ee_size -value 16     -anchor w
radiobutton .f2.i2 -text 32k    -variable ee_size -value 32     -anchor w
radiobutton .f2.i3 -text 64k    -variable ee_size -value 64     -anchor w
radiobutton .f2.i4 -text 128k   -variable ee_size -value 128    -anchor w
radiobutton .f2.i5 -text 256k   -variable ee_size -value 256    -anchor w
radiobutton .f2.i6 -text 512k   -variable ee_size -value 512    -anchor w
radiobutton .f2.i7 -text 1m     -variable ee_size -value 1024   -anchor w
radiobutton .f2.i8 -text 2m     -variable ee_size -value 2048   -anchor w

ttk::button .f3.b1 -text "下一步" -command {start}


#----------------------------------------------------------------------------------------------------
#3.2 Pack the compoents
#----------------------------------------------------------------------------------------------------
pack .f1 .f2 .f3
#pack .f2.b1 .f2.b2 .f2.b3 .f2.b4 -side left -side left -side left
#pack .f1
grid .f1.l1 -sticky w
#pack .f1.l2 .f1.cb .f1.b1 -side left
grid .f1.i1 -sticky w
grid .f1.i2 -sticky w
grid .f1.i3 -sticky w
grid .f2.l1 -sticky w
grid .f2.i1 -sticky w
grid .f2.i2 -sticky w
grid .f2.i3 -sticky w
grid .f2.i4 -sticky w
grid .f2.i5 -sticky w
grid .f2.i6 -sticky w
grid .f2.i7 -sticky w
grid .f2.i8 -sticky w

grid .f3.b1

#****************************************************************************************************
#4 The process
#****************************************************************************************************
#pack .pw
#
#
proc start {ee_if ee_size} {
  exec tclsh rtl_env.tcl ee_if ee_size
}
