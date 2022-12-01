#include "cuda.h"
#include "stdio.h"
__global__ void prime(int *dev_a, int *dev_r)
{
    int id = threadIdx.x + blockIdx.x * blockDim.x;
    int n = dev_a[id];
    if (n * n < 49 && dev_r[id] != 1)
    {
        for (int i = id + 1; i < 49; i++)
        {
            if (dev_a[i] % n == 0)
            {
                dev_r[i] = 1;
            }
        }
    }
}
int main()
{
    int arr[49], res[49];
    for (int i = 0; i < 49; i++)
    {
        arr[i] = i + 2;
        res[i] = 0;
    }
    int *dev_a, *dev_r, *n;
    n = (int *)malloc(49 * sizeof(int));
    cudaMalloc((void **)&dev_a, 49 * sizeof(int));
    cudaMalloc((void **)&dev_r, 49 * sizeof(int));
    cudaMemcpy(dev_a, arr, 49 * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(dev_r, res, 49 * sizeof(int), cudaMemcpyHostToDevice);
    prime<<<2, 25>>>(dev_a, dev_r);
    cudaMemcpy(n, dev_r, 49 * sizeof(int), cudaMemcpyDeviceToHost);
    for (int i = 0; i < 49; i++)
    {
        if (n[i] == 0)
        {
            printf("%d  ", arr[i]);
        }
    }
    return 0;
}
