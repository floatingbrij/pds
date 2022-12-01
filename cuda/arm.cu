#include "cuda.h"
#include "stdio.h"
#include "math.h"
__global__ void amstrong(int *dev_a, int *sum)
{
    int id = threadIdx.x + blockIdx.x * blockDim.x;
    int n = dev_a[id];
    int s = 0;
    int z = n;
    int y = n;
    int c = 0;
    while (n != 0)
    {
        n = n / 10;
        c++;
    }
    while (y != 0)
    {
        int r = y % 10;
        s += pow(r, c);
        y = y / 10;
    }
    if (s == z)
    {
        sum[id] = 1;
    }
}
int main()
{
    int arr[1000], res[1000];
    int *dev_a, *sum, *n;
    n = (int *)malloc(1000 * sizeof(int));
    for (int i = 0; i < 1000; i++)
    {
        arr[i] = i + 1;
        res[i] = 0;
    }
    cudaMalloc((void **)&dev_a, 1000 * sizeof(int));
    cudaMalloc((void **)&sum, 1000 * sizeof(int));
    cudaMemcpy(dev_a, arr, 1000 * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(sum, res, 1000 * sizeof(int), cudaMemcpyHostToDevice);
    amstrong<<<2, 500>>>(dev_a, sum);
    cudaMemcpy(n, sum, 1000 * sizeof(int), cudaMemcpyDeviceToHost);
    for (int i = 0; i < 1000; i++)
    {
        if (n[i] == 1)
        {
            printf("%d ", arr[i]);
        }
    }
    return 0;
}
