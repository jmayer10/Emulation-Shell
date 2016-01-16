vlib work

#OFF_CHIP
vlog -work work ../src/off_chip/LFSR.v
vcom -work work ../RD53_Emulation/RD53_Emulation.srcs/sources_1/ip/cmd_fifo/cmd_fifo_funcsim.vhdl
vlog -work work ../src/off_chip/cmd_top.v
vlog -work work ../src/off_chip/sync_timer.v
vlog -work work ../src/off_chip/triggerunit.v
vlog -work work ../src/off_chip/SER.v
vcom -work work ../RD53_Emulation/RD53_Emulation.srcs/sources_1/ip/off_chip_pll/off_chip_pll_funcsim.vhdl
vlog -work work ../src/off_chip/off_chip_top.v

#ON_CHIP
vlog -work work ../src/on_chip/SRL.v
vlog -work work ../src/on_chip/shift_align.v
vlog -work work ../src/on_chip/clock_picker.v 
vlog -work work ../src/on_chip/ttc_top.v 
vlog -work work ../src/on_chip/trigger_out.v
vcom -work work ../RD53_Emulation/RD53_Emulation.srcs/sources_1/ip/fifo_generator_0/fifo_generator_0_funcsim.vhdl
vcom -work work ../RD53_Emulation/RD53_Emulation.srcs/sources_1/ip/cmd_oserdes/cmd_oserdes_funcsim.vhdl
vlog -work work ../src/on_chip/command_out.v
vlog -work work ../src/on_chip/chip_output.v
vcom -work work ../RD53_Emulation/RD53_Emulation.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_funcsim.vhdl
vlog -work work ../src/on_chip/RD53_top.v

vlog -work work ../src/perf_counter.v
vlog -work work ../src/sys_top.v
vlog -work work sys_tb.v

vsim -t 1pS -novopt sys_tb -L unisim -L unifast

view signals
view wave

############################# OFF_CHIP SIGNALS ##############################################
add wave -color Green -label {RST} /sys_tb/rst
add wave -color Green -label {CLKIn40} /sys_tb/clk40
add wave -color Green -label {Shift In} /sys_tb/shift_in
add wave -color Green -label {Trigger} /sys_tb/trig
add wave -color Green -label {Command} /sys_tb/cmd

add wave -color Blue -label {CLK40} /sys_tb/dut/ext/clk40
add wave -color Blue -label {CLK160} /sys_tb/dut/ext/clk160
add wave -color Blue -label {PLL Lock} /sys_tb/dut/ext/pll_locked
add wave -color Blue -label {Lock Count} -radix unsigned /sys_tb/dut/ext/lock_count
add wave -color Blue -label {Hold Till Lock} /sys_tb/dut/ext/hold_while_locking

add wave -color Cyan -label {Trigger In} /sys_tb/dut/ext/trig_ii
add wave -color Cyan -label {Trig SR40} /sys_tb/dut/ext/trig_handler/trig_sr40
add wave -color Cyan -label {Trig Cnt} /sys_tb/dut/ext/trig_handler/trig_cnt
add wave -color Cyan -label {Trig Load} /sys_tb/dut/ext/trig_handler/trig_load
add wave -color Cyan -label {Trig SR160} /sys_tb/dut/ext/trig_handler/trig_sr160
add wave -color Cyan -label {Trig Present} /sys_tb/dut/ext/trig_handler/trig_pres
add wave -color Cyan -label {Trigger CLR} /sys_tb/dut/ext/trig_clr
add wave -color Cyan -label {Encoded Trig} -radix hexadecimal /sys_tb/dut/ext/trig_handler/encoded_trig

add wave -color Pink -label {Sync Count} -radix unsigned /sys_tb/dut/ext/syncer/sync_count
add wave -color Pink -label {Sync Ready} /sys_tb/dut/ext/syncer/sync_rdy
add wave -color Pink -label {Sync Sent} /sys_tb/dut/ext/sync_sent_i

add wave -color Purple -label {Gen CMD} /sys_tb/dut/ext/cmd_ii
add wave -color Purple -label {WR CMD} /sys_tb/dut/ext/command_top/wr_cmd
add wave -color Purple -label {LFSR Data} -radix hexadecimal /sys_tb/dut/ext/command_top/lfsr_data
add wave -color Purple -label {Read CMD} /sys_tb/dut/ext/get_cmd_i
add wave -color Purple -label {CMD Ready} /sys_tb/dut/ext/cmd_rdy
add wave -color Purple -label {CMD FIFO Data Count} -radix unsigned /sys_tb/dut/ext/command_top/data_count
add wave -color Purple -label {CMD Full} /sys_tb/dut/ext/command_top/fifo_full
add wave -color Purple -label {CMD Data} -radix hexadecimal /sys_tb/dut/ext/cmd_data

add wave -color Orange -label {Next State} /sys_tb/dut/ext/next_state
add wave -color Orange -label {Pres State} /sys_tb/dut/ext/pres_state
add wave -color Orange -label {Word Sent} /sys_tb/dut/ext/word_sent
add wave -color Orange -label {Ser Data} -radix hexadecimal /sys_tb/dut/ext/ser_data_i
add wave -color Orange -label {Ser Count} -radix unsigned /sys_tb/dut/ext/serializer/count
add wave -color Orange -label {Ser Out} -radix hexadecimal /sys_tb/dut/ext/serializer/shift_reg

add wave -color Yellow -label {Dataout P} /sys_tb/dut/ext/dataout_p
add wave -color Yellow -label {Dataout N} /sys_tb/dut/ext/dataout_n

