#include <stdio.h>
#include <mpi.h>
#define Buf_Size 4

int main(int argc, char **argv)
{
    MPI_Init(&argc, &argv);
    int rank, size;
    int Sendbuf[Buf_Size][Buf_Size] = {{1, 2, 3, 4}, {5, 6, 7, 8}, {9, 10, 11, 12}, {13, 14, 15, 16}};
    int RecvBuf[Buf_Size];
    const int root = 1;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    printf("\nBefore Scattering Buffer %d  :%d %d %d %d", rank, RecvBuf[0], RecvBuf[1], RecvBuf[2], RecvBuf[3]);
    MPI_Scatter(&Sendbuf, Buf_Size, MPI_INT, &RecvBuf, Buf_Size, MPI_INT, root, MPI_COMM_WORLD);
    printf("\nAfter Scattering Buffer %d  :%d %d %d %d", rank, RecvBuf[0], RecvBuf[1], RecvBuf[2], RecvBuf[3]);
    MPI_Finalize();
}