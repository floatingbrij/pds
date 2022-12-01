#include "cuda.h"
#include "stdio.h"

__global__ void sumofnat(int *dev_arr, int *res)
{
    int id = threadIdx.x + blockIdx.x * blockDim.x;
    // res+=dev_arr[id];
    atomicAdd(res, dev_arr[id]);
}
int main()
{
    int arr[100], *n;
    int *dev_arr, *res;
    for (int i = 0; i < 100; i++)
    {
        arr[i] = i + 1;
    }
    n = (int *)malloc(sizeof(int));
    cudaMalloc((void **)&dev_arr, 100 * sizeof(int));
    cudaMalloc((void **)&res, sizeof(int));
    cudaMemcpy(dev_arr, arr, 100 * sizeof(int), cudaMemcpyHostToDevice);
    sumofnat<<<2, 50>>>(dev_arr, res);
    cudaMemcpy(n, res, sizeof(int), cudaMemcpyDeviceToHost);
    printf("Result:%d\n", *n);
    return 0;
}