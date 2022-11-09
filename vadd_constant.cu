#include "stdio.h"
#include "cuda.h"
__constant__ float carray[100];
__global__ void vadd(float *darray )
{
int index;
index=blockIdx.x*blockDim.x+threadIdx.x;

for(int i=0;i<100;i++)
{
darray[index]=darray[index]+carray[i];
}
return;
}

int main()
{
int size=3200;
size_t bytes=size*sizeof(float);
float rarray[3200];
float *darray;
float harray[100];
cudaMalloc((void**)&darray,bytes);
cudaMemset(darray,0,bytes);

for(int i=0;i<100;i++)
{
harray[i]=i+1;
}

cudaMemcpyToSymbol(carray,harray,sizeof(float)*100);

cudaEvent_t start,stop;
cudaEventCreate(&start);
cudaEventCreate(&stop);
cudaEventRecord(start);

vadd<<<size/64,64>>>(darray);

cudaEventRecord(stop);
cudaEventSynchronize(stop);
float t=0;
cudaEventElapsedTime(&t,start,stop);
cudaMemcpy(rarray,darray,bytes,cudaMemcpyDeviceToHost);


printf("RESULT ARRAY printed only from index 0 to 9\n");
for(int j=0;j<10;j++)
{
printf("%f \n",rarray[j]);
}
printf("\nTime taken using constant memory :%f",t);

cudaFree(darray);
return 0;
}
                                                                                                                           

