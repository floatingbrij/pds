#include <stdio.h>
#include <mpi.h>

main(int argc, char *argv[])
{
    int rank, size, hr, min, rhr, rmin, diff1, diff2;
    MPI_Init(&argc, &argv);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Status st;
    if (rank == 0)
    {
        hr = 3;
        min = 10;
        rhr = hr;
        rmin = min;
    }
    else if (rank == 1)
    {
        hr = 3;
        min = 0;
    }
    else if (rank == 2)
    {
        hr = 3;
        min = 35;
    }
    printf("Before Synchronization RANK : %d \t hr : %d \t min :%d \t", rank, hr, min);
    MPI_Bcast(&rhr, 1, MPI_INT, 0, MPI_COMM_WORLD);
    MPI_Bcast(&rmin, 1, MPI_INT, 0, MPI_COMM_WORLD);
    if (rank == 0)
    {
        MPI_Recv(&diff1, 1, MPI_INT, 1, 1, MPI_COMM_WORLD, &st);
        MPI_Recv(&diff2, 1, MPI_INT, 2, 2, MPI_COMM_WORLD, &st);
        int send = (diff1 + diff2) / 3;
        min = min + send;
        if (min > 60)
        {
            hr++;
            min = min % 60;
        }
        else if (min < 0)
        {
            hr--;
            min = min % 60;
        }
        diff1 = send - diff1;
        diff2 = send - diff2;

        MPI_Send(&diff1, 1, MPI_INT, 1, 5, MPI_COMM_WORLD);
        MPI_Send(&diff2, 1, MPI_INT, 2, 6, MPI_COMM_WORLD);
    }
    else if (rank == 1)
    {
        diff1 = (hr - rhr) * 60 + (min - rmin);
        MPI_Send(&diff1, 1, MPI_INT, 0, 1, MPI_COMM_WORLD);
        MPI_Recv(&diff1, 1, MPI_INT, 0, 5, MPI_COMM_WORLD, &st);
        min = min + diff1;
        if (min > 60)
        {
            hr++;
            min = min % 60;
        }
        else if (min < 0)
        {
            hr--;
            min = min % 60;
        }
    }
    else if (rank == 2)
    {
        diff2 = (hr - rhr) * 60 + (min - rmin);
        MPI_Send(&diff2, 1, MPI_INT, 0, 2, MPI_COMM_WORLD);
        MPI_Recv(&diff2, 1, MPI_INT, 0, 6, MPI_COMM_WORLD, &st);
        min = min + diff2;
        if (min > 60)
        {
            hr++;
            min = min % 60;
        }
        else if (min < 0)
        {
            hr--;
            min = min % 60;
        }
    }
    printf("After Synchronization RANK : %d \t hr : %d \t min : %d \n", rank, hr, min);
    MPI_Finalize();
}