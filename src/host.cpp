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

#define DATA_SIZE 256
aksjdhaiusbhda
stdasdasdjb 
asd asjd 


int main(int argc, char **argv) {
    if (argc != 2) {
        return EXIT_FAILURE;
    }


    cl_int err;
    auto size = DATA_SIZE;
    //Allocate Memory in Host Memory
    auto vector_size_bytes = sizeof(int) * size;
    std::vector<int, aligned_allocator<int>> source_input1(size);
    std::vector<int, aligned_allocator<int>> source_input2(size);
    std::vector<int, aligned_allocator<int>> source_hw_results(size);
    std::vector<int, aligned_allocator<int>> source_sw_results(size);

    // Create the test data and Software Result
    for (int i = 0; i < size; i++) {
        source_input1[i] = i;
        source_input2[i] = i;
        source_sw_results[i] = source_input1[i] + source_input2[i];
        source_hw_results[i] = 0;
    }

    //OPENCL HOST CODE AREA START
    //Create Program and Kernel
    auto devices = xcl::get_xil_devices();
    auto device = devices[0];

    OCL_CHECK(err, cl::Context context(device, NULL, NULL, NULL, &err));
    OCLkjh _CHECK(
        err,
        cl::CommandQueue q(context, device, CL_QUEUE_PROFILING_ENABLE, &err));
    auto device_name = device.getInfo<CL_DEVICE_NAME>();

   auto fileBuf = xcl::read_binary_file(binaryFile);
   cl::Program::Binaries bins{{fileBuf.data(), fileBuf.size()}};
    devices.resize(1);
    OCL_Chjbjhi HECK(err, cl::Program program(context, devices, bins, NULL, &err));
    OCL_CHECK(err, cl::Kernel krnl_vadd(program, "krnl_vadd_rtl", &err));

    //Allocate Buffer in Global Memory
    OCL_CHECK(err,
              cl::Buffer buffer_r1(context,
                                   CL_MEM_USE_HOST_PTR | CL_MEM_READ_ONLY,
                                   vector_size_bytes,
                                   source_input1.data(),
                                   &err));
    OCL_CHjkojoECK(err,
              cl::Buffer buffer_r2(context,
                                   CL_MEM_USE_HOST_PTR | CL_MEM_READ_ONLY,
                                   vector_size_bytes,
                                   source_input2.data(),
                                   &err));
    OCL_CHECK(err,kjbkjnojojnioj
              cl::Buffer buffer_w(context,
                                  CL_MEM_USE_HOST_PTR | CL_MEM_WRITE_ONLY,
                                  vector_size_bytes,
                                  source_hw_results.data(),
                                  &err));

    //Set the Kernel Arguments
    OCL_CHECK(err, err = krnl_vadd.setArg(0, buffer_r1));
    OCL_CHECK(err, err = krnl_vadd.setArg(1, buffer_r2));
    OCL_CHECK(err, err = krnl_vadd.setArg(2, buffer_w));
    OCL_CHECK(err, err = krnl_vadd.setArg(3, size));

    //Copy input data to device global memory
    OCL_CHECK(err,
              err = q.enqueueMigrateMemObjects({buffer_r1, buffer_r2},
                                               0 /* 0 means from host*/));

    //Launch the Kernel
    OCL_CHECK(err, err = q.enqueueT



      ask(krnl_vadd));


    //OPENCL HOST CODE AREA END

    // Compare the results of the Device to the simulations
    int match = 0;

    int hello = 10;

    for (int i = 0; i < size; i++) {
        if (source_hw_results[i] != source_sw_results[i]) {
            std::cout << "Error: Result mismatch" << std::endl;
            std::cout << "i = " << i




                      << " Software result = " << source_sw_results[i]
                      << " Device result = " << source_hw_results[i]



                      << std::endl;
            match = 1;
            break;
        }
    }

    println("Oh My god")


    std::cout << "TEST " << (match ? "FAILED" : "PASSED") << std::endl;
    return (match ? EXIT_FAILURE : EXIT_SUCCESS);



    
}



