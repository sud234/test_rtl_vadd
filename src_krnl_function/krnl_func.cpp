#include <iostream>
#include <vector>
#include "xcl2.hpp"
#include "krnl_func.hpp"

#define DATA_SIZE 256

//This code has all the kernel functions used for talking with kernel

cl_int err;
cl::Context context_global;
cl::CommandQueue q_global;
cl::Program program_global;
cl::Kernel krnl_vadd_global;


void Kernel_Initialise(std::string binaryFile)
{
  auto devices = xcl::get_xil_devices();
  auto device = devices[0];
  OCL_CHECK(err,cl::Context  context(device, NULL, NULL, NULL, &err));
  OCL_CHECK(
      err,cl::CommandQueue q(context, device, CL_QUEUE_PROFILING_ENABLE, &err));

  auto device_name = device.getInfo<CL_DEVICE_NAME>();

  auto fileBuf = xcl::read_binary_file(binaryFile);
  cl::Program::Binaries bins{{fileBuf.data(), fileBuf.size()}};
   devices.resize(1);
   OCL_CHECK(err,cl::Program program (context, devices, bins, NULL, &err));
   OCL_CHECK(err,cl::Kernel krnl_vadd (program, "krnl_vadd_rtl", &err));
   context_global = context;
   q_global = q;
   program_global = program;
   krnl_vadd_global = krnl_vadd;
}

std::vector<int, aligned_allocator<int>> Rest_of_add(std::vector<int, aligned_allocator<int>> source_input1,std::vector<int, aligned_allocator<int>> source_input2)
{
	
    auto size = DATA_SIZE;
    //Allocate Memory in Host Memory
    auto vector_size_bytes = sizeof(int) * size;

    std::vector<int, aligned_allocator<int>> source_hw_results(size);
    //Allocate Buffer in Global Memory
    OCL_CHECK(err,
              cl::Buffer buffer_r1(context_global,
                                   CL_MEM_USE_HOST_PTR | CL_MEM_READ_ONLY,
                                   vector_size_bytes,
                                   source_input1.data(),
                                   &err));
    OCL_CHECK(err,
              cl::Buffer buffer_r2(context_global,
                                   CL_MEM_USE_HOST_PTR | CL_MEM_READ_ONLY,
                                   vector_size_bytes,
                                   source_input2.data(),
                                   &err));
    OCL_CHECK(err,
              cl::Buffer buffer_w(context_global,
                                  CL_MEM_USE_HOST_PTR | CL_MEM_WRITE_ONLY,
                                  vector_size_bytes,
                                  source_hw_results.data(),
                                  &err));

    //Set the Kernel Arguments
    OCL_CHECK(err, err = krnl_vadd_global.setArg(0, buffer_r1));
    OCL_CHECK(err, err = krnl_vadd_global.setArg(1, buffer_r2));
    OCL_CHECK(err, err = krnl_vadd_global.setArg(2, buffer_w));
    OCL_CHECK(err, err = krnl_vadd_global.setArg(3, size));

    //Copy input data to device global memory
    OCL_CHECK(err,
              err = q_global.enqueueMigrateMemObjects({buffer_r1, buffer_r2},
                                               0 /* 0 means from host*/));

    //Launch the Kernel
    OCL_CHECK(err, err = q_global.enqueueTask(krnl_vadd_global));

    //Copy Result from Device Global Memory to Host Local Memory
    OCL_CHECK(err,
              err = q_global.enqueueMigrateMemObjects({buffer_w},
                                               CL_MIGRATE_MEM_OBJECT_HOST));
    OCL_CHECK(err, err = q_global.finish());

    return source_hw_results;
}
