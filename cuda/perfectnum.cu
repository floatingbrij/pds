#include "cuda.h"
#include "stdio.h"
__global__ void prime(int *dev_a)
{
    int id = threadIdx.x + blockIdx.x * blockDim.x + 1;
    int n = dev_a[100];
    int count = 0;
    int a[100];
    int sum1 = 0;
    for (int k = 1; k < n; k++)
    {
        if (id % k)
        {
            a[count] = k;
            count++;
            sum1 += a[count];
        }
    }
    if (id == sum1)
    {
        dev_a[id] = id;
    }
    else
    {
        dev_a[id] = 0;
    }
}
int main()
{
    int arr[100];
    int n = 100;
    int *dev_a;
    int a[100];
    for (int i = 0; i < n; i++)
    {
        a[i] = 0;
    }
    // n = (int *)malloc(49 * sizeof(int));
    cudaMalloc((void **)&dev_a, n * sizeof(int));
    // cudaMalloc((void **)&dev_r, 49 * sizeof(int));
    cudaMemcpy(dev_a, a, n * sizeof(int), cudaMemcpyHostToDevice);
    // cudaMemcpy(dev_r, res, 49 * sizeof(int), cudaMemcpyHostToDevice);
    prime<<<10, 10>>>(dev_a);
    cudaMemcpy(a, dev_a, n * sizeof(int), cudaMemcpyDeviceToHost);
    for (int i = 0; i < n; i++)
    {
        if (a[i] != 0)
        {
            printf("%d  ", a[i]);
        }
    }
    return 0;
}
