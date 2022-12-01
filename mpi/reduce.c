#include<stdio.h>
#include<mpi.h>

int main(int argc,char **argv){

	MPI_Init(&argc,&argv);
	int rank,size,i,id,randomNo;
	const int root = 0;
	
	MPI_Comm_rank(MPI_COMM_WORLD,&rank);
	MPI_Comm_size(MPI_COMM_WORLD,&size);
	int sendBuf,recvBuf;

	if(rank == root){
		for(i = 0;i < size;i++){
			sendBuf = rand()%100;
			MPI_Send(&sendBuf,1,MPI_INT,i,0,MPI_COMM_WORLD);
		}
	}
	else{
		MPI_Recv(&recvBuf,1,MPI_INT,root,0,MPI_COMM_WORLD,MPI_STATUS_IGNORE);
		printf("\nProcessor %d ID %d",rank,recvBuf);
		sendBuf = recvBuf;
	}	

	MPI_Reduce(&sendBuf,&recvBuf,1,MPI_INT,MPI_MAX,0,MPI_COMM_WORLD);
	if(rank == root){
		printf("\nMAX : %d",recvBuf);
	}


	MPI_Finalize();

}


