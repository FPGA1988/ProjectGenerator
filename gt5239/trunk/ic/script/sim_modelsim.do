
vlib work
vmap work work 

vlog -work work G:/Xilinx/14.7/ISE_DS/ISE/verilog/src/glbl.v

vlog +incdir+../include/+../../src/include  -timescale "1ns/1ps" -f rtl_sim.f 


vsim -voptargs="+acc" -L XilinxCoreLib_ver -L unisims_ver glbl Testbench 

add wave -position insertpoint -group "spi_flash_tx" sim:/Testbench/uut/spi_flash_tx/*
add wave -divider divider-1
add wave -position insertpoint -group "spi_flash_rx" sim:/Testbench/uut/spi_flash_rx/* 
add wave -divider divider-2

configure wave -signalnamewidth 1

run 20us
