vlib work

vlog -work work ../src/off_chip/LFSR.v
vcom -work work ../RD53_Emulation/RD53_Emulation.srcs/sources_1/ip/cmd_fifo/cmd_fifo_funcsim.vhdl
vlog -work work ../src/off_chip/cmd_top.v
vlog -work work ../src/off_chip/sync_timer.v
vlog -work work ../src/off_chip/triggerunit.v
vlog -work work ../src/off_chip/SER.v
vcom -work work ../RD53_Emulation/RD53_Emulation.srcs/sources_1/ip/off_chip_pll/off_chip_pll_funcsim.vhdl
vlog -work work ../src/off_chip/off_chip_top.v

vlog -work work off_chip_tb.v

vsim -t 1pS -novopt off_chip_tb -L unisim -L unifast

view signals
view wave

add wave -color Green -label {RST} /off_chip_tb/rst
add wave -color Green -label {CLKIn40} /off_chip_tb/clk40
add wave -color Green -label {Shift In} /off_chip_tb/shift_in
add wave -color Green -label {Trigger} /off_chip_tb/trig
add wave -color Green -label {Command} /off_chip_tb/cmd

add wave -color Blue -label {CLK40} /off_chip_tb/nchip/clk40
add wave -color Blue -label {CLK160} /off_chip_tb/nchip/clk160
add wave -color Blue -label {PLL Lock} /off_chip_tb/nchip/pll_locked
add wave -color Blue -label {Lock Count} -radix unsigned /off_chip_tb/nchip/lock_count
add wave -color Blue -label {Hold Till Lock} /off_chip_tb/nchip/hold_while_locking

add wave -color Cyan -label {Trigger In} /off_chip_tb/nchip/trig_ii
add wave -color Cyan -label {Trig SR40} /off_chip_tb/nchip/trig_handler/trig_sr40
add wave -color Cyan -label {Trig Cnt} /off_chip_tb/nchip/trig_handler/trig_cnt
add wave -color Cyan -label {Trig Load} /off_chip_tb/nchip/trig_handler/trig_load
add wave -color Cyan -label {Trig SR160} /off_chip_tb/nchip/trig_handler/trig_sr160
add wave -color Cyan -label {Trig Present} /off_chip_tb/nchip/trig_handler/trig_pres
add wave -color Cyan -label {Trigger CLR} /off_chip_tb/nchip/trig_clr
add wave -color Cyan -label {Encoded Trig} -radix hexadecimal /off_chip_tb/nchip/trig_handler/encoded_trig

add wave -color Pink -label {Sync Count} -radix unsigned /off_chip_tb/nchip/syncer/sync_count
add wave -color Pink -label {Sync Ready} /off_chip_tb/nchip/syncer/sync_rdy
add wave -color Pink -label {Sync Sent} /off_chip_tb/nchip/sync_sent_i

add wave -color Purple -label {Gen CMD} /off_chip_tb/nchip/cmd_ii
add wave -color Purple -label {WR CMD} /off_chip_tb/nchip/command_top/wr_cmd
add wave -color Purple -label {LFSR Data} -radix hexadecimal /off_chip_tb/nchip/command_top/lfsr_data
add wave -color Purple -label {Read CMD} /off_chip_tb/nchip/get_cmd_i
add wave -color Purple -label {CMD Ready} /off_chip_tb/nchip/cmd_rdy
add wave -color Purple -label {CMD Full} /off_chip_tb/nchip/command_top/fifo_full
add wave -color Purple -label {CMD Data} -radix hexadecimal /off_chip_tb/nchip/cmd_data

add wave -color Orange -label {Next State} /off_chip_tb/nchip/next_state
add wave -color Orange -label {Pres State} /off_chip_tb/nchip/pres_state
add wave -color Orange -label {Word Sent} /off_chip_tb/nchip/word_sent
add wave -color Orange -label {Ser Data} -radix hexadecimal /off_chip_tb/nchip/ser_data_i
add wave -color Orange -label {Ser Count} -radix unsigned /off_chip_tb/nchip/serializer/count
add wave -color Orange -label {Ser Out} -radix hexadecimal /off_chip_tb/nchip/serializer/shift_reg

add wave -color Yellow -label {Dataout} /off_chip_tb/dataout

run 5 us
