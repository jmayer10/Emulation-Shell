vlib work

vlog -work work ../src/SRL.v
vlog -work work srl_tb.v

vsim -t 1pS -novopt srl_tb

view signals
view wave

add wave -color Green /srl_tb/rst
add wave -color Green /srl_tb/clk
add wave -color Green -radix hexadecimal /srl_tb/datareg
add wave -color Green -radix unsigned /srl_tb/counter
add wave -color Green /srl_tb/datain
add wave -color Green /srl_tb/ctrl

add wave -color Blue -radix unsigned /srl_tb/srl16/shift_count
add wave -color Blue -radix binary /srl_tb/srl16/shift_reg
add wave -color Blue -radix binary /srl_tb/srl16/shift_mux

add wave -color Yellow -radix hexadecimal /srl_tb/data_out
add wave -color Yellow /srl_tb/valid

run 500ns
