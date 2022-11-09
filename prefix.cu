#include"stdio.h"
#include"cuda.h"
__global__ void esort(int *a,int *b)
{
int tid=threadIdx.x;
int sum=0;
for(int i=0;i<=tid;i++)
{
sum=sum+a[i];
}

b[tid]=sum;
}

int main()
{
int a[10]={1,2,3,4,5,6,7,8,9,10};
int *deva,*devb;
size_t bytes=10*sizeof(int);
cudaMalloc((void**)&deva,bytes);
cudaMalloc((void**)&devb,bytes);
cudaMemcpy(deva,a,bytes,cudaMemcpyHostToDevice);
esort<<<1,10>>>(deva,devb);
cudaMemcpy(a,devb,bytes,cudaMemcpyDeviceToHost);
printf("sorted array\n");
for(int i=0;i<10;i++)
{
printf("%d\t",a[i]);
}
return 0;
}


