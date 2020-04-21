/**********
Copyright (c) 2018, Xilinx, Inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice,
this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation
and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors
may be used to endorse or promote products derived from this software
without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**********/
#include "xcl2.hpp"
#include <vector>
#include <tuple>
#include <cstdint>
#define DATA_SIZE 256				//Total number of 32-bit we are sending in each vector argument 
using namespace std;

auto init_device(std::string binaryFile) {
  struct retVals {        // Declare a local structure
	cl::Context context1;
	cl::CommandQueue q;
	cl::Kernel krnl_vadd;
  };	//Structure has all the outputs we want to give back to the main code
  //Local variable
  cl_int err;

  //OPENCL HOST CODE AREA START
  //Create Program and Kernel
  auto devices = xcl::get_xil_devices();
  auto device = devices[0];
  OCL_CHECK(err, cl::Context context(device, NULL, NULL, NULL, &err));
  OCL_CHECK(
      err,
      cl::CommandQueue q(context, device, CL_QUEUE_PROFILING_ENABLE, &err));

  auto device_name = device.getInfo<CL_DEVICE_NAME>();

  auto fileBuf = xcl::read_binary_file(binaryFile);
  cl::Program::Binaries bins{{fileBuf.data(), fileBuf.size()}};
  devices.resize(1);
  OCL_CHECK(err, cl::Program program(context, devices, bins, NULL, &err));
  OCL_CHECK(err, cl::Kernel krnl_vadd(program, "krnl_vadd_rtl", &err));

  return retVals {context, q, krnl_vadd}; 	// Return the local structure
}

//Note read to FPGA
cl::Buffer alloc_read_buff(std::vector<uint32_t, aligned_allocator<uint32_t>> read_data,cl::Context context,auto vector_size_bytes)
{
    cl_int err;
    //Allocate Read Buffer in Global Memory
    OCL_CHECK(err,
              cl::Buffer buffer_read(context,
                                   CL_MEM_USE_HOST_PTR | CL_MEM_READ_ONLY,
                                   vector_size_bytes,
                                   read_data.data(),
                                   &err));
    return buffer_read;
}

//Note write to FPGA
cl::Buffer alloc_write_buff(std::vector<uint32_t, aligned_allocator<uint32_t>> write_data,cl::Context context,auto vector_size_bytes)
{
    cl_int err;
    //Allocate Read Buffer in Global Memory
    OCL_CHECK(err,
              cl::Buffer buffer_write(context,
                                   CL_MEM_USE_HOST_PTR | CL_MEM_WRITE_ONLY,
                                   vector_size_bytes,
                                   write_data.data(),
                                   &err));
    return buffer_write;
}

void copy_data_from_host_to_fpga(std::vector<uint32_t, aligned_allocator<uint32_t>> instructions,std::vector<uint32_t, aligned_allocator<uint32_t>> instructions,std::vector<uint32_t, aligned_allocator<uint32_t>> WRITE_MEM_32bw,cl::Kernel krnl_vadd,cl::CommandQueue q,cl::Context context)
{
    auto size = DATA_SIZE;
    //Allocate Memory in Host Memory
    auto vector_size_bytes = sizeof(uint32_t) * size;
   //Read instruction logic

    cl::Buffer inst_buff = alloc_read_buff(instructions,context,vector_size_bytes);
    cl::Buffer read_32bw_buff = alloc_read_buff(READ_MEM_32bw,context,vector_size_bytes);	//Read to FPGA so we should provide data
    cl::Buffer write_32bw_buff = alloc_read_buff(WRITE_MEM_32bw,context,vector_size_bytes);	//Write from FPGA so result will be presented here


    //Set the Kernel Arguments
    OCL_CHECK(err, err = krnl_vadd.setArg(0, inst_buff));
    OCL_CHECK(err, err = krnl_vadd.setArg(1, read_32bw_buff));
    OCL_CHECK(err, err = krnl_vadd.setArg(2, write_32bw_buff));
    OCL_CHECK(err, err = krnl_vadd.setArg(3, size));
    OCL_CHECK(err, err = krnl_vadd.setArg(4, instructions.size());

    //Copy input data to device global memory
    OCL_CHECK(err,
              err = q.enqueueMigrateMemObjects({inst_buff, read_32bw_buff},
                                               0 /* 0 means from host*/))

}


int main(int argc, char **argv) {
    if (argc != 2) {
        std::cout << "Usage: " << argv[0] << " <XCLBIN File>" << std::endl;
        return EXIT_FAILURE;
    }

    std::string binaryFile = argv[1];

    cl_int err;

    //Instruction vector
    std::vector<uint32_t, aligned_allocator<uint32_t>> instructions(size);
    //32 bit wide Data MEM Write/Read vectors
    std::vector<uint32_t, aligned_allocator<uint32_t>> WRITE_MEM_32bw(size);
    std::vector<uint32_t, aligned_allocator<uint32_t>> READ_MEM_32bw(size);

    auto [context, q, krnl_vadd] = init_device(binaryFile);
    
    copy_data_from_host_to_fpga(instructions,READ_MEM_32bw,WRITE_MEM_32bw,krnl_vadd,q,context);

     //Launch the Kernel
    OCL_CHECK(err, err = q.enqueueTask(krnl_vadd));

    //Copy Result from Device Global Memory to Host Local Memory
    OCL_CHECK(err,
              err = q.enqueueMigrateMemObjects({WRITE_MEM_32bw},
                                               CL_MIGRATE_MEM_OBJECT_HOST));
    OCL_CHECK(err, err = q.finish());

    //OPENCL HOST CODE AREA END

}
