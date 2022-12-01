#include "cuda.h"
#include "stdio.h"
#include "math.h"
__global__ void fibonacci(int *a)
{
    int id = threadIdx.x + blockIdx.x * blockDim.x;

    for (int i = 0; i < 2; i++)
    {
        a[id] = round(pow(1.618, id) / 2.2360);
    }
}
int main()
{
    int *a;
    int *dev_arr;
    cudaMalloc((void **)&dev_arr, 50 * sizeof(int));
    a = (int *)malloc(50 * sizeof(int));
    fibonacci<<<2, 25>>>(dev_arr);
    cudaMemcpy(a, dev_arr, 50 * sizeof(int), cudaMemcpyDeviceToHost);
    for (int i = 0; i < 50; i++)
    {
        printf("%d ", a[i]);
    }
    printf("\n");
    return 0;
}