################################## Clock Constraints ##########################
create_clock -period 16.667 [get_ports sysclk_in_p]

# User Clock Constraints
create_clock -period 5.0 [get_pins -hier -filter {name=~*gt0_gtwizard_0_i*gtxe2_i*TXOUTCLK}]
#set_false_path -to [get_cells -hierarchical -filter {NAME =~ *sync*/data_sync_reg1}]
#set_false_path -from [get_clocks -include_generated_clocks -of_objects [get_pins -hier -filter {name=~*gt_usrclk_source*DRP_CLK_BUFG*I}]] -to [get_clocks -include_generated_clocks -of_objects [get_pins -hier -filter {name=~*gt0_gtwizard_0_i*gtxe2_i*TXOUTCLK}]]
#set_false_path -from [get_clocks -include_generated_clocks -of_objects [get_pins -hier -filter {name=~*gt0_gtwizard_0_i*gtxe2_i*TXOUTCLK}]] -to [get_clocks -include_generated_clocks -of_objects [get_pins -hier -filter {name=~*gt_usrclk_source*DRP_CLK_BUFG*I}]]


set_false_path -to [get_cells -hierarchical -filter {NAME =~ *data_sync_reg1}]

set_false_path -to [get_cells -hierarchical -filter {NAME =~ *ack_sync_reg1}]



####################### GT reference clock constraints #########################
 

#create_clock -period 5.0 [get_ports q3_clk0_gtrefclk_pad_p_in]


#create_clock -name GT0_GTREFCLK0_IN -period 5.0 [get_pins -hier -filter {name=~*gt0_gtwizard_0_i*gtxe2_i*GTREFCLK0}]

################################# Location constraints (Can be uncommented) ##################### 
#Reset input
set_property PACKAGE_PIN AB7 [get_ports reset]
set_property IOSTANDARD LVCMOS15 [get_ports reset]
#GBT Clock from HPC FMC
set_property PACKAGE_PIN C7 [get_ports q3_clk0_gtrefclk_pad_n_in] 
set_property LOC C7 [get_ports q3_clk0_gtrefclk_pad_n_in] 
set_property PACKAGE_PIN C8 [get_ports q3_clk0_gtrefclk_pad_p_in]
set_property LOC C8 [get_ports q3_clk0_gtrefclk_pad_p_in]
#Sys/Rst Clk
set_property PACKAGE_PIN AD11 [get_ports sysclk_in_n]
set_property IOSTANDARD LVDS [get_ports sysclk_in_n]
set_property PACKAGE_PIN AD12 [get_ports sysclk_in_p]
set_property IOSTANDARD LVDS [get_ports sysclk_in_p]
#TX outputs on HPC FMC
set_property PACKAGE_PIN D1 [get_ports out_n]
set_property PACKAGE_PIN D2 [get_ports out_p]

#set_property PACKAGE_PIN C3 [get_ports out_n]
#set_property PACKAGE_PIN C4 [get_ports out_p]
#set_property PACKAGE_PIN B1 [get_ports out_n]
#set_property PACKAGE_PIN B2 [get_ports out_p]
#set_property PACKAGE_PIN A3 [get_ports out_n]
#set_property PACKAGE_PIN A4 [get_ports out_p]
#TTC Input (Random for now)
set_property PACKAGE_PIN B25 [get_ports ttc_datan]
set_property IOSTANDARD LVDS_25 [get_ports ttc_datan]
set_property PACKAGE_PIN C25 [get_ports ttc_datap]
set_property IOSTANDARD LVDS_25 [get_ports ttc_datap]
