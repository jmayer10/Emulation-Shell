vlib work

vlog -work work ../src/shift_align.v
vlog -work work shiftalign_tb.v

vsim -t 1pS -novopt shiftalign_tb

view signals
view wave

add wave -color Green /shiftalign_tb/rst
add wave -color Green /shiftalign_tb/clk
add wave -color Green /shiftalign_tb/valid_in
add wave -color Green -radix hexadecimal /shiftalign_tb/datain

add wave -color Blue -radix binary /shiftalign_tb/SA/locked_i
add wave -color Blue -radix binary /shiftalign_tb/SA/rst_all
add wave -color Blue -radix binary /shiftalign_tb/SA/rst_other
add wave -color Blue -radix binary /shiftalign_tb/SA/rst_count
add wave -color Blue -radix hexadecimal /shiftalign_tb/SA/data_i
add wave -color Blue -radix binary /shiftalign_tb/SA/valid_i
add wave -noupdate -color Blue -radix hexadecimal -subitemconfig {{/shiftalign_tb/SA/sync_count[0]} {-color Blue} {/shiftalign_tb/SA/sync_count[0][5]} {-color Blue} {/shiftalign_tb/SA/sync_count[0][4]} {-color Blue} {/shiftalign_tb/SA/sync_count[0][3]} {-color Blue} {/shiftalign_tb/SA/sync_count[0][2]} {-color Blue} {/shiftalign_tb/SA/sync_count[0][1]} {-color Blue} {/shiftalign_tb/SA/sync_count[0][0]} {-color Blue} {/shiftalign_tb/SA/sync_count[1]} {-color Blue} {/shiftalign_tb/SA/sync_count[2]} {-color Blue} {/shiftalign_tb/SA/sync_count[3]} {-color Blue} {/shiftalign_tb/SA/sync_count[4]} {-color Blue} {/shiftalign_tb/SA/sync_count[5]} {-color Blue} {/shiftalign_tb/SA/sync_count[6]} {-color Blue} {/shiftalign_tb/SA/sync_count[7]} {-color Blue} {/shiftalign_tb/SA/sync_count[8]} {-color Blue} {/shiftalign_tb/SA/sync_count[9]} {-color Blue} {/shiftalign_tb/SA/sync_count[10]} {-color Blue} {/shiftalign_tb/SA/sync_count[11]} {-color Blue} {/shiftalign_tb/SA/sync_count[12]} {-color Blue} {/shiftalign_tb/SA/sync_count[13]} {-color Blue} {/shiftalign_tb/SA/sync_count[14]} {-color Blue} {/shiftalign_tb/SA/sync_count[15]} {-color Blue}} /shiftalign_tb/SA/sync_count

add wave -color Yellow -radix hexadecimal /shiftalign_tb/dataout
add wave -color Yellow /shiftalign_tb/valid

run 700ns
