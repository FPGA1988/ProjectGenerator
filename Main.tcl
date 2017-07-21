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
#File Name      : Main tk gui
#Project Name   : scripts
#Description    : The main scripts of the bench.
#Github Address : https://github.com/C-L-G/scripts/Main.tcl
#License        : CPL
#**************************************************************************************************** 
#Version Information
#**************************************************************************************************** 
#Create Date    : 2016-07-01 17:00
#First Author   : bwang
#Modify Date    : 2016-07-13 14:20
#Last Author    : bwang
#Version Number : 002   
#Last Commit    : 2016-07-03 14:30
#**************************************************************************************************** 
#Revison History
#**************************************************************************************************** 
#2016.07.13 - bwang - Change the codingin style.
#2016.07.01 - bwang - The initial version.
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

#source run_verif.tcl
#1.project driector generate : PDG  

variable CMD_WIDTH
variable ss_path

#wm geometry .window 300x200

#****************************************************************************************************
#3 The frame setup up
#****************************************************************************************************

frame .f1 -bg black
text .f1.t1 -width 105 -height 30 -padx 24 -pady 20 -bg black -fg white -relief solid
text .f1.t2 -bg black -fg white -relief solid -justify now right
button .f1.b1 -text "´´½¨" -width 10 -command {setup} -relief solid -activebackground red -background black \
-foreground white
button .f1.b1 -text "²âÊÔ" -width 10 -command {test} -relief solid -activebackground red -background black \
-foreground white
button .f1.b2 -text "ÍË³ö" -width 10 -command {exit} -background black -foreground white -relief solid
#highlightColor

#.f1.b1 configure -highlightColor red

#----------------------------------------------------------------------------------------------------
#3.2 Pack the compoents
#----------------------------------------------------------------------------------------------------
#pack .f1 .f2
pack .f1
pack .f1.t1
#pack .f2.b1 .f2.b2 .f2.b3 .f2.b4 -side left -side left -side left
pack .f1.t2 .f1.b1 .f1.b2 -side top

#****************************************************************************************************
#4 The process
#****************************************************************************************************
set logo \
{
                                                                                                    
  l/////////////l///ttttttt//lll///kkkk////////lllllllllllllll/l.l/l/////////////lqq///////bb//////   
  kl////kkkl////k//lhhhh/ckt//jj//tkc.../kkkc/kkkkkkkkkkkkkkklk/2rlk////lkkk////lkqq/lkkkl/ccclkt//   
 /c     tkk/                                                                                      /l
        tkk/     
        tkk/             //lll///    ////////               /l  /l/////////////l  ///////  //////   
        kkkl          /ckt//  //tkc   /kkkc/               lk/  lk////lkkk////lk  /lkkkl/   lkt//   
        tkk/         ckk/        ct    tkk/               /k/   l/    /kkt     l/   kkk     tl      
        tkk/        lkkl          /    tkk/              /k/          /kkt          kkk   /c/       
        tkk/        kkk/               tkk/             /k/           /kkt          kkk//tk/        
        tkk/        kkk/               tkk/            /k/            /kkt          kkk/lkkkl       
        tkk/        lkkt               tkk/           /kl             /kkt          kkk   lkkt/     
        tkk/         lkkc        /k    tkk/      lt  /kl              /kkt          kkk    /tkk/    
        tkk/          /ltkl/////tkl  //kkkt////ltk  /kc             //ckkk//      /lkkkc/  /ckkkt// 
        tkk/              ////////   ////////////   //              ////////      ///////  //////// 
        tkk/
      /lkkkc//
      ////////


      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
}

#Tcl/Tk Synthesis&Verification Bench

set copyright\
{
    Copyright (c) 2017, Bwang,Giantec,Co,.Ltd.All Rights Reserved
}
.f1.t1 insert end $logo
.f1.t2 insert end $copyright

