#include <stdio.h>
#include <mpi.h>
int main(int argc, char *argv[])
{
	MPI_Init(&argc, &argv);
	int rank, size, i, j;
	int sendBuf, recvBuf;

	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	MPI_Comm_size(MPI_COMM_WORLD, &size);
	int rankArr[size];
	int allRanks[size][size];
	int count[size];
	for (i = 0; i < size; i++)
	{
		count[i] = 0;
	}
	if (rank == 1)
	{
		sendBuf = rand() % 100;
		for (i = 0; i < size; i++)
		{
			MPI_Send(&sendBuf, 1, MPI_INT, i, 0, MPI_COMM_WORLD);
		}
	}
	else
	{
		for (i = 0; i < size; i++)
		{
			MPI_Send(&rank, 1, MPI_INT, i, 0, MPI_COMM_WORLD);
		}
	}
	for (i = 0; i < size; i++)
	{
		MPI_Recv(&rankArr[i], 1, MPI_INT, i, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
	}
	if (rank == 1)
	{
		for (i = 0; i < size; i++)
		{
			rankArr[i] = rand() % 100;
		}
	}
	/*for(i = 0; i < size; i++){
				 printf("\nRank %d : %d",rank,rankArr[i]);
		}
	*/
	for (i = 0; i < size; i++)
	{
		MPI_Send(rankArr, size, MPI_INT, i, 0, MPI_COMM_WORLD);
	}
	for (i = 0; i < size; i++)
	{
		MPI_Recv(allRanks[i], size, MPI_INT, i, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
	}
	/*  for(i = 0;i < size; i++){
		  for(j = 0;j < size;j++){
			  printf("\nRank %d -  %d: %d",rank,i,allRanks[i][j]);
		}
	}*/
	for (i = 0; i < size; i++)
	{
		for (j = 0; j < size; j++)
		{
			if (allRanks[i][j] < size)
			{
				count[allRanks[i][j]] += 1;
			}
		}
	}
	for (i = 0; i < size; i++)
	{
		if (count[i] == 0)
		{
			printf("\nFrom Processor %d - Faulty processor is %d", rank, i);
		}
	}
	MPI_Finalize();
}
