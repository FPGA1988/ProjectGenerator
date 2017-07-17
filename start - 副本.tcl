variable CMD_WIDTH

#source run_verif.tcl

frame .f1
frame .f2
text .f1.t1 -width 105 -height 40 
button .f2.b1 -text "Quit" -width 5 -command {exit}
button .f2.b2 -text "Start Synthesis" -width 20 -command {start_syn}
button .f2.b3 -text "Start Verification" -width 20 -command {start_verify}
button .f2.b4 -text "Update History" -width 20 -command {open_history}

pack .f1 .f2
pack .f1.t1
pack .f2.b1 .f2.b2 .f2.b3 .f2.b4 -side left -side left -side left

set strings \
{
  
    
                                                                                                    
  l/////////////l/       //lll///    ////////               /l  /l/////////////l  ///////  //////   
  kl////kkkl////kl    /ckt//  //tkc   /kkkc/               lk/  lk////lkkk////lk  /lkkkl/   lkt//   
 /c     tkk/    /l   ckk/        ct    tkk/               /k/   l/    /kkt     l/   kkk     tl      
        tkk/        lkkl          /    tkk/              /k/          /kkt          kkk   /c/       
        tkk/        kkk/               tkk/             /k/           /kkt          kkk//tk/        
        tkk/        kkk/               tkk/            /k/            /kkt          kkk/lkkkl       
        tkk/        lkkt               tkk/           /kl             /kkt          kkk   lkkt/     
        tkk/         lkkc        /k    tkk/      lt  /kl              /kkt          kkk    /tkk/    
      /lkkkc//        /ltkl/////tkl  //kkkt////ltk  /kc             //ckkk//      /lkkkc/  /ckkkt// 
      ////////            ////////   ////////////   //              ////////      ///////  //////// 
                                                                                                    

                                Tcl/Tk Synthesis&Verification Bench
    Welcomen to use this bench,it is came from gaojon@yahoo.com's tri-mode-ethernet ip core.
    Before you use it,please make sure it is in the directory of trunk/ic/digital/bin.
                                              
                                              
                                                                                Thx a lot
                                                                                by bwang
                                                                                2017-04-05
}

.f1.t1 insert end $strings                                    

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

proc start_verify {} {
    destory .f1 .f2
    frame .f1
    frame .f2
    button .f1.b1 -text "Start Modelsim" -width 20 -command {start_modelsim}
    button .f2.b1 -text "Start Ncverilog" -width 20 -command {start_ncverilog}
    pack .f1 .f2
    pack .f1.b1 .f2.b2 -side left
}

proc start_modelsim {} {
    exec tclsh modelsim/modelsim_do.tcl
}
proc start_ncverilog {} {
    run_verif
}

proc start_syn {} {
    cd syn
    synplify_pro syn.prj
}

proc run_sim {} {
    cd sim/rtl_sim/modsim_sim/script/
    run_proc
}