############################## ON_CHIP SIGNALS ##############################################
add wave -color Green -label {RST} /sys_tb/rst
add wave -color Green -label {CLK200} /sys_tb/clk200
add wave -color Green -label {CLK160} /sys_tb/clk160
add wave -color Green -label {TTC Data P} /sys_tb/data_p
add wave -color Green -label {TTC Data N} /sys_tb/data_n

add wave -color Blue -label {TTC Data} /sys_tb/dut/emulator/ttc_data
add wave -color Blue -label {MMCM Locked} /sys_tb/dut/emulator/mmcm_locked
add wave -color Blue -label {RST or Lock} /sys_tb/dut/emulator/rst_or_lock
add wave -color Blue -label {PLL CLK640} /sys_tb/dut/emulator/ttc_in/clk640
add wave -color Blue -label {PLL CLK160} /sys_tb/dut/emulator/ttc_in/clk160

add wave -noupdate -color Cyan -label {Sync Counts} -radix unsigned -subitemconfig {{/sys_tb/dut/emulator/ttc_in/channel_align/sync_count[0]} {-color Cyan} {/sys_tb/dut/emulator/ttc_in/channel_align/sync_count[0][5]} {-color Cyan} {/sys_tb/dut/emulator/ttc_in/channel_align/sync_count[0][4]} {-color Cyan} {/sys_tb/dut/emulator/ttc_in/channel_align/sync_count[0][3]} {-color Cyan} {/sys_tb/dut/emulator/ttc_in/channel_align/sync_count[0][2]} {-color Cyan} {/sys_tb/dut/emulator/ttc_in/channel_align/sync_count[0][1]} {-color Cyan} {/sys_tb/dut/emulator/ttc_in/channel_align/sync_count[0][0]} {-color Cyan} {/sys_tb/dut/emulator/ttc_in/channel_align/sync_count[1]} {-color Cyan} {/sys_tb/dut/emulator/ttc_in/channel_align/sync_count[2]} {-color Cyan} {/sys_tb/dut/emulator/ttc_in/channel_align/sync_count[3]} {-color Cyan} {/sys_tb/dut/emulator/ttc_in/channel_align/sync_count[4]} {-color Cyan} {/sys_tb/dut/emulator/ttc_in/channel_align/sync_count[5]} {-color Cyan} {/sys_tb/dut/emulator/ttc_in/channel_align/sync_count[6]} {-color Cyan} {/sys_tb/dut/emulator/ttc_in/channel_align/sync_count[7]} {-color Cyan} {/sys_tb/dut/emulator/ttc_in/channel_align/sync_count[8]} {-color Cyan} {/sys_tb/dut/emulator/ttc_in/channel_align/sync_count[9]} {-color Cyan} {/sys_tb/dut/emulator/ttc_in/channel_align/sync_count[10]} {-color Cyan} {/sys_tb/dut/emulator/ttc_in/channel_align/sync_count[11]} {-color Cyan} {/sys_tb/dut/emulator/ttc_in/channel_align/sync_count[12]} {-color Cyan} {/sys_tb/dut/emulator/ttc_in/channel_align/sync_count[13]} {-color Cyan} {/sys_tb/dut/emulator/ttc_in/channel_align/sync_count[14]} {-color Cyan} {/sys_tb/dut/emulator/ttc_in/channel_align/sync_count[15]} {-color Cyan}} /sys_tb/dut/emulator/ttc_in/channel_align/sync_count
add wave -color Cyan -label {TTC Locked} /sys_tb/dut/emulator/ttc_in/channel_align/locked_i
add wave -color Cyan -label {TTC DataOut} -radix hexadecimal /sys_tb/dut/emulator/data_i
add wave -color Cyan -label {TTC DataValid} /sys_tb/dut/emulator/valid_i

add wave -color Pink -label {Recovered CLK} -radix binary /sys_tb/dut/emulator/rclk
add wave -color Pink -label {CLK40} -radix binary /sys_tb/dut/emulator/clk40

add wave -color Orange -label {Output DataIn} -radix hexadecimal /sys_tb/dut/emulator/cout/data_in
add wave -color Orange -label {WordValid} /sys_tb/dut/emulator/cout/word_valid
add wave -color Orange -label {Output FIFO DataOut} -radix hexadecimal /sys_tb/dut/emulator/cout/fifo_data_i
add wave -color Orange -label {FIFO Data Valid} /sys_tb/dut/emulator/cout/fifo_data_valid
add wave -color Orange -label {FIFO Data Reg} -radix hexadecimal /sys_tb/dut/emulator/cout/fifo_data
add wave -color Orange -label {Trig SR} /sys_tb/dut/emulator/cout/trig_sr
add wave -color Orange -label {Trig Done} /sys_tb/dut/emulator/cout/trig_done
add wave -color Orange -label {WR Cmd} /sys_tb/dut/emulator/cout/wr_cmd
add wave -color Orange -label {RD FIFO} /sys_tb/dut/emulator/cout/rd_word

add wave -color Orange -label {OSERDES Datain} -radix hexadecimal /sys_tb/dut/emulator/cout/cmd_proc/oserdes_datain

add wave -color Yellow -label {Trig Out} /sys_tb/trig_out
add wave -color Yellow -label {Cmd Out P} /sys_tb/cmd_out_p
add wave -color Yellow -label {Cmd Out N} /sys_tb/cmd_out_n

add wave -color Purple -label {Perf Count} -radix unsigned /sys_tb/dut/perf0/counter

run 20 us
