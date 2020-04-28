export LD_LIBRARY_PATH=/opt/xilinx/xrt/lib:/tools/Xilinx/SDx/2019.1/lib/lnx64.o/Ubuntu/18:/tools/Xilinx/SDx/2019.1/lib/lnx64.o/Ubuntu:/tools/Xilinx/SDx/2019.1/lib/lnx64.o:/tools/Xilinx/SDx/2019.1/runtime/lib/x86_64
export XCL_EMULATION_MODE=hw_emu
export XILINX_SDX="/tools/Xilinx/SDx/2019.1/"
source /tools/Xilinx/SDx/2019.1/settings64.sh
source /opt/xilinx/xrt/setup.sh
./AAIA_proj.exe binary_container_1.xclbin
