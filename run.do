
vlib work


vlog spr.v
vlog Slave.v
vlog TOP.v
vlog SPI_tb.v


vsim -voptargs=+acc work.SPI_tb
add wave -position insertpoint sim:/SPI_tb/*

add wave -position insertpoint sim:/SPI_tb/DUT/*
add wave -position insertpoint sim:/SPI_tb/DUT/spi_slave/*
add wave -position insertpoint sim:/SPI_tb/DUT/ram/*



run 1000 ns