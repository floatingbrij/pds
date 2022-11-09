#include"stdio.h"
#include"cuda.h"
__global__ void enum_sort(int *a,int *b)
{
int t=threadIdx.x;
int count=0;
for(int i=0;i<10;i++)
{
if(a[i]<a[t])
 {
  count++;
 }
}
b[count]=a[t];
}

int main()
{
int a[10]={44,33,22,11,33,77,99,66,88,100};
int *dev_a,*dev_b;
size_t bytes=10*sizeof(int);
cudaMalloc((void**)&dev_a,bytes);
cudaMalloc((void**)&dev_b,bytes);
cudaMemcpy(dev_a,a,bytes,cudaMemcpyHostToDevice);
enum_sort<<<1,10>>>(dev_a,dev_b);
cudaMemcpy(a,dev_b,bytes,cudaMemcpyDeviceToHost);
printf("SORTED ARRAY IS\n");
for(int i=0;i<10;i++)
{
printf("%d\t",a[i]);
}
printf("\n");
return 0;
}






