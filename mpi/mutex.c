#include <stdio.h>
#include <mpi.h>

int main(int argc, char *argv)
{

	MPI_Init(&argc, &argv);
	int rank, size;

	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	MPI_Comm_size(MPI_COMM_WORLD, &size);

	if (rank == 0)
	{
		int queue[20];
		int front, st, lock = 0, count = 0;
		int sharedmem = 0;
		int process;

		while (1)
		{

			MPI_Recv(&process, 1, MPI_INT, MPI_ANY_SOURCE, MPI_ANY_TAG, MPI_COMM_WORLD, &st);

			if (st.MPI_TAG == 1)
			{

				if (lock == 0 && count == 0)
				{
					lock = 1;
					MPI_Send(&sharedmem, 1, MPI_INT, process, 2, MPI_COMM_WORLD);
				}
				else if (lock == 1)
				{
					rear++;
					count++;
					queue[rear] = process;
				}

				else if (st.MPI_TAG == 3)
				{

					sharedmem = process;
					if (count > 0)
					{
						MPI_Send(&sharedmem, 1, MPI_INT, queue[front], 2, MPI_COMM_WORLD);
						count--;
						front++;
					}
					else
					{
						lock = 0;
					}
				}
			}
			else
			{
				int modify;
			MPI_Send(&rank,1,MPI_INT,0,
