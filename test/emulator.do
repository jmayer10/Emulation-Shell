vlib work

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
vlog -work work emulator_tb.v
 
vsim -t 1pS -novopt emulator_tb -L unisim -L unifast

view signals
view wave

add wave -color Green -label {RST} /emulator_tb/rst
add wave -color Green -label {CLK200} /emulator_tb/clk200
add wave -color Green -label {CLK160} /emulator_tb/clk160
add wave -color Green -label {TTC Data} /emulator_tb/ttc_data


add wave -color Blue -label {TTC Data} /emulator_tb/Emulator/ttc_data
add wave -color Blue -label {MMCM Locked} /emulator_tb/Emulator/mmcm_locked
add wave -color Blue -label {RST or Lock} /emulator_tb/Emulator/rst_or_lock
add wave -color Blue -label {PLL CLK640} /emulator_tb/Emulator/ttc_in/clk640
add wave -color Blue -label {PLL CLK160} /emulator_tb/Emulator/ttc_in/clk160

add wave -noupdate -color Cyan -label {Sync Counts} -radix unsigned -subitemconfig {{/emulator_tb/Emulator/ttc_in/channel_align/sync_count[0]} {-color Cyan} {/emulator_tb/Emulator/ttc_in/channel_align/sync_count[0][5]} {-color Cyan} {/emulator_tb/Emulator/ttc_in/channel_align/sync_count[0][4]} {-color Cyan} {/emulator_tb/Emulator/ttc_in/channel_align/sync_count[0][3]} {-color Cyan} {/emulator_tb/Emulator/ttc_in/channel_align/sync_count[0][2]} {-color Cyan} {/emulator_tb/Emulator/ttc_in/channel_align/sync_count[0][1]} {-color Cyan} {/emulator_tb/Emulator/ttc_in/channel_align/sync_count[0][0]} {-color Cyan} {/emulator_tb/Emulator/ttc_in/channel_align/sync_count[1]} {-color Cyan} {/emulator_tb/Emulator/ttc_in/channel_align/sync_count[2]} {-color Cyan} {/emulator_tb/Emulator/ttc_in/channel_align/sync_count[3]} {-color Cyan} {/emulator_tb/Emulator/ttc_in/channel_align/sync_count[4]} {-color Cyan} {/emulator_tb/Emulator/ttc_in/channel_align/sync_count[5]} {-color Cyan} {/emulator_tb/Emulator/ttc_in/channel_align/sync_count[6]} {-color Cyan} {/emulator_tb/Emulator/ttc_in/channel_align/sync_count[7]} {-color Cyan} {/emulator_tb/Emulator/ttc_in/channel_align/sync_count[8]} {-color Cyan} {/emulator_tb/Emulator/ttc_in/channel_align/sync_count[9]} {-color Cyan} {/emulator_tb/Emulator/ttc_in/channel_align/sync_count[10]} {-color Cyan} {/emulator_tb/Emulator/ttc_in/channel_align/sync_count[11]} {-color Cyan} {/emulator_tb/Emulator/ttc_in/channel_align/sync_count[12]} {-color Cyan} {/emulator_tb/Emulator/ttc_in/channel_align/sync_count[13]} {-color Cyan} {/emulator_tb/Emulator/ttc_in/channel_align/sync_count[14]} {-color Cyan} {/emulator_tb/Emulator/ttc_in/channel_align/sync_count[15]} {-color Cyan}} /emulator_tb/Emulator/ttc_in/channel_align/sync_count
add wave -color Cyan -label {TTC Locked} /emulator_tb/Emulator/ttc_in/channel_align/locked_i
add wave -color Cyan -label {TTC DataOut} -radix hexadecimal /emulator_tb/Emulator/data_i
add wave -color Cyan -label {TTC DataValid} /emulator_tb/Emulator/valid_i
add wave -color Cyan -label {Other Counter} -radix unsigned /emulator_tb/other_counter

add wave -color Pink -label {Recovered CLK} -radix binary /emulator_tb/Emulator/rclk
add wave -color Pink -label {CLK40} -radix binary /emulator_tb/Emulator/clk40

add wave -color Orange -label {Output DataIn} -radix hexadecimal /emulator_tb/Emulator/cout/data_in
add wave -color Orange -label {WordValid} /emulator_tb/Emulator/cout/word_valid
add wave -color Orange -label {Output FIFO DataOut} -radix hexadecimal /emulator_tb/Emulator/cout/fifo_data_i
add wave -color Orange -label {FIFO Data Valid} /emulator_tb/Emulator/cout/fifo_data_valid
add wave -color Orange -label {FIFO Data Reg} -radix hexadecimal /emulator_tb/Emulator/cout/fifo_data
add wave -color Orange -label {Trig SR} /emulator_tb/Emulator/cout/trig_sr
add wave -color Orange -label {Trig Done} /emulator_tb/Emulator/cout/trig_done
add wave -color Orange -label {WR Cmd} /emulator_tb/Emulator/cout/wr_cmd
add wave -color Orange -label {RD FIFO} /emulator_tb/Emulator/cout/rd_word

add wave -color Yellow -label {Trig Out} /emulator_tb/trig_out
add wave -color Yellow -label {Cmd Out P} /emulator_tb/cmd_out_p
add wave -color Yellow -label {Cmd Out N} /emulator_tb/cmd_out_n

run 25us
