#include<stdio.h>
#include<cuda.h>

__global__ void suffix(int *a,int n)
{
    it i = threadIdx.x;
    for(int j=0;j<log(n);j++)
    {
        
    }
}