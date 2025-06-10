# Define list of test top modules
set tests {
    axi_lite_reg_interface_tb
    axi_master_read_engine_tb
}

# Directory setup
vlib work
vmap work ./work

# Compile once (optional: move to separate script if needed)
set rtl_files [glob ../rtl/*.vhd]
vcom -2008 {*}$rtl_files

set tb_files [glob ../tb/*.sv]
vlog {*}$tb_files

vsim work.axi_lite_reg_interface_tb
# Open the waveform viewer and set the title of the window
view wave -title "axi_lite_reg_interface simulation vectors"
# Open the signals viewer
view signals
# Run the wave file
do ../sim/waves/axi_reg_lite_interface_wave.do
# Run the simulation
run 100us -all

# Result accumulator
# set results {}

# # Run each test
# foreach test $tests {
#     puts "\n--- Running $test ---"

#     set log_file "sim_${test}.log"
#     set sim_cmd "vsim -c $test -do {run -all; quit -f}"

#     # Execute simulation and write output to log file
#     set fp [open $log_file w]
#     puts $fp [eval exec $sim_cmd]
#     close $fp

#     # Determine pass/fail from log
#     set logfile [open sim_${test}.log r]
#     set logdata [read $logfile]
#     close $logfile

#     if {[string match *TEST_PASS* $logdata]} {
#         lappend results "$test: OK"
#     } else {
#         lappend results "$test: KO"
#     }
# }

# # Summary report
# puts "\n=== TEST SUMMARY ==="
# foreach res $results {
#     puts $res
# }
