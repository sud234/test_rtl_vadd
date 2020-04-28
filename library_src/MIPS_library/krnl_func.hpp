
extern "C" void Kernel_Initialise(char binaryFile[20]);

extern "C" void Start_kernel();

extern "C" void display_rcvd_data_mem();

extern "C" void WriteData(int data,int address);

extern "C" void WriteBatchInstr(int instruction,int address);

extern "C" void WriteBatch(int *instructions,int start_address, int numb_of_inst);

extern "C" int ReadData(int address);
