vlib work

vcom -work work ../RD53_Emulation/RD53_Emulation.srcs/sources_1/ip/fifo_generator_0/fifo_generator_0_funcsim.vhdl
vlog -work work ../src/fifo_controller.v
vlog -work work fifo_controller_tb.v

vsim -t 1pS -novopt fifo_controller_tb -L unisim

view signals
view wave

add wave -color Green -label {RST} /fifo_controller_tb/rst
add wave -color Green -label {Clk160} /fifo_controller_tb/clk160
add wave -color Green -label {TxClk} /fifo_controller_tb/txusrclk
add wave -color Green -label {TxReady} /fifo_controller_tb/tx_ready
add wave -color Green -label {DataIn} -radix hexadecimal /fifo_controller_tb/datain
add wave -color Green -label {DataIn Valid} /fifo_controller_tb/datain_valid

add wave -color Pink -label {FIFO DataOut} -radix hexadecimal /fifo_controller_tb/comptroller/fifo_dataout
add wave -color Pink -label {FIFO DataOut Valid} /fifo_controller_tb/comptroller/fifo_data_valid
add wave -color Pink -label {Read FIFO} /fifo_controller_tb/comptroller/rd_fifo

add wave -color Yellow -label {FIFO full} /fifo_controller_tb/fifo_full
add wave -color Yellow -label {ClrValid} /fifo_controller_tb/clr_valid
add wave -color Yellow -label {DataOut} -radix hexadecimal /fifo_controller_tb/dataout
add wave -color Yellow -label {DataOut Valid} /fifo_controller_tb/dataout_valid

run 250ns
