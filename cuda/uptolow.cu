#include "cuda.h"
#include "stdio.h"
#include "string.h"
__global__ void utol(char *deva, int n)
{
    int id = threadIdx.x + blockIdx.x * blockDim.x;
    if (deva[id] >= 65 && deva[id] <= 90)
    {
        deva[id] = deva[id] + 32;
    }
}
int main()
{
    char a[100];
    printf("\n enter string");
    scanf("%[^\n]%*c", a);
    int len = strlen(a);
    char *deva;
    cudaMalloc((void **)&deva, len * sizeof(char));
    cudaMemcpy(deva, a, len * sizeof(char), cudaMemcpyHostToDevice);
    utol<<<2, (len / 2) + 1>>>(deva, len);
    cudaMemcpy(&a, deva, len * sizeof(char), cudaMemcpyDeviceToHost);
    printf("string:%s", a);
    return 0;
}