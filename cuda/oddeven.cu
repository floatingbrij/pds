#include <stdio.h>
#include <stdlib.h>
#define N 100
__global__ void oddevensort(int *a)
{
    int ix = threadIdx.x;
    for (int i = 0; i < N / 2; i++)
    {
        if (ix < N - 1 && ix % 2 != 0)
        {
            int t = a[ix + 1];
            a[ix + 1] = max(t, a[ix]);
            a[ix] = min(t, a[ix]);
        }
        __syncthreads();
        if (ix < N - 1 && ix % 2 == 0)
        {
            int t = a[ix + 1];
            a[ix + 1] = max(t, a[ix]);
            a[ix] = min(t, a[ix]);
        }
        __syncthreads();
    }
}
int main()
{
    int *arr;
    int *dev_arr;
    arr = (int *)malloc(N * sizeof(int));
    cudaMalloc((void **)&dev_arr, N * sizeof(int));
    int ct = N;
    printf("Input array is :\n");
    for (int i = 0; i < N; i++)
    {
        arr[i] = ct;
        ct--;
        printf("%d ", arr[i]);
    }
    printf("\n");
    cudaMemcpy(dev_arr, arr, N * sizeof(int), cudaMemcpyHostToDevice);
    oddevensort<<<1, N>>>(dev_arr);
    cudaMemcpy(arr, dev_arr, N * sizeof(int), cudaMemcpyDeviceToHost);
    cudaDeviceReset();
    printf("Output array is :\n");
    for (int i = 0; i < N; i++)
    {
        printf("%d ", arr[i]);
    }
    printf("\n");
    cudaFree(dev_arr);
    free(arr);
}
