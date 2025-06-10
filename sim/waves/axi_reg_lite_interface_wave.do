onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /axi_lite_reg_interface_tb/dut/REG_WIDTH
add wave -noupdate /axi_lite_reg_interface_tb/dut/WRITE_REG_COUNT
add wave -noupdate /axi_lite_reg_interface_tb/dut/READ_REG_COUNT
add wave -noupdate /axi_lite_reg_interface_tb/dut/ACLK
add wave -noupdate /axi_lite_reg_interface_tb/dut/ARESETn
add wave -noupdate /axi_lite_reg_interface_tb/dut/AWADDR
add wave -noupdate /axi_lite_reg_interface_tb/dut/AWVALID
add wave -noupdate /axi_lite_reg_interface_tb/dut/AWREADY
add wave -noupdate /axi_lite_reg_interface_tb/dut/WDATA
add wave -noupdate /axi_lite_reg_interface_tb/dut/WSTRB
add wave -noupdate /axi_lite_reg_interface_tb/dut/WVALID
add wave -noupdate /axi_lite_reg_interface_tb/dut/WREADY
add wave -noupdate /axi_lite_reg_interface_tb/dut/BVALID
add wave -noupdate /axi_lite_reg_interface_tb/dut/BREADY
add wave -noupdate /axi_lite_reg_interface_tb/dut/BRESP
add wave -noupdate /axi_lite_reg_interface_tb/dut/ARADDR
add wave -noupdate /axi_lite_reg_interface_tb/dut/ARVALID
add wave -noupdate /axi_lite_reg_interface_tb/dut/ARREADY
add wave -noupdate /axi_lite_reg_interface_tb/dut/RDATA
add wave -noupdate /axi_lite_reg_interface_tb/dut/RVALID
add wave -noupdate /axi_lite_reg_interface_tb/dut/RREADY
add wave -noupdate /axi_lite_reg_interface_tb/dut/RRESP
add wave -noupdate /axi_lite_reg_interface_tb/dut/start
add wave -noupdate /axi_lite_reg_interface_tb/dut/irq_enable
add wave -noupdate /axi_lite_reg_interface_tb/dut/busy
add wave -noupdate /axi_lite_reg_interface_tb/dut/done
add wave -noupdate /axi_lite_reg_interface_tb/dut/src_addr
add wave -noupdate /axi_lite_reg_interface_tb/dut/dst_addr
add wave -noupdate /axi_lite_reg_interface_tb/dut/length
add wave -noupdate /axi_lite_reg_interface_tb/dut/state
add wave -noupdate /axi_lite_reg_interface_tb/dut/state_next
add wave -noupdate /axi_lite_reg_interface_tb/dut/reg_space
add wave -noupdate /axi_lite_reg_interface_tb/dut/reg_space_next
add wave -noupdate /axi_lite_reg_interface_tb/dut/address_reg
add wave -noupdate /axi_lite_reg_interface_tb/dut/address_next
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {1 us}
