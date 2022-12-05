#include <stdio.h>
#include <mpi.h>

int main(int argc, char *argv[])
{
    MPI_Init(&argc, &argv);
    int rank, size;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    MPI_Status st;
    int shared = 0;
    if (rank == 0)
    {
        int queue[10];
        for (int i=0; i < 10; i++)
            queue[i] = 0;
        int front = 0, rear = -1, count = 0;
        int lock=0;
        int process;
        while (1)
        {
            MPI_Recv(&process, 1, MPI_INT, MPI_ANY_SOURCE, MPI_ANY_TAG, MPI_COMM_WORLD, &st);
            if (st.MPI_SOURCE == 0)
                break;
            printf("Values in queue:    \n");
            for (int i = front; i < 10; i++)
            {
                if (queue[i] == 0)
                    break;
                printf("%d: %d\n",i, queue[i]);
            }
            printf("\n");
            if (st.MPI_TAG == 3)
            {
                shared = process;
                int send = queue[front++];
                count--;
                printf("tag 3 %d",count);
                if (send == 0)
                {
                    break;
                }
                MPI_Send(&shared, 1, MPI_INT, send, 4, MPI_COMM_WORLD);
            }
            if (st.MPI_TAG == 2)
            {
                if (count == 0 && lock == 0)
                {
                    lock = 1;
                    printf("%d has got the shared memory ", process);
                    MPI_Send(&shared, 1, MPI_INT, process, 4, MPI_COMM_WORLD);
                }
                else
                {
                    queue[++rear] = process;
                    count++;
                }
            }
        }
    }
    else
    {
        MPI_Send(&rank, 1, MPI_INT, 0, 2, MPI_COMM_WORLD);
        MPI_Recv(&shared, 1, MPI_INT, 0, 4, MPI_COMM_WORLD, &st);
        if (st.MPI_TAG == 4)
        {
            int prev = shared;
            shared++;
            printf("%d", prev);
            MPI_Send(&shared, 1, MPI_INT, 0, 3, MPI_COMM_WORLD);
        }
    }
    MPI_Finalize();
}
