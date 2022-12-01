#include "cuda.h"
#include "stdio.h"
#define N 10
__global__ void enumsort(int *deva, int *devn)
{
    int id = threadIdx.x + blockIdx.x * blockDim.x;
    int i, count = 0;
    for (i = 0; i < N; i++)
    {
        if ((deva[i] <= deva[id]) && (i != id))
        {
            count++;
        }
        devn[count] = deva[id];
    }
}
int main()
{
    int a[] = {19, 500, 29, 306, 65, 38, 1, 59, 254, 41};
    int *deva, *n, *devn;
    n = (int *)malloc(N * sizeof(int));
    cudaMalloc((void **)&deva, N * sizeof(int));
    cudaMalloc((void **)&devn, N * sizeof(int));
    cudaMemcpy(deva, a, N * sizeof(int), cudaMemcpyHostToDevice);
    enumsort<<<2, 5>>>(deva, devn);
    cudaMemcpy(n, devn, N * sizeof(int), cudaMemcpyDeviceToHost);
    for (int i = 0; i < N; i++)
    {
        printf("%d ", n[i]);
    }
    return 0;
}
