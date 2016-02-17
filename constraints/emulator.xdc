################################## Clock Constraints ##########################
#create_clock -period 5.0 -waveform {0 2.5} [get_ports sysclk_in_p]
#create_generated_clock -name emulator/ttc_in/cheap320 -source [get_pins {emulator/mypll/inst/mmcm_adv_inst/CLKOUT0}] -divide_by 2 [get_pins {emulator/ttc_in/cheap320_reg/Q}]
create_generated_clock -name emulator/ttc_in/rclk -source [get_pins {emulator/mypll/clk_out1}] -divide_by 3 [get_pins {emulator/ttc_in/sample_reg/Q}] 
create_generated_clock -name emualtor/phase_pick/clk40_i -source [get_pins {emulator/ttc_in/sample_reg/Q}] -divide_by 4 [get_pins {emulator/phase_pick/clk_out_reg/Q}]
################################# Location constraints (Can be uncommented) ##################### 
#Reset input
set_property PACKAGE_PIN AB7 [get_ports rst]
set_property IOSTANDARD LVCMOS15 [get_ports rst]
#Sys/Rst Clk
set_property PACKAGE_PIN AD11 [get_ports sysclk_in_n]
#set_property PACKAGE_PIN C27 [get_ports sysclk_in_n]
set_property IOSTANDARD LVDS [get_ports sysclk_in_n]
set_property PACKAGE_PIN AD12 [get_ports sysclk_in_p]
#set_property PACKAGE_PIN D27 [get_ports sysclk_in_p]
set_property IOSTANDARD LVDS [get_ports sysclk_in_p]
#Emulator Ports
set_property PACKAGE_PIN G30 [get_ports ttc_data_n]
set_property IOSTANDARD LVDS_25 [get_ports ttc_data_n]
set_property PACKAGE_PIN H30 [get_ports ttc_data_p]
set_property IOSTANDARD LVDS_25 [get_ports ttc_data_p]
set_property PACKAGE_PIN C30 [get_ports cmd_out_n]
set_property IOSTANDARD LVDS_25 [get_ports cmd_out_n]
set_property PACKAGE_PIN D29 [get_ports cmd_out_p]
set_property IOSTANDARD LVDS_25 [get_ports cmd_out_p]
set_property PACKAGE_PIN F21 [get_ports trig_out]
set_property IOSTANDARD LVCMOS25 [get_ports trig_out]
#OFF-CHIP Ports
set_property PACKAGE_PIN D17 [get_ports clkin40]
set_property IOSTANDARD LVCMOS25 [get_ports clkin40]

set_property PACKAGE_PIN E21 [get_ports trigger]
set_property IOSTANDARD LVCMOS25 [get_ports trigger]
set_property PACKAGE_PIN C19 [get_ports command]
set_property IOSTANDARD LVCMOS25 [get_ports command]
set_property PACKAGE_PIN A28 [get_ports dataout_n]
set_property IOSTANDARD LVDS_25 [get_ports dataout_n]
set_property PACKAGE_PIN B28 [get_ports dataout_p]
set_property IOSTANDARD LVDS_25 [get_ports dataout_p]
#Placement controls
#set_property LOC BUFR_X0Y17 [get_cells ttc_in/BUFR_inst640]
#set_property LOC BUFR_X0Y18 [get_cells ttc_in/BUFR_inst320]
#set_property LOC BUFR_X0Y19 [get_cells ttc_in/BUFR_inst160]

#set_property LOC BUFG_X0Y17 [get_cells ttc_in/BUFG_inst640]
#set_property LOC BUFG_X0Y18 [get_cells ttc_in/BUFG_inst320]
#set_property LOC BUFG_X0Y19 [get_cells ttc_in/BUFG_inst160]
