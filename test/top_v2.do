vlib work

vlog -work work ../src/SRL.v
vlog -work work ../src/shift_align.v
vlog -work work ../src/ttc_top.v 
vlog -work work ../../ttc_other.v
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
add wave -color Pink -label {DataReg1} -radix binary /tb_top_v2/chip1/ddrq_data
add wave -color Pink -label {DataIn1} -radix binary /tb_top_v2/chip1/data_in
add wave -color Pink -label {RCLK1} -radix binary /tb_top_v2/chip1/recovered_clk
#add wave -color Pink -label {Sample A} -radix binary /tb_top_v2/chip1/sampleA
#add wave -color Pink -label {Sample B} -radix binary /tb_top_v2/chip1/sampleB
#add wave -color Pink -label {Sample C} -radix binary /tb_top_v2/chip1/sampleC
#add wave -color Pink -label {Sample D} -radix binary /tb_top_v2/chip1/sampleD
#add wave -color Pink -label {Countx} -radix binary /tb_top_v2/chip1/countx

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
add wave /tb_top_v2/chip/clr_valid

add wave -color Yellow -label {UseA} -radix binary /tb_top_v2/chip1/usea
add wave -color Yellow -label {UseB} -radix binary /tb_top_v2/chip1/useb
add wave -color Yellow -label {UseC} -radix binary /tb_top_v2/chip1/usec
add wave -color Yellow -label {UseD} -radix binary /tb_top_v2/chip1/used
add wave -color Yellow -label {UseAint} -radix binary /tb_top_v2/chip1/useaint
add wave -color Yellow -label {UseBint} -radix binary /tb_top_v2/chip1/usebint
add wave -color Yellow -label {UseCint} -radix binary /tb_top_v2/chip1/usecint
add wave -color Yellow -label {UseDint} -radix binary /tb_top_v2/chip1/usedint

add wave -color Pink -label {Ctrl Reg} -radix binary /tb_top_v2/chip1/ctrl_reg1
add wave -color Pink -label {SR Data} -radix binary /tb_top_v2/chip1/srdata
add wave -color Blue -radix binary /tb_top_v2/chip1/channel_align/locked_i

add wave /tb_top_v2/chip1/valid_i

run 5 us
