# Compiler tools
XILINX_SDX ?= /tools/Xilinx/SDx/2019.1
XILINX_XRT ?= /opt/xilinx/xrt
XILINX_VIVADO ?= /tools/Xilinx/Vivado/2019.1
SDX_PLATFORM = xilinx_aws-vu9p-f1-04261818_dynamic_5_0

HOST_CXX ?= ${XILINX_SDX}/bin/xcpp

# host compiler global settings
CXXFLAGS += -DSDX_PLATFORM=$(SDX_PLATFORM) -D__USE_XOPEN2K8 -I$(XILINX_XRT)/include/ -I$(XILINX_VIVADO)/include/ -O0 -g -Wall -c -fmessage-length=0 -L.

LIBS = libkrnl.a -lpthread 

HOST_OBJECTS += obj/host.o
HOST_EXE = AAIA_project.exe


obj/host.o: host.c 
	gcc host.c -L. libkrnl.a -o HOST.exe

#$(HOST_EXE): $(HOST_OBJECTS) libkrnl.a
#	gcc $(CXXFLAGS) $(LIBS) "$@"
