#include <stdio.h>
#include <mpi.h>

int main(int argc, char **argv)
{
    MPI_Init(&argc, &argv);
    int rank, size, i = 0;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    while (i <= 5)
    {
        if (rank != i % 2)
        {
            i += 1;
            printf("\nRank %d , SENT %d :", rank, i);
            MPI_Send(&i, 1, MPI_INT, (rank + 1) % 2, 0, MPI_COMM_WORLD);
        }
        else
        {
            MPI_Recv(&i, 1, MPI_INT, (rank + 1) % 2, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
            printf("\nRank %d , RECEIVED %d:", rank, i);
        }
    }
    MPI_Finalize();
}
