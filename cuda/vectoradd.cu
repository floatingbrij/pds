#include "cuda.h"
#include "stdio.h"
#define N 3
__global__ void vectoradd(int *c, int *a, int *b)
{
    int id = threadIdx.x + blockIdx.x * blockDim.x;
    c[id] = a[id] + b[id];
}
int main()
{
    int a[N], b[N], c[N];
    int *da, *db, *dc;
    cudaMalloc((void **)&da, N * sizeof(int));
    cudaMalloc((void **)&db, N * sizeof(int));
    cudaMalloc((void **)&dc, N * sizeof(int));
    for (int i = 0; i < N; i++)
    {
        a[i] = i + 1;
        b[i] = i + 1;
    }
    cudaMemcpy(da, a, N * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(db, b, N * sizeof(int), cudaMemcpyHostToDevice);
    vectoradd<<<2, (N / 2) + 1>>>(dc, da, db);
    cudaMemcpy(c, dc, N * sizeof(int), cudaMemcpyDeviceToHost);
    for (int i = 0; i < N; i++)
    {
        printf("%d + %d = %d\n", a[i], b[i], c[i]);
    }
    return 0;
}
