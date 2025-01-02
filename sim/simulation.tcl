# Set the working directory
set work_dir "work"
set src_dir "../src"
set tb_dir "../tb"

# Create the work library if it does not exist
if {[file exists $work_dir]} {
    vdel -lib $work_dir -all
}
vlib $work_dir

# Compile the design files
vmap work $work_dir

# List of RTL files to compile
set datapath_dir "$src_dir/DATAPATH"
set alu_dir "$datapath_dir/ALU"
set adder_dir "$alu_dir/ADDER"


#compile the constants.vhd file first
vcom -work work "$src_dir/CONSTANTS.vhd"
vcom -work work "$src_dir/GLOBALS.vhd"

set adder {
    FA.vhd
    RCAN.vhd
    G_BLOCK.vhd
    PG_BLOCK.vhd
    PG_NETWORK.vhd
    CARRY_SELECTOR.vhd
    SUM_GENERATOR.vhd
    CARRY_GENERATOR.vhd
    ADDER.vhd
}

set alu {
    ND3.vhd
    ND4.vhd
    IV.vhd
    AND.vhd
    CMP.vhd
    ENCODER.vhd
    LOGIC.vhd
    MULTIPLIER.vhd
    SHIFTER.vhd
    ALU.vhd
}

set datapath {
    FFD.vhd
    MUX2to1.vhd
    MUX3to1.vhd
    MUX4to1.vhd
    MUX5to1.vhd
    REG.vhd
    RF.vhd
    BHT.vhd
    CWBU.vhd
    FWDU.vhd
    HDU.vhd
    PCADDER.vhd
    DATAPATH.vhd
}

set top {
    CU.vhd
    DRAM.vhd
    IRAM.vhd
    DLX.vhd
}

#Compile each adder file
foreach file $adder {
    vcom -work work "$adder_dir/$file"
}

#Compile each adder file
foreach file $alu {
    vcom -work work "$alu_dir/$file"
}

#Compile each adder file
foreach file $datapath {
    vcom -work work "$datapath_dir/$file"
}

#Compile each adder file
foreach file $top {
    vcom -work work "$src_dir/$file"
}

#compile the testbench
vcom -work work "$tb_dir/TB_DLX.vhd"

# Load the testbench
vsim -voptargs="+acc" work.tb_dlx

#set all the waves in decimal view
add wave -color white sim:/tb_dlx/Clock
add wave -color white sim:/tb_dlx/Reset
add wave -color yellow -radix decimal sim:/tb_dlx/DRAM_IN
add wave -color blue -radix decimal sim:/tb_dlx/DRAM_OUT
add wave -color green -radix hex sim:/tb_dlx/DRAM_ADDR
add wave -color yellow -radix hex sim:/tb_dlx/IRAM_DATA
add wave -color green -radix hex sim:/tb_dlx/IRAM_ADDR
add wave -color purple -radix decimal sim:/tb_dlx/DRAM_DATA
add wave -color white sim:/tb_dlx/MEM_WR_t
add wave -color white sim:/tb_dlx/MEM_RD_t


set runTime 220ns

# Run simulation
run $runTime

