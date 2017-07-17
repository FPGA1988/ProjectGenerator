######################################################################
#
# Create work library
#
#
#
#
cd ../temp

if {[file exists work]} {
    puts stdout "There is a old work lib,it will be deleted." 
    file delete -force work
} else { 
    puts "There is no one old work library."
}

exec vlib work
exec vlib xilinxcorelib_ver
exec vlib unisims_ver
exec vlib unimacro_ver
exec vlib secureip

#set prj_dir "e:/Projects/project_20151030/VPX6_SFPGA_TOP/Projects/"
#set src_dir e:/projects/spi_master/src
#set tb_dir e:/projects/spi_master/tb
#set flist ../../flist/rtl_sim.f 
set flist ../../flist/rtl_sim_t.f 

#the "" is the must
set ise_dir "G:/Xilinx/14.7/ISE_DS/ISE"
set ise_src_dir $ise_dir/verilog/src

set testbench_name test_4_tb


puts stdout "Start to compiler the source."
# Compile the library

if {[file exists xilinxcorelib_ver]==0} {
    puts stdout "Re-compiler the library : xilinxcorelib_ver"
    exec vlog -work xilinxcorelib_ver    $ise_src_dir/XilinxCoreLib/*.v   
} else { 
    puts "the the library 'xilinxcorelib_ver' has been compilered." 
}

if {[file exists unimacro_ver]==0} {
    puts stdout "Re-compiler the library : unimacro_ver"
    exec vlog -work unimacro_ver         $ise_src_dir/unimacro/*.v   
} else { 
    puts "the the library 'unimacro_ver' has been compilered." 
}

if {[file exists unisims_ver]==0} {
    puts stdout "Re-compiler the library : unisims_ver"
    exec vlog -work unisims_ver          $ise_src_dir/unisims/*.v   
} else { 
    puts "the the library 'unisims_ver' has been compilered." 
}

if {[file exists secureip]==0} {
    puts stdout "Re-compiler the library : secureip"
    exec vlog -work secureip          -f $ise_dir/secureip/mti/mti_secureip.list.f   
} else { 
    puts "the the library 'secureip' has been compilered." 
}

exec vlog -work work $ise_src_dir/glbl.v

set vlog_inc +incdir+../../include/+../../../src/include/+../../../src/spi_flash_core
set vlog_tsc "-timescale 1ns/1ps"
set vlog_define "+define+SIM"

puts "Start to vlog the source."
catch {exec vlog $vlog_inc $vlog_define -timescale "1ns/1ps" -f $flist > vlog.log} fid
set fid
#file copy transcript transcript_vlog.do
#
#
# Compile sources
#
#exec vlog  $src_dir/spi_sim_master.v
#exec vlog  $tb_dir/testbench.v

#vlog  "$prj_dir/HDLFiles/UdpIpCore_V3/source/temac_connected_to_sgmii/mac_src/pselect_f.v"
#vlog  "$prj_dir/HDLFiles/UdpIpCore_V3/source/temac_connected_to_sgmii/mac_src/counter_f.v"
#vlog  "$prj_dir/HDLFiles/UdpIpCore_V3/source/temac_connected_to_sgmii/mac_src/address_decoder.v"
#vlog  "$prj_dir/HDLFiles/UdpIpCore_V3/source/temac_connected_to_sgmii/mac_src/slave_attachment.v"
#vlog  "$prj_dir/HDLFiles/UdpIpCore_V3/source/temac_connected_to_sgmii/mac_src/sync_block.v"
#vlog  "$prj_dir/HDLFiles/UdpIpCore_V3/source/temac_connected_to_sgmii/mac_src/axi_lite_ipif.v"
#vlog  "$prj_dir/HDLFiles/UdpIpCore_V3/source/temac_connected_to_sgmii/mac_src/vector_decode.v"
#vlog  "$prj_dir/HDLFiles/UdpIpCore_V3/source/temac_connected_to_sgmii/mac_src/tx_client_fifo.v"
#vlog  "$prj_dir/HDLFiles/UdpIpCore_V3/source/temac_connected_to_sgmii/mac_src/rx_client_fifo.v"<F2>
#vlog  "$prj_dir/HDLFiles/UdpIpCore_V3/source/temac_connected_to_sgmii/mac_src/reset_sync.v"
#vlog  "$prj_dir/HDLFiles/UdpIpCore_V3/source/temac_connected_to_sgmii/mac_src/axi4_lite_ipif_wrapper.v"
#vlog  "$prj_dir/HDLFiles/UdpIpCore_V3/source/temac_connected_to_sgmii/mac_src/tri_mode_eth_mac_v5_2_block.v"
#vlog  "$prj_dir/HDLFiles/UdpIpCore_V3/source/temac_connected_to_sgmii/mac_src/ten_100_1g_eth_fifo.v"
#vlog  "$prj_dir/HDLFiles/UdpIpCore_V3/source/temac_connected_to_sgmii/mac_src/tri_mode_eth_mac_v5_2_fifo_block.v"
#vlog  "$prj_dir/HDLFiles/UdpIpCore_V3/source/temac_connected_to_sgmii/mac_src/basic_pat_gen.v"
#vlog  "$prj_dir/HDLFiles/UdpIpCore_V3/source/temac_connected_to_sgmii/mac_src/axi_lite_sm.v"
#vlog  "$prj_dir/HDLFiles/UdpIpCore_V3/source/temac_connected_to_sgmii/coregen_files/tri_mode_eth_mac_v5_2.v"
#vlog  "$prj_dir/HDLFiles/UdpIpCore_V3/source/temac_connected_to_sgmii/coregen_files/gig_eth_pcs_pma_v11_2.v"
#vlog  "$prj_dir/HDLFiles/UdpIpCore_V3/source/temac_connected_to_sgmii/coregen_files/gig_eth_pcs_pma_v11_2/example_design/reset_sync.v"
#vlog  "$prj_dir/HDLFiles/UdpIpCore_V3/source/temac_connected_to_sgmii/coregen_files/gig_eth_pcs_pma_v11_2/example_design/gig_eth_pcs_pma_v11_2_block.v"
#vlog  "$prj_dir/HDLFiles/UdpIpCore_V3/source/temac_connected_to_sgmii/coregen_files/gig_eth_pcs_pma_v11_2/example_design/transceiver/gtwizard_gt.v"
#vlog  "$prj_dir/HDLFiles/UdpIpCore_V3/source/temac_connected_to_sgmii/coregen_files/gig_eth_pcs_pma_v11_2/example_design/transceiver/rx_elastic_buffer.v"
#vlog  "$prj_dir/HDLFiles/UdpIpCore_V3/source/temac_connected_to_sgmii/coregen_files/gig_eth_pcs_pma_v11_2/example_design/transceiver/gtwizard.v"
#vlog  "$prj_dir/HDLFiles/UdpIpCore_V3/source/temac_connected_to_sgmii/coregen_files/gig_eth_pcs_pma_v11_2/example_design/transceiver/transceiver.v"
#vlog  "$prj_dir/HDLFiles/UdpIpCore_V3/source/temac_connected_to_sgmii/coregen_files/gig_eth_pcs_pma_v11_2/example_design/sgmii_adapt/johnson_cntr.v"
#vlog  "$prj_dir/HDLFiles/UdpIpCore_V3/source/temac_connected_to_sgmii/coregen_files/gig_eth_pcs_pma_v11_2/example_design/sgmii_adapt/tx_rate_adapt.v"
#vlog  "$prj_dir/HDLFiles/UdpIpCore_V3/source/temac_connected_to_sgmii/coregen_files/gig_eth_pcs_pma_v11_2/example_design/sgmii_adapt/rx_rate_adapt.v"
#vlog  "$prj_dir/HDLFiles/UdpIpCore_V3/source/temac_connected_to_sgmii/coregen_files/gig_eth_pcs_pma_v11_2/example_design/sgmii_adapt/clk_gen.v"
#vlog  "$prj_dir/HDLFiles/UdpIpCore_V3/source/temac_connected_to_sgmii/coregen_files/gig_eth_pcs_pma_v11_2/example_design/sgmii_adapt/sgmii_adapt.v"
#vlog  "$prj_dir/HDLFiles/UdpIpCore_V3/ipcore/debug/ila_core.v"
#vlog  "d:/Xilinx/14.7/ISE_DS/ISE/verilog/src/glbl.v"
#
# Call vsim to invoke simulator
#
#vsim -voptargs="+acc" -t 1ps  -L xilinxcorelib_ver -L unisims_ver -L unimacro_ver -L secureip -lib work work.udpip_stack_top_tb glbl
#vsim -voptargs="+acc" -t 1ps  -L xilinxcorelib_ver  -L secureip -L unimacro_ver -lib work work.udpip_stack_top_tb glbl
#
#
#

#exec vopt +acc -o design_opt -debugdb
set wave_name sim


#
set vsim_lib "-L xilinxcorelib_ver -L unimacro_ver -L unisims_ver -L secureip"
set vsim_args \
"
    add wave -position insertpoint -divide Testbench;
    add wave -position insertpoint -hex -group top sim:/$testbench_name/*;
    add wave -position insertpoint -hex -group hmi_phy sim:/Testbench/hmi_phy/*
    add wave -position insertpoint -divide dut;
    add wave -position insertpoint -hex -group dut sim:/Testbench/dut/*

    add wave -position insertpoint -group hmi_mac_core sim:/Testbench/dut/hmi_ctrl_top/hmi_mac_core/*
    add wave -position insertpoint -group hmi_cmd_module  sim:/Testbench/dut/hmi_ctrl_top/hmi_cmd_module/*
    add wave -position insertpoint -group firmware_update_module sim:/Testbench/dut/hmi_ctrl_top/firmware_update_module/*
    add wave -position insertpoint -group trimac_localloik sim:/Testbench/dut/hmi_ctrl_top/hmi_mac_core/trimac_locallink/*

    add wave -position insertpoint -divide flash;
    add wave -position insertpoint -group spi_flash_core sim:/Testbench/dut/spi_flash_core/*
    add wave -position insertpoint -group spi_flash_tx sim:/Testbench/dut/spi_flash_core/spi_flash_tx/*
    add wave -position insertpoint -group spi_flash_rx sim:/Testbench/dut/spi_flash_core/spi_flash_rx/*
    
    run 400us
    add log -r /*
    archive write debug.dbar -wlf wave.wlf -include_src
"
#puts stdout "Start to sim the design."
#exec vsim -c -voptargs="+acc" -t 1ps -L xilinxcorelib_ver -L unimacro_ver -L unisims_ver -L secureip  -lib work work.$testbench_name glbl -do "$vsim_args" > vsim.log
#only one -i/-c/-gui can be used
exec vsim -gui -voptargs="+acc" -L xilinxcorelib_ver -L unimacro_ver -L unisims_ver -L secureip  -lib work work.$testbench_name glbl -do "$vsim_args" > vsim.log
#exec vsim -c -voptargs="+acc" -L xilinxcorelib_ver -L unimacro_ver -L unisims_ver -L secureip  -lib work work.$testbench_name glbl -do "$vsim_args" > vsim.log

#
# Source the wave do file
#
#puts stdout "Start to write the vcd file."
#exec vcd2wlf wave.vcd wave.wlf -ignorestderr
#catch {exec vcd2wlf wave.vcd wave.wlf} fid
#set fid



set vsim_args \
"
    archive load debug.dbar -wlf wave.wlf
    add wave -position insertpoint -divide Testbench;
    add wave -position insertpoint -hex -group top wave:/$testbench_name/*;
    add wave -position insertpoint -hex -group hmi_phy wave:/Testbench/hmi_phy/*
    add wave -position insertpoint -divide dut;
    add wave -position insertpoint -hex -group dut wave:/Testbench/dut/*
"
#
#Vsim can not invoke the modelsim,so use the 'modelsim' to replace it.
#
#exec vsim -do "$vsim_args" -view wave.wlf
#exec modelsim -voptargs="+acc" -do "$vsim_args" > modelsim.log

#
# Set the window types
#
#view wave
#view structure
#view signals
#
# Source the user do file
#
#do {udpip_stack_top_tb.udo}
#
# Run simulation for this time
#
#run 1000ns
#
# End
#


