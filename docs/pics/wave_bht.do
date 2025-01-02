onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /tb_dlx/ALMOND_32/DATAP/IRAM_OUT
add wave -noupdate -radix decimal /tb_dlx/ALMOND_32/DATAP/IRAM_ADDR
add wave -noupdate /tb_dlx/ALMOND_32/DATAP/CLK
add wave -noupdate /tb_dlx/ALMOND_32/DATAP/BHT1/d_in
add wave -noupdate /tb_dlx/ALMOND_32/DATAP/BHT1/w_en
add wave -noupdate /tb_dlx/ALMOND_32/DATAP/BHT1/d_out
add wave -noupdate -radix unsigned /tb_dlx/ALMOND_32/DATAP/BHT1/entry
add wave -noupdate /tb_dlx/ALMOND_32/ALU_OPCODE_i
add wave -noupdate /tb_dlx/ALMOND_32/DATAP/ZDU_out
add wave -noupdate /tb_dlx/ALMOND_32/DATAP/ZDU_SEL
add wave -noupdate -radix decimal /tb_dlx/ALMOND_32/DATAP/FWD1/OP_DEC
add wave -noupdate -radix decimal /tb_dlx/ALMOND_32/DATAP/ADDR_RA
add wave -noupdate -radix decimal /tb_dlx/ALMOND_32/DATAP/ADDR_RB
add wave -noupdate /tb_dlx/ALMOND_32/DATAP/BMP
add wave -noupdate -radix decimal /tb_dlx/ALMOND_32/DATAP/RA_out
add wave -noupdate -radix decimal /tb_dlx/ALMOND_32/DATAP/RB_out
add wave -noupdate -radix decimal /tb_dlx/ALMOND_32/DATAP/RF1/REGISTERS(3)
add wave -noupdate -radix decimal /tb_dlx/ALMOND_32/DATAP/WB_in
add wave -noupdate /tb_dlx/ALMOND_32/DATAP/RF_RD
add wave -noupdate /tb_dlx/ALMOND_32/DATAP/RF_WR
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {11036 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 348
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {3202 ps} {19778 ps}
