source /tools/Xilinx/Vivado/2019.1/settings64.sh
vivado -mode batch -source scripts/gen_xo.tcl -tclargs RTL_AAIA.xo krnl_AAIA Xil AWS
