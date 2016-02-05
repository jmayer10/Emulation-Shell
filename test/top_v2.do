vlib work

vlog -work work ../src/on_chip/SRL.v
vlog -work work ../src/on_chip/shift_align.v
vlog -work work ../src/on_chip/ttc_top.v 
vlog -work work tb_top_v2.v

vsim -t 1pS -novopt tb_top_v2 -L unisim

view signals
view wave

add wave -label {CLK160} /tb_top_v2/chip/clk160
add wave -label {CLK320} /tb_top_v2/chip/clk320
add wave -label {CLK640} /tb_top_v2/chip/clk640
add wave -color Pink -label {DataReg0} -radix binary /tb_top_v2/chip/ddrq_data
add wave -color Pink -label {DataIn0} -radix binary /tb_top_v2/chip/data_in
add wave -color Pink -label {RCLK0} -radix binary /tb_top_v2/chip/recovered_clk

add wave /tb_top_v2/rstin
add wave -hexadecimal /tb_top_v2/datareg
add wave /tb_top_v2/datain

add wave -label {CLK40} /tb_top_v2/clk40
add wave -hexadecimal /tb_top_v2/dataout
add wave /tb_top_v2/valid
add wave -label {CLK401} /tb_top_v2/clk401
add wave -hexadecimal /tb_top_v2/dataout1
add wave /tb_top_v2/valid1

add wave -color Yellow -label {UseA} -radix binary /tb_top_v2/chip/usea
add wave -color Yellow -label {UseB} -radix binary /tb_top_v2/chip/useb
add wave -color Yellow -label {UseC} -radix binary /tb_top_v2/chip/usec
add wave -color Yellow -label {UseD} -radix binary /tb_top_v2/chip/used
add wave -color Yellow -label {UseAint} -radix binary /tb_top_v2/chip/useaint
add wave -color Yellow -label {UseBint} -radix binary /tb_top_v2/chip/usebint
add wave -color Yellow -label {UseCint} -radix binary /tb_top_v2/chip/usecint
add wave -color Yellow -label {UseDint} -radix binary /tb_top_v2/chip/usedint

add wave -color Pink -label {Ctrl Reg} -radix binary /tb_top_v2/chip/ctrl_reg1
add wave -color Pink -label {SR Data} -radix binary /tb_top_v2/chip/srdata
add wave -noupdate -color Blue -radix unsigned -subitemconfig {{/tb_top_v2/chip/channel_align/sync_count[0]} {-color Blue} {/tb_top_v2/chip/channel_align/sync_count[0][5]} {-color Blue} {/tb_top_v2/chip/channel_align/sync_count[0][4]} {-color Blue} {/tb_top_v2/chip/channel_align/sync_count[0][3]} {-color Blue} {/tb_top_v2/chip/channel_align/sync_count[0][2]} {-color Blue} {/tb_top_v2/chip/channel_align/sync_count[0][1]} {-color Blue} {/tb_top_v2/chip/channel_align/sync_count[0][0]} {-color Blue} {/tb_top_v2/chip/channel_align/sync_count[1]} {-color Blue} {/tb_top_v2/chip/channel_align/sync_count[2]} {-color Blue} {/tb_top_v2/chip/channel_align/sync_count[3]} {-color Blue} {/tb_top_v2/chip/channel_align/sync_count[4]} {-color Blue} {/tb_top_v2/chip/channel_align/sync_count[5]} {-color Blue} {/tb_top_v2/chip/channel_align/sync_count[6]} {-color Blue} {/tb_top_v2/chip/channel_align/sync_count[7]} {-color Blue} {/tb_top_v2/chip/channel_align/sync_count[8]} {-color Blue} {/tb_top_v2/chip/channel_align/sync_count[9]} {-color Blue} {/tb_top_v2/chip/channel_align/sync_count[10]} {-color Blue} {/tb_top_v2/chip/channel_align/sync_count[11]} {-color Blue} {/tb_top_v2/chip/channel_align/sync_count[12]} {-color Blue} {/tb_top_v2/chip/channel_align/sync_count[13]} {-color Blue} {/tb_top_v2/chip/channel_align/sync_count[14]} {-color Blue} {/tb_top_v2/chip/channel_align/sync_count[15]} {-color Blue}} /tb_top_v2/chip/channel_align/sync_count
add wave -color Blue -radix binary /tb_top_v2/chip/channel_align/locked_i

add wave /tb_top_v2/chip/valid_i

run 5 us
