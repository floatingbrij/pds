#include <stdio.h>
#include <mpi.h>
#include <stdlib.h>

int main(int argc, char **argv)
{
    MPI_Init(&argc, &argv);
    int rank, size;
    const int root = 0;
    int msg = 0;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    // broadcast

    printf("\nBefore Broadcast :%d", msg);
    if (rank == root)
    {
        msg = 100;
        printf("\nSending message to everyone");
    }
    MPI_Bcast(&msg, 1, MPI_INT, root, MPI_COMM_WORLD);
    printf("\nAfter receiving Buffer %d: %d", rank, msg);
    MPI_Finalize();
}