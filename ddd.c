%%cu
__global__ void enumsort(int *d_a){
    int i = threadIdx.x;
    int c=0;
    for(int j=0;j<10;j++){
        if(i!=j && d_a[i]>d_a[j]){
            c++;
        }
    }    
    int q = d_a[i];
    __syncthreads();
    d_a[c]=q;
}

int main(){
    int a[10]={3,4,2,9,1,10,6,3,6,2};
    int *d_a;
    cudaMalloc((void **)&d_a,10*sizeof(int));
    cudaMemcpy(d_a,&a,10*sizeof(int),cudaMemcpyHostToDevice);
    enumsort<<<1,10>>>(d_a);
    cudaMemcpy(a,d_a,10*sizeof(int),cudaMemcpyDeviceToHost);
    for(int i=0;i<10;i++){
        printf("%d\t",a[i]);
    }
}