#proc module_conf {} {    
#    global MAC_SOURCE_REPLACE_EN     
#    global MAC_TARGET_CHECK_EN       
#    global MAC_BROADCAST_FILTER_EN   
#    global MAC_TX_FF_DEPTH           
#    global MAC_RX_FF_DEPTH     
#    global header_data      
#
#    if {[catch {open ./rtl/verilog/header.v r} fileid]} {
#        puts "Failed open ./rtl/verilog/header.v file\n"
#    } else {
#        gets $fileid line
#        if {[lindex $line 0]=="//"} {
#            set line [lreplace $line 0 0]
#            set MAC_SOURCE_REPLACE_EN 0
#        } else {
#            set MAC_SOURCE_REPLACE_EN 1
#        } 
#        lappend header_data $line
#        gets $fileid line
#        if {[lindex $line 0]=="//"} {
#            set line [lreplace $line 0 0]
#            set MAC_TARGET_CHECK_EN 0
#        } else {
#            set MAC_TARGET_CHECK_EN 1
#        } 
#        lappend header_data $line
#        gets $fileid line
#        if {[lindex $line 0]=="//"} {
#            set line [lreplace $line 0 0]
#            set MAC_BROADCAST_FILTER_EN 0
#        } else {
#            set MAC_BROADCAST_FILTER_EN 1
#        }
#        lappend header_data $line
#        gets $fileid line
#        set MAC_TX_FF_DEPTH [lindex $line 2]
#        lappend header_data $line
#        gets $fileid line
#        set MAC_RX_FF_DEPTH [lindex $line 2]
#        lappend header_data $line
#        close $fileid
#     }
#                        
#    destroy .f1 .f2
#    frame .f1 
#    frame .f2
#    frame .f1.f1
#    frame .f1.f2
#    frame .f1.f3
#    frame .f1.f4
#    frame .f1.f5
#    frame .f1.f6
#    
#    pack .f1 .f2 
#    pack .f1.f1 .f1.f2 .f1.f3 .f1.f4 .f1.f5 .f1.f6
#    label       .f1.f1.lb -text "enable source MAC replace module" -width 30
#    checkbutton .f1.f1.cb -variable MAC_SOURCE_REPLACE_EN
#    label       .f1.f2.lb -text "enable target MAC check module " -width 30
#    checkbutton .f1.f2.cb -variable MAC_TARGET_CHECK_EN
#    label       .f1.f3.lb -text "enable broadcast packet filter module" -width 30
#    checkbutton .f1.f3.cb -variable MAC_BROADCAST_FILTER_EN
#    
#    label       .f1.f4.lb -text "MAC_TX_FF_DEPTH" -width 30
#    entry       .f1.f4.en -textvariable MAC_TX_FF_DEPTH -width 5
#    label       .f1.f5.lb -text "MAC_RX_FF_DEPTH" -width 30
#    entry       .f1.f5.en -textvariable MAC_RX_FF_DEPTH -width 5
#    
#    button .f2.b1 -width 10 -text "Save"            -command {save_header}
#    button .f2.b2 -width 10 -text "Verify"          -command {run_sim}
#    button .f2.b4 -width 10 -text "Exit"            -command {exit}
#    
#    pack .f1.f1.cb .f1.f1.lb -side right 
#    pack .f1.f2.cb .f1.f2.lb -side right 
#    pack .f1.f3.cb .f1.f3.lb -side right 
#    pack .f1.f4.en .f1.f4.lb -side right 
#    pack .f1.f5.en .f1.f5.lb -side right 
#    
#    pack .f2.b1 .f2.b2 .f2.b4 -side left
#
#}     

#proc save_header {} {
#    global MAC_SOURCE_REPLACE_EN     
#    global MAC_TARGET_CHECK_EN       
#    global MAC_BROADCAST_FILTER_EN   
#    global MAC_TX_FF_DEPTH           
#    global MAC_RX_FF_DEPTH     
#    global header_data 
#    if {[catch {open ./rtl/verilog/header.v w} fileid]} {
#        puts "Failed open ./rtl/verilog/header.v file\n"
#    } else {
#        set line [lindex $header_data 0]
#        if {$MAC_SOURCE_REPLACE_EN==0} {
#            set line [linsert $line 0 "//"]
#        } 
#        puts $fileid $line
#
#        set line [lindex $header_data 1]        
#        if {$MAC_TARGET_CHECK_EN==0} {
#            set line [linsert $line 0 "//"]
#        } 
#        puts $fileid $line
#
#        set line [lindex $header_data 2]
#        if {$MAC_BROADCAST_FILTER_EN==0} {
#            set line [linsert $line 0 "//"]
#        } 
#        puts $fileid $line
#        
#        set line [lindex $header_data 3]
#        set line [lreplace $line 2 2 $MAC_TX_FF_DEPTH]
#        puts $fileid $line
#        
#        set line [lindex $header_data 4]
#        set line [lreplace $line 2 2 $MAC_RX_FF_DEPTH]
#        puts $fileid $line                
#        
#        close $fileid
#     }        
#            
#}

proc setup {} {
    destroy .f1
    frame .f1
    button .f1.b1 -text "1.PDG" -width 10 -command {prj_dir_gen}
    button .f1.b2 -text "2.PRS" -width 10 -command {prj_run_start}
    button .f1.b3 -text "3.PUH" -width 10 -command {prj_up_his}
    pack .f1
    pack .f1.b1 .f1.b2 .f1.b3 -side top
}

proc prj_dir_gen {} {
    set ss_path "./subscripts"
    exec tclsh $ss_path/ic_flow.tcl
}

proc prj_dir_gen {} {
    set ss_path "./subscripts"
    exec tclsh $ss_path/project_dir_generator.tcl
}

proc prj_run_start {} {
    set ss_path "./subscripts"
    exec tclsh $ss_path/project_run_start.tcl
}

proc prj_up_his {} {
    exec notepad update_history.txt
}
