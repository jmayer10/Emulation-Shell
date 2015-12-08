vlib work

vcom -work work ../RD53_Emulation/RD53_Emulation.srcs/sources_1/ip/fifo_generator_0/fifo_generator_0_funcsim.vhdl
vlog -work work ../src/fifo_controller.v

vlog -work work ../src/SRL.v
vlog -work work ../src/shift_align.v
vlog -work work ../src/ttc_top.v 

vcom -work work ../RD53_Emulation/RD53_Emulation.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_funcsim.vhdl

vcom -work work ../RD53_Emulation/RD53_Emulation.srcs/sources_1/ip/gtwizard_0/gtwizard_0_funcsim.vhdl

vlog -work work ../src/RD53_top.v
vlog -work work emulator_tb.v

vsim -t 1pS -novopt emulator_tb -L unisim -L unifast

view signals
view wave

add wave -color Green -label {RST} /emulator_tb/rst
add wave -color Green -label {CLK200} /emulator_tb/clk200
add wave -color Green -label {CLK160} /emulator_tb/clk160
add wave -color Green -label {CLK156} /emulator_tb/clk156
add wave -color Green -label {TTC Data} /emulator_tb/ttc_data


add wave -color Blue -label {TTC Data} /emulator_tb/Emulator/datain
add wave -color Blue -label {TxReady} /emulator_tb/Emulator/tx_rst_done
add wave -color Blue -label {Tx MMCM Locked} /emulator_tb/Emulator/tx_locked
add wave -color Blue -label {TxUsrClk2} /emulator_tb/Emulator/txusrclk2
add wave -color Blue -label {MMCM Locked} /emulator_tb/Emulator/mmcm_locked
add wave -color Blue -label {PLL CLK160} /emulator_tb/Emulator/clk160
add wave -color Blue -label {PLL CLK320} /emulator_tb/Emulator/clk320

add wave -noupdate -color Cyan -label {Sync Counts} -radix unsigned -subitemconfig {{/emulator_tb/Emulator/ttc_in/channel_align/sync_count[0]} {-color Cyan} {/emulator_tb/Emulator/ttc_in/channel_align/sync_count[0][5]} {-color Cyan} {/emulator_tb/Emulator/ttc_in/channel_align/sync_count[0][4]} {-color Cyan} {/emulator_tb/Emulator/ttc_in/channel_align/sync_count[0][3]} {-color Cyan} {/emulator_tb/Emulator/ttc_in/channel_align/sync_count[0][2]} {-color Cyan} {/emulator_tb/Emulator/ttc_in/channel_align/sync_count[0][1]} {-color Cyan} {/emulator_tb/Emulator/ttc_in/channel_align/sync_count[0][0]} {-color Cyan} {/emulator_tb/Emulator/ttc_in/channel_align/sync_count[1]} {-color Cyan} {/emulator_tb/Emulator/ttc_in/channel_align/sync_count[2]} {-color Cyan} {/emulator_tb/Emulator/ttc_in/channel_align/sync_count[3]} {-color Cyan} {/emulator_tb/Emulator/ttc_in/channel_align/sync_count[4]} {-color Cyan} {/emulator_tb/Emulator/ttc_in/channel_align/sync_count[5]} {-color Cyan} {/emulator_tb/Emulator/ttc_in/channel_align/sync_count[6]} {-color Cyan} {/emulator_tb/Emulator/ttc_in/channel_align/sync_count[7]} {-color Cyan} {/emulator_tb/Emulator/ttc_in/channel_align/sync_count[8]} {-color Cyan} {/emulator_tb/Emulator/ttc_in/channel_align/sync_count[9]} {-color Cyan} {/emulator_tb/Emulator/ttc_in/channel_align/sync_count[10]} {-color Cyan} {/emulator_tb/Emulator/ttc_in/channel_align/sync_count[11]} {-color Cyan} {/emulator_tb/Emulator/ttc_in/channel_align/sync_count[12]} {-color Cyan} {/emulator_tb/Emulator/ttc_in/channel_align/sync_count[13]} {-color Cyan} {/emulator_tb/Emulator/ttc_in/channel_align/sync_count[14]} {-color Cyan} {/emulator_tb/Emulator/ttc_in/channel_align/sync_count[15]} {-color Cyan}} /emulator_tb/Emulator/ttc_in/channel_align/sync_count
add wave -color Cyan -label {TTC Locked} /emulator_tb/Emulator/ttc_in/channel_align/locked_i
add wave -color Cyan -label {TTC DataOut} -radix hexadecimal /emulator_tb/Emulator/data_i
add wave -color Cyan -label {TTC DataValid} /emulator_tb/Emulator/valid_i
add wave -color Cyan -label {FIFO Full} /emulator_tb/Emulator/comptroller/fifo_full
add wave -color Cyan -label {Other Counter} -radix unsigned /emulator_tb/other_counter
add wave -color Cyan -label {FIFO DataOut} -radix hexadecimal /emulator_tb/Emulator/comptroller/fifo_dataout
add wave -color Cyan -label {FIFO OutValid} /emulator_tb/Emulator/comptroller/fifo_data_valid


add wave -color Yellow -label {DataOut} /emulator_tb/dataout

run 25us
