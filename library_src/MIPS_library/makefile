# Compiler tools
XILINX_SDX ?= /tools/Xilinx/SDx/2019.1
XILINX_XRT ?= /opt/xilinx/xrt
XILINX_VIVADO ?= /tools/Xilinx/Vivado/2019.1
SDX_PLATFORM = xilinx_aws-vu9p-f1-04261818_dynamic_5_0

HOST_CXX ?= ${XILINX_SDX}/bin/xcpp

# host compiler global settings
CXXFLAGS += -DSDX_PLATFORM=$(SDX_PLATFORM) -D__USE_XOPEN2K8 -I$(XILINX_XRT)/include/ -I$(XILINX_VIVADO)/include/ -O0 -g -Wall -c -fmessage-length=0 -std=c++14


LIB_OBJECTS += obj/krnl_func.o
LIB_OBJECTS += obj/xcl2.o

LIBRARY_FILE_NAME = ../MIPS_host/libkrnl.a

$(LIBRARY_FILE_NAME): $(LIB_OBJECTS)
	ar -rc $(LIBRARY_FILE_NAME) $(LIB_OBJECTS)


obj/krnl_func.o: krnl_func.cpp xcl2.hpp krnl_func.hpp
	@mkdir -p $(@D)
	$(HOST_CXX) $(CXXFLAGS) -o "$@" "$<"


obj/xcl2.o: xcl2.cpp xcl2.hpp
	@mkdir -p $(@D)
	$(HOST_CXX) $(CXXFLAGS) -o "$@" "$<"
