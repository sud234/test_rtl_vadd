#include <stdio.h>
#include <string.h>
//#include "krnl_func.hpp"

int main( int argc, char *argv[] )  {
    if (argc != 2) {
        printf("Usage %s <XCLBIN> file", argv[0]);
        return -1;
    }

   	int data=2;
	int instruction[10]={0,0,0,0,0};

	Kernel_Initialise(argv[1]);
	WriteData(data,1);
	WriteData(data+10,0);
	WriteData(data+25,2);
	WriteBatch(instruction,0,5);
	Start_kernel();
	display_rcvd_data_mem();
	printf("Exited from function\n");
	return 1;
}
