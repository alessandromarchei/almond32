###################################################################

# Created by write_sdc on Thu Oct 19 01:02:20 2023

###################################################################
set sdc_version 2.1

set_units -time ns -resistance MOhm -capacitance fF -voltage V -current mA
set_wire_load_model -name 5K_hvratio_1_4 -library NangateOpenCellLibrary
create_clock [get_ports Clk]  -name MY_CLK  -period 1.5  -waveform {0 0.75}
set_clock_uncertainty 0.05  [get_clocks MY_CLK]
set_max_delay 1.5  -from [list [get_ports Clk] [get_ports Rst] [get_ports {DATA_IN[31]}]         \
[get_ports {DATA_IN[30]}] [get_ports {DATA_IN[29]}] [get_ports {DATA_IN[28]}]  \
[get_ports {DATA_IN[27]}] [get_ports {DATA_IN[26]}] [get_ports {DATA_IN[25]}]  \
[get_ports {DATA_IN[24]}] [get_ports {DATA_IN[23]}] [get_ports {DATA_IN[22]}]  \
[get_ports {DATA_IN[21]}] [get_ports {DATA_IN[20]}] [get_ports {DATA_IN[19]}]  \
[get_ports {DATA_IN[18]}] [get_ports {DATA_IN[17]}] [get_ports {DATA_IN[16]}]  \
[get_ports {DATA_IN[15]}] [get_ports {DATA_IN[14]}] [get_ports {DATA_IN[13]}]  \
[get_ports {DATA_IN[12]}] [get_ports {DATA_IN[11]}] [get_ports {DATA_IN[10]}]  \
[get_ports {DATA_IN[9]}] [get_ports {DATA_IN[8]}] [get_ports {DATA_IN[7]}]     \
[get_ports {DATA_IN[6]}] [get_ports {DATA_IN[5]}] [get_ports {DATA_IN[4]}]     \
[get_ports {DATA_IN[3]}] [get_ports {DATA_IN[2]}] [get_ports {DATA_IN[1]}]     \
[get_ports {DATA_IN[0]}] [get_ports {IRAM_OUT[31]}] [get_ports {IRAM_OUT[30]}] \
[get_ports {IRAM_OUT[29]}] [get_ports {IRAM_OUT[28]}] [get_ports               \
{IRAM_OUT[27]}] [get_ports {IRAM_OUT[26]}] [get_ports {IRAM_OUT[25]}]          \
[get_ports {IRAM_OUT[24]}] [get_ports {IRAM_OUT[23]}] [get_ports               \
{IRAM_OUT[22]}] [get_ports {IRAM_OUT[21]}] [get_ports {IRAM_OUT[20]}]          \
[get_ports {IRAM_OUT[19]}] [get_ports {IRAM_OUT[18]}] [get_ports               \
{IRAM_OUT[17]}] [get_ports {IRAM_OUT[16]}] [get_ports {IRAM_OUT[15]}]          \
[get_ports {IRAM_OUT[14]}] [get_ports {IRAM_OUT[13]}] [get_ports               \
{IRAM_OUT[12]}] [get_ports {IRAM_OUT[11]}] [get_ports {IRAM_OUT[10]}]          \
[get_ports {IRAM_OUT[9]}] [get_ports {IRAM_OUT[8]}] [get_ports {IRAM_OUT[7]}]  \
[get_ports {IRAM_OUT[6]}] [get_ports {IRAM_OUT[5]}] [get_ports {IRAM_OUT[4]}]  \
[get_ports {IRAM_OUT[3]}] [get_ports {IRAM_OUT[2]}] [get_ports {IRAM_OUT[1]}]  \
[get_ports {IRAM_OUT[0]}]]  -to [list [get_ports {IRAM_ADDR[31]}] [get_ports {IRAM_ADDR[30]}] [get_ports  \
{IRAM_ADDR[29]}] [get_ports {IRAM_ADDR[28]}] [get_ports {IRAM_ADDR[27]}]       \
[get_ports {IRAM_ADDR[26]}] [get_ports {IRAM_ADDR[25]}] [get_ports             \
{IRAM_ADDR[24]}] [get_ports {IRAM_ADDR[23]}] [get_ports {IRAM_ADDR[22]}]       \
[get_ports {IRAM_ADDR[21]}] [get_ports {IRAM_ADDR[20]}] [get_ports             \
{IRAM_ADDR[19]}] [get_ports {IRAM_ADDR[18]}] [get_ports {IRAM_ADDR[17]}]       \
[get_ports {IRAM_ADDR[16]}] [get_ports {IRAM_ADDR[15]}] [get_ports             \
{IRAM_ADDR[14]}] [get_ports {IRAM_ADDR[13]}] [get_ports {IRAM_ADDR[12]}]       \
[get_ports {IRAM_ADDR[11]}] [get_ports {IRAM_ADDR[10]}] [get_ports             \
{IRAM_ADDR[9]}] [get_ports {IRAM_ADDR[8]}] [get_ports {IRAM_ADDR[7]}]          \
[get_ports {IRAM_ADDR[6]}] [get_ports {IRAM_ADDR[5]}] [get_ports               \
{IRAM_ADDR[4]}] [get_ports {IRAM_ADDR[3]}] [get_ports {IRAM_ADDR[2]}]          \
[get_ports {IRAM_ADDR[1]}] [get_ports {IRAM_ADDR[0]}] [get_ports               \
{DATA_OUT[31]}] [get_ports {DATA_OUT[30]}] [get_ports {DATA_OUT[29]}]          \
[get_ports {DATA_OUT[28]}] [get_ports {DATA_OUT[27]}] [get_ports               \
{DATA_OUT[26]}] [get_ports {DATA_OUT[25]}] [get_ports {DATA_OUT[24]}]          \
[get_ports {DATA_OUT[23]}] [get_ports {DATA_OUT[22]}] [get_ports               \
{DATA_OUT[21]}] [get_ports {DATA_OUT[20]}] [get_ports {DATA_OUT[19]}]          \
[get_ports {DATA_OUT[18]}] [get_ports {DATA_OUT[17]}] [get_ports               \
{DATA_OUT[16]}] [get_ports {DATA_OUT[15]}] [get_ports {DATA_OUT[14]}]          \
[get_ports {DATA_OUT[13]}] [get_ports {DATA_OUT[12]}] [get_ports               \
{DATA_OUT[11]}] [get_ports {DATA_OUT[10]}] [get_ports {DATA_OUT[9]}]           \
[get_ports {DATA_OUT[8]}] [get_ports {DATA_OUT[7]}] [get_ports {DATA_OUT[6]}]  \
[get_ports {DATA_OUT[5]}] [get_ports {DATA_OUT[4]}] [get_ports {DATA_OUT[3]}]  \
[get_ports {DATA_OUT[2]}] [get_ports {DATA_OUT[1]}] [get_ports {DATA_OUT[0]}]  \
[get_ports {DATA_ADDR[31]}] [get_ports {DATA_ADDR[30]}] [get_ports             \
{DATA_ADDR[29]}] [get_ports {DATA_ADDR[28]}] [get_ports {DATA_ADDR[27]}]       \
[get_ports {DATA_ADDR[26]}] [get_ports {DATA_ADDR[25]}] [get_ports             \
{DATA_ADDR[24]}] [get_ports {DATA_ADDR[23]}] [get_ports {DATA_ADDR[22]}]       \
[get_ports {DATA_ADDR[21]}] [get_ports {DATA_ADDR[20]}] [get_ports             \
{DATA_ADDR[19]}] [get_ports {DATA_ADDR[18]}] [get_ports {DATA_ADDR[17]}]       \
[get_ports {DATA_ADDR[16]}] [get_ports {DATA_ADDR[15]}] [get_ports             \
{DATA_ADDR[14]}] [get_ports {DATA_ADDR[13]}] [get_ports {DATA_ADDR[12]}]       \
[get_ports {DATA_ADDR[11]}] [get_ports {DATA_ADDR[10]}] [get_ports             \
{DATA_ADDR[9]}] [get_ports {DATA_ADDR[8]}] [get_ports {DATA_ADDR[7]}]          \
[get_ports {DATA_ADDR[6]}] [get_ports {DATA_ADDR[5]}] [get_ports               \
{DATA_ADDR[4]}] [get_ports {DATA_ADDR[3]}] [get_ports {DATA_ADDR[2]}]          \
[get_ports {DATA_ADDR[1]}] [get_ports {DATA_ADDR[0]}] [get_ports {BLC[1]}]     \
[get_ports {BLC[0]}] [get_ports MEM_WR] [get_ports MEM_RD]]
