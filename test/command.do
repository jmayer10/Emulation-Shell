vlib work

vcom -work work ../RD53_Emulation/RD53_Emulation.srcs/sources_1/ip/fifo_generator_0/fifo_generator_0_funcsim.vhdl
vcom -work work ../RD53_Emulation/RD53_Emulation.srcs/sources_1/ip/cmd_oserdes/cmd_oserdes_funcsim.vhdl

vlog -work work ../src/command_out.v
vlog -work work cmd_out_tb.v

vsim -t 1pS -novopt cmd_out_tb -L unisim -L unifast

view signals
view wave

add wave -color Green -label {RST} /cmd_out_tb/rst
add wave -color Green -label {CLKIn40} /cmd_out_tb/clk40
add wave -color Green -label {CLKIn160} /cmd_out_tb/clk160
add wave -color Green -label {CLKIn640} /cmd_out_tb/clk640

add wave -color Blue -label {FIFO Full} /cmd_out_tb/fifo_full
add wave -color Blue -label {WR Cmd} /cmd_out_tb/wr_cmd
add wave -color Blue -label {Datain} -radix hexadecimal /cmd_out_tb/datain

add wave -color Orange -label {FIFO Valid} /cmd_out_tb/dut/word_valid
add wave -color Orange -label {FIFO Data} -radix hexadecimal /cmd_out_tb/dut/word_out
add wave -color Orange -label {RD En} /cmd_out_tb/dut/rd_cmd
add wave -color Orange -label {Top Not Bottom} /cmd_out_tb/dut/top_nbottom
add wave -color Orange -label {Cmd Not Sync} /cmd_out_tb/dut/cmd_nsync
add wave -color Orange -label {OSERDES In} -radix hexadecimal /cmd_out_tb/dut/oserdes_datain

add wave -color Yellow -label {Cmd Out P} /cmd_out_tb/cmd_out_p
add wave -color Yellow -label {Cmd Out N} /cmd_out_tb/cmd_out_n

run 2 us
